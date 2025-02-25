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

    property real vel_normal: 0.0
    property real vel_tangent: 0.0
    property real angle: 0.0

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

    Connections {
        target: observer
        function onRobotsChanged() {
            vel_normal = observer.robots[0].velnormal*3;
            vel_tangent = observer.robots[0].veltangent;
            // console.log("vel_normal: " + vel_normal);
            // var updatedBots = blue_bots.slice(); // 現在の配列をコピー
            // for (var i = 0; i < updatedBots.length; i++) {
            //     // angle += 0.01;
            //     // if (angle > 2 * Math.PI) {
            //     //     angle = 0;
            //     // }
            //     updatedBots[i] = Qt.vector3d(updatedBots[i].x + vel_normal, updatedBots[i].y + vel_tangent, updatedBots[i].z);
            // }
            // updatedBots[0] = Qt.vector3d(updatedBots[0].x + vel_normal, updatedBots[0].y, updatedBots[0].z);
            // blue_bots = updatedBots; // 配列を再代入して QML に変更を通知
        }
    }

    Timer {
        interval: 16 // 16msごとに実行 (約60FPS)
        running: true
        repeat: true
        onTriggered: {
            var updatedBots = blue_bots.slice(); // 配列をコピー
            for (var i = 0; i < updatedBots.length; i++) {
                angle += 0.01;
                if (angle > 2 * Math.PI) {
                    angle = 0;
                }
                // updatedBots[i] = Qt.vector3d(updatedBots[i].x + vel_normal, updatedBots[i].y + vel_tangent, updatedBots[i].z);
                updatedBots[i] = Qt.vector3d(updatedBots[i].x + vel_normal * Math.cos(angle), updatedBots[i].y + vel_normal * Math.sin(angle), updatedBots[i].z);
            }
            blue_bots = updatedBots; // 配列を再代入して QML に変更を通知
        }
    }

    Repeater3D {
        id: blueBotsRepeater
        model: blue_bots.length

        delegate: Node {
            property int botIndex: index 
            Bot {
                id: bot
                position: Qt.vector3d(blue_bots[index].x, 0.5, blue_bots[index].y)
                eulerRotation: Qt.vector3d(0, -90, 0)
            }

            // Center Circle
            Model {
                source: "#Cylinder"
                scale: Qt.vector3d(0.05, 0.001, 0.05)
                position: Qt.vector3d(blue_bots[botIndex].x, 12.8, blue_bots[botIndex].y)
                materials: [
                    DefaultMaterial {
                        diffuseColor: "blue"
                    }
                ]
            }

            // Four small circles around the bot
            Repeater3D {
                model: 4

                delegate: Model {
                    source: "#Cylinder"
                    scale: Qt.vector3d(0.04, 0.001, 0.04)

                    position: {
                        var offsets = [
                            Qt.vector3d(3.5, 0, -5.4772),  // Left Up
                            Qt.vector3d(-5.4772, 0, -3.5), // Left Down
                            Qt.vector3d(-5.4772, 0, 3.5),  // Right Down
                            Qt.vector3d(3.5, 0, 5.4772)   // Right Up
                        ];
                        return Qt.vector3d(
                            blue_bots[botIndex].x + offsets[index].x,
                            12.8,
                            blue_bots[botIndex].y + offsets[index].z
                        );
                    }

                    materials: [
                        DefaultMaterial {
                            diffuseColor: {
                                var colors = ["#EA3EF7", "#75FA4C", "#EA3EF7", "#75FA4C"];
                                return colors[index];
                            }
                        }
                    ]
                }
            }
        }
    }



    // Repeater3D {
    //     id: yLeftUpCircle
    //     model: yellow_bots.length
    //     Model {
    //         source: "#Cylinder"
    //         scale: Qt.vector3d(0.04, 0.001, 0.04)
    //         position: Qt.vector3d(yellow_bots[index].x + 3.5 * (-1), 12.8, yellow_bots[index].y - 5.4772 * (-1))
    //         materials: [
    //             DefaultMaterial {
    //                 diffuseColor: index === 0 ? "#EA3EF7" :
    //                               index === 1 ? "#75FA4C" :
    //                               index === 2 ? "#75FA4C" :
    //                               index === 3 ? "#EA3EF7" :
    //                               index === 4 ? "#EA3EF7" :
    //                               index === 5 ? "#75FA4C" :
    //                               index === 6 ? "#75FA4C" :
    //                               index === 7 ? "#EA3EF7" :
    //                               index === 8 ? "#75FA4C" :
    //                               index === 9 ? "#EA3EF7" :
    //                               index === 10 ? "#EA3EF7" : "#75FA4C"
    //             }
    //         ]
    //     }
    // }
    // Repeater3D {
    //     id: yLeftDownCircle
    //     model: yellow_bots.length
    //     Model {
    //         source: "#Cylinder"
    //         scale: Qt.vector3d(0.04, 0.001, 0.04)
    //         position: Qt.vector3d(yellow_bots[index].x - 5.4772 * (-1), 12.8, yellow_bots[index].y - 3.5 * (-1))
    //         materials: [
    //             DefaultMaterial {
    //                 diffuseColor: index === 0 ? "#75FA4C" :
    //                               index === 1 ? "#75FA4C" :
    //                               index === 2 ? "#75FA4C" :
    //                               index === 3 ? "#75FA4C" :
    //                               index === 4 ? "#EA3EF7" :
    //                               index === 5 ? "#EA3EF7" :
    //                               index === 6 ? "#EA3EF7" :
    //                               index === 7 ? "#EA3EF7" :
    //                               index === 8 ? "#75FA4C" :
    //                               index === 9 ? "#EA3EF7" :
    //                               index === 10 ? "#75FA4C" : "#EA3EF7"
    //             }
    //         ]
    //     }
    // }
    // Repeater3D {
    //     id: yRightDownCircle
    //     model: yellow_bots.length
    //     Model {
    //         source: "#Cylinder"
    //         scale: Qt.vector3d(0.04, 0.001, 0.04)
    //         position: Qt.vector3d(yellow_bots[index].x - 5.4772 * (-1), 12.8, yellow_bots[index].y + 3.5 * (-1))
    //         materials: [
    //             DefaultMaterial {
    //                 diffuseColor: index === 0 ? "#EA3EF7" :
    //                               index === 1 ? "#EA3EF7" :
    //                               index === 2 ? "#EA3EF7" :
    //                               index === 3 ? "#EA3EF7" :
    //                               index === 4 ? "#75FA4C" :
    //                               index === 5 ? "#75FA4C" :
    //                               index === 6 ? "#75FA4C" :
    //                               index === 7 ? "#75FA4C" :
    //                               index === 8 ? "#75FA4C" :
    //                               index === 9 ? "#EA3EF7" :
    //                               index === 10 ? "#75FA4C" : "#EA3EF7"
    //             }
    //         ]
    //     }
    // }
    // Repeater3D {
    //     id: yRightUpCircle
    //     model: yellow_bots.length
    //     Model {
    //         source: "#Cylinder"
    //         scale: Qt.vector3d(0.04, 0.001, 0.04)
    //         position: Qt.vector3d(yellow_bots[index].x + 3.5 * (-1), 12.8, yellow_bots[index].y + 5.4772 * (-1))
    //         materials: [
    //             DefaultMaterial {
    //                 diffuseColor: index === 0 ? "#EA3EF7" :
    //                               index === 1 ? "#EA3EF7" :
    //                               index === 2 ? "#75FA4C" :
    //                               index === 3 ? "#75FA4C" :
    //                               index === 4 ? "#EA3EF7" :
    //                               index === 5 ? "#EA3EF7" :
    //                               index === 6 ? "#75FA4C" :
    //                               index === 7 ? "#75FA4C" :
    //                               index === 8 ? "#75FA4C" :
    //                               index === 9 ? "#EA3EF7" :
    //                               index === 10 ? "#EA3EF7" : "#75FA4C"
    //             }
    //         ]
    //     }
    // }
    // Component.onCompleted: {
    //     robot.updateInfo(); // 初期データを取得
    // }
}