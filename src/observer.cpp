#include "observer.h"

Observer::Observer(QObject *parent)
    : QObject(parent), visionReceiver(new VisionReceiver(nullptr)), controlBlueReceiver(new ControlBlueReceiver(nullptr)), controlYellowReceiver(new ControlYellowReceiver(nullptr)), sender(new Sender(10694)) {
    visionReceiver->startListening(20694);
    controlBlueReceiver->startListening(10301);
    controlYellowReceiver->startListening(10302);

    connect(visionReceiver, &VisionReceiver::receivedPacket, this, &Observer::visionReceive);
    connect(controlBlueReceiver, &ControlBlueReceiver::receivedPacket, this, &Observer::controlReceive);
    connect(controlYellowReceiver, &ControlYellowReceiver::receivedPacket, this, &Observer::controlReceive);

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

void Observer::visionReceive(const mocSim_Packet packet) {
    bool isYellow = packet.commands().isteamyellow();
    for (const auto& command : packet.commands().robot_commands()) {
        int id = command.id();
        if (isYellow) {
            yellow_robots[id]->visionUpdate(command);
        } else {
            blue_robots[id]->visionUpdate(command);
        }
    }
    if (isYellow) emit yellowRobotsChanged();
    else emit blueRobotsChanged();
}

void Observer::controlReceive(const RobotControl packet, bool isYellow) {
    for (const auto& robotCommand : packet.robot_commands()) {
        int id = robotCommand.id();
        if (isYellow) {
            yellow_robots[id]->controlUpdate(robotCommand);
        } else {
            blue_robots[id]->controlUpdate(robotCommand);
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
    sender->send(1, ball_position, blue_positions, yellow_positions);
}