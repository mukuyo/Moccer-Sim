import QtQuick
import QtQuick3D
import MOC

import "../../assets/models/bot/"

Node {
    id: robotNode

    property real radius: 10 // 円の半径 (m)
    property real speed: 10 // ロボットの速度 (m/s)
    property real angularSpeed: speed / radius // 角速度 (rad/s)
    property real theta: 0 // 現在の角度 (ラジアン)
    property vector3d _position: Qt.vector3d(0, 0, 0)

    property var blue_bots: [
        Qt.vector3d(-50, 0, 0),
        Qt.vector3d(-75, 300, 0),
        Qt.vector3d(-75, -300, 0),
        Qt.vector3d(-200, 150, 0),
        Qt.vector3d(-200, -150, 0),
        Qt.vector3d(-350, 0, 0),
        Qt.vector3d(-350, 400, 0),
        Qt.vector3d(-350, -400, 0),
        Qt.vector3d(-500, 300, 0),
        Qt.vector3d(-500, -300, 0),
        Qt.vector3d(-600, 0, 0),
    ]

    property var yellow_bots: [
        Qt.vector3d(50, 0, 0),
        Qt.vector3d(75, 300, 0),
        Qt.vector3d(75, -300, 0),
        Qt.vector3d(200, 150, 0),
        Qt.vector3d(200, -150, 0),
        Qt.vector3d(350, 0, 0),
        Qt.vector3d(350, 400, 0),
        Qt.vector3d(350, -400, 0),
        Qt.vector3d(500, 300, 0),
        Qt.vector3d(500, -300, 0),
        Qt.vector3d(600, 0, 0),
    ]

    // Connections {
    //     target: robot
    //     function onUpdateChanged() {
    //         blue_bots = robot.positions;
    //     }
    // }

    Repeater3D {
        id: bbots
        model: blue_bots.length // 配列の長さを model に指定

        Bot {
            id: bot
            position: Qt.vector3d(blue_bots[index].x, 0.5, blue_bots[index].y)
            eulerRotation: Qt.vector3d(0, -90, 0)
        }
    }

    Repeater3D {
        id: ybots
        model: yellow_bots.length // 配列の長さを model に指定

        Bot {
            id: bot
            position: Qt.vector3d(yellow_bots[index].x, 0.5, yellow_bots[index].y)
            eulerRotation: Qt.vector3d(0, 90, 0)
        }
    }
    // Component.onCompleted: {
    //     robot.updateInfo(); // 初期データを取得
    // }
}