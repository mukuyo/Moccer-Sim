#include "include/robot.h"
#include <Qt3DExtras/Qt3DWindow>
#include <Qt3DExtras/QForwardRenderer>
#include <Qt3DRender/QCamera>
#include <Qt3DExtras/QOrbitCameraController>
#include <Qt3DRender/QMesh>
#include <Qt3DCore/QTransform>
#include <Qt3DExtras/QDiffuseSpecularMaterial>
#include <Qt3DExtras/QPlaneMesh>
#include <Qt3DExtras/QPhongMaterial>
#include <Qt3DCore/QTransform>
#include <Qt3DExtras/QConeMesh>
#include <Qt3DExtras/QCylinderMesh>
#include <Qt3DExtras/QCuboidMesh>
#include <Qt3DExtras/QDiffuseMapMaterial>
#include <Qt3DCore/QEntity>
#include <Qt3DRender/QTexture>
#include <QUrl>
#include <Qt3DRender/QTextureImage>
#include <Qt3DExtras/QTextureMaterial>
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

// テクスチャ付きのマテリアルを作成する関数
Qt3DExtras::QTextureMaterial *createTexturedMaterial(const QString &textureFilePath) {
    // テクスチャを作成
    Qt3DRender::QTexture2D *texture = new Qt3DRender::QTexture2D();
    Qt3DRender::QTextureImage *textureImage = new Qt3DRender::QTextureImage();
    textureImage->setSource(QUrl::fromLocalFile(textureFilePath));
    texture->addTextureImage(textureImage);

    // テクスチャマテリアルを作成
    Qt3DExtras::QTextureMaterial *textureMaterial = new Qt3DExtras::QTextureMaterial();
    textureMaterial->setTexture(texture);

    return textureMaterial;
}

// ex_wall_1 の追加でテクスチャを適用
void addTexturedWall(Qt3DCore::QEntity *rootEntity, const QString &objFilePath, const QString &textureFilePath) {
    Qt3DCore::QEntity *wallEntity = new Qt3DCore::QEntity(rootEntity);

    // 壁のメッシュをロード
    Qt3DRender::QMesh *mesh = new Qt3DRender::QMesh();
    mesh->setSource(QUrl::fromLocalFile(objFilePath));

    // トランスフォームを作成
    Qt3DCore::QTransform *transform = new Qt3DCore::QTransform();
    transform->setScale(1.0f); // 必要に応じてスケールを調整
    transform->setTranslation(QVector3D(0.0, 0.0, 0.0));

    // テクスチャマテリアルを作成
    Qt3DExtras::QTextureMaterial *material = createTexturedMaterial(textureFilePath);

    // エンティティにコンポーネントを追加
    wallEntity->addComponent(mesh);
    wallEntity->addComponent(transform);
    wallEntity->addComponent(material);
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

    Qt3DCore::QTransform *wallTransform = new Qt3DCore::QTransform();
    transRobot(wallTransform, QVector3D(0,0,0), 0);
    // addOBJModel(rootEntity, "../assets/models/field/ex_wall_1.obj", wallTransform, QColor(60,60,60));
    addTexturedWall(rootEntity, "../assets/models/field/ex_wall_1.obj", "../assets/textures/logo_01.png");
    // addOBJModel(rootEntity, "../assets/models/field/ex_wall_2.obj", wallTransform, QColor(60,60,60));
    addTexturedWall(rootEntity, "../assets/models/field/seats_floor_1.obj", "../assets/textures/logo_01.png");
    // addOBJModel(rootEntity, "../assets/models/field/seats_floor_2.obj", wallTransform, "gray");
    // addOBJModel(rootEntity, "../assets/models/field/seats.obj", wallTransform, QColor(143,186, 250));
    // Qt3DCore::QTransform *chairTransform = new Qt3DCore::QTransform();
    // transRobot(chairTransform, QVector3D(0,0,0), 0);
    // // wallTransform->setScale(0.001);
    // // baseTransforms.append(baseTransform);
    // addOBJModel(rootEntity, "../assets/models/field/chairs.obj", chairTransform, QColor(143, 186, 250));
}