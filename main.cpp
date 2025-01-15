#include <QApplication>
#include <QWidget>
#include <Qt3DExtras/Qt3DWindow>
#include <Qt3DExtras/QForwardRenderer>
#include <Qt3DRender/QCamera>
#include <Qt3DExtras/QOrbitCameraController>
#include <Qt3DRender/QMesh>
#include <Qt3DCore/QTransform>
#include <Qt3DExtras/QDiffuseSpecularMaterial>
#include <QDebug>
#include <QTimer>
#include <cmath>  // for sin, cos
#include "geometry.h"
#include "lighting.h"

// GLTFモデルを読み込む関数
void addOBJModel(Qt3DCore::QEntity *rootEntity, const QString &objFilePath, Qt3DCore::QTransform *transform, const QColor &color) {
    Qt3DCore::QEntity *objEntity = new Qt3DCore::QEntity(rootEntity);

    Qt3DRender::QMesh *mesh = new Qt3DRender::QMesh();
    mesh->setSource(QUrl::fromLocalFile(objFilePath));

    QObject::connect(mesh, &Qt3DRender::QMesh::statusChanged, [](Qt3DRender::QMesh::Status status) {
        if (status == Qt3DRender::QMesh::Status::Ready) {
            qDebug() << "OBJ model loaded successfully!";
        } else if (status == Qt3DRender::QMesh::Status::Error) {
            qDebug() << "Failed to load OBJ model.";
        }
    });

    objEntity->addComponent(mesh);
    objEntity->addComponent(transform);

    Qt3DExtras::QDiffuseSpecularMaterial *material = new Qt3DExtras::QDiffuseSpecularMaterial();
    material->setDiffuse(color);
    objEntity->addComponent(material);
}

int main(int argc, char **argv)
{
    QApplication app(argc, argv);

    Qt3DExtras::Qt3DWindow *view = new Qt3DExtras::Qt3DWindow();
    view->setTitle("GLTF Model Viewer");

    Qt3DExtras::QForwardRenderer *frameGraph = view->defaultFrameGraph();
    frameGraph->setClearColor(QColor(QRgb(0x4d4d4f)));

    Qt3DCore::QEntity *rootEntity = new Qt3DCore::QEntity();

    // 既存のフィールドとライティング
    create_fileds(rootEntity);
    create_lines(rootEntity);
    addLightingToRoot(rootEntity);

    // GLTFモデルを追加
    const int numModels = 1; // モデルの数

    QVector<Qt3DCore::QTransform*> baseTransforms;
    QVector<QVector<Qt3DCore::QTransform*>> wheelTransforms;

    for (int i = 0; i < numModels; ++i) {
        Qt3DCore::QTransform *baseTransform = new Qt3DCore::QTransform();
        baseTransform->setScale(0.001f);
        baseTransform->setTranslation(QVector3D(1.0f + i * 1.5f, 0.0f, 0.0f));
        baseTransform->setRotationX(-90.0f);
        baseTransform->setRotationY(-90.0f);
        baseTransforms.append(baseTransform);

        // addOBJModel(rootEntity, "../model/unit/black.obj", baseTransform, QColor(60, 60, 60));
        // addOBJModel(rootEntity, "../model/unit/white.obj", baseTransform, QColor(QColor(200, 200, 200)));

        // ホイールの追加 (4つ)
        QVector<Qt3DCore::QTransform*> singleWheelTransforms;
        for (int j = 0; j < 1; ++j) {
            Qt3DCore::QTransform *wheelTransform = new Qt3DCore::QTransform();
            wheelTransform->setScale(0.001f);
            wheelTransform->setTranslation(baseTransform->translation());
            // wheelTransform->setRotationX(-90.0f);
            // wheelTransform->setRotationY(-90.0f);
            singleWheelTransforms.append(wheelTransform);

            // QString sidePath = QString("../model/wheel/side.obj");
            QString framePath = QString("../model/wheel/frame.obj");

            // addOBJModel(rootEntity, sidePath, wheelTransform, QColor(Qt::yellow));
            addOBJModel(rootEntity, framePath, wheelTransform, QColor(Qt::white));
        }
        wheelTransforms.append(singleWheelTransforms);
    }

    // カメラ設定
    Qt3DRender::QCamera *camera = view->camera();
    camera->lens()->setPerspectiveProjection(45.0f, 16.0f / 9.0f, 0.1f, 1000.0f);
    camera->setPosition(QVector3D(0, 10.0f, 10.0f));
    camera->setViewCenter(QVector3D(0, 0, 0));

    Qt3DExtras::QOrbitCameraController *cameraController = new Qt3DExtras::QOrbitCameraController(rootEntity);
    cameraController->setLinearSpeed(50.0f);
    cameraController->setLookSpeed(180.0f);
    cameraController->setCamera(camera);

    view->setRootEntity(rootEntity);

    QWidget *container = QWidget::createWindowContainer(view);
    container->setMinimumSize(QSize(800, 600));
    container->setMaximumSize(QSize(800, 600));
    container->show();

    // 円運動のためのパラメータ
    const float radius = 0.5f;
    QVector<float> angles(numModels, 0.0f);
    QVector<float> wheelAngles(numModels, 0.0f);

    // QTimerの設定 (60fps)
    QTimer *timer = new QTimer(&app);
    timer->setInterval(1000 / 60); // 60fps
    QObject::connect(timer, &QTimer::timeout, [&]() {
        for (int i = 0; i < numModels; ++i) {
            angles[i] += 1.0f * (i + 0.005);
            wheelAngles[i] += 5.0f;

            float x = radius * cos(angles[i]);
            float z = radius * sin(angles[i]);
            QVector3D newPosition(x + i * 0.2f, 0.0f, z + i * 0.2f);

            // baseTransforms[i]->setTranslation(newPosition);

            for (int j = 0; j < 1; ++j) {
                // wheelTransforms[i][j]->setTranslation(newPosition);
                wheelTransforms[i][j]->setRotationY(wheelAngles[i]);
            }
        }
    });
    timer->start();

    return app.exec();
}
