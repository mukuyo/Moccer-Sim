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

    Q_INVOKABLE bool ball_check(QVector3D ball_position, QList<QVector3D> bbots_positions, QList<QVector3D> ybots_positions);
};

#endif // COLLISION_H
