#pragma once

#include <QObject>
#include <QVector3D>
#include <QVector4D>
#include <QMatrix4x4>

class Camera : public QObject {
    Q_OBJECT
public:
    explicit Camera(QObject *parent = nullptr);
    // ~Camera();
    Q_INVOKABLE void getBallPosition(QVector3D objectPos, QVector3D cameraPos, QVector3D cameraForward, QVector3D cameraUp, int screenWidth, int screenHeight, float fovDegrees);
    QMatrix4x4 createViewMatrix(const QVector3D& eye, const QVector3D& center, const QVector3D& up);
    QMatrix4x4 createProjectionMatrix(float fovDegrees, float aspectRatio, float nearPlane, float farPlane);
};
