import QtQuick
import QtQuick3D
import QtQuick3D.Physics

import "../../assets/models/stadium/"

Node {
    id: rootEntity

    // Stadium {
    //     id: stadium
    //     scale: Qt.vector3d(10, 10, 10)
    // }
    PhysicsMaterial {
        id: fieldMaterial
        staticFriction: 0.0
        dynamicFriction: 0.0
        restitution: 0.0
    }
    StaticRigidBody {
        id: field
        eulerRotation: Qt.vector3d(-90, 0, 0)
        physicsMaterial: fieldMaterial
        collisionShapes: PlaneShape {}
        
        Model {
            source: "#Rectangle"
            objectName: "field"
            pickable: true
            scale: Qt.vector3d(154, 124, 0.1)
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
        scale: Qt.vector3d(126.2, 3, 0.2)
        position: Qt.vector3d(0, 50, -4810)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }
    StaticRigidBody {
        id: topWallSecret
        position: Qt.vector3d(0, 50, -5310)
        scale: Qt.vector3d(126.2, 3, 10)
        physicsMaterial: physicsMaterial
        collisionShapes: BoxShape {}
    }

    Model {
        id: bottomWall
        source: "#Cube"
        scale: Qt.vector3d(126.2, 3, 0.2)
        position: Qt.vector3d(0, 50, 4810)
        eulerRotation: Qt.vector3d(0, 180, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }
    StaticRigidBody {
        id: bottomWallSecret
        position: Qt.vector3d(0, 50, 5310)
        scale: Qt.vector3d(126.2, 3, 10)
        physicsMaterial: physicsMaterial
        collisionShapes: BoxShape {}
    }
    
    Model {
        id: leftWall
        source: "#Cube"
        scale: Qt.vector3d(96.2, 3, 0.2)
        position: Qt.vector3d(-6310, 50, 0)
        eulerRotation: Qt.vector3d(0, 90, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }
    StaticRigidBody {
        id: leftWallSecret
        position: Qt.vector3d(-6810, 50, 0)
        scale: Qt.vector3d(96.2, 3, 10)
        eulerRotation: Qt.vector3d(0, 90, 0)
        physicsMaterial: physicsMaterial
        collisionShapes: BoxShape {}
    }

    Model {
        id: rightWall
        source: "#Cube"
        scale: Qt.vector3d(96.2, 3, 0.2)
        position: Qt.vector3d(6310, 50, 0)
        eulerRotation: Qt.vector3d(0, -90, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }
    StaticRigidBody {
        id: rightWallSecret
        position: Qt.vector3d(6810, 50, 0)
        scale: Qt.vector3d(96.2, 3, 10)
        eulerRotation: Qt.vector3d(0, -90, 0)
        physicsMaterial: physicsMaterial
        collisionShapes: BoxShape {}
    }

    Model {
        id: rightGoal
        source: "#Cube"
        scale: Qt.vector3d(18.4, 3, 0.2)
        position: Qt.vector3d(6180, 50, 0)
        eulerRotation: Qt.vector3d(0, -90, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }
    StaticRigidBody {
        id: rightGoalSecret
        position: Qt.vector3d(6490, 50, 0)
        scale: Qt.vector3d(18.4, 3, 6.2)
        eulerRotation: Qt.vector3d(0, -90, 0)
        physicsMaterial: physicsMaterial
        collisionShapes: BoxShape {}
    }

    StaticRigidBody {
        id: rightGoalTop
        position: Qt.vector3d(6090, 50, -910)
        scale: Qt.vector3d(1.8, 3, 0.2)
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
        position: Qt.vector3d(6090, 50, 910)
        scale: Qt.vector3d(1.8, 3, 0.2)
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
        scale: Qt.vector3d(18.4, 3, 0.2)
        position: Qt.vector3d(-6180, 50, 0)
        eulerRotation: Qt.vector3d(0, 90, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }
    StaticRigidBody {
        id: leftGoalSecret
        position: Qt.vector3d(-6490, 50, 0)
        scale: Qt.vector3d(18.4, 3, 6.2)
        eulerRotation: Qt.vector3d(0, 90, 0)
        physicsMaterial: physicsMaterial
        collisionShapes: BoxShape {}
    }

    StaticRigidBody {
        id: leftGoalTop
        position: Qt.vector3d(-6090, 50, -910)
        scale: Qt.vector3d(1.8, 3, 0.2)
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
        position: Qt.vector3d(-6090, 50, 910)
        scale: Qt.vector3d(1.8, 3, 0.2)
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
        scale: Qt.vector3d(0.1, 90, 1)
        position: Qt.vector3d(0, 3, 0)
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
        scale: Qt.vector3d(120, 0.1, 1)
        position: Qt.vector3d(0, 3, 0)
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
        scale: Qt.vector3d(120, 0.1, 1)
        position: Qt.vector3d(0, 3, -4495)
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
        scale: Qt.vector3d(120, 0.1, 1)
        position: Qt.vector3d(0, 3, 4495)
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
        scale: Qt.vector3d(0.1, 90, 1)
        position: Qt.vector3d(-5995, 3, 0)
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
        scale: Qt.vector3d(0.1, 90, 1)
        position: Qt.vector3d(5995, 3, 0)
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
        scale: Qt.vector3d(18, 0.1, 1)
        position: Qt.vector3d(-5095, 3, -1800)
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
        scale: Qt.vector3d(18, 0.1, 1)
        position: Qt.vector3d(5095, 3, -1800)
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
        scale: Qt.vector3d(18, 0.1, 1)
        position: Qt.vector3d(-5095, 3, 1800)
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
        scale: Qt.vector3d(18, 0.1, 1)
        position: Qt.vector3d(5095, 3, 1800)
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
        scale: Qt.vector3d(0.1, 36, 1)
        position: Qt.vector3d(-4200, 3, 0)
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
        scale: Qt.vector3d(0.1, 36, 1)
        position: Qt.vector3d(4200, 3, 0)
        eulerRotation: Qt.vector3d(-90, 0, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "white"
            }
        ]
    }

    // Model {
    //     id: centerWhiteCircle
    //     source: "#Cylinder"
    //     scale: Qt.vector3d(10.2, 0.0001, 10.2)
    //     position: Qt.vector3d(0, 4, 0)
    //     materials: [
    //         DefaultMaterial {
    //             diffuseColor: "white"
    //         }
    //     ]
    // }

    // Model {
    //     id: centerGreenCircle
    //     source: "#Cylinder"
    //     scale: Qt.vector3d(10, 0.01, 10)
    //     position: Qt.vector3d(0, 10, 0)
    //     materials: [ 
    //         DefaultMaterial {
    //             diffuseMap: Texture {
    //                 source: "../../assets/textures/field_texture.jpg"
    //             }
    //         }
    //     ]
    // }
}
