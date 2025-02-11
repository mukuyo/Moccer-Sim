#ifndef ROBOT_H
#define ROBOT_H

#include <iostream>
#include <QObject>
#include <QVector3D>
#include <QVariantList>
#include <QElapsedTimer>
#include <QRandomGenerator>

using namespace std;

class Robot : public QObject {
    Q_OBJECT
    Q_PROPERTY(float wheel1 READ getWheel1 CONSTANT)
    // Q_PROPERTY(float wheel_speed1 READ getWheelSpeed1 CONSTANT)
    // Q_PROPERTY(float wheel_speed2 READ getWheelSpeed2 CONSTANT)
    // Q_PROPERTY(float wheel_speed3 READ getWheelSpeed3 CONSTANT)
    // Q_PROPERTY(QVector3D position READ getPosition CONSTANT)

public:
    explicit Robot(QObject *parent = nullptr);
    ~Robot();

    float getWheel1() const;
    // float getWheelSpeed0() const;
    // float getWheelSpeed1() const;
    // float getWheelSpeed2() const;
    // float getWheelSpeed3() const;

    // QVector3D getPosition() const;

private:
    void updatePosition();
    void updateWheelSpeeds();    

    uint32_t id;
    float kickspeedx;
    float kickspeedz;
    float veltangent;
    float velnormal;
    float velangular;

    bool spinner;
    bool wheelsspeed;

    float wheel1;
    float wheel2;
    float wheel3;
    float wheel4;

    // float theta;
    // float wheel_speed0;
    // float wheel_speed1;
    // float wheel_speed2;
    // float wheel_speed3;
    // QVariantList positions;

    // int id;
    // QVector3D position;
    // float distance_ball_robot;
    // float radian_ball_robot;
    // float diff_x;
    // float diff_y;
    // float diff_theta;
    // float speed;
    // float slope;
    // float intercept;
    // float angular_velocity;
    // bool visible;
    // bool ball_catch;

public slots:
    void updateInfo();

signals:
    void updateChanged();
};

#endif // ROBOT_H