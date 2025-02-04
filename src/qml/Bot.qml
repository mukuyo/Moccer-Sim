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

    Robot {
        id: robot
    }

    Connections {
        target: robot
        function onWheelSpeedChanged() {
            _position = Qt.vector3d(
                robot.position.x, // x座標
                0, // y座標（高さは一定）
                robot.position.y
            );
        }
    }

    Bot {
        id: bot
        position: Qt.vector3d(_position.x, _position.y, _position.z)
    }

    // // アニメーションで円運動
    // SequentialAnimation {
    //     loops: Animation.Infinite // 無限ループ
    //     running: true // アニメーション開始
    //     NumberAnimation {
    //         target: robotNode
    //         property: "theta" // 角度を管理
    //         from: 0
    //         to: 2 * Math.PI // 1周（360度 = 2πラジアン）
    //         duration: 5000 // 1周の所要時間
    //         easing.type: Easing.Linear // 一定速度で動く
    //     }
    // }

    // thetaが変化するたびにロボットの位置を更新

}
