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
    property var botList: []

    Connections {
        target: robot
        function onUpdateChanged() {
            botList = robot.positions;
        }
    }

    Repeater3D {
        id: bots
        model: botList.length // 配列の長さを model に指定

        Bot {
            id: bot
            position: Qt.vector3d(botList[index].x, 0.5, botList[index].y)
            eulerRotation: Qt.vector3d(0, -90, 0)
        }
    }

    Component.onCompleted: {
        robot.updateInfo(); // 初期データを取得
    }
}