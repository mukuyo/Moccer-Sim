#include "include/lighting.h"
#include <Qt3DRender/QPointLight>
#include <Qt3DCore/QTransform>
#include <QVector3D>

void addLightingToRoot(Qt3DCore::QEntity *rootEntity)
{
    // ライトの作成
    Qt3DRender::QPointLight *light = new Qt3DRender::QPointLight();
    light->setColor(Qt::white);  // 色を白に設定
    light->setIntensity(1.0f);   // ライトの強度を増加させる

    // 上からのライト
    Qt3DCore::QEntity *lightTopEntity = new Qt3DCore::QEntity(rootEntity);
    lightTopEntity->addComponent(light);

    Qt3DCore::QTransform *lightTopTransform = new Qt3DCore::QTransform();
    lightTopTransform->setTranslation(QVector3D(0.0f, 100.0f, 0.0f)); // 上方向に配置
    lightTopEntity->addComponent(lightTopTransform);

    // 下からのライト (シーンの下側を照らす)
    Qt3DCore::QEntity *lightBottomEntity = new Qt3DCore::QEntity(rootEntity);
    lightBottomEntity->addComponent(light);

    Qt3DCore::QTransform *lightBottomTransform = new Qt3DCore::QTransform();
    lightBottomTransform->setTranslation(QVector3D(0.0f, -50.0f, 0.0f)); // 下方向に配置
    lightBottomEntity->addComponent(lightBottomTransform);
}
