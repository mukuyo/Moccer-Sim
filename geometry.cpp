#include "geometry.h"
#include <Qt3DExtras/QPlaneMesh>
#include <Qt3DExtras/QPhongMaterial>
#include <Qt3DCore/QTransform>
#include <Qt3DExtras/QConeMesh>
#include <Qt3DExtras/QCylinderMesh>
#include <Qt3DExtras/QCuboidMesh>
#include <QColor>

void create_fileds(Qt3DCore::QEntity *rootEntity)
{
    // フィールドの作成
    Qt3DExtras::QPlaneMesh *fieldMesh = new Qt3DExtras::QPlaneMesh();
    fieldMesh->setWidth(12.6f);  // 12000mm = 12.0m
    fieldMesh->setHeight(9.6f);  // 9000mm = 9.0m
    Qt3DExtras::QPhongMaterial *fieldMaterial = new Qt3DExtras::QPhongMaterial();
    fieldMaterial->setDiffuse(QColor(Qt::gray));
    Qt3DCore::QEntity *fieldEntity = new Qt3DCore::QEntity(rootEntity);
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

void create_lines(Qt3DCore::QEntity *rootEntity)
{
    // ライン（中央線）の作成
    Qt3DExtras::QPlaneMesh *centerLineMesh = new Qt3DExtras::QPlaneMesh();
    centerLineMesh->setWidth(0.01f);
    centerLineMesh->setHeight(9.0f);  // 中央線の高さもフィールドに合わせる
    Qt3DExtras::QPhongMaterial *lineMaterial = new Qt3DExtras::QPhongMaterial();
    lineMaterial->setDiffuse(QColor(Qt::white));
    Qt3DCore::QEntity *centerLineEntity = new Qt3DCore::QEntity(rootEntity);
    centerLineEntity->addComponent(centerLineMesh);
    centerLineEntity->addComponent(lineMaterial);
    Qt3DCore::QTransform *lineTransform = new Qt3DCore::QTransform();
    lineTransform->setTranslation(QVector3D(0, 0.001f, 0));  // 中央に配置
    centerLineEntity->addComponent(lineTransform);

    // 横ラインの作成（新たに追加）
    Qt3DExtras::QPlaneMesh *horizontalLineMesh = new Qt3DExtras::QPlaneMesh();
    horizontalLineMesh->setWidth(12.0f);  // 横ラインの幅をフィールドの幅に合わせる
    horizontalLineMesh->setHeight(0.01f);  // 厚さは薄く設定
    Qt3DCore::QEntity *horizontalLineEntity = new Qt3DCore::QEntity(rootEntity);
    horizontalLineEntity->addComponent(horizontalLineMesh);
    horizontalLineEntity->addComponent(lineMaterial);
    Qt3DCore::QTransform *horizontalLineTransform = new Qt3DCore::QTransform();
    horizontalLineTransform->setTranslation(QVector3D(0, 0.001f, 0));  // 中央に配置
    horizontalLineEntity->addComponent(horizontalLineTransform);
    Qt3DExtras::QPlaneMesh *rectangleEdgeMesh = new Qt3DExtras::QPlaneMesh();
    rectangleEdgeMesh->setWidth(12.0f);  // 幅はフィールドの幅に微調整
    rectangleEdgeMesh->setHeight(0.01f);  // 枠の厚さ

    Qt3DCore::QEntity *topEdgeEntity = new Qt3DCore::QEntity(rootEntity);
    topEdgeEntity->addComponent(rectangleEdgeMesh);
    topEdgeEntity->addComponent(lineMaterial);
    Qt3DCore::QTransform *topEdgeTransform = new Qt3DCore::QTransform();
    topEdgeTransform->setTranslation(QVector3D(0, 0.001f, -4.495f));  // 上端
    topEdgeEntity->addComponent(topEdgeTransform);

    Qt3DCore::QEntity *bottomEdgeEntity = new Qt3DCore::QEntity(rootEntity);
    bottomEdgeEntity->addComponent(rectangleEdgeMesh);
    bottomEdgeEntity->addComponent(lineMaterial);
    Qt3DCore::QTransform *bottomEdgeTransform = new Qt3DCore::QTransform();
    bottomEdgeTransform->setTranslation(QVector3D(0, 0.001f, 4.495f));  // 下端
    bottomEdgeEntity->addComponent(bottomEdgeTransform);

    Qt3DExtras::QPlaneMesh *verticalEdgeMesh = new Qt3DExtras::QPlaneMesh();
    verticalEdgeMesh->setWidth(0.01f);  // 厚さ
    verticalEdgeMesh->setHeight(9.0f);  // 高さはフィールドの高さに合わせる
    Qt3DCore::QEntity *leftEdgeEntity = new Qt3DCore::QEntity(rootEntity);
    leftEdgeEntity->addComponent(verticalEdgeMesh);
    leftEdgeEntity->addComponent(lineMaterial);
    Qt3DCore::QTransform *leftEdgeTransform = new Qt3DCore::QTransform();
    leftEdgeTransform->setTranslation(QVector3D(-5.995f, 0.001f, 0));  // 左端
    leftEdgeEntity->addComponent(leftEdgeTransform);
    Qt3DCore::QEntity *rightEdgeEntity = new Qt3DCore::QEntity(rootEntity);
    rightEdgeEntity->addComponent(verticalEdgeMesh);
    rightEdgeEntity->addComponent(lineMaterial);
    Qt3DCore::QTransform *rightEdgeTransform = new Qt3DCore::QTransform();
    rightEdgeTransform->setTranslation(QVector3D(5.995f, 0.001f, 0));  // 右端
    rightEdgeEntity->addComponent(rightEdgeTransform);

    Qt3DExtras::QCylinderMesh *circleMesh = new Qt3DExtras::QCylinderMesh();
    circleMesh->setRadius(0.5f);  // 半径 1000mm = 1m の場合、半径は0.5f
    circleMesh->setLength(0.001f); // 円の高さ（薄くする）
    Qt3DExtras::QPhongMaterial *circleMaterial = new Qt3DExtras::QPhongMaterial();
    circleMaterial->setDiffuse(QColor(Qt::white));  // 青色
    Qt3DCore::QEntity *circleEntity = new Qt3DCore::QEntity(rootEntity);
    circleEntity->addComponent(circleMesh);
    circleEntity->addComponent(circleMaterial);
    Qt3DCore::QTransform *circleTransform = new Qt3DCore::QTransform();
    circleTransform->setTranslation(QVector3D(0, 0.0001f, 0));  // フィールドの中央に配置
    circleEntity->addComponent(circleTransform);

    Qt3DExtras::QCylinderMesh *_circleMesh = new Qt3DExtras::QCylinderMesh();
    _circleMesh->setRadius(0.49f);  // 半径 1000mm = 1m の場合、半径は0.5f
    _circleMesh->setLength(0.001f); // 円の高さ（薄くする）
    Qt3DExtras::QPhongMaterial *_circleMaterial = new Qt3DExtras::QPhongMaterial();
    _circleMaterial->setDiffuse(QColor(Qt::gray));  // 青色
    Qt3DCore::QEntity *_circleEntity = new Qt3DCore::QEntity(rootEntity);
    _circleEntity->addComponent(_circleMesh);
    _circleEntity->addComponent(_circleMaterial);
    Qt3DCore::QTransform *_circleTransform = new Qt3DCore::QTransform();
    _circleTransform->setTranslation(QVector3D(0, 0.0004f, 0));  // フィールドの中央に配置
    _circleEntity->addComponent(_circleTransform);
}
