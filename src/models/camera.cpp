# include "camera.h"

Camera::Camera(QObject *parent) : QObject(parent) {}

QMatrix4x4 Camera::createViewMatrix(const QVector3D& eye, const QVector3D& center, const QVector3D& up) {
    QMatrix4x4 view;
    view.lookAt(eye, center, up);
    return view;
}

QMatrix4x4 Camera::createProjectionMatrix(float fovDegrees, float aspectRatio, float nearPlane, float farPlane) {
    QMatrix4x4 proj;
    proj.perspective(fovDegrees, aspectRatio, nearPlane, farPlane);
    return proj;
}

void Camera::getBallPosition(QVector3D objectPos, QVector3D cameraPos, QVector3D cameraForward, QVector3D cameraUp, int screenWidth, int screenHeight, float fovDegrees) {
    QVector3D center = cameraPos + cameraForward.normalized();
    QMatrix4x4 view = createViewMatrix(cameraPos, center, cameraUp);
    QMatrix4x4 proj = createProjectionMatrix(fovDegrees, float(screenWidth) / screenHeight, 0.1f, 10000.0f);

    QVector4D worldPos(objectPos, 1.0f);
    QVector4D clipSpace = proj * view * worldPos;

    if (clipSpace.w() != 0.0f)
    clipSpace /= clipSpace.w();

    float ndcX = clipSpace.x(); // -1〜1
    float ndcY = clipSpace.y(); // -1〜1

    bool visible = (ndcX >= -1.0f && ndcX <= 1.0f && ndcY >= -1.0f && ndcY <= 1.0f);

    float pixelX = (ndcX * 0.5f + 0.5f) * screenWidth;
    float pixelY = (1.0f - (ndcY * 0.5f + 0.5f)) * screenHeight;

    qDebug() << "NDC Coordinates:" << ndcX << ndcY;
    // if (visible)
    // qDebug() << "Object is visible at screen coordinates:" << pixelX << pixelY;
    // else
    // qDebug() << "Object is outside of view";
}