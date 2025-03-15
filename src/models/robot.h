#ifndef ROBOT_H
#define ROBOT_H

#include <iostream>
#include <QObject>
#include <QVector3D>
#include <QVariantList>
#include <QElapsedTimer>
#include <QRandomGenerator>
#include <QDebug>

#include "mocSim_Commands.pb.h"
#include "ssl_simulation_robot_control.pb.h"
#include "ssl_simulation_robot_feedback.pb.h"

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

    void visionUpdate(mocSim_Robot_Command robotCommand);
    void controlUpdate(RobotCommand robotCommand);

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
    void processMoveCommand(const RobotMoveCommand &moveCommand);

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

};

#endif // ROBOT_H