import QtQuick
import QtQuick3D
import MOC

import "../../assets/models/wheel/"

Node {
    id: wheelNode
    property real wheel_radius: 8.15 // ホイールの半径 (m)
    property real angle0: 0 // ホイールの回転角度 (度)
    property real angle1: 0 // ホイールの回転角度 (度)
    property real angle2: 0 // ホイールの回転角度 (度)
    property real angle3: 0 // ホイールの回転角度 (度)
    property real pi: 3.14159265358979323846
    property real wheel_speed0: 1000000
    property real wheel_speed1: 1000000
    property real wheel_speed2: 1000000
    property real wheel_speed3: 1000000

    Robot {
        id: robot
    }

    // Connectionsで位置の速度が更新された場合にアニメーションを更新
    Connections {
        target: robot
        function onWheelSpeedChanged() {
            wheel_speed0 = robot.wheel_speed0;
            wheel_speed1 = robot.wheel_speed1;
            wheel_speed2 = robot.wheel_speed2;
            wheel_speed3 = robot.wheel_speed3;
            // console.log("Wheel speeds updated", wheel_speed, robot.wheel_speed1, robot.wheel_speed2, robot.wheel_speed3);
        }
    }

    // 各ホイールの定義
    Wheel {
        id: side0
        position: Qt.vector3d(wheel_radius*Math.cos(145*wheelNode.pi/180.0), 2.2, wheel_radius*Math.sin(-145*wheelNode.pi/180.0))
        eulerRotation: Qt.vector3d(0, -125, wheelNode.angle0)
    }

    Wheel {
        id: side1
        position: Qt.vector3d(wheel_radius*Math.cos(135*wheelNode.pi/180.0), 2.2, wheel_radius*Math.sin(135*wheelNode.pi/180.0))
        eulerRotation: Qt.vector3d(0, -45, wheelNode.angle1)
    }

    Wheel {
        id: side2
        position: Qt.vector3d(wheel_radius*Math.cos(-45*wheelNode.pi/180.0), 2.2, wheel_radius*Math.sin(45*wheelNode.pi/180.0))
        eulerRotation: Qt.vector3d(0, 45, wheelNode.angle2)
    }

    Wheel {
        id: side3
        position: Qt.vector3d(wheel_radius*Math.cos(35*wheelNode.pi/180.0), 2.2, wheel_radius*Math.sin(-35*wheelNode.pi/180.0))
        eulerRotation: Qt.vector3d(0, 125, wheelNode.angle3)
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



// import QtQuick
// import QtQuick3D
// import MOC

// import "../../assets/models/wheel/"

// Node {
//     id: wheelNode
//     property real angle: 0
//     property real wheel_radius: 8.15
//     property real pi: 3.14159265358979323846
//     property real wheel_speed: 1.0

//     // Robot {
//     //     id: robot
//     // }
//     Connections {
//         target: robot
//         function onWheelSpeedChanged() {
//             wheel_speed = robot.wheelSpeed
//             console.log("wheel_speed: " + wheel_speed)
//         }
        
//     }
    
//     Wheel {
//         id: side0
//         position: Qt.vector3d(wheel_radius*Math.cos(145*wheelNode.pi/180.0), 2.2, wheel_radius*Math.sin(-145*wheelNode.pi/180.0))
//         eulerRotation: Qt.vector3d(0, -125, wheelNode.angle)
//     }
//     Wheel {
//         id: side1
//         position: Qt.vector3d(wheel_radius*Math.cos(135*wheelNode.pi/180.0), 2.2, wheel_radius*Math.sin(135*wheelNode.pi/180.0))
//         eulerRotation: Qt.vector3d(0, -45, wheelNode.angle)
//     }
//     Wheel {
//         id: side2
//         position: Qt.vector3d(wheel_radius*Math.cos(-45*wheelNode.pi/180.0), 2.2, wheel_radius*Math.sin(45*wheelNode.pi/180.0))
//         eulerRotation: Qt.vector3d(0, 45, wheelNode.angle)
//     }
//     Wheel {
//         id: side3
//         position: Qt.vector3d(wheel_radius*Math.cos(35*wheelNode.pi/180.0), 2.2, wheel_radius*Math.sin(-35*wheelNode.pi/180.0))
//         eulerRotation: Qt.vector3d(0, 125, wheelNode.angle)
//     }

//     // Animation for rotating on the Y-axis
//     SequentialAnimation on angle {
//         loops: Animation.Infinite
//         NumberAnimation {
//             from: 0
//             to: 360
//             duration: wheel_speed 
//             easing.type: Easing.InOutQuad
//         }
//     }
// }