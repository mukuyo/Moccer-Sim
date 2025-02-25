#include "collision.h"
#include <Qt3DCore/QNode>
#include <Qt3DCore/QTransform>
#include <Qt3DCore/QEntity>
#include <Qt3DCore/QComponent>
#include <QDebug>

Collision::Collision(QObject *parent) : QObject(parent) {}

bool Collision::ball_check(QVector3D ball_position, QList<QVector3D> bbots_positions, QList<QVector3D> ybots_positions) {   
    for (int i = 0; i < bbots_positions.size(); i++) {
        if (abs(ball_position.x() - bbots_positions[i].x()) < (8.15 - 2.15) && abs(ball_position.y() - bbots_positions[i].y()) < (8.15 - 2.15) || 
            abs(ball_position.x() - ybots_positions[i].x()) < (8.15 - 2.15) && abs(ball_position.y() - ybots_positions[i].y()) < (8.15 - 2.15)) {
            return true;
        }
    }
    return false;
}

