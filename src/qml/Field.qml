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
        id: physicsMaterial2
        staticFriction: 1.0
        dynamicFriction: 1.0
        restitution: 0.0
    }
    StaticRigidBody {
        eulerRotation: Qt.vector3d(-90, 0, 0)
        // physicsMaterial: physicsMaterial2
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
    Model {
        id: topWall
        source: "#Cube"
        scale: Qt.vector3d(13.4, 0.1, 0.02)
        position: Qt.vector3d(0, 5, -520)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }

    // 下壁
    Model {
        id: bottomWall
        source: "#Cube"
        scale: Qt.vector3d(13.4, 0.1, 0.02)
        position: Qt.vector3d(0, 5, 520)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }

    // 左壁
    Model {
        id: leftWall
        source: "#Cube"
        scale: Qt.vector3d(10.42, 0.1, 0.02)
        position: Qt.vector3d(-670, 5, 0)
        eulerRotation: Qt.vector3d(0, 90, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }

    // 右壁
    Model {
        id: rightWall
        source: "#Cube"
        scale: Qt.vector3d(10.42, 0.1, 0.02)
        position: Qt.vector3d(670, 5, 0)
        eulerRotation: Qt.vector3d(0, -90, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }

    // 右ゴール
    Model {
        id: rightGoal
        source: "#Cube"
        scale: Qt.vector3d(1.84, 0.1, 0.02)
        position: Qt.vector3d(618, 5, 0)
        eulerRotation: Qt.vector3d(0, 90, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }

    // 右ゴール端上
    Model {
        id: rightGoalTop
        source: "#Cube"
        scale: Qt.vector3d(0.18, 0.1, 0.02)
        position: Qt.vector3d(609, 5, -91)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }

    // 右ゴール端下
    Model {
        id: rightGoalBottom
        source: "#Cube"
        scale: Qt.vector3d(0.18, 0.1, 0.02)
        position: Qt.vector3d(609, 5, 91)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }

    // 左ゴール
    Model {
        id: leftGoal
        source: "#Cube"
        scale: Qt.vector3d(1.84, 0.1, 0.02)
        position: Qt.vector3d(-618, 5, 0)
        eulerRotation: Qt.vector3d(0, 90, 0)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }

    // 左ゴール端上
    Model {
        id: leftGoalTop
        source: "#Cube"
        scale: Qt.vector3d(0.18, 0.1, 0.02)
        position: Qt.vector3d(-609, 5, -91)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
    }

    // 左ゴール端下
    Model {
        id: leftGoalBottom
        source: "#Cube"
        scale: Qt.vector3d(0.18, 0.1, 0.02)
        position: Qt.vector3d(-609, 5, 91)
        materials: [
            DefaultMaterial {
                diffuseColor: "black"
            }
        ]
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

// import QtQuick
// import QtQuick3D

// import "../../assets/models/field/"

// Node {
//     id: rootEntity

//     Stadium {
//         id: ex_wall
//         eulerRotation: Qt.vector3d(-90, 0, 0)
//         scale: Qt.vector3d(0.1, 0.1, 0.1)
//     }

//     // フィールド
//     Model {
//         id: fieldEntity
//         source: "#Rectangle"
//         scale: Qt.vector3d(1.54, 1.24, 0.0001) // 15.4, 12.4 -> 1.54, 1.24
//         position: Qt.vector3d(0, 0, 0)
//         eulerRotation: Qt.vector3d(-90, 0, 0)
//         materials: [ 
//             DefaultMaterial {
//                 diffuseMap: Texture {
//                     source: "../../assets/textures/field_texture.jpg" // 画像ファイルのパス
//                 }
//             }
//         ]
//     }

//     // 上壁
//     Model {
//         id: topWall
//         source: "#Cube"
//         scale: Qt.vector3d(1.34, 0.01, 0.002)
//         position: Qt.vector3d(0, 0.5, -52)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "black"
//             }
//         ]
//     }

//     // 下壁
//     Model {
//         id: bottomWall
//         source: "#Cube"
//         scale: Qt.vector3d(1.34, 0.01, 0.002)
//         position: Qt.vector3d(0, 0.5, 52)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "black"
//             }
//         ]
//     }

//     // 左壁
//     Model {
//         id: leftWall
//         source: "#Cube"
//         scale: Qt.vector3d(1.042, 0.01, 0.002)
//         position: Qt.vector3d(-67, 0.5, 0)
//         eulerRotation: Qt.vector3d(0, 90, 0)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "black"
//             }
//         ]
//     }

//     // 右壁
//     Model {
//         id: rightWall
//         source: "#Cube"
//         scale: Qt.vector3d(1.042, 0.01, 0.002)
//         position: Qt.vector3d(67, 0.5, 0)
//         eulerRotation: Qt.vector3d(0, -90, 0)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "black"
//             }
//         ]
//     }

//     // 右ゴール
//     Model {
//         id: rightGoal
//         source: "#Cube"
//         scale: Qt.vector3d(0.184, 0.01, 0.002)
//         position: Qt.vector3d(61.8, 0.5, 0)
//         eulerRotation: Qt.vector3d(0, 90, 0)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "black"
//             }
//         ]
//     }

//     // 右ゴール端上
//     Model {
//         id: rightGoalTop
//         source: "#Cube"
//         scale: Qt.vector3d(0.018, 0.01, 0.002)
//         position: Qt.vector3d(60.9, 0.5, -9.1)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "black"
//             }
//         ]
//     }

//     // 右ゴール端下
//     Model {
//         id: rightGoalBottom
//         source: "#Cube"
//         scale: Qt.vector3d(0.018, 0.01, 0.002)
//         position: Qt.vector3d(60.9, 0.5, 9.1)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "black"
//             }
//         ]
//     }

//     // 左ゴール
//     Model {
//         id: leftGoal
//         source: "#Cube"
//         scale: Qt.vector3d(0.184, 0.01, 0.002)
//         position: Qt.vector3d(-61.8, 0.5, 0)
//         eulerRotation: Qt.vector3d(0, 90, 0)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "black"
//             }
//         ]
//     }

//     // 左ゴール端上
//     Model {
//         id: leftGoalTop
//         source: "#Cube"
//         scale: Qt.vector3d(0.018, 0.01, 0.002)
//         position: Qt.vector3d(-60.9, 0.5, -9.1)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "black"
//             }
//         ]
//     }

//     // 左ゴール端下
//     Model {
//         id: leftGoalBottom
//         source: "#Cube"
//         scale: Qt.vector3d(0.018, 0.01, 0.002)
//         position: Qt.vector3d(-60.9, 0.5, 9.1)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "black"
//             }
//         ]
//     }

//     // 中央線
//     Model {
//         id: centerLine
//         source: "#Rectangle"
//         scale: Qt.vector3d(0.001, 0.9, 0.1)
//         position: Qt.vector3d(0, 0.03, 0)
//         eulerRotation: Qt.vector3d(-90, 0, 0)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "white"
//             }
//         ]
//     }

//     // 横ライン
//     Model {
//         id: horizontalLine
//         source: "#Rectangle"
//         scale: Qt.vector3d(1.2, 0.001, 0.1)
//         position: Qt.vector3d(0, 0.03, 0)
//         eulerRotation: Qt.vector3d(-90, 0, 0)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "white"
//             }
//         ]
//     }

//     // フィールドの枠線
//     Model {
//         id: topEdge
//         source: "#Rectangle"
//         scale: Qt.vector3d(1.2, 0.001, 0.1)
//         position: Qt.vector3d(0, 0.01, -44.95)
//         eulerRotation: Qt.vector3d(-90, 0, 0)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "white"
//             }
//         ]
//     }
//     Model {
//         id: bottomEdge
//         source: "#Rectangle"
//         scale: Qt.vector3d(1.2, 0.001, 0.1)
//         position: Qt.vector3d(0, 0.01, 44.95)
//         eulerRotation: Qt.vector3d(-90, 0, 0)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "white"
//             }
//         ]
//     }
//     Model {
//         id: leftEdge
//         source: "#Rectangle"
//         scale: Qt.vector3d(0.001, 0.9, 0.1)
//         position: Qt.vector3d(-59.95, 0.01, 0)
//         eulerRotation: Qt.vector3d(-90, 0, 0)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "white"
//             }
//         ]
//     }
//     Model {
//         id: rightEdge
//         source: "#Rectangle"
//         scale: Qt.vector3d(0.001, 0.9, 0.1)
//         position: Qt.vector3d(59.95, 0.01, 0)
//         eulerRotation: Qt.vector3d(-90, 0, 0)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "white"
//             }
//         ]
//     }

//     // ペナルティエリアライン
//     Model {
//         id: leftPenaltyTop
//         source: "#Rectangle"
//         scale: Qt.vector3d(0.18, 0.001, 0.1)
//         position: Qt.vector3d(-50.95, 0.01, -18)
//         eulerRotation: Qt.vector3d(-90, 0, 0)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "white"
//             }
//         ]
//     }
//     Model {
//         id: rightPenaltyTop
//         source: "#Rectangle"
//         scale: Qt.vector3d(0.18, 0.001, 0.1)
//         position: Qt.vector3d(50.95, 0.01, -18)
//         eulerRotation: Qt.vector3d(-90, 0, 0)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "white"
//             }
//         ]
//     }
//     Model {
//         id: leftPenaltyBottom
//         source: "#Rectangle"
//         scale: Qt.vector3d(0.18, 0.001, 0.1)
//         position: Qt.vector3d(-50.95, 0.01, 18)
//         eulerRotation: Qt.vector3d(-90, 0, 0)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "white"
//             }
//         ]
//     }
//     Model {
//         id: rightPenaltyBottom
//         source: "#Rectangle"
//         scale: Qt.vector3d(0.18, 0.001, 0.1)
//         position: Qt.vector3d(50.95, 0.01, 18)
//         eulerRotation: Qt.vector3d(-90, 0, 0)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "white"
//             }
//         ]
//     }
//     Model {
//         id: leftPenaltyVertical
//         source: "#Rectangle"
//         scale: Qt.vector3d(0.001, 0.36, 0.1)
//         position: Qt.vector3d(-42, 0.01, 0)
//         eulerRotation: Qt.vector3d(-90, 0, 0)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "white"
//             }
//         ]
//     }
//     Model {
//         id: rightPenaltyVertical
//         source: "#Rectangle"
//         scale: Qt.vector3d(0.001, 0.36, 0.1)
//         position: Qt.vector3d(42, 0.01, 0)
//         eulerRotation: Qt.vector3d(-90, 0, 0)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "white"
//             }
//         ]
//     }

//     // Center Circle
//     Model {
//         id: centerWhiteCircle
//         source: "#Cylinder"
//         scale: Qt.vector3d(0.102, 0.0001, 0.102)
//         position: Qt.vector3d(0, 0.00001, 0)
//         materials: [
//             DefaultMaterial {
//                 diffuseColor: "white"
//             }
//         ]
//     }
//     Model {
//         id: centerGreenCircle
//         source: "#Cylinder"
//         scale: Qt.vector3d(0.1, 0.0001, 0.1)
//         position: Qt.vector3d(0, 0.02, 0)
//         materials: [ 
//             DefaultMaterial {
//                 diffuseMap: Texture {
//                     source: "../../assets/textures/field_texture.jpg" // 画像ファイルのパス
//                 }
//             }
//         ]
//     }
// }
