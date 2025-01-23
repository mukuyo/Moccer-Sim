#include <QTimer>
#include "include/robot.h"

Robot::Robot(QObject *parent) : QObject(parent){
    QTimer *timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &Robot::updateWheelSpeeds);
    timer->start(16); // 100msごとに更新
}

Robot::~Robot() = default;

// Getter
float Robot::getWheelSpeed0() const { return wheel_speed0; }
float Robot::getWheelSpeed1() const { return wheel_speed1; }
float Robot::getWheelSpeed2() const { return wheel_speed2; }
float Robot::getWheelSpeed3() const { return wheel_speed3; }


void Robot::updateWheelSpeeds() {
    wheel_speed0 = 360.0/180.0*3.14;
    wheel_speed1 = 360.0/180.0*3.14;
    wheel_speed2 = 360.0/180.0*3.14;
    wheel_speed3 = 360.0/180.0*3.14;

    emit wheelSpeedChanged();
}
