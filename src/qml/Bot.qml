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
        model: blue_bots.length

        Bot {
            id: bot
            position: Qt.vector3d(blue_bots[index].x, 0.5, blue_bots[index].y)
            eulerRotation: Qt.vector3d(0, -90, 0)
        }
    }
    Repeater3D {
        id: bCircle
        model: blue_bots.length
        Model {
            source: "#Cylinder"
            scale: Qt.vector3d(0.05, 0.001, 0.05)
            position: Qt.vector3d(blue_bots[index].x, 12.8, blue_bots[index].y)
            materials: [
                DefaultMaterial {
                    diffuseColor: "blue"
                }
            ]
        }
    }
    Repeater3D {
        id: ybots
        model: yellow_bots.length

        Bot {
            id: bot
            position: Qt.vector3d(yellow_bots[index].x, 0.5, yellow_bots[index].y)
            eulerRotation: Qt.vector3d(0, 90, 0)
        }
    }
    Repeater3D {
        id: yCircle
        model: yellow_bots.length
        Model {
            source: "#Cylinder"
            scale: Qt.vector3d(0.05, 0.001, 0.05)
            position: Qt.vector3d(yellow_bots[index].x, 12.8, yellow_bots[index].y)
            materials: [
                DefaultMaterial {
                    diffuseColor: "yellow"
                }
            ]
        }
    }

    Repeater3D {
        id: leftUpCircle
        model: blue_bots.length
        Model {
            source: "#Cylinder"
            scale: Qt.vector3d(0.04, 0.001, 0.04)
            position: Qt.vector3d(blue_bots[index].x + 3.5, 12.8, blue_bots[index].y - 5.4772)
            materials: [
                DefaultMaterial {
                    diffuseColor: index === 0 ? "#EA3EF7" :
                                  index === 1 ? "#75FA4C" :
                                  index === 2 ? "#75FA4C" :
                                  index === 3 ? "#EA3EF7" :
                                  index === 4 ? "#EA3EF7" :
                                  index === 5 ? "#75FA4C" :
                                  index === 6 ? "#75FA4C" :
                                  index === 7 ? "#EA3EF7" :
                                  index === 8 ? "#75FA4C" :
                                  index === 9 ? "#EA3EF7" :
                                  index === 10 ? "#EA3EF7" : "#75FA4C"
                }
            ]
        }
    }
    Repeater3D {
        id: leftDownCircle
        model: blue_bots.length
        Model {
            source: "#Cylinder"
            scale: Qt.vector3d(0.04, 0.001, 0.04)
            position: Qt.vector3d(blue_bots[index].x - 5.4772, 12.8, blue_bots[index].y - 3.5)
            materials: [
                DefaultMaterial {
                    diffuseColor: index === 0 ? "#75FA4C" :
                                  index === 1 ? "#75FA4C" :
                                  index === 2 ? "#75FA4C" :
                                  index === 3 ? "#75FA4C" :
                                  index === 4 ? "#EA3EF7" :
                                  index === 5 ? "#EA3EF7" :
                                  index === 6 ? "#EA3EF7" :
                                  index === 7 ? "#EA3EF7" :
                                  index === 8 ? "#75FA4C" :
                                  index === 9 ? "#EA3EF7" :
                                  index === 10 ? "#75FA4C" : "#EA3EF7"
                }
            ]
        }
    }
    Repeater3D {
        id: rightDownCircle
        model: blue_bots.length
        Model {
            source: "#Cylinder"
            scale: Qt.vector3d(0.04, 0.001, 0.04)
            position: Qt.vector3d(blue_bots[index].x - 5.4772, 12.8, blue_bots[index].y + 3.5)
            materials: [
                DefaultMaterial {
                    diffuseColor: index === 0 ? "#EA3EF7" :
                                  index === 1 ? "#EA3EF7" :
                                  index === 2 ? "#EA3EF7" :
                                  index === 3 ? "#EA3EF7" :
                                  index === 4 ? "#75FA4C" :
                                  index === 5 ? "#75FA4C" :
                                  index === 6 ? "#75FA4C" :
                                  index === 7 ? "#75FA4C" :
                                  index === 8 ? "#75FA4C" :
                                  index === 9 ? "#EA3EF7" :
                                  index === 10 ? "#75FA4C" : "#EA3EF7"
                }
            ]
        }
    }
    Repeater3D {
        id: rightUpCircle
        model: blue_bots.length
        Model {
            source: "#Cylinder"
            scale: Qt.vector3d(0.04, 0.001, 0.04)
            position: Qt.vector3d(blue_bots[index].x + 3.5, 12.8, blue_bots[index].y + 5.4772)
            materials: [
                DefaultMaterial {
                    diffuseColor: index === 0 ? "#EA3EF7" :
                                  index === 1 ? "#EA3EF7" :
                                  index === 2 ? "#75FA4C" :
                                  index === 3 ? "#75FA4C" :
                                  index === 4 ? "#EA3EF7" :
                                  index === 5 ? "#EA3EF7" :
                                  index === 6 ? "#75FA4C" :
                                  index === 7 ? "#75FA4C" :
                                  index === 8 ? "#75FA4C" :
                                  index === 9 ? "#EA3EF7" :
                                  index === 10 ? "#EA3EF7" : "#75FA4C"
                }
            ]
        }
    }

    Repeater3D {
        id: yLeftUpCircle
        model: yellow_bots.length
        Model {
            source: "#Cylinder"
            scale: Qt.vector3d(0.04, 0.001, 0.04)
            position: Qt.vector3d(yellow_bots[index].x + 3.5 * (-1), 12.8, yellow_bots[index].y - 5.4772 * (-1))
            materials: [
                DefaultMaterial {
                    diffuseColor: index === 0 ? "#EA3EF7" :
                                  index === 1 ? "#75FA4C" :
                                  index === 2 ? "#75FA4C" :
                                  index === 3 ? "#EA3EF7" :
                                  index === 4 ? "#EA3EF7" :
                                  index === 5 ? "#75FA4C" :
                                  index === 6 ? "#75FA4C" :
                                  index === 7 ? "#EA3EF7" :
                                  index === 8 ? "#75FA4C" :
                                  index === 9 ? "#EA3EF7" :
                                  index === 10 ? "#EA3EF7" : "#75FA4C"
                }
            ]
        }
    }
    Repeater3D {
        id: yLeftDownCircle
        model: yellow_bots.length
        Model {
            source: "#Cylinder"
            scale: Qt.vector3d(0.04, 0.001, 0.04)
            position: Qt.vector3d(yellow_bots[index].x - 5.4772 * (-1), 12.8, yellow_bots[index].y - 3.5 * (-1))
            materials: [
                DefaultMaterial {
                    diffuseColor: index === 0 ? "#75FA4C" :
                                  index === 1 ? "#75FA4C" :
                                  index === 2 ? "#75FA4C" :
                                  index === 3 ? "#75FA4C" :
                                  index === 4 ? "#EA3EF7" :
                                  index === 5 ? "#EA3EF7" :
                                  index === 6 ? "#EA3EF7" :
                                  index === 7 ? "#EA3EF7" :
                                  index === 8 ? "#75FA4C" :
                                  index === 9 ? "#EA3EF7" :
                                  index === 10 ? "#75FA4C" : "#EA3EF7"
                }
            ]
        }
    }
    Repeater3D {
        id: yRightDownCircle
        model: yellow_bots.length
        Model {
            source: "#Cylinder"
            scale: Qt.vector3d(0.04, 0.001, 0.04)
            position: Qt.vector3d(yellow_bots[index].x - 5.4772 * (-1), 12.8, yellow_bots[index].y + 3.5 * (-1))
            materials: [
                DefaultMaterial {
                    diffuseColor: index === 0 ? "#EA3EF7" :
                                  index === 1 ? "#EA3EF7" :
                                  index === 2 ? "#EA3EF7" :
                                  index === 3 ? "#EA3EF7" :
                                  index === 4 ? "#75FA4C" :
                                  index === 5 ? "#75FA4C" :
                                  index === 6 ? "#75FA4C" :
                                  index === 7 ? "#75FA4C" :
                                  index === 8 ? "#75FA4C" :
                                  index === 9 ? "#EA3EF7" :
                                  index === 10 ? "#75FA4C" : "#EA3EF7"
                }
            ]
        }
    }
    Repeater3D {
        id: yRightUpCircle
        model: yellow_bots.length
        Model {
            source: "#Cylinder"
            scale: Qt.vector3d(0.04, 0.001, 0.04)
            position: Qt.vector3d(yellow_bots[index].x + 3.5 * (-1), 12.8, yellow_bots[index].y + 5.4772 * (-1))
            materials: [
                DefaultMaterial {
                    diffuseColor: index === 0 ? "#EA3EF7" :
                                  index === 1 ? "#EA3EF7" :
                                  index === 2 ? "#75FA4C" :
                                  index === 3 ? "#75FA4C" :
                                  index === 4 ? "#EA3EF7" :
                                  index === 5 ? "#EA3EF7" :
                                  index === 6 ? "#75FA4C" :
                                  index === 7 ? "#75FA4C" :
                                  index === 8 ? "#75FA4C" :
                                  index === 9 ? "#EA3EF7" :
                                  index === 10 ? "#EA3EF7" : "#75FA4C"
                }
            ]
        }
    }
    // Component.onCompleted: {
    //     robot.updateInfo(); // 初期データを取得
    // }
}