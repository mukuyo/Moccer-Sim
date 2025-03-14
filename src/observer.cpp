#include "observer.h"

Observer::Observer(QObject *parent)
    : QObject(parent), visionReceiver(new VisionReceiver(nullptr)), controlReceiver(new ControlReceiver(nullptr)), sender(new Sender(10694)) {
    visionReceiver->startListening(20694);
    controlReceiver->startListening(10301);

    connect(visionReceiver, &VisionReceiver::receivedPacket, this, &Observer::receive);

    for (int i = 0; i < 16; ++i) {
        blue_robots[i] = new Robot();
        yellow_robots[i] = new Robot();
    } 
}

Observer::~Observer() {
    for (int i = 0; i < 16; ++i) {
        delete blue_robots[i];
        delete yellow_robots[i];
    }
}

void Observer::receive(const mocSim_Packet packet) {
    bool isYellow = packet.commands().isteamyellow();
    for (int i = 0; i < packet.commands().robot_commands_size(); ++i) {
        if (isYellow) {
            yellow_robots[packet.commands().robot_commands(i).id()]->update(packet.commands().robot_commands(i));
        } else {
            blue_robots[packet.commands().robot_commands(i).id()]->update(packet.commands().robot_commands(i));
        }
    }
    if (isYellow) emit yellowRobotsChanged();
    else emit blueRobotsChanged();
}

QList<QObject*> Observer::getBlueRobots() const {
    QList<QObject*> list;
    for (int i = 0; i < 16; ++i) {
        list.append(blue_robots[i]);
    }
    return list;
}

QList<QObject*> Observer::getYellowRobots() const {
    QList<QObject*> list;
    for (int i = 0; i < 16; ++i) {
        list.append(yellow_robots[i]);
    }
    return list;
}

void Observer:: updateObjects(QList<QVector3D> blue_positions, QList<QVector3D> yellow_positions, QVector3D ball_position) {
    sender->send(2, ball_position, blue_positions, yellow_positions);
}