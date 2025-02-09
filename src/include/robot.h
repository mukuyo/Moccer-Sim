#ifndef ROBOT_H
#define ROBOT_H

#include <iostream>
#include <QObject>
#include <QVector3D>
#include <QVariantList>
#include <QElapsedTimer>

using namespace std;

class Robot : public QObject {
    Q_OBJECT
    Q_PROPERTY(float wheel_speed0 READ getWheelSpeed0 CONSTANT)
    Q_PROPERTY(float wheel_speed1 READ getWheelSpeed1 CONSTANT)
    Q_PROPERTY(float wheel_speed2 READ getWheelSpeed2 CONSTANT)
    Q_PROPERTY(float wheel_speed3 READ getWheelSpeed3 CONSTANT)
    Q_PROPERTY(QVariantList positions READ getPositions CONSTANT)
    Q_PROPERTY(QVector3D position READ getPosition CONSTANT)

public:
    explicit Robot(QObject *parent = nullptr);
    ~Robot();

    float getWheelSpeed0() const;
    float getWheelSpeed1() const;
    float getWheelSpeed2() const;
    float getWheelSpeed3() const;

    QVariantList getPositions() const;
    QVector3D getPosition() const;

private:
    QElapsedTimer m_elapsedTimer; // QElapsedTimerを使って経過時間を計測
    float theta;
    float wheel_speed0;
    float wheel_speed1;
    float wheel_speed2;
    float wheel_speed3;
    QVector3D position;
    QVariantList positions;

public slots:
    void updateWheelSpeeds();

signals:
    void wheelSpeedChanged();
};

#endif // ROBOT_H
