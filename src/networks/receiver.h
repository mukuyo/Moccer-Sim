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
#include "mocSim_Packet.pb.h"
#include "ssl_simulation_robot_control.pb.h"
#include "ssl_simulation_synchronous.pb.h"
#include "ssl_simulation_robot_feedback.pb.h"

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


class ControlBlueWorker : public QObject {
    Q_OBJECT

public:
    explicit ControlBlueWorker(QObject *parent = nullptr);
    ~ControlBlueWorker();

public slots:
    void startListening(quint16 port);
    void receive();
    void stopListening();
    void processRobotControl(const RobotControl &robotControl, RobotControlResponse &robotControlResponse, string team);

private:
    QUdpSocket *udpSocket;
    bool running;
};

// class ControlYellowWorker : public QObject {
//     Q_OBJECT

// public:
//     explicit ControlYellowWorker(QObject *parent = nullptr);
//     ~ControlYellowWorker();

// public slots:
//     void startListening(quint16 port);
//     void receive();
//     void stopListening();

// private:
//     QUdpSocket *udpSocket;
//     bool running;
// };

#endif // receiver.h