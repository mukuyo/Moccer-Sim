#ifndef ROBOT_H
#define ROBOT_H

#include <QObject>
#include <iostream>

using namespace std;
class Robot : public QObject {
    Q_OBJECT
    Q_PROPERTY(int wheel_speed0 READ getWheelSpeed0 CONSTANT)
    Q_PROPERTY(int wheel_speed1 READ getWheelSpeed1 CONSTANT)
    Q_PROPERTY(int wheel_speed2 READ getWheelSpeed2 CONSTANT)
    Q_PROPERTY(int wheel_speed3 READ getWheelSpeed3 CONSTANT)

    // // 各ホイールの速度をプロパティとして定義
    // Q_PROPERTY(int wheelSpeed0 READ wheelSpeed0 WRITE setWheelSpeed0 NOTIFY wheelSpeed0Changed)
    // Q_PROPERTY(int wheelSpeed1 READ wheelSpeed1 WRITE setWheelSpeed1 NOTIFY wheelSpeed1Changed)
    // Q_PROPERTY(int wheelSpeed2 READ wheelSpeed2 WRITE setWheelSpeed2 NOTIFY wheelSpeed2Changed)
    // Q_PROPERTY(int wheelSpeed3 READ wheelSpeed3 WRITE setWheelSpeed3 NOTIFY wheelSpeed3Changed)

public:
    explicit Robot(QObject *parent = nullptr);
    ~Robot();

    // Getter
    int getWheelSpeed0() const;
    int getWheelSpeed1() const;
    int getWheelSpeed2() const;
    int getWheelSpeed3() const;

    // // Setter
    // void setWheelSpeed0(int speed);
    // void setWheelSpeed1(int speed);
    // void setWheelSpeed2(int speed);
    // void setWheelSpeed3(int speed);

    int wheel_speed0;
    int wheel_speed1;
    int wheel_speed2;
    int wheel_speed3;

public slots:
    void updateWheelSpeeds();

signals:
    // 各ホイール速度の変更シグナル
    // void wheelSpeed0Changed();
    // void wheelSpeed1Changed();
    // void wheelSpeed2Changed();
    // void wheelSpeed3Changed();
    
    void wheelSpeedChanged();

};

#endif // ROBOT_H
