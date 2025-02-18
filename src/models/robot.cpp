#include "robot.h"
#include <cmath>

Robot::Robot(QObject *parent)
    : QObject(parent),
      id(0),
      kickspeedx(0.0f),
      kickspeedz(0.0f),
      veltangent(0.0f),
      velnormal(0.0f),
      velangular(0.0f),
      spinner(false),
      wheelsspeed(false),
      wheel1(0.0f),
      wheel2(0.0f),
      wheel3(0.0f),
      wheel4(0.0f) {}

Robot::~Robot() = default;


void Robot::update(mocSim_Robot_Command robot_command) {
    id = robot_command.id();
    kickspeedx = robot_command.kickspeedx();
    kickspeedz = robot_command.kickspeedz();
    veltangent = robot_command.veltangent();
    velnormal = robot_command.velnormal();
    velangular = robot_command.velangular();
    spinner = robot_command.spinner();
    wheelsspeed = robot_command.wheelsspeed();
    wheel1 = robot_command.wheel1();
    wheel2 = robot_command.wheel2();
    wheel3 = robot_command.wheel3();
    wheel4 = robot_command.wheel4();
}

// void Robot::updateInfo() {
//     updateWheelSpeeds();
//     updatePosition();
//     emit updateChanged();
// }

// void Robot::updateWheelSpeeds() {
    // wheel_speed0 = 360.0 / 180.0 * M_PI;
    // wheel_speed1 = 360.0 / 180.0 * M_PI;
    // wheel_speed2 = 360.0 / 180.0 * M_PI;
    // wheel_speed3 = 360.0 / 180.0 * M_PI;
// }

// void Robot::updatePosition() {
//     float r = 0.0f;
    // theta += 0.05f;
    // positoin = QVector3D(0, 0, 0);
    // positions = {
    //     QVariant::fromValue(QVector3D(-60+r*cos(theta), 0+r*sin(theta), 0)),
    //     // QVariant::fromValue(QVector3D(100+r*cos(theta), 0+r*sin(theta), 0)),
    //     // QVariant::fromValue(QVector3D(-100+r*cos(theta), 0+r*sin(theta), 0)),
    //     // QVariant::fromValue(QVector3D(0+r*cos(theta), 100+r*sin(theta), 0)),
    //     // QVariant::fromValue(QVector3D(0+r*cos(theta), -100+r*sin(theta), 0)),
    //     // QVariant::fromValue(QVector3D(200+r*cos(theta), 200+r*sin(theta), 0)),
    //     // QVariant::fromValue(QVector3D(-200+r*cos(theta), 200+r*sin(theta), 0)),
    //     // QVariant::fromValue(QVector3D(200+r*cos(theta), -200+r*sin(theta), 0)),
    //     // QVariant::fromValue(QVector3D(-200+r*cos(theta), -200+r*sin(theta), 0)),
    //     // QVariant::fromValue(QVector3D(300+r*cos(theta), 0+r*sin(theta), 0)),
    //     // QVariant::fromValue(QVector3D(-300+r*cos(theta), 0+r*sin(theta), 0))
    // };
// }


uint32_t Robot::getId() const { return id; }
float Robot::getKickspeedx() const { return kickspeedx; }
float Robot::getKickspeedz() const { return kickspeedz; }
float Robot::getVeltangent() const { return veltangent; }
float Robot::getVelnormal() const { return velnormal; }
float Robot::getVelangular() const { return velangular; }
float Robot::getSpinner() const { return spinner; }
bool Robot::getWheelsspeed() const { return wheelsspeed; }
float Robot::getWheel1() const { return wheel1; }
float Robot::getWheel2() const { return wheel2; }
float Robot::getWheel3() const { return wheel3; }
float Robot::getWheel4() const { return wheel4; }
