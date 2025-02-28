import QtQuick
import QtQuick3D
import QtQuick3D.Physics
import MOC

import "../../assets/models/ball/"

Node {
    id: ballNode

    PhysicsMaterial {
        id: physicsMaterial2
        staticFriction: 1.0
        dynamicFriction: 1.0
        restitution: 0.0
    }
    DynamicRigidBody {
        id: ball
        mass: 1.0
        position: Qt.vector3d(0, 100, 0)
        // gravityEnabled: false
        // physicsMaterial: physicsMaterial2
        collisionShapes: ConvexMeshShape {
            id: sphereShape
            source: "../../assets/models/ball/meshes/icosphere_mesh.mesh"
        }
        Ball {

        }

    }
    Timer {
        interval: 16
        running: true
        repeat: true
        onTriggered: {
            console.log("ball position: ", ball.position)
            ball.applyCentralForce(Qt.vector3d(0.0, 0.0, 0.0));
            // ball.applyCentralForce(Qt.vector3d(velocity.x, 0.0, 0.0));
            // let currentVelocity = ball.physicsBody.velocity  // `PhysicsBody` の `velocity` を使用
            // if (velocity.x > 0) {
            //     velocity.x -= acceleration*0.1;
            // }
            // ball.setLinearVelocity(Qt.vector3d(velocity.x, 0.0, 0.0))
            // ball.position = Qt.vector3d(ball.position.x + velocity.x, ball.position.y, ball.position.z + velocity.z)
            
            // ball.position = Qt.vector3d(ball.position.x)
            console.log("ball velocity: ", velocity)
        }
    }
}
