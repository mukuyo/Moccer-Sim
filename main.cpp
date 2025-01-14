#include <QApplication>
#include <QWidget>
#include <Qt3DExtras/Qt3DWindow>
#include <Qt3DExtras/QForwardRenderer>
#include <Qt3DRender/QCamera>
#include <Qt3DExtras/QOrbitCameraController>
#include "geometry.h"
#include "lighting.h"

int main(int argc, char **argv)
{
    QApplication app(argc, argv);

    Qt3DExtras::Qt3DWindow *view = new Qt3DExtras::Qt3DWindow();
    view->setTitle("Soccer Field with Lighting");

    Qt3DExtras::QForwardRenderer *frameGraph = view->defaultFrameGraph();
    frameGraph->setClearColor(QColor(QRgb(0x4d4d4f)));

    Qt3DCore::QEntity *rootEntity = new Qt3DCore::QEntity();

    create_fileds(rootEntity);
    create_lines(rootEntity);
    addLightingToRoot(rootEntity);

    // カメラ設定
    Qt3DRender::QCamera *camera = view->camera();
    camera->lens()->setPerspectiveProjection(45.0f, 16.0f / 9.0f, 0.1f, 1000.0f);
    camera->setPosition(QVector3D(0, 10.0f, 10.0f));
    camera->setViewCenter(QVector3D(0, 0, 0));

    Qt3DExtras::QOrbitCameraController *cameraController = new Qt3DExtras::QOrbitCameraController(rootEntity);
    cameraController->setLinearSpeed(50.0f);
    cameraController->setLookSpeed(180.0f);
    cameraController->setCamera(camera);

    // エンティティを設定して表示
    view->setRootEntity(rootEntity);

    QWidget *container = QWidget::createWindowContainer(view);
    container->setMinimumSize(QSize(800, 600));
    container->setMaximumSize(QSize(800, 600));
    container->show();

    return app.exec();
}
