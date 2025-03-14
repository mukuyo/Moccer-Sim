#ifndef RECEIVER_H
#define RECEIVER_H

#include <QObject>
#include <QThread>
#include <QUdpSocket>
#include <QHostAddress>
#include <QNetworkDatagram>
#include <iostream>
#include <thread>
#include <chrono>
#include <string>
#include "models/robot.h"
#include "mocSim_Packet.pb.h"
#include "ssl_simulation_robot_control.pb.h"
#include "ssl_simulation_synchronous.pb.h"
#include "ssl_simulation_robot_feedback.pb.h"

using namespace std;

class VisionReceiver : public QObject
{
    Q_OBJECT
    // Q_PROPERTY(QList<QObject*> blue_robots READ getBlueRobots NOTIFY blueRobotsChanged)
    // Q_PROPERTY(QList<QObject*> yellow_robots READ getYellowRobots NOTIFY yellowRobotsChanged)

public:
    explicit VisionReceiver(QObject *parent = nullptr);
    ~VisionReceiver();

    void startListening(quint16 port);
    void stopListening();

    QList<QObject*> getBlueRobots() const;
    QList<QObject*> getYellowRobots() const;

signals:
    void receivedPacket(const mocSim_Packet &packet);

private slots:
    void receive();

private:
    QUdpSocket *udpSocket;

    Robot *blue_robots[16];
    Robot *yellow_robots[16];
};

class ControlReceiver : public QObject
{
    Q_OBJECT

public:
    explicit ControlReceiver(QObject *parent = nullptr);
    ~ControlReceiver();

public slots:
    void startListening(quint16 port);
    void receive();
    void stopListening();
    void processRobotControl(const RobotControl &robotControl, RobotControlResponse &robotControlResponse, std::string team);

private:
    // void processMoveCommand(RobotControlResponse &robotControlResponse, const RobotMoveCommand &moveCommand, Robot *robot);

    QUdpSocket *udpSocket;
};

#endif // receiver.h