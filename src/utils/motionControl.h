#pragma once

#include <iostream>
#include <QObject>
#include <QVector3D>
#include <QSettings>
#include <cmath>

using namespace std;

class MotionControl : public QObject {
    Q_OBJECT

public:
    explicit MotionControl(QObject *parent = nullptr);

    Q_INVOKABLE QVector3D calcSpeed(QVector3D velocity, QVector3D botVelocity, QVector3D botPreVelocity, float deltaTime, float botAngle);

private:
    QSettings config;

    float VelAbsoluteMax;
    float VelAngularMax;
    float AccBrakeAbsoluteMax;
    float AccBrakeAngularMax;
    float AccSpeedupAbsoluteMax;
    float AccSpeedupAngularMax;
};