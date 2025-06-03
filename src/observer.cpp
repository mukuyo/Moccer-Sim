#include "observer.h"

Observer::Observer(QObject *parent)
    : QObject(parent), visionReceiver(new VisionReceiver(nullptr)), controlBlueReceiver(new ControlBlueReceiver(nullptr)), controlYellowReceiver(new ControlYellowReceiver(nullptr)), config("../config/config.ini", QSettings::IniFormat) {
    sender = new Sender(config.value("Network/visionMulticastPort", 10020).toInt(), this);
    visionReceiver->startListening(config.value("Network/CommandListenPort", 20011).toInt());
    controlBlueReceiver->startListening(config.value("Network/BlueTeamControlPort", 10301).toInt());
    controlYellowReceiver->startListening(config.value("Network/YellowTeamControlPort", 10302).toInt());

    connect(visionReceiver, &VisionReceiver::receivedPacket, this, &Observer::visionReceive);
    connect(controlBlueReceiver, &ControlBlueReceiver::receivedPacket, this, &Observer::controlReceive);
    connect(controlYellowReceiver, &ControlYellowReceiver::receivedPacket, this, &Observer::controlReceive);
    connect(this, &Observer::sendBotBallContacts, controlBlueReceiver, &ControlBlueReceiver::updateBallContacts);
    connect(this, &Observer::sendBotBallContacts, controlYellowReceiver, &ControlYellowReceiver::updateBallContacts);

    for (int i = 0; i < 16; ++i) {
        blue_robots[i] = new Robot();
        yellow_robots[i] = new Robot();
    }

    windowWidth = config.value("Display/width", 1100).toInt();
    windowHeight = config.value("Display/height", 720).toInt();

    visionMulticastPort = config.value("Network/visionMulticastPort", 10020).toInt();
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
    int receive_count = 0;
    for (const auto& robotCommand : packet.robot_commands()) {
        int id = robotCommand.id();
        if (!robotCommand.has_move_command()) continue;
        if (isYellow) {
            yellow_robots[id]->controlUpdate(robotCommand);
        } else {
            blue_robots[id]->controlUpdate(robotCommand);
        }
        receive_count++;
    }
    if (receive_count == 0) return;
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

int Observer::getWindowWidth() const {
    return windowWidth;
}
int Observer::getWindowHeight() const {
    return windowHeight;
}
int Observer::getVisionMulticastPort() const {
    return visionMulticastPort;
}

void Observer::setWindowWidth(int width) { 
    windowWidth = width; 
    config.setValue("window/width", width);
    emit settingChanged(); 
}
void Observer::setWindowHeight(int height) { 
    windowHeight = height; 
    config.setValue("window/height", height);
    emit settingChanged(); 
}
void Observer::setVisionMulticastPort(int port) { 
    visionMulticastPort = port; 
    config.setValue("Network/visionMulticastPort", port);
    sender->setPort(port);
    emit settingChanged(); 
}

void Observer::updateObjects(QList<QVector3D> blue_positions, QList<QVector3D> yellow_positions, QList<bool> bBotBallContacts, QList<bool> yBotBallContacts, QVector3D ball_position) {
    sender->send(1, ball_position, blue_positions, yellow_positions);
    emit sendBotBallContacts(bBotBallContacts, yBotBallContacts);
}
