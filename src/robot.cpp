#include "include/robot.h"
#include <Qt3DExtras/Qt3DWindow>
#include <Qt3DExtras/QForwardRenderer>
#include <Qt3DRender/QCamera>
#include <Qt3DExtras/QOrbitCameraController>
#include <Qt3DRender/QMesh>
#include <Qt3DCore/QTransform>
#include <Qt3DExtras/QDiffuseSpecularMaterial>


// Function to add an OBJ model to the scene
void addOBJModel(Qt3DCore::QEntity *rootEntity, const QString &objFilePath, Qt3DCore::QTransform *transform, const QColor &color) {
    Qt3DCore::QEntity *objEntity = new Qt3DCore::QEntity(rootEntity);

    // Load the mesh
    Qt3DRender::QMesh *mesh = new Qt3DRender::QMesh();
    mesh->setSource(QUrl::fromLocalFile(objFilePath));

    objEntity->addComponent(mesh);
    objEntity->addComponent(transform);

    // Set material
    Qt3DExtras::QDiffuseSpecularMaterial *material = new Qt3DExtras::QDiffuseSpecularMaterial();
    material->setDiffuse(color);
    objEntity->addComponent(material);
}

void transRobot(Qt3DCore::QTransform *transform, QVector3D base_position, float angle) {
    QVector3D temp_position = QVector3D(base_position.x(), base_position.z(), base_position.y());
    transform->setRotationY(angle);
    transform->setTranslation(temp_position);

}

void create_robots(Qt3DCore::QEntity *rootEntity, const int numModels, QVector<Qt3DCore::QTransform*> &baseTransforms, QVector<Qt3DCore::QTransform*> &whiteTransforms, QVector<QVector<Qt3DCore::QTransform*>> &wheelSideTransforms, QVector<QVector<Qt3DCore::QTransform*>> &wheelFrameTransforms, QVector<Qt3DCore::QTransform*> &topCenterTransforms, QVector<QVector<Qt3DCore::QTransform*>> &topOutTransforms) {
    for (int i = 0; i < numModels; ++i) {
        // float x = -1000.0 + i * 2000;
        // float y = 0.0 + i * 150;
        // float z = 5.2;
        float x = 0.0;
        float y = 0.0;
        float z = 0.0052;

        QVector3D base_position = QVector3D(x, y, z);

        // Base transform for the model
        Qt3DCore::QTransform *baseTransform = new Qt3DCore::QTransform();
        transRobot(baseTransform, base_position, 0);
        baseTransforms.append(baseTransform);
        addOBJModel(rootEntity, "../assets/models/robot/black.obj", baseTransform, QColor(50, 50, 50));

        // Transform for the white component
        Qt3DCore::QTransform *whiteTransform = new Qt3DCore::QTransform();
        transRobot(whiteTransform, base_position, 0);
        whiteTransforms.append(whiteTransform);
        addOBJModel(rootEntity, "../assets/models/robot/white.obj", whiteTransform, QColor(169, 169, 169));

        // Add wheels (4 for each model)
        QVector<Qt3DCore::QTransform*> singleWheelSideTransforms;
        QVector<Qt3DCore::QTransform*> singleWheelFrameTransforms;
        float wheelRadius = 0.0815f;
        float wheelAngles[4] = {35.0, -45.0, -135.0, 145.0};
        for (int j = 0; j < 4; ++j) {
            QVector3D wheelPosition(
                x + wheelRadius * cos((270+wheelAngles[j]) * M_PI / 180.0),
                y + wheelRadius * sin((270+wheelAngles[j]) * M_PI / 180.0),
                0.0270
            );
            Qt3DCore::QTransform *wheelSideTransform = new Qt3DCore::QTransform();
            transRobot(wheelSideTransform, wheelPosition, -wheelAngles[j]);
            singleWheelSideTransforms.append(wheelSideTransform);
            addOBJModel(rootEntity, "../assets/models/wheel/side.obj", wheelSideTransform, QColor(Qt::yellow));
        
            Qt3DCore::QTransform *wheelFrameTransform = new Qt3DCore::QTransform;
            transRobot(wheelFrameTransform, wheelPosition, -wheelAngles[j]);
            singleWheelFrameTransforms.append(wheelFrameTransform);
            addOBJModel(rootEntity, "../assets/models/wheel/frame.obj", wheelFrameTransform, QColor(Qt::white));
        }
        wheelSideTransforms.append(singleWheelSideTransforms);
        wheelFrameTransforms.append(singleWheelFrameTransforms);

        // Add center top marker
        Qt3DCore::QTransform *topCenterTransform = new Qt3DCore::QTransform();
        QVector3D centerTopPosition(x, y, 0.145);
        transRobot(topCenterTransform, centerTopPosition, 0);
        topCenterTransforms.append(topCenterTransform);
        addOBJModel(rootEntity, "../assets/models/top/center.obj", topCenterTransform, QColor(Qt::blue));

        // Add outside top markers
        QVector<Qt3DCore::QTransform*> singleTopOutTransforms;
        QColor colorList[4] = {QColor(221, 67, 169), Qt::green, Qt::green, Qt::green};
        float xOffset[4] = {0.035, -0.054772, -0.054772, 0.035};
        float yOffset[4] = {-0.054772, -0.035, 0.035, 0.054772};
        for (int k = 0; k < 4; ++k) {
            QVector3D topOutPosition(x + xOffset[k], y + yOffset[k], 0.145);
            Qt3DCore::QTransform *topOutTransform = new Qt3DCore::QTransform();
            transRobot(topOutTransform, topOutPosition, 0);
            singleTopOutTransforms.append(topOutTransform);
            addOBJModel(rootEntity, "../assets/models/top/outside.obj", topOutTransform, QColor(colorList[k]));
        }
        topOutTransforms.append(singleTopOutTransforms);
    }
}