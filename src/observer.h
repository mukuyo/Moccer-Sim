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

    Q_PROPERTY(QList<QObject*> robots READ getRobots NOTIFY robotsChanged)

public:
    explicit Observer(QObject *parent = nullptr);
    ~Observer();

    void start(quint16 port);
    void stop();

    void receive(const mocSim_Packet& packet);

    QList<QObject*> getRobots() const;

signals:
    void robotsChanged();

private:
    QThread receiverThread;
    ReceiverWorker *worker;

    Robot *robots[16];
};

#endif // OBSERVER_H
