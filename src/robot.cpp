#include <QTimer>
#include "include/robot.h"

Robot::Robot(QObject *parent) : QObject(parent){
    QTimer *timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &Robot::updateWheelSpeeds);
    timer->start(16); // 16msごとに更新

    theta = -M_PI;
}

Robot::~Robot() = default;

// Getter
float Robot::getWheelSpeed0() const { return wheel_speed0; }
float Robot::getWheelSpeed1() const { return wheel_speed1; }
float Robot::getWheelSpeed2() const { return wheel_speed2; }
float Robot::getWheelSpeed3() const { return wheel_speed3; }

QVector3D Robot::getPosition() const { return position; }

void Robot::updateWheelSpeeds() {
    wheel_speed0 = 360.0/180.0*M_PI;
    wheel_speed1 = 360.0/180.0*M_PI;
    wheel_speed2 = 360.0/180.0*M_PI;
    wheel_speed3 = 360.0/180.0*M_PI;
    float r = 10.0;
    theta += 0.01;
    if (theta >= M_PI)
        theta = -M_PI;
    position = QVector3D(r*cos(theta), r*sin(theta), 0);

    emit wheelSpeedChanged();
}
