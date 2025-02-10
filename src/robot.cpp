#include "include/robot.h"
#include <cmath>

Robot::Robot(QObject *parent)
    : QObject(parent), theta(-M_PI), wheel_speed0(0), wheel_speed1(0), wheel_speed2(0), wheel_speed3(0) {}

Robot::~Robot() = default;

void Robot::updateWheelSpeeds() {
    wheel_speed0 = 360.0 / 180.0 * M_PI;
    wheel_speed1 = 360.0 / 180.0 * M_PI;
    wheel_speed2 = 360.0 / 180.0 * M_PI;
    wheel_speed3 = 360.0 / 180.0 * M_PI;

    // 半径と角度の更新
    float r = 40.0f;
    theta += 0.0f;

    positions = {
        QVariant::fromValue(QVector3D(0+r*cos(theta), 0+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(100+r*cos(theta), 0+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(-100+r*cos(theta), 0+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(0+r*cos(theta), 100+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(0+r*cos(theta), -100+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(200+r*cos(theta), 200+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(-200+r*cos(theta), 200+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(200+r*cos(theta), -200+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(-200+r*cos(theta), -200+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(300+r*cos(theta), 0+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(-300+r*cos(theta), 0+r*sin(theta), 0))
    };

    if (theta >= M_PI * 5)
        theta = -M_PI;

    // シグナルを発行
    emit wheelSpeedChanged();
}

float Robot::getWheelSpeed0() const { return wheel_speed0; }
float Robot::getWheelSpeed1() const { return wheel_speed1; }
float Robot::getWheelSpeed2() const { return wheel_speed2; }
float Robot::getWheelSpeed3() const { return wheel_speed3; }
QVariantList Robot::getPositions() const { return positions; }
QVector3D Robot::getPosition() const { return position; }