import QtQuick
import QtQuick3D

Node {
    id: rootEntity

    // フィールド
    Model {
        id: fieldEntity
        source: "#Rectangle"
        scale: Qt.vector3d(13.4, 10.4, 1)
        eulerRotation: Qt.vector3d(-90, 0, 0)
        materials: [ 
            DefaultMaterial {
                diffuseColor: "green"
            }
        ]
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
}

