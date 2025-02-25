import QtQuick
import QtQuick3D
import MOC

import "../../assets/models/bot/"
import "../../assets/models/wheel/"

Node {
    id: robotNode

    property real wheel_radius: 8.15
    property real angle0: 0
    property real angle1: 0
    property real angle2: 0
    property real angle3: 0
    property real wheel_speed0: 1.0
    property real wheel_speed1: 1.0
    property real wheel_speed2: 1.0
    property real wheel_speed3: 1.0

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

    property var blue_bot_radians: new Array(16).fill(Math.PI/2.0)
    property var bbot_vel_normals: new Array(16).fill(0.0)
    property var bbot_vel_tangents: new Array(16).fill(0.0)
    property var bbot_vel_angulars: new Array(16).fill(0.0)
    property var bbot_vel_radians: new Array(16).fill(0.0)

    property var yellow_bot_radians: new Array(16).fill(-Math.PI/2.0)
    property var ybot_vel_normals: new Array(16).fill(0.0)
    property var ybot_vel_tangents: new Array(16).fill(0.0)
    property var ybot_vel_angulars: new Array(16).fill(0.0)
    property var ybot_vel_radians: new Array(16).fill(0.0)

    property real radian_offset: -Math.atan(35.0/54.772)

    Connections {
        target: observer
        function onBlueRobotsChanged() {
            for (var i = 0; i < observer.blue_robots.length; i++) {
                bbot_vel_normals[i] = observer.blue_robots[i].velnormal;
                bbot_vel_tangents[i] = -observer.blue_robots[i].veltangent;
                bbot_vel_angulars[i] = observer.blue_robots[i].velangular;
                
            }
        }
        function onYellowRobotsChanged() {
            for (var i = 0; i < observer.yellow_robots.length; i++) {
                ybot_vel_normals[i] = observer.yellow_robots[i].velnormal;
                ybot_vel_tangents[i] = -observer.yellow_robots[i].veltangent;
                ybot_vel_angulars[i] = observer.yellow_robots[i].velangular;
            }
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
                eulerRotation: Qt.vector3d(0, blue_bot_radians[index] * 180.0 / Math.PI, 0)
            }
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

            Repeater3D {
                model: 4

                delegate: Model {
                    source: "#Cylinder"
                    scale: Qt.vector3d(0.04, 0.001, 0.04)

                    position: {
                        var offsets = [
                            Qt.vector3d(6.5*Math.cos(Math.PI-radian_offset-blue_bot_radians[index]), 0, 6.5*Math.sin(Math.PI-radian_offset-blue_bot_radians[index])),  // Left Up
                            Qt.vector3d(6.5*Math.cos(Math.PI/2.0-radian_offset-blue_bot_radians[index]), 0, 6.5*Math.sin(Math.PI/2.0-radian_offset-blue_bot_radians[index])), // Left Down
                            Qt.vector3d(6.5*Math.cos(Math.PI/2.0+radian_offset-blue_bot_radians[index]), 0, 6.5*Math.sin(Math.PI/2.0+radian_offset-blue_bot_radians[index])), // Right Down
                            Qt.vector3d(6.5*Math.cos(radian_offset-blue_bot_radians[index]), 0, 6.5*Math.sin(radian_offset-blue_bot_radians[index]))   // Right Up
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
            Repeater3D {
                id: wheels
                model: 4
                property int botIndex: modelData

                Wheel {
                    id: wheel
                    property int wheelIndex: index
                    property var angles: [
                        Qt.vector3d(0, -125+blue_bot_radians[index]*180.0/Math.PI, angle0),
                        Qt.vector3d(0, -45+blue_bot_radians[index]*180.0/Math.PI, angle1),
                        Qt.vector3d(0,  45+blue_bot_radians[index]*180.0/Math.PI, angle2),
                        Qt.vector3d(0, 125+blue_bot_radians[index]*180.0/Math.PI, angle3),
                    ]
                    property var offsets: [
                        Qt.vector3d(wheel_radius * Math.cos((215 * Math.PI / 180.0)-blue_bot_radians[index]), 2.7, wheel_radius * Math.sin((215 * Math.PI / 180.0)-blue_bot_radians[index])),
                        Qt.vector3d(wheel_radius * Math.cos((135 * Math.PI / 180.0)-blue_bot_radians[index]), 2.7, wheel_radius * Math.sin((135 * Math.PI / 180.0)-blue_bot_radians[index])),
                        Qt.vector3d(wheel_radius * Math.cos((45 * Math.PI / 180.0)-blue_bot_radians[index]), 2.7, wheel_radius * Math.sin((45 * Math.PI / 180.0)-blue_bot_radians[index])),
                        Qt.vector3d(wheel_radius * Math.cos((-35 * Math.PI / 180.0)-blue_bot_radians[index]), 2.7, wheel_radius * Math.sin((-35 * Math.PI / 180.0)-blue_bot_radians[index])),
                        
                    ]
                    position: Qt.vector3d(
                        blue_bots[botIndex].x + offsets[wheelIndex].x,
                        blue_bots[botIndex].z + offsets[wheelIndex].y,
                        blue_bots[botIndex].y + offsets[wheelIndex].z
                    )
                    eulerRotation: angles[wheelIndex]
                }
            }
        }
    }
    Repeater3D {
        id: yellowBotsRepeater
        model: yellow_bots.length

        delegate: Node {
            property int botIndex: index
            Bot {
                id: bot
                position: Qt.vector3d(yellow_bots[index].x, 0.5, yellow_bots[index].y)
                eulerRotation: Qt.vector3d(0, yellow_bot_radians[index] * 180.0 / Math.PI, 0)
            }
            Model {
                source: "#Cylinder"
                scale: Qt.vector3d(0.05, 0.001, 0.05)
                position: Qt.vector3d(yellow_bots[botIndex].x, 12.8, yellow_bots[botIndex].y)
                materials: [
                    DefaultMaterial {
                        diffuseColor: "yellow"
                    }
                ]
            }

            Repeater3D {
                model: 4

                delegate: Model {
                    source: "#Cylinder"
                    scale: Qt.vector3d(0.04, 0.001, 0.04)

                    position: {
                        var offsets = [
                            Qt.vector3d(6.5*Math.cos(Math.PI-radian_offset-yellow_bot_radians[index]), 0, 6.5*Math.sin(Math.PI-radian_offset-yellow_bot_radians[index])),
                            Qt.vector3d(6.5*Math.cos(Math.PI/2.0-radian_offset-yellow_bot_radians[index]), 0, 6.5*Math.sin(Math.PI/2.0-radian_offset-yellow_bot_radians[index])),
                            Qt.vector3d(6.5*Math.cos(Math.PI/2.0+radian_offset-yellow_bot_radians[index]), 0, 6.5*Math.sin(Math.PI/2.0+radian_offset-yellow_bot_radians[index])),
                            Qt.vector3d(6.5*Math.cos(radian_offset-yellow_bot_radians[index]), 0, 6.5*Math.sin(radian_offset-yellow_bot_radians[index]))
                        ];
                        return Qt.vector3d(
                            yellow_bots[botIndex].x + offsets[index].x,
                            12.8,
                            yellow_bots[botIndex].y + offsets[index].z
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
            
            Repeater3D {
                id: wheelsYellow
                model: 4
                property int botIndex: modelData

                Wheel {
                    id: wheel
                    property int wheelIndex: index
                    property var angles: [
                        Qt.vector3d(0, -125+yellow_bot_radians[index]*180.0/Math.PI, angle0),
                        Qt.vector3d(0, -45+yellow_bot_radians[index]*180.0/Math.PI, angle1),
                        Qt.vector3d(0,  45+yellow_bot_radians[index]*180.0/Math.PI, angle2),
                        Qt.vector3d(0, 125+yellow_bot_radians[index]*180.0/Math.PI, angle3),
                    ]
                    property var offsets: [
                        Qt.vector3d(wheel_radius * Math.cos((215 * Math.PI / 180.0)-yellow_bot_radians[index]), 2.7, wheel_radius * Math.sin((215 * Math.PI / 180.0)-yellow_bot_radians[index])),
                        Qt.vector3d(wheel_radius * Math.cos((135 * Math.PI / 180.0)-yellow_bot_radians[index]), 2.7, wheel_radius * Math.sin((135 * Math.PI / 180.0)-yellow_bot_radians[index])),
                        Qt.vector3d(wheel_radius * Math.cos((45 * Math.PI / 180.0)-yellow_bot_radians[index]), 2.7, wheel_radius * Math.sin((45 * Math.PI / 180.0)-yellow_bot_radians[index])),
                        Qt.vector3d(wheel_radius * Math.cos((-35 * Math.PI / 180.0)-yellow_bot_radians[index]), 2.7, wheel_radius * Math.sin((-35 * Math.PI / 180.0)-yellow_bot_radians[index])),
                    ]
                    position: Qt.vector3d(
                        yellow_bots[botIndex].x + offsets[wheelIndex].x,
                        yellow_bots[botIndex].z + offsets[wheelIndex].y,
                        yellow_bots[botIndex].y + offsets[wheelIndex].z
                    )
                    eulerRotation: angles[wheelIndex]
                }
            }
        }
    }

    Timer {
        interval: 16
        running: true
        repeat: true
        onTriggered: {
            var updatedbBots = blue_bots.slice();
            var updatedyBots = yellow_bots.slice();
            var updatedbBotRadians = blue_bot_radians.slice();
            var updatedyBotRadians = yellow_bot_radians.slice();

            for (var i = 0; i < updatedbBots.length; i++) {
                bbot_vel_radians[i] += bbot_vel_angulars[i] * 0.016;
                if (bbot_vel_radians[i] > 2 * Math.PI) {
                    bbot_vel_radians[i] = 0;
                }
                updatedbBotRadians[i] = -90 + bbot_vel_radians[i];
                updatedbBots[i] = Qt.vector3d(
                    updatedbBots[i].x + bbot_vel_normals[i] * Math.cos(updatedbBotRadians[i]) + bbot_vel_tangents[i] * Math.sin(updatedbBotRadians[i]),
                    updatedbBots[i].y + bbot_vel_normals[i] * Math.sin(updatedbBotRadians[i]) + bbot_vel_tangents[i] * Math.cos(updatedbBotRadians[i]),
                    updatedbBots[i].z
                );
                
            }
            
            for (var i = 0; i < updatedyBots.length; i++) {
                ybot_vel_radians[i] += ybot_vel_angulars[i] * 0.016;
                if (ybot_vel_radians[i] > 2.0 * Math.PI) {
                    ybot_vel_radians[i] = 0.0;
                }
                updatedyBotRadians[i] = 90 + ybot_vel_radians[i];
                updatedyBots[i] = Qt.vector3d(
                    updatedyBots[i].x + ybot_vel_normals[i] * Math.cos(updatedyBotRadians[i]) + ybot_vel_tangents[i] * Math.sin(updatedyBotRadians[i]),
                    updatedyBots[i].y + ybot_vel_normals[i] * Math.sin(updatedyBotRadians[i]) + ybot_vel_tangents[i] * Math.cos(updatedyBotRadians[i]),
                    updatedyBots[i].z
                );
            }

            blue_bots = updatedbBots;
            yellow_bots = updatedyBots;
            blue_bot_radians = updatedbBotRadians;
            yellow_bot_radians = updatedyBotRadians;
        }
    }
}
