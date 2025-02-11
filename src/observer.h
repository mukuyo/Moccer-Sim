#ifndef OBSERVER_H
#define OBSERVER_H

#include <QObject>
#include <QThread>
#include <QUdpSocket>
#include <QHostAddress>
#include <iostream>
#include "mocSim_Packet.pb.h"

// 受信スレッド用のクラス
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

// Observer クラス
class Observer : public QObject {
    Q_OBJECT

public:
    explicit Observer(QObject *parent = nullptr);
    ~Observer();

    void start(quint16 port);
    void stop();

// private slots:
//     void handlePacket(const mocSim_Packet &packet);

private:
    QThread receiverThread;
    ReceiverWorker *worker;
};

#endif // OBSERVER_H
