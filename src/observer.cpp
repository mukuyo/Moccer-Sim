#include "observer.h"

ReceiverWorker::ReceiverWorker(QObject *parent)
    : QObject(parent), udpSocket(nullptr), running(false) {}

ReceiverWorker::~ReceiverWorker() {
    stopListening();
}

void ReceiverWorker::startListening(quint16 port) {
    udpSocket = new QUdpSocket(this);
    if (udpSocket->bind(QHostAddress::Any, port)) {
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
        datagram.resize(udpSocket->pendingDatagramSize());

        QHostAddress sender;
        quint16 senderPort;
        udpSocket->readDatagram(datagram.data(), datagram.size(), &sender, &senderPort);

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

Observer::Observer(QObject *parent)
    : QObject(parent), worker(new ReceiverWorker(nullptr)) {
    worker->moveToThread(&receiverThread);

    connect(&receiverThread, &QThread::started, worker, [this]() {
        worker->startListening(20011);  // grSim のデフォルトポート
    });

    connect(&receiverThread, &QThread::finished, worker, &QObject::deleteLater);

    receiverThread.start();
}

Observer::~Observer() {
    stop();
}

void Observer::stop() {
    if (receiverThread.isRunning()) {
        worker->stopListening();
        receiverThread.quit();
        receiverThread.wait();
    }
}
