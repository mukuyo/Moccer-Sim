#include <QApplication>
#include <QWidget>
#include <Qt3DExtras/Qt3DWindow>
#include <Qt3DExtras/QForwardRenderer>
#include <Qt3DRender/QCamera>
#include <Qt3DExtras/QOrbitCameraController>
#include <Qt3DRender/QMesh>
#include <Qt3DCore/QTransform>
#include <Qt3DExtras/QDiffuseSpecularMaterial>
#include <QLoggingCategory>
#include <QDebug>
#include <QTimer>
#include <cmath>
#include "src/include/geometry.h"
#include "src/include/lighting.h"
#include "src/include/robot.h"


int main(int argc, char **argv) {
    QApplication app(argc, argv);

    // Create a Qt3D window
    Qt3DExtras::Qt3DWindow *view = new Qt3DExtras::Qt3DWindow();

    // Set the background color
    Qt3DExtras::QForwardRenderer *frameGraph = view->defaultFrameGraph();
    frameGraph->setClearColor(QColor(QRgb(0x4d4d4f)));

    // Root entity of the scene
    Qt3DCore::QEntity *rootEntity = new Qt3DCore::QEntity();

    // Add fields, lines, and lighting to the scene
    create_fileds(rootEntity);
    create_lines(rootEntity);
    addLightingToRoot(rootEntity);

    QVector<Qt3DCore::QTransform*> baseTransforms;
    QVector<Qt3DCore::QTransform*> whiteTransforms;
    QVector<QVector<Qt3DCore::QTransform*>> wheelSideTransforms;
    QVector<QVector<Qt3DCore::QTransform*>> wheelFrameTransforms;
    QVector<Qt3DCore::QTransform*> topCenterTransforms;
    QVector<QVector<Qt3DCore::QTransform*>> topOutTransforms;
    
    // Create the robots
    const int numModels = 1;
    create_robots(rootEntity, numModels, baseTransforms, whiteTransforms, wheelSideTransforms, wheelFrameTransforms, topCenterTransforms, topOutTransforms);

    // Camera settings
    Qt3DRender::QCamera *camera = view->camera();
    camera->lens()->setPerspectiveProjection(45.0f, 16.0f / 9.0f, 0.1f, 1000.0f);
    camera->setPosition(QVector3D(0, 10.0f, 10.0f));
    camera->setViewCenter(QVector3D(0, 0, 0));

    Qt3DExtras::QOrbitCameraController *cameraController = new Qt3DExtras::QOrbitCameraController(rootEntity);
    cameraController->setLinearSpeed(50.0f);
    cameraController->setLookSpeed(180.0f);
    cameraController->setCamera(camera);

    // Set the root entity to the view
    view->setRootEntity(rootEntity);

    // Create a container for the Qt3D view
    QWidget *container = QWidget::createWindowContainer(view);
    container->setMinimumSize(QSize(800, 600));
    container->setMaximumSize(QSize(800, 600));
    container->show();

    // Parameters for circular motion
    // const float radius = 0.3f;
    // const float wheelAngles[4] = {35.0, -45.0, -135.0, 145.0};
    // QVector<float> angles = {0.0f, 180.0f};
    // QVector<float> wheelRotations(numModels, 0.0f);

    // // Timer for updating the animation (60fps)
    // QTimer *timer = new QTimer(&app);
    // timer->setInterval(1000 / 60);
    // QObject::connect(timer, &QTimer::timeout, [&]() {
    //     for (int i = 0; i < numModels; ++i) {
    //         angles[i] += 1.5;
    //         wheelRotations[i] += 20.0f;

    //         // Calculate new position
    //         float x = radius * cos(angles[i] * M_PI / 180.0);
    //         float z = radius * sin(angles[i] * M_PI / 180.0);
    //         QVector3D newPosition(x, 0.0052, z);

    //         baseTransforms[i]->setTranslation(newPosition);
    //         whiteTransforms[i]->setTranslation(newPosition);

    //         float wheelRadius = 0.0815f;
    //         for (int j = 0; j < 4; ++j) {
    //             QQuaternion rotationY = QQuaternion::fromAxisAndAngle(QVector3D(0, 1, 0), wheelRotations[i]);
    //             QQuaternion rotationX = QQuaternion::fromAxisAndAngle(QVector3D(1, 0, 0), 90.0f);
    //             QQuaternion additionalRotationX = QQuaternion::fromAxisAndAngle(QVector3D(0, 0, 1), wheelAngles[j]);
    //             QQuaternion combinedRotation = rotationX * additionalRotationX * rotationY;

    //             wheelSideTransforms[i][j]->setRotation(combinedRotation);
    //             wheelFrameTransforms[i][j]->setRotation(combinedRotation);

    //             QVector3D wheelPosition(
    //                 x + wheelRadius * cos((270 + wheelAngles[j]) * M_PI / 180.0),
    //                 0.027f,
    //                 z + wheelRadius * sin((270 + wheelAngles[j]) * M_PI / 180.0)
    //             );
    //             wheelSideTransforms[i][j]->setTranslation(wheelPosition);
    //             wheelFrameTransforms[i][j]->setTranslation(wheelPosition);
    //         }

    //         // Update center top marker
    //         QVector3D centerTopPosition(x, 0.145f, z);
    //         topCenterTransforms[i]->setTranslation(centerTopPosition);
    //         topCenterTransforms[i]->setRotationX(-90.0f);

    //         // Update outside top markers
    //         float xOffset[4] = {0.035, -0.054772, -0.054772, 0.035};
    //         float zOffset[4] = {-0.054772, -0.035, 0.035, 0.054772};
    //         for (int k = 0; k < 4; ++k) {
    //             QVector3D topOutPosition(x + xOffset[k], 0.145f, z + zOffset[k]);
    //             topOutTransforms[i][k]->setTranslation(topOutPosition);
    //             topOutTransforms[i][k]->setRotationX(-90.0f);
    //         }
    //     }
    // });
    // timer->start();

    return app.exec();
}
