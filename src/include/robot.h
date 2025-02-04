#ifndef ROBOT_H
#define ROBOT_H

#include <iostream>
#include <QObject>
#include <QVector3D>
#include <QVariantList>

using namespace std;

class Robot : public QObject {
    Q_OBJECT
    Q_PROPERTY(float wheel_speed0 READ getWheelSpeed0 CONSTANT)
    Q_PROPERTY(float wheel_speed1 READ getWheelSpeed1 CONSTANT)
    Q_PROPERTY(float wheel_speed2 READ getWheelSpeed2 CONSTANT)
    Q_PROPERTY(float wheel_speed3 READ getWheelSpeed3 CONSTANT)
    Q_PROPERTY(QVariantList positions READ getPositions CONSTANT)

public:
    explicit Robot(QObject *parent = nullptr);
    ~Robot();

    float getWheelSpeed0() const;
    float getWheelSpeed1() const;
    float getWheelSpeed2() const;
    float getWheelSpeed3() const;

    QVariantList getPositions() const;

    float wheel_speed0;
    float wheel_speed1;
    float wheel_speed2;
    float wheel_speed3;

    QVariantList positions;

private:
    float theta;

public slots:
    void updateWheelSpeeds();

signals:
    void wheelSpeedChanged();
};

#endif // ROBOT_H
