#include "motionControl.h"

MotionControl::MotionControl(QObject *parent)
    : QObject(parent), config("../config/config.ini", QSettings::IniFormat) {
    VelAbsoluteMax = config.value("Physics/VelAbsoluteMax", 5000.0).toFloat();
    VelAngularMax = config.value("Physics/VelAngularMax", 3.0).toFloat();
    AccBrakeAbsoluteMax = config.value("Physics/AccBrakeAbsoluteMax", 4000.0).toFloat();
    AccBrakeAngularMax = config.value("Physics/AccBrakeAngularMax", 50.0).toFloat();
    AccSpeedupAbsoluteMax = config.value("Physics/AccSpeedupAbsoluteMax", 4000.0).toFloat();
    AccSpeedupAngularMax = config.value("Physics/AccSpeedupAngularMax", 50.0).toFloat();
}

QVector3D MotionControl::calcSpeed(QVector3D velocity, QVector3D botVelocity, float deltaTime, float botAngle) {
    float vx = velocity.x();
    float vy = velocity.y();
    float vw = velocity.z();
    float bx = botVelocity.x();
    float by = botVelocity.z();
    float bw = botVelocity.y();
    if (abs(bx) > 10000)
        bx = 0;
    if (abs(by) > 10000)
        by = 0;
    if (abs(bw) > 50)
        bw = 0;

    float v = sqrt(vx * vx + vy * vy);
    float bv = sqrt(bx * bx + by * by);
    float a = 0;

    if (vx != 0 && vy != 0) {
        if (v > VelAbsoluteMax) {
            vx *= VelAbsoluteMax / v;
            vy *= VelAbsoluteMax / v;
            v = VelAbsoluteMax;
        }
        
        a = (v - bv) / deltaTime / 2.0;
        float aLimit = a > 0 ? AccSpeedupAbsoluteMax : AccBrakeAbsoluteMax;
        if (abs(a) > aLimit) {
            a = copysign(aLimit, a);
            float newV = bv + a * deltaTime * 2.0;
            if (v > 0) {
                vx *= newV / v;
                vy *= newV / v;
            }
        }
    }

    if (vw != 0) {
        if (abs(vw) > VelAngularMax) {
            vw = copysign(VelAngularMax, vw);
        }
        float aw = (vw - bw) / deltaTime / 2.0;
        float awLimit = aw > 0 ? AccSpeedupAngularMax : AccBrakeAngularMax;
        if (abs(aw) > awLimit) {
            aw = copysign(awLimit, aw);
            vw = bw + aw * deltaTime * 2.0;
        }
        // cout << "vw: " << vw << ", bw: " << bw << ", aw: " << aw << endl;
    }
    // cout << "vw: " << vw << ", bw: " << bw << endl;
        // cout << "vx: " << vx << ", vy: " << vy << ", v: " << v << endl;
        // cout << "bx: " << bx << ", by: " << by << ", bv: " << bv << endl;
        // cout << "a: " << a <<  ", t: " << deltaTime << endl;
        // cout << " " << endl;
    return QVector3D(vx, vy, vw);
}