#include "receiver.h"

ReceiverWorker::ReceiverWorker(QObject *parent)
    : QObject(parent), udpSocket(nullptr), running(false) {}

ReceiverWorker::~ReceiverWorker() {
    stopListening();
}

void ReceiverWorker::startListening(quint16 port) {
    udpSocket = new QUdpSocket(this);
    if (udpSocket->bind(QHostAddress::AnyIPv4, port)) {
        connect(udpSocket, &QUdpSocket::readyRead, this, &ReceiverWorker::receive);
        running = true;
        std::cout << "Listening on port " << port << " (in thread)" << std::endl;
    } else {
        std::cerr << "Failed to bind UDP socket to port " << port << std::endl;
    }
}

void ReceiverWorker::receive() {
    while (udpSocket->hasPendingDatagrams()) {
        QByteArray datagram;
        datagram.resize(static_cast<int>(udpSocket->pendingDatagramSize()));
        udpSocket->readDatagram(datagram.data(), datagram.size());
        
        mocSim_Packet packet;
        if (packet.ParseFromArray(datagram.data(), datagram.size())) {
            emit receivedPacket(packet);
        } else {
            std::cerr << "Failed to parse Protobuf packet" << std::endl;
        }
    }
}

void ReceiverWorker::stopListening() {
    running = false;
    if (udpSocket) {
        udpSocket->close();
        udpSocket->deleteLater();
        udpSocket = nullptr;
    }
}
