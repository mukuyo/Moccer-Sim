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
    theta += 0.08f;

    positions = {
        QVariant::fromValue(QVector3D(0+r*cos(theta), 0+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(5+r*cos(theta), 0+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(-5+r*cos(theta), 0+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(0+r*cos(theta), 5+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(0+r*cos(theta), -5+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(7+r*cos(theta), 7+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(-7+r*cos(theta), 7+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(7+r*cos(theta), -7+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(-7+r*cos(theta), -7+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(10+r*cos(theta), 0+r*sin(theta), 0)),
        QVariant::fromValue(QVector3D(-10+r*cos(theta), 0+r*sin(theta), 0))
    };

    if (theta >= M_PI * 5)
        theta = -M_PI;

    // 位置更新
    position.setX(position.x() + 0.15f);

    // シグナルを発行
    emit wheelSpeedChanged();
    // emit positionChanged();
}

float Robot::getWheelSpeed0() const { return wheel_speed0; }
float Robot::getWheelSpeed1() const { return wheel_speed1; }
float Robot::getWheelSpeed2() const { return wheel_speed2; }
float Robot::getWheelSpeed3() const { return wheel_speed3; }
QVariantList Robot::getPositions() const { return positions; }
QVector3D Robot::getPosition() const { return position; }