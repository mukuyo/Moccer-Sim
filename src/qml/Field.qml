import QtQuick
import QtQuick3D

Node {
    id: rootEntity

    // フィールド
    Model {
        id: fieldEntity
        source: "#Rectangle"
        // scale: Qt.vector3d(16.6, 15.6, 1)
        scale: Qt.vector3d(1, 1, 1)
        materials: [ 
            DefaultMaterial {
                diffuseColor: "red"
            }
        ]
    }

    // // 上壁
    // Model {
    //     id: topWall
    //     source: "#Cube"
    //     scale: Qt.vector3d(12.6, 0.1, 0.02)
    //     position: Qt.vector3d(0, 0.05, -4.8)
    //     materials: [
    //         DefaultMaterial {
    //             diffuseColor: "black"
    //         }
    //     ]
    // }

    // // 下壁
    // Model {
    //     id: bottomWall
    //     source: "#Cube"
    //     scale: Qt.vector3d(12.6, 0.1, 0.02)
    //     position: Qt.vector3d(0, 0.05, 4.8)
    //     materials: [
    //         DefaultMaterial {
    //             diffuseColor: "black"
    //         }
    //     ]
    // }

    // // 左壁
    // Model {
    //     id: leftWall
    //     source: "#Cube"
    //     scale: Qt.vector3d(9.6, 0.1, 0.02)
    //     position: Qt.vector3d(-6.3, 0.05, 0)
    //     eulerRotation: Qt.vector3d(0, 90, 0)
    //     materials: [
    //         DefaultMaterial {
    //             diffuseColor: "black"
    //         }
    //     ]
    // }

    // // 右壁
    // Model {
    //     id: rightWall
    //     source: "#Cube"
    //     scale: Qt.vector3d(9.6, 0.1, 0.02)
    //     position: Qt.vector3d(6.3, 0.05, 0)
    //     eulerRotation: Qt.vector3d(0, -90, 0)
    //     materials: [
    //         DefaultMaterial {
    //             diffuseColor: "black"
    //         }
    //     ]
    // }

    // // 右ゴール
    // Model {
    //     id: rightGoal
    //     source: "#Cube"
    //     scale: Qt.vector3d(1.84, 0.1, 0.02)
    //     position: Qt.vector3d(6.18, 0.05, 0)
    //     eulerRotation: Qt.vector3d(0, 90, 0)
    //     materials: [
    //         DefaultMaterial {
    //             diffuseColor: "black"
    //         }
    //     ]
    // }

    // // 右ゴール端上
    // Model {
    //     id: rightGoalTop
    //     source: "#Cube"
    //     scale: Qt.vector3d(0.18, 0.1, 0.02)
    //     position: Qt.vector3d(6.09, 0.05, -0.91)
    //     materials: [
    //         DefaultMaterial {
    //             diffuseColor: "black"
    //         }
    //     ]
    // }

    // // 右ゴール端下
    // Model {
    //     id: rightGoalBottom
    //     source: "#Cube"
    //     scale: Qt.vector3d(0.18, 0.1, 0.02)
    //     position: Qt.vector3d(6.09, 0.05, 0.91)
    //     materials: [
    //         DefaultMaterial {
    //             diffuseColor: "black"
    //         }
    //     ]
    // }

    // // 左ゴール
    // Model {
    //     id: leftGoal
    //     source: "#Cube"
    //     scale: Qt.vector3d(1.84, 0.1, 0.02)
    //     position: Qt.vector3d(-6.18, 0.05, 0)
    //     eulerRotation: Qt.vector3d(0, 90, 0)
    //     materials: [
    //         DefaultMaterial {
    //             diffuseColor: "black"
    //         }
    //     ]
    // }

    // // 左ゴール端上
    // Model {
    //     id: leftGoalTop
    //     source: "#Cube"
    //     scale: Qt.vector3d(0.18, 0.1, 0.02)
    //     position: Qt.vector3d(-6.09, 0.05, -0.91)
    //     materials: [
    //         DefaultMaterial {
    //             diffuseColor: "black"
    //         }
    //     ]
    // }

    // // 左ゴール端下
    // Model {
    //     id: leftGoalBottom
    //     source: "#Cube"
    //     scale: Qt.vector3d(0.18, 0.1, 0.02)
    //     position: Qt.vector3d(-6.09, 0.05, 0.91)
    //     materials: [
    //         DefaultMaterial {
    //             diffuseColor: "black"
    //         }
    //     ]
    // }
}

