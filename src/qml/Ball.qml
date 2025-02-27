import QtQuick
import QtQuick3D
import QtQuick3D.Physics
import MOC

import "../../assets/models/ball/"

Node {
    id: ballNode
    property real friction: 0.05

    // Ball {
    //     id: ball
    //     position: Qt.vector3d(0, 0, 0)
    // }
    // Model {
    //     id: ball
    //     source: "#Sphere"
    //     scale: Qt.vector3d(0.043, 0.043, 0.043)
    //     position: Qt.vector3d(0, 50, 0)
    //     materials: [
    //         DefaultMaterial {
    //             diffuseColor: "orange"
    //         }
    //     ]
    // }
    // PhysicsBody {
    //     id: ball
    //     position: Qt.vector3d(0, 50, 0)
    //     velocity: Qt.vector3d(0, 0, 0)
    //     acceleration: Qt.vector3d(0, 0, 0)
    //     mass: 1
    //     friction: ballNode.friction
    // }
    DynamicRigidBody {
        position: Qt.vector3d(0, 100, 0)
        // scale: Qt.vector3d(0.043, 0.043, 0.043)
        collisionShapes: SphereShape {
            id: sphereShape
            // source: "../../assets/models/ball/meshes/icosphere.mesh"
        }
        Model {
            source: "../../assets/models/ball/meshes/icosphere.mesh"
            // scale: Qt.vector3d(10,10,10)
            materials: PrincipledMaterial {
                baseColor: "blue"
            }
        }
    }
    // Timer {
    //     interval: 16
    //     running: true
    //     repeat: true
    //     onTriggered: {
    //         var _pos = Qt.vector3d(
    //             ball.position.x + velocity.x,
    //             ball.position.y + velocity.y,
    //             ball.position.z + velocity.z
    //         );
    //         ball.position = _pos;
    //         // physics.updateBallPosition(velocity);
    //         // // physics.stepSimulation()
    //         // var pos = physics.getBallPosition()
    //         // ball.position = pos
    //         // console.log("ball position: ", pos)
    //     }
    // }
}