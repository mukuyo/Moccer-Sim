#include "receiver.h"

VisionReceiver::VisionReceiver(QObject *parent) : QObject(parent), udpSocket(new QUdpSocket(this)) {
}

VisionReceiver::~VisionReceiver() {
    stopListening();
}

void VisionReceiver::startListening(quint16 port) {
    if (udpSocket->bind(QHostAddress("127.0.0.1"), port)) {
        connect(udpSocket, &QUdpSocket::readyRead, this, &VisionReceiver::receive);
        std::cout << "Listening on port " << port << std::endl;
    } else {
        std::cerr << "Failed to bind UDP socket to port " << port << std::endl;
    }
}

void VisionReceiver::receive() {
    mocSim_Packet packet;
    while (udpSocket->hasPendingDatagrams()) {
        QNetworkDatagram datagram = udpSocket->receiveDatagram();
        if (!datagram.isValid()) continue;
        packet.ParseFromArray(datagram.data().data(), datagram.data().size());
        emit receivedPacket(packet);
    }
}

void VisionReceiver::stopListening() {
    if (udpSocket) {
        udpSocket->close();
        udpSocket->deleteLater();
        udpSocket = nullptr;
    }
}

ControlBlueReceiver::ControlBlueReceiver(QObject *parent)
    : QObject(parent), udpSocket(nullptr){}

ControlBlueReceiver::~ControlBlueReceiver() {
    stopListening();
}

void ControlBlueReceiver::startListening(quint16 port) {
    udpSocket = new QUdpSocket(this);
    if (udpSocket->bind(QHostAddress("127.0.0.1"), port)) {
        connect(udpSocket, &QUdpSocket::readyRead, this, &ControlBlueReceiver::receive);
        std::cout << "Listening on port " << port << " (in thread)" << std::endl;
    } else {
        std::cerr << "Failed to bind UDP socket to port " << port << std::endl;
    }
}

void ControlBlueReceiver::receive() {
    RobotControl packet;
    while (udpSocket->hasPendingDatagrams()) {
        QNetworkDatagram datagram = udpSocket->receiveDatagram();
        if (!datagram.isValid()) continue;
        packet.ParseFromArray(datagram.data().data(), datagram.data().size());
        emit receivedPacket(packet, false);
    }
}

void ControlBlueReceiver::stopListening() {
    if (udpSocket) {
        udpSocket->close();
        udpSocket->deleteLater();
        udpSocket = nullptr;
    }
}

ControlYellowReceiver::ControlYellowReceiver(QObject *parent)
    : QObject(parent), udpSocket(nullptr){}

ControlYellowReceiver::~ControlYellowReceiver() {
    stopListening();
}

void ControlYellowReceiver::startListening(quint16 port) {
    udpSocket = new QUdpSocket(this);
    if (udpSocket->bind(QHostAddress("127.0.0.1"), port)) {
        connect(udpSocket, &QUdpSocket::readyRead, this, &ControlYellowReceiver::receive);
        std::cout << "Listening on port " << port << " (in thread)" << std::endl;
    } else {
        std::cerr << "Failed to bind UDP socket to port " << port << std::endl;
    }
}

void ControlYellowReceiver::receive() {
    RobotControl packet;
    while (udpSocket->hasPendingDatagrams()) {
        QNetworkDatagram datagram = udpSocket->receiveDatagram();
        if (!datagram.isValid()) continue;
        packet.ParseFromArray(datagram.data().data(), datagram.data().size());
        emit receivedPacket(packet, true);
    }
}

void ControlYellowReceiver::stopListening() {
    if (udpSocket) {
        udpSocket->close();
        udpSocket->deleteLater();
        udpSocket = nullptr;
    }
}
