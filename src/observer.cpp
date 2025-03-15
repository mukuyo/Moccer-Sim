#include "observer.h"

Observer::Observer(QObject *parent)
    : QObject(parent), visionReceiver(new VisionReceiver(nullptr)), controlReceiver(new ControlReceiver(nullptr)), sender(new Sender(10694)) {
    visionReceiver->startListening(20694);
    controlReceiver->startListening(10301);

    connect(visionReceiver, &VisionReceiver::receivedPacket, this, &Observer::visionReceive);
    connect(controlReceiver, &ControlReceiver::receivedPacket, this, &Observer::controlReceive);

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
    // for (const auto& robotCommand : packet.robot_commands()) {
    //     int id = robotCommand.id();

    //     if (robotCommand.has_kick_speed() && robotCommand.kick_speed() > 0) {
    //         double kickSpeed = robotCommand.kick_speed();
    //         double limit = robotCommand.kick_angle() > 0 ? 10 : 10;
    //         if (kickSpeed > limit) {
    //             kickSpeed = limit;
    //         }
    //         double kickAngle = robotCommand.kick_angle() * M_PI / 180.0;
    //         double length = cos(kickAngle) * kickSpeed;
    //         double z = sin(kickAngle) * kickSpeed;

    //         // robot->kicker->kick(length, z);
    //     }

        // if (robotCommand.has_dribbler_speed()) {
        //     // robot->kicker->setRoller(robotCommand.dribbler_speed() > 0 ? 1 : 0);
        // }

        // if (robotCommand.has_move_command()) {
        //     // processMoveCommand(robotControlResponse, robotCommand.move_command(), nullptr); // 仮のnullptr
        // }

    // }
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