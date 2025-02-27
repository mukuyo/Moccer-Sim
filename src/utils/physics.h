#ifndef PHYSICS_H
#define PHYSICS_H

#include <QObject>
#include <QVector3D>
#include <bullet/btBulletDynamicsCommon.h>
#include <assimp/Importer.hpp>
#include <assimp/scene.h>
#include <assimp/postprocess.h>

class Physics : public QObject {
    Q_OBJECT
public:
    explicit Physics(QObject *parent = nullptr);
    ~Physics();

    Q_INVOKABLE void stepSimulation();         // 物理演算を進める
    Q_INVOKABLE QVector3D getBallPosition(); // ボールの位置を取得

private:
    btBvhTriangleMeshShape* loadObjToBulletShape(const std::string &filename);

    btDiscreteDynamicsWorld *dynamicsWorld;
    btRigidBody *ballBody;
};

#endif // PHYSICS_H
