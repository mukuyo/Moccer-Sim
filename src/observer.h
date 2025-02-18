#ifndef OBSERVER_H
#define OBSERVER_H

#include <QObject>
#include <QThread>
#include <QUdpSocket>
#include <QHostAddress>
#include <iostream>
#include "networks/receiver.h"
#include "models/robot.h"
#include "mocSim_Packet.pb.h"

class Observer : public QObject {
    Q_OBJECT

public:
    explicit Observer(QObject *parent = nullptr);
    ~Observer();

    void start(quint16 port);
    void stop();

    void receive(const mocSim_Packet& packet);

private:
    QThread receiverThread;
    ReceiverWorker *worker;

    Robot *robot[16];
};

#endif // OBSERVER_H
