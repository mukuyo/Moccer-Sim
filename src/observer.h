#ifndef OBSERVER_H
#define OBSERVER_H

#include <QObject>
#include <QThread>
#include <QUdpSocket>
#include <QHostAddress>
#include <iostream>
#include "networks/receiver.h"
#include "networks/sender.h"
#include "models/robot.h"
#include "mocSim_Packet.pb.h"

class Observer : public QObject {
    Q_OBJECT
    // Q_PROPERTY(QList<QObject*> blue_robots READ getBlueRobots NOTIFY blueRobotsChanged)
    // Q_PROPERTY(QList<QObject*> yellow_robots READ getYellowRobots NOTIFY yellowRobotsChanged)

public:
    explicit Observer(QObject *parent = nullptr);
    ~Observer();

    Q_INVOKABLE void updateObjects(QList<QVector3D> blue_positions, QList<QVector3D> yellow_positions, QVector3D ball_position);

    void start(quint16 port);
    void stop();

    // void receive(Robot *blue_robots[16], Robot *yellow_robots[16]);

    // QList<QObject*> getBlueRobots() const;
    // QList<QObject*> getYellowRobots() const;

signals:
    void blueRobotsChanged();
    void yellowRobotsChanged();

private:
    VisionReceiver *visionReceiver;
    ControlReceiver *controlReceiver;

    Sender *sender;
    SenderControl *senderControl;
};

#endif // OBSERVER_H
