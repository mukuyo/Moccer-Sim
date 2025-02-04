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

    Robot {
        id: robot
    }

    Connections {
        target: robot
        function onWheelSpeedChanged() {
            // _position = Qt.vector3d(
            //     robot.position.x, // x座標
            //     0, // y座標（高さは一定）
            //     robot.position.y
            // );
            botList = robot.positions;
        }
    }

    Repeater3D {
        // model: bot
        id: bots
        Bot {
            id: bot
            position: botList[index]
        }
    }
    Component.onCompleted: {
        robot.updateWheelSpeeds(); // 初期データを取得
    }
}
