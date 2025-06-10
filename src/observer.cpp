#include "observer.h"

Observer::Observer(QObject *parent)
    : QObject(parent), visionReceiver(new VisionReceiver(nullptr)), controlBlueReceiver(new ControlBlueReceiver(nullptr)), controlYellowReceiver(new ControlYellowReceiver(nullptr)), config("../config/config.ini", QSettings::IniFormat) {
    visionMulticastAddress = config.value("Network/visionMulticastAddress", "127.0.0.1").toString();
    visionMulticastPort = config.value("Network/visionMulticastPort", 10020).toInt();
    commandListenPort = config.value("Network/commandListenPort", 20011).toInt();
    blueTeamControlPort = config.value("Network/blueTeamControlPort", 10301).toInt();
    yellowTeamControlPort = config.value("Network/yellowTeamControlPort", 10302).toInt();
    
    forceDebugDrawMode = config.value("Display/ForceDebugDrawMode", false).toBool();
    lightBlueRobotMode = config.value("LightMode/BlueRobot", true).toBool();
    lightYellowRobotMode = config.value("LightMode/YellowRobot", true).toBool();
    lightStadiumMode = config.value("LightMode/Stadium", true).toBool();
    lightFieldMode = config.value("LightMode/Field", true).toBool();

    sender = new Sender(visionMulticastAddress.toStdString(), visionMulticastPort, this);
    visionReceiver->startListening(commandListenPort);
    controlBlueReceiver->startListening(blueTeamControlPort);
    controlYellowReceiver->startListening(yellowTeamControlPort);

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

    blueRobotCount = config.value("Robot/blueRobotCount", 11).toInt();
    yellowRobotCount = config.value("Robot/yellowRobotCount", 11).toInt();

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

void Observer::setWindowWidth(int width) { 
    windowWidth = width; 
    config.setValue("Display/width", width);
    emit settingChanged(); 
}
void Observer::setWindowHeight(int height) { 
    windowHeight = height; 
    config.setValue("Display/height", height);
    emit settingChanged(); 
}
void Observer::setVisionMulticastPort(int port) { 
    visionMulticastPort = port; 
    config.setValue("Network/visionMulticastPort", port);
    sender->setPort(visionMulticastAddress.toStdString(), visionMulticastPort);
    emit settingChanged(); 
}
void Observer::setVisionMulticastAddress(const QString &address) {
    visionMulticastAddress = address;
    config.setValue("Network/visionMulticastAddress", QString::fromStdString(visionMulticastAddress.toStdString()));
    sender->setPort(visionMulticastAddress.toStdString() , visionMulticastPort);
    emit settingChanged();
}
void Observer::setCommandListenPort(int port) {
    commandListenPort = port;
    config.setValue("Network/commandListenPort", port);
    visionReceiver->setPort(commandListenPort);
    emit settingChanged();
}
void Observer::setBlueTeamControlPort(int port) {
    blueTeamControlPort = port;
    config.setValue("Network/blueTeamControlPort", port);
    controlBlueReceiver->setPort(blueTeamControlPort);
    emit settingChanged();
}
void Observer::setYellowTeamControlPort(int port) {
    yellowTeamControlPort = port;
    config.setValue("Network/yellowTeamControlPort", port);
    controlYellowReceiver->setPort(yellowTeamControlPort);
    emit settingChanged();
}
void Observer::setForceDebugDrawMode(bool mode) {
    forceDebugDrawMode = mode;
    config.setValue("Display/ForceDebugDrawMode", mode);
    emit settingChanged();
}
void Observer::setLightBlueRobotMode(bool mode) {
    lightBlueRobotMode = mode;
    config.setValue("LightMode/BlueRobot", mode);
    emit settingChanged();
}
void Observer::setLightYellowRobotMode(bool mode) {
    lightYellowRobotMode = mode;
    config.setValue("LightMode/YellowRobot", mode);
    emit settingChanged();
}
void Observer::setLightStadiumMode(bool mode) {
    lightStadiumMode = mode;
    config.setValue("LightMode/Stadium", mode);
    emit settingChanged();
}
void Observer::setLightFieldMode(bool mode) {
    lightFieldMode = mode;
    config.setValue("LightMode/Field", mode);
    emit settingChanged();
}
void Observer::setBlueRobotCount(int count) {
    blueRobotCount = count;
    config.setValue("Robot/blueRobotCount", count);
    emit settingChanged();
}
void Observer::setYellowRobotCount(int count) {
    yellowRobotCount = count;
    config.setValue("Robot/yellowRobotCount", count);
    emit settingChanged();
}

void Observer::updateObjects(QList<QVector3D> blue_positions, QList<QVector3D> yellow_positions, QList<bool> bBotBallContacts, QList<bool> yBotBallContacts, QVector3D ball_position) {
    sender->send(1, ball_position, blue_positions, yellow_positions);
    emit sendBotBallContacts(bBotBallContacts, yBotBallContacts);
}
