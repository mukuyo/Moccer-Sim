import QtQuick
import QtQuick3D
import QtQuick3D.Physics

import "../../assets/models/field/"

Node {
    id: rootEntity

    Stadium {
        id: ex_wall
        eulerRotation: Qt.vector3d(-90, 0, 0)
    }
    PhysicsMaterial {
        id: fieldMaterial
        staticFriction: 0.3
        dynamicFriction: 0.3
        restitution: 0.0
    }
    StaticRigidBody {
        eulerRotation: Qt.vector3d(-90, 0, 0)
        physicsMaterial: fieldMaterial
        collisionShapes: PlaneShape {}
        scale: Qt.vector3d(15.4, 12.4, 1)
        Model {
            source: "#Rectangle"
            materials: [ 
                DefaultMaterial {
                    diffuseMap: Texture {
                        source: "../../assets/textures/field_texture.jpg" // 画像ファイルのパス
                    }
                }
            ]
        }
    }

    // 上壁
    StaticRigidBody {
        id: topWall
        position: Qt.vector3d(0, 5, -520)
        scale: Qt.vector3d(13.4, 0.1, 0.02)
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
    // 下壁
    StaticRigidBody {
        id: bottomWall
        position: Qt.vector3d(0, 5, 520)
        eulerRotation: Qt.vector3d(0, 180, 0)
        scale: Qt.vector3d(13.4, 0.1, 0.02)
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
        id: leftWall
        position: Qt.vector3d(-670, 5, 0)
        scale: Qt.vector3d(10.42, 0.1, 0.02)
        eulerRotation: Qt.vector3d(0, 90, 0)
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
        id: rightWall
        position: Qt.vector3d(670, 5, 0)
        scale: Qt.vector3d(10.42, 0.1, 0.02)
        eulerRotation: Qt.vector3d(0, -90, 0)
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
        id: rightGoal
        position: Qt.vector3d(618, 5, 0)
        scale: Qt.vector3d(1.84, 0.1, 0.02)
        eulerRotation: Qt.vector3d(0, 90, 0)
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
        id: rightGoalTop
        position: Qt.vector3d(609, 5, -91)
        scale: Qt.vector3d(0.18, 0.1, 0.02)
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
        scale: Qt.vector3d(0.18, 0.1, 0.02)
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
        id: leftGoal
        position: Qt.vector3d(-618, 5, 0)
        scale: Qt.vector3d(1.84, 0.1, 0.02)
        eulerRotation: Qt.vector3d(0, 90, 0)
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
        id: leftGoalTop
        position: Qt.vector3d(-609, 5, -91)
        scale: Qt.vector3d(0.18, 0.1, 0.02)
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
        scale: Qt.vector3d(0.18, 0.1, 0.02)
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

    // 中央線
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

    // 横ライン
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

    // フィールドの枠線
    Model {
        id: topEdge
        source: "#Rectangle"
        scale: Qt.vector3d(12.0, 0.01, 1)
        position: Qt.vector3d(0, 0.1, -449.5)
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
        position: Qt.vector3d(0, 0.1, 449.5)
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
        position: Qt.vector3d(-599.5, 0.1, 0)
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
        position: Qt.vector3d(599.5, 0.1, 0)
        eulerRotation: Qt.vector3d(-90, 0, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "white"
            }
        ]
    }

    // ペナルティエリアライン
    Model {
        id: leftPenaltyTop
        source: "#Rectangle"
        scale: Qt.vector3d(1.8, 0.01, 1)
        position: Qt.vector3d(-509.5, 0.1, -180)
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
        position: Qt.vector3d(509.5, 0.1, -180)
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
        position: Qt.vector3d(-509.5, 0.1, 180)
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
        position: Qt.vector3d(509.5, 0.1, 180)
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
        position: Qt.vector3d(-420, 0.1, 0)
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
        position: Qt.vector3d(420, 0.1, 0)
        eulerRotation: Qt.vector3d(-90, 0, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "white"
            }
        ]
    }

    // Center Circle
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
                    source: "../../assets/textures/field_texture.jpg" // 画像ファイルのパス
                }
            }
        ]
    }
}
