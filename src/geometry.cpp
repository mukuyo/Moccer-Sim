// #include "include/geometry.h"
// #include <Qt3DExtras/QCuboidMesh>
// #include <Qt3DCore/QTransform>
// #include <Qt3DExtras/QDiffuseSpecularMaterial>
// #include <iostream>
#include "include/geometry.h"
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
#include <iostream>
Geometry::Geometry(Qt3DCore::QEntity *rootEntity) : Qt3DCore::QEntity(rootEntity) {
    create_fileds(rootEntity);
}

Geometry::~Geometry() = default;

// void Geometry::addCube(float x, float y, float z) {
//     std::cout << "Geometry::addCube()" << std::endl;
//     // 立方体のエンティティを作成
//     auto *cube = new Qt3DCore::QEntity(this);
//     auto *mesh = new Qt3DExtras::QCuboidMesh();
//     auto *transform = new Qt3DCore::QTransform();
//     auto *material = new Qt3DExtras::QDiffuseSpecularMaterial();

//     cube->addComponent(mesh);
//     cube->addComponent(transform);
//     cube->addComponent(material);

//     // 座標を設定
//     transform->setTranslation(QVector3D(x, y, z));
// }





// Geometry::Geometry(Qt3DCore::QEntity* rootEntity) : Qt3DCore::QEntity(rootEntity)
// {
//     std::cout << "Geometry::Geometry()" << std::endl;
//     create_fileds(rootEntity);
//     create_lines(rootEntity);
// }

// Geometry::~Geometry()
// {
// }

void Geometry::create_fileds(Qt3DCore::QEntity *rootEntity)
{
    Qt3DExtras::QPlaneMesh *fieldMesh = new Qt3DExtras::QPlaneMesh();
    fieldMesh->setWidth(15.6f);  // 12000mm = 12.0m
    fieldMesh->setHeight(16.6f);  // 9000mm = 9.0m

    // マテリアルの作成
    Qt3DExtras::QDiffuseMapMaterial *fieldMaterial = new Qt3DExtras::QDiffuseMapMaterial();

    // テクスチャの読み込み
    Qt3DRender::QTexture2D *texture = new Qt3DRender::QTexture2D();
    Qt3DRender::QTextureImage *textureImage = new Qt3DRender::QTextureImage();
    textureImage->setSource(QUrl::fromLocalFile("../assets/textures/field2.jpg")); // テクスチャ画像のパス
    texture->addTextureImage(textureImage);
    fieldMaterial->setDiffuse(texture);

    // エンティティの設定
    Qt3DCore::QEntity *fieldEntity = new Qt3DCore::QEntity(rootEntity);
    // rootEntity->addComponent(fieldMesh);
    // rootEntity->addComponent(fieldMaterial);
    fieldEntity->addComponent(fieldMesh);
    fieldEntity->addComponent(fieldMaterial);

    // フィールド外側の壁を作成
    Qt3DExtras::QCuboidMesh *wallMesh = new Qt3DExtras::QCuboidMesh();
    wallMesh->setXExtent(12.6f);  // 壁の長さ（フィールドの高さ）
    wallMesh->setYExtent(0.1f);  // 壁の太さ
    wallMesh->setZExtent(0.02f); // 壁の奥行き（適宜変更）

    Qt3DExtras::QPhongMaterial *wallMaterial = new Qt3DExtras::QPhongMaterial();
    wallMaterial->setDiffuse(QColor(Qt::black));

    // 上壁
    Qt3DCore::QEntity *topWallEntity = new Qt3DCore::QEntity(rootEntity);
    topWallEntity->addComponent(wallMesh);
    topWallEntity->addComponent(wallMaterial);
    Qt3DCore::QTransform *topWallTransform = new Qt3DCore::QTransform();
    topWallTransform->setTranslation(QVector3D(0, 0.05f, -4.8f)); // フィールド上側
    topWallEntity->addComponent(topWallTransform);

    // 下壁
    Qt3DCore::QEntity *bottomWallEntity = new Qt3DCore::QEntity(rootEntity);
    bottomWallEntity->addComponent(wallMesh);
    bottomWallEntity->addComponent(wallMaterial);
    Qt3DCore::QTransform *bottomWallTransform = new Qt3DCore::QTransform();
    bottomWallTransform->setTranslation(QVector3D(0, 0.05f, 4.8f)); // フィールド下側
    bottomWallEntity->addComponent(bottomWallTransform);

    // 左壁
    Qt3DExtras::QCuboidMesh *sideWallMesh = new Qt3DExtras::QCuboidMesh();
    sideWallMesh->setXExtent(9.6f);  // 壁の長さ（フィールドの高さ）
    sideWallMesh->setYExtent(0.1f);  // 壁の高さ
    sideWallMesh->setZExtent(0.02f); // 壁の奥行き（適宜変更）
    Qt3DCore::QEntity *leftWallEntity = new Qt3DCore::QEntity(rootEntity);
    leftWallEntity->addComponent(sideWallMesh);
    leftWallEntity->addComponent(wallMaterial);
    Qt3DCore::QTransform *leftWallTransform = new Qt3DCore::QTransform();
    leftWallTransform->setTranslation(QVector3D(-6.3f, 0.05f, 0));
    leftWallTransform->setRotationY(90.0f);
    leftWallEntity->addComponent(leftWallTransform);

    // 右壁
    Qt3DCore::QEntity *rightWallEntity = new Qt3DCore::QEntity(rootEntity);
    rightWallEntity->addComponent(sideWallMesh);
    rightWallEntity->addComponent(wallMaterial);
    Qt3DCore::QTransform *rightWallTransform = new Qt3DCore::QTransform();
    rightWallTransform->setTranslation(QVector3D(6.3f, 0.05f, 0));
    rightWallTransform->setRotationY(-90.0f);
    rightWallEntity->addComponent(rightWallTransform);

    // 右ゴール
    Qt3DExtras::QCuboidMesh *rightGoalMesh = new Qt3DExtras::QCuboidMesh();
    rightGoalMesh->setXExtent(1.84f);  // 壁の長さ（フィールドの高さ）
    rightGoalMesh->setYExtent(0.1f);  // 壁の高さ
    rightGoalMesh->setZExtent(0.02f); // 壁の奥行き（適宜変更）
    Qt3DCore::QEntity *rightGoalEntity = new Qt3DCore::QEntity(rootEntity);
    rightGoalEntity->addComponent(rightGoalMesh);
    rightGoalEntity->addComponent(wallMaterial);
    Qt3DCore::QTransform *rightGoalTransform = new Qt3DCore::QTransform();
    rightGoalTransform->setTranslation(QVector3D(6.18f, 0.05f, 0));
    rightGoalTransform->setRotationY(90.0f);
    rightGoalEntity->addComponent(rightGoalTransform);

    // 右ゴール端上
    Qt3DExtras::QCuboidMesh *rightSideUpGoalMesh = new Qt3DExtras::QCuboidMesh();
    rightSideUpGoalMesh->setXExtent(0.18f);  // 壁の長さ（フィールドの高さ）
    rightSideUpGoalMesh->setYExtent(0.1f);  // 壁の高さ
    rightSideUpGoalMesh->setZExtent(0.02f); // 壁の奥行き（適宜変更）
    Qt3DCore::QEntity *rightSideUpGoalEntity = new Qt3DCore::QEntity(rootEntity);
    rightSideUpGoalEntity->addComponent(rightSideUpGoalMesh);
    rightSideUpGoalEntity->addComponent(wallMaterial);
    Qt3DCore::QTransform *rightSideUpGoalTransform = new Qt3DCore::QTransform();
    rightSideUpGoalTransform->setTranslation(QVector3D(6.09f, 0.05f, -0.91f));
    rightSideUpGoalTransform->setRotationY(0.0f);
    rightSideUpGoalEntity->addComponent(rightSideUpGoalTransform);

    // 右ゴール端下
    Qt3DExtras::QCuboidMesh *rightSideUnderGoalMesh = new Qt3DExtras::QCuboidMesh();
    rightSideUnderGoalMesh->setXExtent(0.18f);  // 壁の長さ（フィールドの高さ）
    rightSideUnderGoalMesh->setYExtent(0.1f);  // 壁の高さ
    rightSideUnderGoalMesh->setZExtent(0.02f); // 壁の奥行き（適宜変更）
    Qt3DCore::QEntity *rightSideUnderGoalEntity = new Qt3DCore::QEntity(rootEntity);
    rightSideUnderGoalEntity->addComponent(rightSideUnderGoalMesh);
    rightSideUnderGoalEntity->addComponent(wallMaterial);
    Qt3DCore::QTransform *rightSideUnderGoalTransform = new Qt3DCore::QTransform();
    rightSideUnderGoalTransform->setTranslation(QVector3D(6.09f, 0.05f, 0.91f));
    rightSideUnderGoalTransform->setRotationY(0.0f);
    rightSideUnderGoalEntity->addComponent(rightSideUnderGoalTransform);

    // 左ゴール端
    Qt3DExtras::QCuboidMesh *leftGoalMesh = new Qt3DExtras::QCuboidMesh();
    leftGoalMesh->setXExtent(1.84f);  // 壁の長さ（フィールドの高さ）
    leftGoalMesh->setYExtent(0.1f);  // 壁の太さ
    leftGoalMesh->setZExtent(0.02f); // 壁の奥行き（適宜変更）
    Qt3DCore::QEntity *leftGoalEntity = new Qt3DCore::QEntity(rootEntity);
    leftGoalEntity->addComponent(leftGoalMesh);
    leftGoalEntity->addComponent(wallMaterial);
    Qt3DCore::QTransform *leftGoalTransform = new Qt3DCore::QTransform();
    leftGoalTransform->setTranslation(QVector3D(-6.18f, 0.05f, 0));
    leftGoalTransform->setRotationY(90.0f);
    leftGoalEntity->addComponent(leftGoalTransform);

    // 左ゴール端上
    Qt3DExtras::QCuboidMesh *leftSideUpGoalMesh = new Qt3DExtras::QCuboidMesh();
    leftSideUpGoalMesh->setXExtent(0.18f);  // 壁の長さ（フィールドの高さ）
    leftSideUpGoalMesh->setYExtent(0.1f);  // 壁の高さ
    leftSideUpGoalMesh->setZExtent(0.02f); // 壁の奥行き（適宜変更）
    Qt3DCore::QEntity *leftSideUpGoalEntity = new Qt3DCore::QEntity(rootEntity);
    leftSideUpGoalEntity->addComponent(leftSideUpGoalMesh);
    leftSideUpGoalEntity->addComponent(wallMaterial);
    Qt3DCore::QTransform *leftSideUpGoalTransform = new Qt3DCore::QTransform();
    leftSideUpGoalTransform->setTranslation(QVector3D(-6.09f, 0.05f, -0.91f));
    leftSideUpGoalTransform->setRotationY(0.0f);
    leftSideUpGoalEntity->addComponent(leftSideUpGoalTransform);

    // 左ゴール端下
    Qt3DExtras::QCuboidMesh *leftSideUnderGoalMesh = new Qt3DExtras::QCuboidMesh();
    leftSideUnderGoalMesh->setXExtent(0.18f);  // 壁の長さ（フィールドの高さ）
    leftSideUnderGoalMesh->setYExtent(0.1f);  // 壁の高さ
    leftSideUnderGoalMesh->setZExtent(0.02f); // 壁の奥行き（適宜変更）
    Qt3DCore::QEntity *leftSideUnderGoalEntity = new Qt3DCore::QEntity(rootEntity);
    leftSideUnderGoalEntity->addComponent(leftSideUnderGoalMesh);
    leftSideUnderGoalEntity->addComponent(wallMaterial);
    Qt3DCore::QTransform *leftSideUnderGoalTransform = new Qt3DCore::QTransform();
    leftSideUnderGoalTransform->setTranslation(QVector3D(-6.09f, 0.05f, 0.91f));
    leftSideUnderGoalTransform->setRotationY(0.0f);
    leftSideUnderGoalEntity->addComponent(leftSideUnderGoalTransform);

}

// void Geometry::create_lines(Qt3DCore::QEntity *rootEntity)
// {
//     // ライン（中央線）の作成
//     Qt3DExtras::QPlaneMesh *centerLineMesh = new Qt3DExtras::QPlaneMesh();
//     centerLineMesh->setWidth(0.01f);
//     centerLineMesh->setHeight(9.0f);  // 中央線の高さもフィールドに合わせる
//     Qt3DExtras::QPhongMaterial *lineMaterial = new Qt3DExtras::QPhongMaterial();
//     lineMaterial->setDiffuse(QColor(Qt::white));
//     Qt3DCore::QEntity *centerLineEntity = new Qt3DCore::QEntity(rootEntity);
//     centerLineEntity->addComponent(centerLineMesh);
//     centerLineEntity->addComponent(lineMaterial);
//     Qt3DCore::QTransform *lineTransform = new Qt3DCore::QTransform();
//     lineTransform->setTranslation(QVector3D(0, 0.001f, 0));  // 中央に配置
//     centerLineEntity->addComponent(lineTransform);

//     // 横ラインの作成（新たに追加）
//     Qt3DExtras::QPlaneMesh *horizontalLineMesh = new Qt3DExtras::QPlaneMesh();
//     horizontalLineMesh->setWidth(12.0f);  // 横ラインの幅をフィールドの幅に合わせる
//     horizontalLineMesh->setHeight(0.01f);  // 厚さは薄く設定
//     Qt3DCore::QEntity *horizontalLineEntity = new Qt3DCore::QEntity(rootEntity);
//     horizontalLineEntity->addComponent(horizontalLineMesh);
//     horizontalLineEntity->addComponent(lineMaterial);
//     Qt3DCore::QTransform *horizontalLineTransform = new Qt3DCore::QTransform();
//     horizontalLineTransform->setTranslation(QVector3D(0, 0.001f, 0));  // 中央に配置
//     horizontalLineEntity->addComponent(horizontalLineTransform);
//     Qt3DExtras::QPlaneMesh *rectangleEdgeMesh = new Qt3DExtras::QPlaneMesh();
//     rectangleEdgeMesh->setWidth(12.0f);  // 幅はフィールドの幅に微調整
//     rectangleEdgeMesh->setHeight(0.01f);  // 枠の厚さ

//     Qt3DCore::QEntity *topEdgeEntity = new Qt3DCore::QEntity(rootEntity);
//     topEdgeEntity->addComponent(rectangleEdgeMesh);
//     topEdgeEntity->addComponent(lineMaterial);
//     Qt3DCore::QTransform *topEdgeTransform = new Qt3DCore::QTransform();
//     topEdgeTransform->setTranslation(QVector3D(0, 0.001f, -4.495f));  // 上端
//     topEdgeEntity->addComponent(topEdgeTransform);

//     Qt3DCore::QEntity *bottomEdgeEntity = new Qt3DCore::QEntity(rootEntity);
//     bottomEdgeEntity->addComponent(rectangleEdgeMesh);
//     bottomEdgeEntity->addComponent(lineMaterial);
//     Qt3DCore::QTransform *bottomEdgeTransform = new Qt3DCore::QTransform();
//     bottomEdgeTransform->setTranslation(QVector3D(0, 0.001f, 4.495f));  // 下端
//     bottomEdgeEntity->addComponent(bottomEdgeTransform);

//     Qt3DExtras::QPlaneMesh *verticalEdgeMesh = new Qt3DExtras::QPlaneMesh();
//     verticalEdgeMesh->setWidth(0.01f);  // 厚さ
//     verticalEdgeMesh->setHeight(9.0f);  // 高さはフィールドの高さに合わせる
//     Qt3DCore::QEntity *leftEdgeEntity = new Qt3DCore::QEntity(rootEntity);
//     leftEdgeEntity->addComponent(verticalEdgeMesh);
//     leftEdgeEntity->addComponent(lineMaterial);
//     Qt3DCore::QTransform *leftEdgeTransform = new Qt3DCore::QTransform();
//     leftEdgeTransform->setTranslation(QVector3D(-5.995f, 0.001f, 0));  // 左端
//     leftEdgeEntity->addComponent(leftEdgeTransform);
//     Qt3DCore::QEntity *rightEdgeEntity = new Qt3DCore::QEntity(rootEntity);
//     rightEdgeEntity->addComponent(verticalEdgeMesh);
//     rightEdgeEntity->addComponent(lineMaterial);
//     Qt3DCore::QTransform *rightEdgeTransform = new Qt3DCore::QTransform();
//     rightEdgeTransform->setTranslation(QVector3D(5.995f, 0.001f, 0));  // 右端
//     rightEdgeEntity->addComponent(rightEdgeTransform);

//     Qt3DExtras::QPlaneMesh *horizontalPenaltyMesh = new Qt3DExtras::QPlaneMesh();
//     horizontalPenaltyMesh->setWidth(1.8f);  // 厚さ
//     horizontalPenaltyMesh->setHeight(0.01f);  // 高さはフィールドの高さに合わせる
//     Qt3DCore::QEntity *leftUpHorizontalPenaltyEntity = new Qt3DCore::QEntity(rootEntity);
//     leftUpHorizontalPenaltyEntity->addComponent(horizontalPenaltyMesh);
//     leftUpHorizontalPenaltyEntity->addComponent(lineMaterial);
//     Qt3DCore::QTransform *leftUpHorizontalPenaltyTransform = new Qt3DCore::QTransform();
//     leftUpHorizontalPenaltyTransform->setTranslation(QVector3D(-5.095f, 0.001f, -1.8f));  // 左端
//     leftUpHorizontalPenaltyEntity->addComponent(leftUpHorizontalPenaltyTransform);
//     Qt3DCore::QEntity *rightUpHorizontalPenaltyEntity = new Qt3DCore::QEntity(rootEntity);
//     rightUpHorizontalPenaltyEntity->addComponent(horizontalPenaltyMesh);
//     rightUpHorizontalPenaltyEntity->addComponent(lineMaterial);
//     Qt3DCore::QTransform *rightUpHorizontalPenaltyTransform = new Qt3DCore::QTransform();
//     rightUpHorizontalPenaltyTransform->setTranslation(QVector3D(5.095f, 0.001f, -1.8f));  // 右端
//     rightUpHorizontalPenaltyEntity->addComponent(rightUpHorizontalPenaltyTransform);

//     // 左下水平ペナルティライン
//     Qt3DCore::QEntity *leftUnderHorizontalPenaltyEntity = new Qt3DCore::QEntity(rootEntity);
//     leftUnderHorizontalPenaltyEntity->addComponent(horizontalPenaltyMesh);
//     leftUnderHorizontalPenaltyEntity->addComponent(lineMaterial);
//     Qt3DCore::QTransform *leftUnderHorizontalPenaltyTransform = new Qt3DCore::QTransform();
//     leftUnderHorizontalPenaltyTransform->setTranslation(QVector3D(-5.095f, 0.001f, 1.8f));  // 左端 (Z座標を-1.8fに変更)
//     leftUnderHorizontalPenaltyEntity->addComponent(leftUnderHorizontalPenaltyTransform);

//     // 右下水平ペナルティライン
//     Qt3DCore::QEntity *rightUnderHorizontalPenaltyEntity = new Qt3DCore::QEntity(rootEntity);
//     rightUnderHorizontalPenaltyEntity->addComponent(horizontalPenaltyMesh);
//     rightUnderHorizontalPenaltyEntity->addComponent(lineMaterial);
//     Qt3DCore::QTransform *rightUnderHorizontalPenaltyTransform = new Qt3DCore::QTransform();
//     rightUnderHorizontalPenaltyTransform->setTranslation(QVector3D(5.095f, 0.001f, 1.8f));  // 右端 (Z座標を-1.8fに変更)
//     rightUnderHorizontalPenaltyEntity->addComponent(rightUnderHorizontalPenaltyTransform);

//     Qt3DExtras::QPlaneMesh *verticalPenaltyMesh = new Qt3DExtras::QPlaneMesh();
//     verticalPenaltyMesh->setWidth(0.01f);  // 厚さ
//     verticalPenaltyMesh->setHeight(3.6f);  // 高さはフィールドの高さに合わせる
//     Qt3DCore::QEntity *leftUpVerticalPenaltyEntity = new Qt3DCore::QEntity(rootEntity);
//     leftUpVerticalPenaltyEntity->addComponent(verticalPenaltyMesh);
//     leftUpVerticalPenaltyEntity->addComponent(lineMaterial);
//     Qt3DCore::QTransform *leftUpVerticalPenaltyTransform = new Qt3DCore::QTransform();
//     leftUpVerticalPenaltyTransform->setTranslation(QVector3D(-4.2f, 0.001f, 0));  // 左端
//     leftUpVerticalPenaltyEntity->addComponent(leftUpVerticalPenaltyTransform);
//     Qt3DCore::QEntity *rightUpVerticalPenaltyEntity = new Qt3DCore::QEntity(rootEntity);
//     rightUpVerticalPenaltyEntity->addComponent(verticalPenaltyMesh);
//     rightUpVerticalPenaltyEntity->addComponent(lineMaterial);
//     Qt3DCore::QTransform *rightUpVerticalPenaltyTransform = new Qt3DCore::QTransform();
//     rightUpVerticalPenaltyTransform->setTranslation(QVector3D(4.2f, 0.001f, 0));  // 右端
//     rightUpVerticalPenaltyEntity->addComponent(rightUpVerticalPenaltyTransform);

// }
