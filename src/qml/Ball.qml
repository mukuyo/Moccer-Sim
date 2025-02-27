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
    // DynamicRigidBody {
    //     id: ball
    //     // isKinematic: true
    //     // mass: 0
    //     // property vector3d bottomPos: Qt.vector3d(0, 40, 0)
    //     position: Qt.vector3d(0, 100, 0)
    //     // position: bottomPos
    //     // kinematicPivot: Qt.vector3d(0, 40, 0)
    //     // kinematicPosition: bottomPos
    //     // scale: Qt.vector3d(0.043, 0.043, 0.043)
    //     collisionShapes: TriangleMeshShape {
    //         id: sphereShape
    //         source: "../../assets/models/ball/meshes/icosphere_mesh.mesh"
    //     }
    //     Model {
            
    //         // position: Qt.vector3d(0, 40, 0)
    //         source: "../../assets/models/ball/meshes/icosphere_mesh.mesh"
    //         // scale: Qt.vector3d(10,10,10)
    //         materials: PrincipledMaterial {
    //             baseColor: "blue"
    //         }
    //     }
    // }
    // DynamicRigidBody {
    //     id: ball
    //     position: Qt.vector3d(0, 40, 0)
    //     scale: Qt.vector3d(100,100,100)
    //     collisionShapes: SphereShape {
    //     }
    //     Model {
    //         id: ballModel
    //         source: "#Sphere"
            
    //         materials: PrincipledMaterial {
    //             baseColor: "blue"
    //         }
    //     }
    // }
    PhysicsMaterial {
        id: physicsMaterial
        staticFriction: 0.3
        dynamicFriction: 0.3
        restitution: 0.3
    }
    DynamicRigidBody {
        id: ball
        position: Qt.vector3d(0, 100, 0)
        
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
            var _pos = Qt.vector3d(
                ball.position.x + velocity.x,
                ball.position.y + velocity.y,
                ball.position.z + velocity.z
            );
            ball.position = _pos;
            // physics.updateBallPosition(velocity);
            // // physics.stepSimulation()
            // var pos = physics.getBallPosition()
            // ball.position = pos
            // console.log("ball position: ", pos)
        }
    }
}


// DynamicRigidBody {
//     property string color: "blue"

//     collisionShapes: [
//         SphereShape {
//             id: sphere0
//             diameter:  1
//         },
//         SphereShape {
//             id: sphere1
//             diameter:  0.8
//             position: Qt.vector3d(0, 6, 0)
//         },
//         SphereShape {
//             id: sphere2
//             diameter:  0.6
//             position: Qt.vector3d(0, 11, 0)
//         }
//     ]

//     Model {
//         source: "#Sphere"
//         position: sphere0.position
//         scale: Qt.vector3d(1,1,1).times(sphere0.diameter*1)
//         materials: PrincipledMaterial {
//             baseColor: color
//         }
//     }

//     Model {
//         source: "#Sphere"
//         position: sphere1.position
//         scale: Qt.vector3d(1,1,1).times(sphere1.diameter*0.1)
//         materials: PrincipledMaterial {
//             baseColor: color
//         }
//     }

//     Model {
//         source: "#Sphere"
//         position: sphere2.position
//         scale: Qt.vector3d(1,1,1).times(sphere2.diameter*0.1)
//         materials: PrincipledMaterial {
//             baseColor: color
//         }
//     }
// }