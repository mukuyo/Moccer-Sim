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
    property vector3d center: Qt.vector3d(0, 0, 0)
    property real radius: 10
    property real theta: 0
    property var botList: []

    Connections {
        target: robot
        function onUpdateChanged() {
            wheel_speed0 = robot.wheel_speed0;
            wheel_speed1 = robot.wheel_speed1;
            wheel_speed2 = robot.wheel_speed2;
            wheel_speed3 = robot.wheel_speed3;
            botList = robot.positions;
        }
    }

    Repeater3D {
        id: bots
        model: botList.length

        Repeater3D {
            id: wheels
            model: 4
            property int botIndex: modelData

            Wheel {
                id: wheel
                property int wheelIndex: index    // 各ホイールのインデックス
                property var angles: [
                    Qt.vector3d(235, -90, wheelNode.angle0),
                    Qt.vector3d(305, -90, wheelNode.angle1),
                    Qt.vector3d(45, -90, wheelNode.angle2),
                    Qt.vector3d(125,  -90, wheelNode.angle3)
                ]
                property var offsets: [
                    Qt.vector3d(wheelNode.wheel_radius * Math.sin(35 * wheelNode.pi / 180.0), wheelNode.wheel_radius * Math.cos(35 * wheelNode.pi / 180.0), 2.7),
                    Qt.vector3d(wheelNode.wheel_radius * Math.sin(-45 * wheelNode.pi / 180.0), wheelNode.wheel_radius * Math.cos(-45 * wheelNode.pi / 180.0), 2.7),
                    Qt.vector3d(wheelNode.wheel_radius * Math.sin(-135 * wheelNode.pi / 180.0), wheelNode.wheel_radius * Math.cos(135 * wheelNode.pi / 180.0), 2.7),
                    Qt.vector3d(wheelNode.wheel_radius * Math.sin(145 * wheelNode.pi / 180.0), wheelNode.wheel_radius * Math.cos(145 * wheelNode.pi / 180.0), 2.7)
                ]
                position: Qt.vector3d(
                    wheelNode.botList[botIndex].x + offsets[wheelIndex].x,
                    wheelNode.botList[botIndex].y + offsets[wheelIndex].y,
                    wheelNode.botList[botIndex].z + offsets[wheelIndex].z
                )
                eulerRotation: angles[wheelIndex]
            }
        }
    }

    Timer {
        interval: 16  // Approximately 60 FPS
        running: true
        repeat: true
        onTriggered: {
            angle0 += 0;
            angle1 += 0;
            angle2 += 0;
            angle3 += 0;
        }
    }
    Component.onCompleted: {
        robot.updateInfo(); // 初期データを取得
    }
}
