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

void Robot::updateInfo() {
    updateWheelSpeeds();
    updatePosition();

    emit updateChanged();
}

void Robot::updateWheelSpeeds() {
    // wheel_speed0 = 360.0 / 180.0 * M_PI;
    // wheel_speed1 = 360.0 / 180.0 * M_PI;
    // wheel_speed2 = 360.0 / 180.0 * M_PI;
    // wheel_speed3 = 360.0 / 180.0 * M_PI;
}

void Robot::updatePosition() {
    float r = 0.0f;
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
}

float Robot::getWheel1() const { return wheel1; }
// float Robot::getWheelSpeed0() const { return wheel_speed0; }
// float Robot::getWheelSpeed1() const { return wheel_speed1; }
// float Robot::getWheelSpeed2() const { return wheel_speed2; }
// float Robot::getWheelSpeed3() const { return wheel_speed3; }
// QVector3D Robot::getPosition() const { return position; }
