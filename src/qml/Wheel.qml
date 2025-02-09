import QtQuick
import QtQuick3D
import MOC

import "../../assets/models/wheel/"

Node {
    id: wheelNode
    property real wheel_radius: 8.15
    property real angle0: 0
    property real angle1: 0
    property real angle2: 0
    property real angle3: 0
    property real pi: 3.14159265358979323846
    property real wheel_speed0: 1.0
    property real wheel_speed1: 1.0
    property real wheel_speed2: 1.0
    property real wheel_speed3: 1.0
    property vector3d center: Qt.vector3d(0, 0, 0) // 円運動の中心
    property real radius: 10 // ロボット全体の円運動の半径
    property real theta: 0 // 円運動の角度
    property vector3d position: Qt.vector3d(0, 0, 0)



    Connections {
        target: robot
        function onWheelSpeedChanged() {
            wheel_speed0 = (2.0 * wheelNode.pi / robot.wheel_speed0) * 1000.0;
            wheel_speed1 = (2.0 * wheelNode.pi / robot.wheel_speed1) * 1000.0;
            wheel_speed2 = (2.0 * wheelNode.pi / robot.wheel_speed2) * 1000.0;
            wheel_speed3 = (2.0 * wheelNode.pi / robot.wheel_speed3) * 1000.0;
            position = Qt.vector3d(
                robot.position.x, // x座標
                0, // y座標（高さは一定）
                robot.position.y
            );
        }
    }

    // Timer {
    //     interval: 16  // 16msごとに更新 (約60FPS)
    //     running: true
    //     repeat: true
    //     onTriggered: robot.updateWheelSpeeds()
    // }

    property vector3d robotPosition: position

    // 各ホイールの定義
    Wheel {
        id: side0
        position: Qt.vector3d(
            wheelNode.robotPosition.x + wheel_radius * Math.cos(145 * wheelNode.pi / 180.0),
            wheelNode.robotPosition.y + 2.2,
            wheelNode.robotPosition.z + wheel_radius * Math.sin(-145 * wheelNode.pi / 180.0)
        )
        eulerRotation: Qt.vector3d(0, -125, wheelNode.angle0)
    }

    Wheel {
        id: side1
        position: Qt.vector3d(
            wheelNode.robotPosition.x + wheel_radius * Math.cos(135 * wheelNode.pi / 180.0),
            wheelNode.robotPosition.y + 2.2,
            wheelNode.robotPosition.z + wheel_radius * Math.sin(135 * wheelNode.pi / 180.0)
        )
        eulerRotation: Qt.vector3d(0, -45, wheelNode.angle1)
    }

    Wheel {
        id: side2
        position: Qt.vector3d(
            wheelNode.robotPosition.x + wheel_radius * Math.cos(-45 * wheelNode.pi / 180.0),
            wheelNode.robotPosition.y + 2.2,
            wheelNode.robotPosition.z + wheel_radius * Math.sin(45 * wheelNode.pi / 180.0)
        )
        eulerRotation: Qt.vector3d(0, 45, wheelNode.angle2)
    }

    Wheel {
        id: side3
        position: Qt.vector3d(
            wheelNode.robotPosition.x + wheel_radius * Math.cos(35 * wheelNode.pi / 180.0),
            wheelNode.robotPosition.y + 2.2,
            wheelNode.robotPosition.z + wheel_radius * Math.sin(-35 * wheelNode.pi / 180.0)
        )
        eulerRotation: Qt.vector3d(0, 125, wheelNode.angle3)
    }

    // // ホイールの回転アニメーション
    // SequentialAnimation on angle0 {
    //     loops: Animation.Infinite
    //     NumberAnimation {
    //         from: 0
    //         to: 360
    //         duration: wheel_speed0  // [ms]
    //         easing.type: Easing.Linear
    //     }
    // }
    // SequentialAnimation on angle1 {
    //     loops: Animation.Infinite
    //     NumberAnimation {
    //         from: 0
    //         to: 360
    //         duration: wheel_speed1  // [ms]
    //         easing.type: Easing.Linear
    //     }
    // }
    // SequentialAnimation on angle2 {
    //     loops: Animation.Infinite
    //     NumberAnimation {
    //         from: 0
    //         to: 360
    //         duration: wheel_speed2  // [ms]
    //         easing.type: Easing.Linear
    //     }
    // }
    // SequentialAnimation on angle3 {
    //     loops: Animation.Infinite
    //     NumberAnimation {
    //         from: 0
    //         to: 360
    //         duration: wheel_speed3  // [ms]
    //         easing.type: Easing.Linear
    //     }
    // }
}
