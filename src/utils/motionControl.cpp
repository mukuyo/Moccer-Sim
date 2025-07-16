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

QVector3D MotionControl::calcSpeed(QVector3D velocity, QVector3D botVelocity, QVector3D botPreVelocity, float deltaTime, float botAngle) {
    // 入力の各成分を分解
    float vx = velocity.x();
    float vy = velocity.y();
    float vw = velocity.z();

    float bx = botVelocity.x();
    float by = botVelocity.y();
    float bw = botVelocity.z();

    float pbx = botPreVelocity.x();
    float pby = botPreVelocity.y();
    float pbw = botPreVelocity.z();

    // ノイズ制限（異常値カット）
    if (fabs(bx) > 5000) bx = 0;
    if (fabs(by) > 5000) by = 0;
    if (fabs(bw) > 50)   bw = 0;

    // 速度ベクトルの大きさ
    float v = std::sqrt(vx * vx + vy * vy);
    float bv = std::sqrt(bx * bx + by * by);

    // 最大速度制限
    if (v > VelAbsoluteMax) {
        vx *= VelAbsoluteMax / v;
        vy *= VelAbsoluteMax / v;
        v = VelAbsoluteMax;
    }

    // 加速度計算 (半分に割るのは慣性補正的な処理)
    float a = (v - bv) / (deltaTime / 2.0f);
    float aLimit = (a > 0) ? AccSpeedupAbsoluteMax : AccBrakeAbsoluteMax;

    if (fabs(a) > aLimit) {
        a = copysign(aLimit, a);
        float newV = bv + a * deltaTime * 2.0f;
        if (v > 0.0f) {
            vx *= newV / v;
            vy *= newV / v;
        }
    }

    // --- 速度ジャンプ制限 ---
    const float maxVelocityDelta = 120.0f;
    float deltaVx = vx - pbx;
    float deltaVy = vy - pby;
    if (fabs(deltaVx) > maxVelocityDelta) {
        vx = pbx + copysign(maxVelocityDelta, deltaVx);
    }
    if (fabs(deltaVy) > maxVelocityDelta) {
        vy = pby + copysign(maxVelocityDelta, deltaVy);
    }

    if (abs(vw) > VelAngularMax) {
        vw = copysign(VelAngularMax, vw);
    }
    float aw = (vw - bw) / deltaTime / 2.0;
    float awLimit = aw > 0 ? AccSpeedupAngularMax : AccBrakeAngularMax;
    if (abs(aw) > awLimit) {
        aw = copysign(awLimit, aw);
        vw = bw + aw * deltaTime * 2.0;
    }
    
    // cout << "vx: " << vx << ", vy: " << vy << ", v: " << v << ", vw: " << vw << endl;
    // cout << "bx: " << bx << ", by: " << by << ", bv: " << bv << ", bw: " << bw << endl;
    // cout << "a: " << a << ", aw: " << aw <<  ", t: " << deltaTime << endl;
    // cout << " " << endl;
    return QVector3D(vx, vy, vw);
}
