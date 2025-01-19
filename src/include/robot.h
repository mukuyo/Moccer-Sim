#ifndef ROBOT_H
#define ROBOT_H

#include <Qt3DCore/QEntity>
#include <Qt3DExtras/Qt3DWindow>
#include <Qt3DExtras/QForwardRenderer>
#include <Qt3DRender/QCamera>
#include <Qt3DExtras/QOrbitCameraController>
#include <Qt3DRender/QMesh>
#include <Qt3DCore/QTransform>
#include <Qt3DExtras/QDiffuseSpecularMaterial>

void addOBJModel(Qt3DCore::QEntity *rootEntity, const QString &objFilePath, Qt3DCore::QTransform *transform, const QColor &color);
void create_robots(Qt3DCore::QEntity *rootEntity, const int numModels, QVector<Qt3DCore::QTransform*> &baseTransforms, QVector<Qt3DCore::QTransform*> &whiteTransforms, QVector<QVector<Qt3DCore::QTransform*>> &wheelSideTransforms, QVector<QVector<Qt3DCore::QTransform*>> &wheelFrameTransforms, QVector<Qt3DCore::QTransform*> &topCenterTransforms, QVector<QVector<Qt3DCore::QTransform*>> &topOutTransforms);
void transRobot(Qt3DCore::QTransform *transform, float x, float y, float z, float angle);

#endif // ROBOT_H
