#ifndef COLLISION_H
#define COLLISION_H

#include <QtCore/QObject>
#include <Qt3DCore/QNode>
#include <Qt3DCore/QTransform>
#include <Qt3DCore/QComponent> // For iterating over components

class Collision : public QObject {
    Q_OBJECT
public:
    explicit Collision(QObject *parent = nullptr);

    Q_INVOKABLE bool check(Qt3DCore::QNode *node1, Qt3DCore::QNode *node2);
};

#endif // COLLISION_H
