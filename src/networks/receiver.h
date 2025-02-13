#ifndef RECEIVER_H
#define RECEIVER_H

#include <QObject>
#include <QThread>
#include <QUdpSocket>
#include <QHostAddress>
#include <iostream>
#include "mocSim_Packet.pb.h"

using namespace std;

class ReceiverWorker : public QObject {
    Q_OBJECT

public:
    explicit ReceiverWorker(QObject *parent = nullptr);
    ~ReceiverWorker();

public slots:
    void startListening(quint16 port);
    void receive();
    void stopListening();

signals:
    void receivedPacket(const mocSim_Packet &packet);

private:
    QUdpSocket *udpSocket;
    bool running;
};

#endif // receiver.h