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

    Q_PROPERTY(QList<QObject*> blue_robots READ getBlueRobots NOTIFY blueRobotsChanged)
    Q_PROPERTY(QList<QObject*> yellow_robots READ getYellowRobots NOTIFY yellowRobotsChanged)

public:
    explicit Observer(QObject *parent = nullptr);
    ~Observer();

    Q_INVOKABLE void updateBlueRobots(QList<QVector3D> positions, QList<QVector3D> rotations);
    Q_INVOKABLE void updateYellowRobots(QList<QVector3D> positions, QList<QVector3D> rotations);

    Q_INVOKABLE void updateBall(QVector3D position);

    void start(quint16 port);
    void stop();

    void receive(const mocSim_Packet& packet);

    QList<QObject*> getBlueRobots() const;
    QList<QObject*> getYellowRobots() const;

signals:
    void blueRobotsChanged();
    void yellowRobotsChanged();

private:
    QThread receiverThread;
    ReceiverWorker *worker;

    Robot *blue_robots[16];
    Robot *yellow_robots[16];
};

#endif // OBSERVER_H
