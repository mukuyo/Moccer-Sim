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
#include "ssl_simulation_robot_control.pb.h"

using namespace std;

class Observer : public QObject {
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> blue_robots READ getBlueRobots NOTIFY blueRobotsChanged)
    Q_PROPERTY(QList<QObject*> yellow_robots READ getYellowRobots NOTIFY yellowRobotsChanged)

public:
    explicit Observer(QObject *parent = nullptr);
    ~Observer();

    Q_INVOKABLE void updateObjects(QList<QVector3D> blue_positions, QList<QVector3D> yellow_positions, QList<bool> bBotBallContacts, QList<bool> yBotBallContacts, QVector3D ball_position);

    void start(quint16 port);
    void stop();

    void visionReceive(mocSim_Packet packet);
    void controlReceive(RobotControl packet, bool isYellow);

    QList<QObject*> getBlueRobots() const;
    QList<QObject*> getYellowRobots() const;

signals:
    void blueRobotsChanged();
    void yellowRobotsChanged();
    void sendBotBallContacts(const QList<bool> &bBotBallContacts, const QList<bool> &yBotBallContacts);

private:
    VisionReceiver *visionReceiver;
    ControlBlueReceiver *controlBlueReceiver;
    ControlYellowReceiver *controlYellowReceiver;

    Sender *sender;

    Robot *blue_robots[16];
    Robot *yellow_robots[16];

    RobotControlResponse robotControlResponse;
};

#endif // OBSERVER_H
