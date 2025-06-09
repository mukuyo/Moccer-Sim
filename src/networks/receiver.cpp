#include "receiver.h"

VisionReceiver::VisionReceiver(QObject *parent) : QObject(parent), udpSocket(new QUdpSocket(this)) {
}

VisionReceiver::~VisionReceiver() {
    stopListening();
}

void VisionReceiver::startListening(quint16 port) {
    if (udpSocket->state() != QAbstractSocket::BoundState) {
        udpSocket->close();
    }

    if (udpSocket->bind(QHostAddress::AnyIPv4, port)) {
        currentPort = port;
        connect(udpSocket, &QUdpSocket::readyRead, this, &VisionReceiver::receive, Qt::UniqueConnection);
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
    if (udpSocket && udpSocket->state() == QAbstractSocket::BoundState) {
        udpSocket->close();
    }
}

void VisionReceiver::setPort(quint16 newPort) {
    if (newPort == currentPort) return;
    stopListening();
    startListening(newPort);
}

ControlBlueReceiver::ControlBlueReceiver(QObject *parent)
    : QObject(parent), udpSocket(new QUdpSocket(this)){}

ControlBlueReceiver::~ControlBlueReceiver() {
    stopListening();
}

void ControlBlueReceiver::startListening(quint16 port) {
    if (udpSocket->state() != QAbstractSocket::BoundState) {
        udpSocket->close();
    }
    cout << "Starting to listen on port: " << port << std::endl;
    
    if (udpSocket->bind(QHostAddress::AnyIPv4, port)) {
        currentPort = port;
        connect(udpSocket, &QUdpSocket::readyRead, this, &ControlBlueReceiver::receive);
        std::cout << "Listening on port " << port << std::endl;
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

        RobotControlResponse robotControlResponse;
        for (int i = 0; i < bBotBallContacts.size(); ++i) {
            auto feedback = robotControlResponse.add_feedback();
            feedback->set_id(i);
            feedback->set_dribbler_ball_contact(bBotBallContacts[i]);
        }
        std::string serializedData;
        if (!robotControlResponse.SerializeToString(&serializedData)) {
            std::cerr << "Failed to serialize command." << std::endl;
            return;
        }
        udpSocket->writeDatagram(QByteArray::fromStdString(serializedData),
                                 datagram.senderAddress(), datagram.senderPort());
    }
}

void ControlBlueReceiver::updateBallContacts(const QList<bool> &bBotBallContacts, const QList<bool> &yBotBallContacts) {
    this->bBotBallContacts = bBotBallContacts;
}

void ControlBlueReceiver::setPort(quint16 newPort) {
    if (newPort == currentPort) return;
    stopListening();
    startListening(newPort);
}

void ControlBlueReceiver::stopListening() {
    if (udpSocket && udpSocket->state() == QAbstractSocket::BoundState) {
        udpSocket->close();
    }
}

ControlYellowReceiver::ControlYellowReceiver(QObject *parent)
    : QObject(parent), udpSocket(new QUdpSocket(this)){}

ControlYellowReceiver::~ControlYellowReceiver() {
    stopListening();
}

void ControlYellowReceiver::startListening(quint16 port) {
    if (udpSocket->state() != QAbstractSocket::BoundState) {
        udpSocket->close();
    }

    if (udpSocket->bind(QHostAddress::AnyIPv4, port)) {
        currentPort = port;
        connect(udpSocket, &QUdpSocket::readyRead, this, &ControlYellowReceiver::receive, Qt::UniqueConnection);
        std::cout << "Listening on port " << port << std::endl;
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

        RobotControlResponse robotControlResponse;
        for (int i = 0; i < yBotBallContacts.size(); ++i) {
            auto feedback = robotControlResponse.add_feedback();
            feedback->set_id(i);
            feedback->set_dribbler_ball_contact(yBotBallContacts[i]);
        }
        std::string serializedData;
        if (!robotControlResponse.SerializeToString(&serializedData)) {
            std::cerr << "Failed to serialize command." << std::endl;
            return;
        }
        udpSocket->writeDatagram(QByteArray::fromStdString(serializedData),
                                 datagram.senderAddress(), datagram.senderPort());
    }
}

void ControlYellowReceiver::updateBallContacts(const QList<bool> &bBotBallContacts, const QList<bool> &yBotBallContacts) {
    this->yBotBallContacts = yBotBallContacts;
}

void ControlYellowReceiver::stopListening() {
    if (udpSocket && udpSocket->state() == QAbstractSocket::BoundState) {
        udpSocket->close();
    }
}

void ControlYellowReceiver::setPort(quint16 newPort) {
    if (newPort == currentPort) return;
    stopListening();
    startListening(newPort);
}