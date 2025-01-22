// #include <QApplication>
// #include <QWidget>
// #include <Qt3DExtras/Qt3DWindow>
// #include <Qt3DExtras/QForwardRenderer>
// #include <Qt3DRender/QCamera>
// #include <Qt3DExtras/QOrbitCameraController>
// #include <Qt3DRender/QMesh>
// #include <Qt3DCore/QTransform>
// #include <Qt3DExtras/QDiffuseSpecularMaterial>
// #include <QLoggingCategory>
// #include <QDebug>
// #include <QTimer>
// #include <cmath>
// #include "src/include/geometry.h"
// #include "src/include/lighting.h"
// #include "src/include/robot.h"


// int main(int argc, char **argv) {
//     QApplication app(argc, argv);

//     // Create a Qt3D window
//     Qt3DExtras::Qt3DWindow *view = new Qt3DExtras::Qt3DWindow();

//     // Set the background color
//     Qt3DExtras::QForwardRenderer *frameGraph = view->defaultFrameGraph();
//     frameGraph->setClearColor(QColor(QRgb(0x4d4d4f)));

//     // Root entity of the scene
//     Qt3DCore::QEntity *rootEntity = new Qt3DCore::QEntity();

//     // Add fields, lines, and lighting to the scene
//     create_fileds(rootEntity);
//     create_lines(rootEntity);
//     addLightingToRoot(rootEntity);

//     QVector<Qt3DCore::QTransform*> baseTransforms;
//     QVector<Qt3DCore::QTransform*> whiteTransforms;
//     QVector<QVector<Qt3DCore::QTransform*>> wheelSideTransforms;
//     QVector<QVector<Qt3DCore::QTransform*>> wheelFrameTransforms;
//     QVector<Qt3DCore::QTransform*> topCenterTransforms;
//     QVector<QVector<Qt3DCore::QTransform*>> topOutTransforms;
    
//     // Create the robots
//     const int numModels = 1;
//     create_robots(rootEntity, numModels, baseTransforms, whiteTransforms, wheelSideTransforms, wheelFrameTransforms, topCenterTransforms, topOutTransforms);

//     // Camera settings
//     Qt3DRender::QCamera *camera = view->camera();
//     camera->lens()->setPerspectiveProjection(45.0f, 16.0f / 9.0f, 0.1f, 1000.0f);
//     camera->setPosition(QVector3D(0, 10.0f, 10.0f));
//     camera->setViewCenter(QVector3D(0, 0, 0));

//     Qt3DExtras::QOrbitCameraController *cameraController = new Qt3DExtras::QOrbitCameraController(rootEntity);
//     cameraController->setLinearSpeed(50.0f);
//     cameraController->setLookSpeed(180.0f);
//     cameraController->setCamera(camera);

//     // Set the root entity to the view
//     view->setRootEntity(rootEntity);

//     // Create a container for the Qt3D view
//     QWidget *container = QWidget::createWindowContainer(view);
//     container->setMinimumSize(QSize(800, 600));
//     container->setMaximumSize(QSize(800, 600));
//     container->show();

//     return app.exec();
// }
#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include "src/include/geometry.h"
#include "src/include/robot.h"

class Moccer {
public:
    Moccer(QQmlApplicationEngine &engine) {
        // qmlRegisterType<Geometry>("MOC", 1, 0, "Geometry");
        qmlRegisterType<Robot>("MOC", 1, 0, "Robot");

        engine.load(QUrl(QStringLiteral("../src/qml/Main.qml")));

        if (engine.rootObjects().isEmpty()) {
            qWarning() << "Failed to load QML file.";
            return;
        }

        qDebug() << "QML successfully loaded!";
    }
};

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    Moccer moccer(engine);

    return app.exec();
}
