#include "collision.h"
#include <Qt3DCore/QNode>
#include <Qt3DCore/QTransform>
#include <Qt3DCore/QEntity>
#include <Qt3DCore/QComponent>
#include <QDebug>

Collision::Collision(QObject *parent) : QObject(parent) {}

bool Collision::check(Qt3DCore::QNode *node1, Qt3DCore::QNode *node2) {
    qDebug() << "Entering the check method";

    // if (!node1 || !node2) {
    //     qDebug() << "One or both nodes are null";  // Debugging to catch the error
    //     return false;
    // }

    qDebug() << "Checking collision";

    // Try casting QNode to QEntity to access components like QTransform
    Qt3DCore::QEntity *entity1 = qobject_cast<Qt3DCore::QEntity *>(node1);
    Qt3DCore::QEntity *entity2 = qobject_cast<Qt3DCore::QEntity *>(node2);

    // If casting fails, try casting to QTransform
    if (!entity1) {
        qDebug() << "Node1 is not a QEntity, trying QTransform";
        Qt3DCore::QTransform *transform1 = qobject_cast<Qt3DCore::QTransform *>(node1);
        if (transform1) {
            qDebug() << "Node1 is a QTransform.";
            // Process transform1 for collision
        } else {
            qDebug() << "Node1 is neither QEntity nor QTransform.";
            return false;  // If it's neither, we cannot handle collision here.
        }
    }

    if (!entity2) {
        qDebug() << "Node2 is not a QEntity, trying QTransform";
        Qt3DCore::QTransform *transform2 = qobject_cast<Qt3DCore::QTransform *>(node2);
        if (transform2) {
            qDebug() << "Node2 is a QTransform.";
            // Process transform2 for collision
        } else {
            qDebug() << "Node2 is neither QEntity nor QTransform.";
            return false;  // If it's neither, we cannot handle collision here.
        }
    }

    // At this point, we should have either QEntity or QTransform for both nodes
    // If working with QEntities, access the QTransform component
    if (entity1 && entity2) {
        Qt3DCore::QTransform *transform1 = entity1->componentsOfType<Qt3DCore::QTransform>().first();
        Qt3DCore::QTransform *transform2 = entity2->componentsOfType<Qt3DCore::QTransform>().first();

        if (!transform1 || !transform2) {
            qDebug() << "One or both QTransforms are null";
            return false;
        }

        // Perform the AABB (Axis-Aligned Bounding Box) check based on the positions
        QVector3D position1 = transform1->translation();
        QVector3D position2 = transform2->translation();

        float size = 1.0f;  // Example size for AABB check, adjust based on your object size

        bool collides = (abs(position1.x() - position2.x()) < size) &&
                        (abs(position1.y() - position2.y()) < size) &&
                        (abs(position1.z() - position2.z()) < size);

        qDebug() << "Collision detected: " << collides;
        return collides;
    }

    return false;
}
