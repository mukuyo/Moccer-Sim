#ifndef ROBOT_H
#define ROBOT_H

#include <iostream>
#include <QObject>
#include <QVector3D>
#include <QVariantList>
#include <QElapsedTimer>
#include <QRandomGenerator>

#include "mocSim_Commands.pb.h"

using namespace std;

class Robot : public QObject {
    Q_OBJECT

    Q_PROPERTY(uint32_t id READ getId)
    Q_PROPERTY(float kickspeedx READ getKickspeedx)
    Q_PROPERTY(float kickspeedz READ getKickspeedz)
    Q_PROPERTY(float veltangent READ getVeltangent)
    Q_PROPERTY(float velnormal READ getVelnormal)
    Q_PROPERTY(float velangular READ getVelangular)
    Q_PROPERTY(float spinner READ getSpinner)
    Q_PROPERTY(bool wheelsspeed READ getWheelsspeed)
    Q_PROPERTY(float wheel1 READ getWheel1)
    Q_PROPERTY(float wheel2 READ getWheel2)
    Q_PROPERTY(float wheel3 READ getWheel3)
    Q_PROPERTY(float wheel4 READ getWheel4)

public:
    explicit Robot(QObject *parent = nullptr);
    ~Robot();

    void update(mocSim_Robot_Command robot_command);

    uint32_t getId() const;
    float getKickspeedx() const;
    float getKickspeedz() const;
    float getVeltangent() const;
    float getVelnormal() const;
    float getVelangular() const;
    float getSpinner() const;
    bool getWheelsspeed() const;
    float getWheel1() const;
    float getWheel2() const;
    float getWheel3() const;
    float getWheel4() const;

private:
    // void updatePosition();
    // void updateWheelSpeeds();    

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

};

#endif // ROBOT_H