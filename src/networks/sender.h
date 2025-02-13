#ifndef SENDER_H
#define SENDER_H

#include <QObject>
#include <QThread>
#include <QUdpSocket>
#include <QHostAddress>
#include <iostream>
#include "mocSim_Packet.pb.h"

class SenderWorker : public QObject {
    Q_OBJECT

public:
    explicit SenderWorker(QObject *parent = nullptr);
    ~SenderWorker();

// public slots:
//     void startListening(quint16 port);
//     void receive();
//     void stopListening();

// signals:
//     void receivedPacket(const mocSim_Packet &packet);

// private:
//     QUdpSocket *udpSocket;
//     bool running;
};

#endif // sender.h