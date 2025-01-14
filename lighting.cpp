#include "lighting.h"
#include <Qt3DRender/QPointLight>
#include <Qt3DCore/QTransform>
#include <QVector3D>

void addLightingToRoot(Qt3DCore::QEntity *rootEntity)
{
    // ライトの作成
    Qt3DRender::QPointLight *light = new Qt3DRender::QPointLight();
    light->setColor(Qt::white);
    light->setIntensity(1.0f);

    Qt3DCore::QEntity *lightEntity = new Qt3DCore::QEntity(rootEntity);
    lightEntity->addComponent(light);

    Qt3DCore::QTransform *lightTransform = new Qt3DCore::QTransform();
    lightTransform->setTranslation(QVector3D(0, 20.0f, 10.0f));
    lightEntity->addComponent(lightTransform);
}
