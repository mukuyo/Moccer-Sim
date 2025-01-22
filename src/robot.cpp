#include <QTimer>
#include "include/robot.h"

Robot::Robot(QObject *parent) : QObject(parent){
    // 定期的に速度を更新するタイマー
    QTimer *timer = new QTimer(this);
    connect(timer, &QTimer::timeout, this, &Robot::updateWheelSpeeds);
    timer->start(100); // 100msごとに更新
}

Robot::~Robot() = default;

// Getter
int Robot::getWheelSpeed0() const { return wheel_speed0; }
int Robot::getWheelSpeed1() const { return wheel_speed1; }
int Robot::getWheelSpeed2() const { return wheel_speed2; }
int Robot::getWheelSpeed3() const { return wheel_speed3; }

// Setter
// void Robot::setWheelSpeed0(int speed) {
//     if (qFuzzyCompare(m_wheelSpeed0, speed)) return;
//     m_wheelSpeed0 = speed;
//     emit wheelSpeed0Changed();
// }

// void Robot::setWheelSpeed1(int speed) {
//     if (qFuzzyCompare(m_wheelSpeed1, speed)) return;
//     m_wheelSpeed1 = speed;
//     emit wheelSpeed1Changed();
// }

// void Robot::setWheelSpeed2(int speed) {
//     if (qFuzzyCompare(m_wheelSpeed2, speed)) return;
//     m_wheelSpeed2 = speed;
//     emit wheelSpeed2Changed();
// }

// void Robot::setWheelSpeed3(int speed) {
//     if (qFuzzyCompare(m_wheelSpeed3, speed)) return;
//     m_wheelSpeed3 = speed;
//     emit wheelSpeed3Changed();
// }

// 各ホイールの速度をランダムに更新する (例として固定値を使用)
void Robot::updateWheelSpeeds() {
    // setWheelSpeed0(10.0); // 仮の速度 (m/s)
    // setWheelSpeed1(12.0); // 仮の速度 (m/s)
    // setWheelSpeed2(8.0);  // 仮の速度 (m/s)
    // setWheelSpeed3(11.0); // 仮の速度 (m/s)
    
    wheel_speed0 = 1000.0;
    wheel_speed1 = 10.0;
    wheel_speed2 = 10.0;
    wheel_speed3 = 1.0;
    // cout<<wheel_speed0<<endl;
    emit wheelSpeedChanged();
}
