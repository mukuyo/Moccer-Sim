import QtQuick
import QtQuick3D
import QtQuick3D.Physics

import "../../assets/models/stadium/"

Node {
    id: rootEntity

    Stadium {
        id: stadium
    }
    PhysicsMaterial {
        id: fieldMaterial
        staticFriction: 0.5
        dynamicFriction: 0.5
        restitution: 0.001
    }
    StaticRigidBody {
        id: field
        eulerRotation: Qt.vector3d(-90, 0, 0)
        physicsMaterial: fieldMaterial
        collisionShapes: PlaneShape {}
        scale: Qt.vector3d(15.4, 12.4, 1)
        Model {
            source: "#Rectangle"
            objectName: "field"
            pickable: true
            materials: [ 
                DefaultMaterial {
                    diffuseMap: Texture {
                        source: "../../assets/textures/field_texture.jpg"
                    }
                }
            ]
        }
    }

    Model {
        id: topWall
        pickable: true
        source: "#Cube"
        scale: Qt.vector3d(12.62, 0.3, 0.02)
        position: Qt.vector3d(0, 5, -481)
        eulerRotation: Qt.vector3d(0, 0, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }
    StaticRigidBody {
        id: topWallSecret
        position: Qt.vector3d(0, 5, -531)
        scale: Qt.vector3d(12.62, 0.3, 1)
        physicsMaterial: physicsMaterial
        collisionShapes: BoxShape {}
    }

    Model {
        id: bottomWall
        source: "#Cube"
        scale: Qt.vector3d(12.62, 0.3, 0.02)
        position: Qt.vector3d(0, 5, 481)
        eulerRotation: Qt.vector3d(0, 180, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }
    StaticRigidBody {
        id: bottomWallSecret
        position: Qt.vector3d(0, 5, 531)
        scale: Qt.vector3d(12.62, 0.3, 1)
        physicsMaterial: physicsMaterial
        collisionShapes: BoxShape {}
    }
    
    Model {
        id: leftWall
        source: "#Cube"
        scale: Qt.vector3d(9.62, 0.3, 0.02)
        position: Qt.vector3d(-631, 5, 0)
        eulerRotation: Qt.vector3d(0, 90, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }
    StaticRigidBody {
        id: leftWallSecret
        position: Qt.vector3d(-681, 5, 0)
        scale: Qt.vector3d(9.62, 0.3, 1)
        eulerRotation: Qt.vector3d(0, 90, 0)
        physicsMaterial: physicsMaterial
        collisionShapes: BoxShape {}
    }

    Model {
        id: rightWall
        source: "#Cube"
        scale: Qt.vector3d(9.62, 0.3, 0.02)
        position: Qt.vector3d(631, 5, 0)
        eulerRotation: Qt.vector3d(0, -90, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }
    StaticRigidBody {
        id: rightWallSecret
        position: Qt.vector3d(681, 5, 0)
        scale: Qt.vector3d(9.62, 0.3, 1)
        eulerRotation: Qt.vector3d(0, -90, 0)
        physicsMaterial: physicsMaterial
        collisionShapes: BoxShape {}
    }

    Model {
        id: rightGoal
        source: "#Cube"
        scale: Qt.vector3d(1.84, 0.3, 0.02)
        position: Qt.vector3d(618, 5, 0)
        eulerRotation: Qt.vector3d(0, -90, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }
    StaticRigidBody {
        id: rightGoalSecret
        position: Qt.vector3d(649, 5, 0)
        scale: Qt.vector3d(1.84, 0.3, 0.62)
        eulerRotation: Qt.vector3d(0, -90, 0)
        physicsMaterial: physicsMaterial
        collisionShapes: BoxShape {}
    }

    StaticRigidBody {
        id: rightGoalTop
        position: Qt.vector3d(609, 5, -91)
        scale: Qt.vector3d(0.18, 0.3, 0.02)
        physicsMaterial: physicsMaterial
        collisionShapes: BoxShape {}
        Model {
            source: "#Cube"
            materials: [
                DefaultMaterial {
                    diffuseColor: "black"
                }
            ]
        }
    }

    StaticRigidBody {
        id: rightGoalBottom
        position: Qt.vector3d(609, 5, 91)
        scale: Qt.vector3d(0.18, 0.3, 0.02)
        physicsMaterial: physicsMaterial
        collisionShapes: BoxShape {}
        Model {
            source: "#Cube"
            materials: [
                DefaultMaterial {
                    diffuseColor: "black"
                }
            ]
        }
    }

    Model {
        id: leftGoal
        source: "#Cube"
        scale: Qt.vector3d(1.84, 0.3, 0.02)
        position: Qt.vector3d(-618, 5, 0)
        eulerRotation: Qt.vector3d(0, 90, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }
    StaticRigidBody {
        id: leftGoalSecret
        position: Qt.vector3d(-649, 5, 0)
        scale: Qt.vector3d(1.84, 0.3, 0.62)
        eulerRotation: Qt.vector3d(0, 90, 0)
        physicsMaterial: physicsMaterial
        collisionShapes: BoxShape {}
    }

    StaticRigidBody {
        id: leftGoalTop
        position: Qt.vector3d(-609, 5, -91)
        scale: Qt.vector3d(0.18, 0.3, 0.02)
        physicsMaterial: physicsMaterial
        collisionShapes: BoxShape {}
        Model {
            source: "#Cube"
            materials: [
                DefaultMaterial {
                    diffuseColor: "black"
                }
            ]
        }
    }

    StaticRigidBody {
        id: leftGoalBottom
        position: Qt.vector3d(-609, 5, 91)
        scale: Qt.vector3d(0.18, 0.3, 0.02)
        physicsMaterial: physicsMaterial
        collisionShapes: BoxShape {}
        Model {
            source: "#Cube"
            materials: [
                DefaultMaterial {
                    diffuseColor: "black"
                }
            ]
        }
    }

    Model {
        id: centerLine
        source: "#Rectangle"
        scale: Qt.vector3d(0.01, 9.0, 1)
        position: Qt.vector3d(0, 0.3, 0)
        eulerRotation: Qt.vector3d(-90, 0, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "white"
            }
        ]
    }

    Model {
        id: horizontalLine
        source: "#Rectangle"
        scale: Qt.vector3d(12.0, 0.01, 1)
        position: Qt.vector3d(0, 0.3, 0)
        eulerRotation: Qt.vector3d(-90, 0, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "white"
            }
        ]
    }

    Model {
        id: topEdge
        source: "#Rectangle"
        scale: Qt.vector3d(12.0, 0.01, 1)
        position: Qt.vector3d(0, 0.3, -449.5)
        eulerRotation: Qt.vector3d(-90, 0, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "white"
            }
        ]
    }

    Model {
        id: bottomEdge
        source: "#Rectangle"
        scale: Qt.vector3d(12.0, 0.01, 1)
        position: Qt.vector3d(0, 0.3, 449.5)
        eulerRotation: Qt.vector3d(-90, 0, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "white"
            }
        ]
    }

    Model {
        id: leftEdge
        source: "#Rectangle"
        scale: Qt.vector3d(0.01, 9.0, 1)
        position: Qt.vector3d(-599.5, 0.3, 0)
        eulerRotation: Qt.vector3d(-90, 0, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "white"
            }
        ]
    }

    Model {
        id: rightEdge
        source: "#Rectangle"
        scale: Qt.vector3d(0.01, 9.0, 1)
        position: Qt.vector3d(599.5, 0.3, 0)
        eulerRotation: Qt.vector3d(-90, 0, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "white"
            }
        ]
    }

    Model {
        id: leftPenaltyTop
        source: "#Rectangle"
        scale: Qt.vector3d(1.8, 0.01, 1)
        position: Qt.vector3d(-509.5, 0.3, -180)
        eulerRotation: Qt.vector3d(-90, 0, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "white"
            }
        ]
    }

    Model {
        id: rightPenaltyTop
        source: "#Rectangle"
        scale: Qt.vector3d(1.8, 0.01, 1)
        position: Qt.vector3d(509.5, 0.3, -180)
        eulerRotation: Qt.vector3d(-90, 0, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "white"
            }
        ]
    }

    Model {
        id: leftPenaltyBottom
        source: "#Rectangle"
        scale: Qt.vector3d(1.8, 0.01, 1)
        position: Qt.vector3d(-509.5, 0.3, 180)
        eulerRotation: Qt.vector3d(-90, 0, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "white"
            }
        ]
    }

    Model {
        id: rightPenaltyBottom
        source: "#Rectangle"
        scale: Qt.vector3d(1.8, 0.01, 1)
        position: Qt.vector3d(509.5, 0.3, 180)
        eulerRotation: Qt.vector3d(-90, 0, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "white"
            }
        ]
    }

    Model {
        id: leftPenaltyVertical
        source: "#Rectangle"
        scale: Qt.vector3d(0.01, 3.6, 1)
        position: Qt.vector3d(-420, 0.3, 0)
        eulerRotation: Qt.vector3d(-90, 0, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "white"
            }
        ]
    }

    Model {
        id: rightPenaltyVertical
        source: "#Rectangle"
        scale: Qt.vector3d(0.01, 3.6, 1)
        position: Qt.vector3d(420, 0.3, 0)
        eulerRotation: Qt.vector3d(-90, 0, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "white"
            }
        ]
    }

    Model {
        id: centerWhiteCircle
        source: "#Cylinder"
        scale: Qt.vector3d(1.02, 0.001, 1.02)
        position: Qt.vector3d(0, 0.0001, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "white"
            }
        ]
    }

    Model {
        id: centerGreenCircle
        source: "#Cylinder"
        scale: Qt.vector3d(1, 0.001, 1)
        position: Qt.vector3d(0, 0.2, 0)
        materials: [ 
            DefaultMaterial {
                diffuseMap: Texture {
                    source: "../../assets/textures/field_texture.jpg"
                }
            }
        ]
    }
}
