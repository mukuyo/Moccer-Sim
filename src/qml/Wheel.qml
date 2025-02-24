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
    //         wheel_speed0 = (2.0 * wheelNode.pi / robot.wheel_speed0) * 1000.0;
    //         wheel_speed1 = (2.0 * wheelNode.pi / robot.wheel_speed1) * 1000.0;
    //         wheel_speed2 = (2.0 * wheelNode.pi / robot.wheel_speed2) * 1000.0;
    //         wheel_speed3 = (2.0 * wheelNode.pi / robot.wheel_speed3) * 1000.0;
    //         botList = robot.positions;
    //     }
    // }

    Repeater3D {
        id: bots
        model: blue_bots.length

        Repeater3D {
            id: wheels
            model: 4
            property int botIndex: modelData

            Wheel {
                id: wheel
                property int wheelIndex: index    // 各ホイールのインデックス
                property var angles: [
                    Qt.vector3d(0, 145, wheelNode.angle0),
                    Qt.vector3d(0, -135, wheelNode.angle1),
                    Qt.vector3d(0, -45, wheelNode.angle2),
                    Qt.vector3d(0,  35, wheelNode.angle3),
                ]
                property var offsets: [
                    Qt.vector3d(wheelNode.wheel_radius * Math.cos(55 * wheelNode.pi / 180.0), 2.7, wheelNode.wheel_radius * Math.sin(-55 * wheelNode.pi / 180.0)),
                    Qt.vector3d(wheelNode.wheel_radius * Math.cos(135 * wheelNode.pi / 180.0), 2.7, wheelNode.wheel_radius * Math.sin(-135 * wheelNode.pi / 180.0)),
                    Qt.vector3d(wheelNode.wheel_radius * Math.cos(135 * wheelNode.pi / 180.0), 2.7, wheelNode.wheel_radius * Math.sin(135 * wheelNode.pi / 180.0)),
                    Qt.vector3d(wheelNode.wheel_radius * Math.cos(-55 * wheelNode.pi / 180.0), 2.7, wheelNode.wheel_radius * Math.sin(55 * wheelNode.pi / 180.0))
                    
                ]
                position: Qt.vector3d(
                    wheelNode.blue_bots[botIndex].x + offsets[wheelIndex].x,
                    wheelNode.blue_bots[botIndex].z + offsets[wheelIndex].y,
                    wheelNode.blue_bots[botIndex].y + offsets[wheelIndex].z
                )
                eulerRotation: angles[wheelIndex]
            }
        }
    }

    Repeater3D {
        id: ybots
        model: yellow_bots.length

        Repeater3D {
            id: ywheels
            model: 4
            property int botIndex: modelData

            Wheel {
                id: ywheel
                property int wheelIndex: index    // 各ホイールのインデックス
                property var angles: [
                    Qt.vector3d(0, 145 * -1.0, wheelNode.angle0),
                    Qt.vector3d(0, -135 * -1.0, wheelNode.angle1),
                    Qt.vector3d(0, -45 * -1.0, wheelNode.angle2),
                    Qt.vector3d(0,  35 * -1.0, wheelNode.angle3),
                ]
                property var offsets: [
                    Qt.vector3d(wheelNode.wheel_radius * Math.cos(55 * wheelNode.pi / 180.0), 2.7, wheelNode.wheel_radius * Math.sin(-55 * wheelNode.pi / 180.0)),
                    Qt.vector3d(wheelNode.wheel_radius * Math.cos(135 * wheelNode.pi / 180.0), 2.7, wheelNode.wheel_radius * Math.sin(-135 * wheelNode.pi / 180.0)),
                    Qt.vector3d(wheelNode.wheel_radius * Math.cos(135 * wheelNode.pi / 180.0), 2.7, wheelNode.wheel_radius * Math.sin(135 * wheelNode.pi / 180.0)),
                    Qt.vector3d(wheelNode.wheel_radius * Math.cos(-55 * wheelNode.pi / 180.0), 2.7, wheelNode.wheel_radius * Math.sin(55 * wheelNode.pi / 180.0))
                    
                ]
                position: Qt.vector3d(
                    wheelNode.yellow_bots[botIndex].x + offsets[wheelIndex].x * -1.0,
                    wheelNode.yellow_bots[botIndex].z + offsets[wheelIndex].y,
                    wheelNode.yellow_bots[botIndex].y + offsets[wheelIndex].z
                )
                eulerRotation: angles[wheelIndex]
            }
        }
    }
    SequentialAnimation on angle0 {
        loops: Animation.Infinite
        NumberAnimation {
            from: 0
            to: 360
            duration: wheel_speed0
            easing.type: Easing.Linear
        }
    }
    SequentialAnimation on angle1 {
        loops: Animation.Infinite
        NumberAnimation {
            from: 0
            to: 360
            duration: wheel_speed1
            easing.type: Easing.Linear
        }
    }
    SequentialAnimation on angle2 {
        loops: Animation.Infinite
        NumberAnimation {
            from: 0
            to: 360
            duration: wheel_speed2
            easing.type: Easing.Linear
        }
    }
    SequentialAnimation on angle3 {
        loops: Animation.Infinite
        NumberAnimation {
            from: 0
            to: 360
            duration: wheel_speed3
            easing.type: Easing.Linear
        }
    }
}