#ifndef OBSERVER_H
#define OBSERVER_H

#include <QObject>
#include <QThread>
#include <QUdpSocket>
#include <QHostAddress>
#include <QSettings>
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
    Q_PROPERTY(int windowWidth READ getWindowWidth WRITE setWindowWidth NOTIFY settingChanged)
    Q_PROPERTY(int windowHeight READ getWindowHeight WRITE setWindowHeight NOTIFY settingChanged)  

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
    int getWindowWidth() const;
    int getWindowHeight() const;
    
    void setWindowWidth(int width) { windowWidth = width; emit settingChanged(); }
    void setWindowHeight(int height) { windowHeight = height; emit settingChanged(); }

signals:
    void blueRobotsChanged();
    void yellowRobotsChanged();
    void settingChanged();
    void sendBotBallContacts(const QList<bool> &bBotBallContacts, const QList<bool> &yBotBallContacts);

private:
    QSettings config;

    VisionReceiver *visionReceiver;
    ControlBlueReceiver *controlBlueReceiver;
    ControlYellowReceiver *controlYellowReceiver;

    Sender *sender;

    Robot *blue_robots[16];
    Robot *yellow_robots[16];

    int windowWidth;
    int windowHeight;

    RobotControlResponse robotControlResponse;
};

#endif // OBSERVER_H
