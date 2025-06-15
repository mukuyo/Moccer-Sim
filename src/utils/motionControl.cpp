#include "motionControl.h"

MotionControl::MotionControl(QObject *parent)
    : QObject(parent), config("../config/config.ini", QSettings::IniFormat) {
    VelAbsoluteMax = config.value("Physics/VelAbsoluteMax", 5.0).toFloat();
    VelAngularMax = config.value("Physics/VelAngularMax", 3.0).toFloat();
    AccBrakeAbsoluteMax = config.value("Physics/AccBrakeAbsoluteMax", 4.0).toFloat();
    AccBrakeAngularMax = config.value("Physics/AccBrakeAngularMax", 50.0).toFloat();
    AccSpeedupAbsoluteMax = config.value("Physics/AccSpeedupAbsoluteMax", 4.0).toFloat();
    AccSpeedupAngularMax = config.value("Physics/AccSpeedupAngularMax", 50.0).toFloat();
}

QVector3D MotionControl::calcSpeed(QVector3D velocity, QVector3D botVelocity, float deltaTime, float botAngle) {
    float vx = velocity.x();
    float vy = velocity.y();
    float vw = velocity.z();
    float bx = botVelocity.x();
    float by = botVelocity.z();
    float bw = botVelocity.y();
    float v = sqrt(vx * vx + vy * vy);

    if (v > VelAbsoluteMax) {
        vx *= VelAbsoluteMax / v;
        vy *= VelAbsoluteMax / v;
        v = VelAbsoluteMax;
    }
    if (abs(vw) > VelAngularMax) {
        vw = copysign(VelAngularMax, vw);
    }
    float bv = sqrt(bx * bx + by * by);
    float a = (v - bv) / deltaTime / 2.0;
    float aLimit = a > 0 ? AccSpeedupAbsoluteMax : AccBrakeAbsoluteMax;
    cout << "a: " << a << ", aLimit: " << aLimit << endl;
    if (abs(a) > aLimit) {
        a = copysign(aLimit, a);
        float newV = bv + a * deltaTime * 2.0;
        if (v > 0) {
            vx *= newV / v;
            vy *= newV / v;
        } else {
            float angle = botAngle;
            float botVx = bx*cos(angle) + by*sin(angle);
            float botVy = by*cos(angle) - bx*sin(angle);
            vx = botVx * (newV / bv);
            vy = botVy * (newV / bv);
        }
    }
    float aw = (vw - bw) / deltaTime / 2.0;
    float awLimit = aw > 0 ? AccSpeedupAngularMax : AccBrakeAngularMax;
    if (abs(aw) > awLimit) {
        aw = copysign(awLimit, aw);
        vw = bw + aw * deltaTime * 2.0;
    }
    cout << "Velocity: " << vx << ", " << vy << ", " << vw << endl;

    return QVector3D(vx, vy, vw);
}