#include "physics.h"
#include <QDebug>
#include <assimp/Importer.hpp>
#include <assimp/scene.h>
#include <assimp/postprocess.h>

// **Assimp を使って .obj を Bullet の衝突形状に変換**
btBvhTriangleMeshShape* Physics::loadObjToBulletShape(const std::string &filename) {
    Assimp::Importer importer;
    const aiScene* scene = importer.ReadFile(filename, aiProcess_Triangulate | aiProcess_JoinIdenticalVertices);

    if (!scene || !scene->mRootNode || scene->mFlags & AI_SCENE_FLAGS_INCOMPLETE) {
        qWarning() << "Assimp error: " << importer.GetErrorString();
        return nullptr;
    }

    btTriangleMesh* triangleMesh = new btTriangleMesh();

    for (unsigned int i = 0; i < scene->mNumMeshes; i++) {
        aiMesh* mesh = scene->mMeshes[i];

        for (unsigned int j = 0; j < mesh->mNumFaces; j++) {
            aiFace face = mesh->mFaces[j];
            if (face.mNumIndices != 3) continue;

            aiVector3D v0 = mesh->mVertices[face.mIndices[0]];
            aiVector3D v1 = mesh->mVertices[face.mIndices[1]];
            aiVector3D v2 = mesh->mVertices[face.mIndices[2]];

            triangleMesh->addTriangle(
                btVector3(v0.x, v0.y, v0.z),
                btVector3(v1.x, v1.y, v1.z),
                btVector3(v2.x, v2.y, v2.z)
            );
        }
    }

    return new btBvhTriangleMeshShape(triangleMesh, true);
}

/// **Physics クラスのコンストラクタ**
Physics::Physics(QObject *parent) : QObject(parent) {
    btDefaultCollisionConfiguration* collisionConfig = new btDefaultCollisionConfiguration();
    btCollisionDispatcher* dispatcher = new btCollisionDispatcher(collisionConfig);
    btBroadphaseInterface* broadphase = new btDbvtBroadphase();
    btSequentialImpulseConstraintSolver* solver = new btSequentialImpulseConstraintSolver();

    // **Bullet の物理世界を作成**
    dynamicsWorld = new btDiscreteDynamicsWorld(dispatcher, broadphase, solver, collisionConfig);
    dynamicsWorld->setGravity(btVector3(0, -9.8, 0));
    btBoxShape* fieldShape = new btBoxShape(btVector3(15.4, 0.1, 12.4));

    btTransform startTransform;
    startTransform.setIdentity();
    startTransform.setOrigin(btVector3(0,0,0));

    btDefaultMotionState* fieldMotionState = new btDefaultMotionState(startTransform);

    btScalar mass(0);  // Static object (mass = 0)
    btVector3 inertia(0, 0, 0);  // No inertia for a static object
    fieldShape->calculateLocalInertia(mass, inertia);

    btRigidBody::btRigidBodyConstructionInfo rbInfo(mass, fieldMotionState, fieldShape, inertia);
    btRigidBody* fieldBody = new btRigidBody(rbInfo);

    dynamicsWorld->addRigidBody(fieldBody);
    // // **地面を直接作成**
    // btCollisionShape* groundShape = new btBoxShape(btVector3(154*2, 0.1, 124*2));
    // btDefaultMotionState* groundMotion = new btDefaultMotionState(btTransform(btQuaternion(0, 0, 0, 1), btVector3(0, 0, 0)));
    // btRigidBody::btRigidBodyConstructionInfo groundCI(0, groundMotion, groundShape);
    // btRigidBody* groundBody = new btRigidBody(groundCI);
    // groundBody->setRestitution(0.3);
    // // groundBody->setFriction(0.5); // Set friction for ground
    // dynamicsWorld->addRigidBody(groundBody);

    // **ボールを .obj からロード**
    btCollisionShape* ballShape = loadObjToBulletShape("../assets/models/ball/ball.obj");
    if (!ballShape) {
        qWarning() << "Ball shape load failed!";
        return;
    }

    btDefaultMotionState* ballMotion = new btDefaultMotionState(btTransform(btQuaternion(0, 0, 0, 1), btVector3(0, 25, 0)));

    mass = 1.0;
    // inertia = inertia(0, 0, 0);
    ballShape->calculateLocalInertia(mass, inertia);

    btRigidBody::btRigidBodyConstructionInfo ballCI(mass, ballMotion, ballShape, inertia);
    ballBody = new btRigidBody(ballCI);
    ballBody->setRestitution(0.3); // 反発係数
    ballBody->setFriction(0.5);   // Set friction for ball
    dynamicsWorld->addRigidBody(ballBody);
}

void Physics::updateBallPosition(QVector3D velocity) {
    // Get the current transform and velocity.
    btTransform trans;
    ballBody->getMotionState()->getWorldTransform(trans);
    btVector3 currentVelocity = ballBody->getLinearVelocity();
    
    // Add the new velocity to the current one.
    btVector3 newVelocity = currentVelocity + btVector3(velocity.x(), velocity.y(), velocity.z());
    ballBody->setLinearVelocity(newVelocity);
    
    // Optionally, apply a force (e.g., a manual force, like thrust):
    // btVector3 force(0, 10, 0); // Example: apply upward force
    // ballBody->applyForce(force, btVector3(0, 0, 0)); // Apply force at center of mass
    
    // Step the simulation.
    dynamicsWorld->stepSimulation(1 / 60.f);
}



QVector3D Physics::getBallPosition() {
    btTransform trans;
    ballBody->getMotionState()->getWorldTransform(trans);
    btVector3 pos = trans.getOrigin();

    QVector3D result;
    result.setX(pos.x());
    result.setY(pos.y());
    result.setZ(pos.z());
    return result;
}



// **Physics クラスのデストラクタ**
Physics::~Physics() {
    delete dynamicsWorld;
}
