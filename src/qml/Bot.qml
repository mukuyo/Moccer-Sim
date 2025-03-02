import QtQuick
import QtQuick3D
import QtQuick3D.Physics
import MOC

import "../../assets/models/frame/"
import "../../assets/models/bot/"
import "../../assets/models/wheel/"
import "../../assets/models/ball/"


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

    property var blue_bots_pos: [
        Qt.vector3d(-50, 0, 0),
        // Qt.vector3d(-75, 0, 300),
        // Qt.vector3d(-75, 0, -300),
        // Qt.vector3d(-200, 0, 150),
        // Qt.vector3d(-200, 0, -150),
        // Qt.vector3d(-350, 0, 0),
        // Qt.vector3d(-350, 0, 400),
        // Qt.vector3d(-350, 0, -400),
        // Qt.vector3d(-500, 0, 300),
        // Qt.vector3d(-500, 0, -300),
        // Qt.vector3d(-600, 0, 0),
    ]

    property var yellow_bots_pos: [
        Qt.vector3d(50, 0, 0),
        // Qt.vector3d(75, 0, 300),
        // Qt.vector3d(75, 0, -300),
        // Qt.vector3d(200, 0, 150),
        // Qt.vector3d(200, 0, -150),
        // Qt.vector3d(350, 0, 0),
        // Qt.vector3d(350, 0, 400),
        // Qt.vector3d(350, 0, -400),
        // Qt.vector3d(500, 0, 300),
        // Qt.vector3d(500, 0, -300),
        // Qt.vector3d(600, 0, 0),
    ]

    property var blue_bot_radians: new Array(16).fill(0)
    property var bbot_vel_normals: new Array(16).fill(0.0)
    property var bbot_vel_tangents: new Array(16).fill(0.0)
    property var bbot_vel_angulars: new Array(16).fill(0.0)
    property var bbot_vel_radians: new Array(16).fill(0.0)

    property var yellow_bot_radians: new Array(16).fill(0)
    property var ybot_vel_normals: new Array(16).fill(0.0)
    property var ybot_vel_tangents: new Array(16).fill(0.0)
    property var ybot_vel_angulars: new Array(16).fill(0.0)
    property var ybot_vel_radians: new Array(16).fill(0.0)

    property real radian_offset: -Math.atan(35.0/54.772)

    property var previousPos : Qt.vector3d(0, 0, 0)
    property var currentPos : Qt.vector3d(0, 0, 0)
    property real lastUpdateTime: Date.now()
    Connections {
        target: observer
        function onBlueRobotsChanged() {
            for (var i = 0; i < observer.blue_robots.length; i++) {
                if (Math.abs(observer.blue_robots[i].velnormal) < 4.0)
                    bbot_vel_normals[i] = observer.blue_robots[i].velnormal;
                if (Math.abs(observer.blue_robots[i].veltangent) < 4.0)
                    bbot_vel_tangents[i] = -observer.blue_robots[i].veltangent;
                bbot_vel_angulars[i] = observer.blue_robots[i].velangular;
            }
        }
        function onYellowRobotsChanged() {
            for (var i = 0; i < observer.yellow_robots.length; i++) {
                if (Math.abs(observer.yellow_robots[i].velnormal) < 4.0)
                    ybot_vel_normals[i] = observer.yellow_robots[i].velnormal;
                if (Math.abs(observer.yellow_robots[i].veltangent) < 4.0)
                    ybot_vel_tangents[i] = -observer.yellow_robots[i].veltangent;
                ybot_vel_angulars[i] = observer.yellow_robots[i].velangular;
            }
        }
    }

    PhysicsMaterial {
        id: physicsMaterial
        staticFriction: 0
        dynamicFriction: 0
        restitution:0
    }

    Repeater3D {
        id: frame_blue_bots
        model: blue_bots_pos.length
        DynamicRigidBody {
            // gravityEnabled: false
            physicsMaterial: physicsMaterial
            position: Qt.vector3d(blue_bots_pos[index].x, 0, blue_bots_pos[index].z)
            eulerRotation: Qt.vector3d(0, -90, 0)
            collisionShapes: [
                ConvexMeshShape {
                    source: "../../assets/models/plane/meshes/plane_mesh.cooked.cvx"
                },
                ConvexMeshShape {
                    source: "../../assets/models/frame/meshes/frame_mesh.cooked.cvx"
                }
            ]
        }
    }
    Repeater3D {
        id: frame_yellow_bots
        model: yellow_bots_pos.length
        DynamicRigidBody {
            gravityEnabled: true
            physicsMaterial: physicsMaterial
            eulerRotation: Qt.vector3d(0, 90, 0)
            position: Qt.vector3d(yellow_bots_pos[index].x, 0.5, yellow_bots_pos[index].z)
            collisionShapes: [
                ConvexMeshShape {
                    source: "../../assets/models/plane/meshes/plane_mesh.cooked.cvx"
                },
                ConvexMeshShape {
                    source: "../../assets/models/frame/meshes/frame_mesh.cooked.cvx"
                }
            ]
        }
    }

    Repeater3D {
        id: blueBotsRepeater
        model: blue_bots_pos.length
        delegate: Node {
            property int botIndex: index
            Bot {
            }
            Model {
                source: "#Cylinder"
                scale: Qt.vector3d(0.05, 0.001, 0.05)
                position: Qt.vector3d(0, 12.3, 0)
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
                            offsets[index].x,
                            12.3,
                            offsets[index].z
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
                        offsets[wheelIndex].x,
                        offsets[wheelIndex].y,
                        offsets[wheelIndex].z
                    )
                    eulerRotation: angles[wheelIndex]
                }
            }
        }
    }

    Repeater3D {
        id: yellowBotsRepeater
        model: yellow_bots_pos.length
        delegate: Node {
            property int botIndex: index
            Bot {
            }
            Model {
                source: "#Cylinder"
                scale: Qt.vector3d(0.05, 0.001, 0.05)
                position: Qt.vector3d(0, 12.3, 0)
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
                            offsets[index].x,
                            12.3,
                            offsets[index].z
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
                        offsets[wheelIndex].x,
                        offsets[wheelIndex].y,
                        offsets[wheelIndex].z
                    )
                    eulerRotation: angles[wheelIndex]
                }
            }
        }
    }

    DynamicRigidBody {
        id: ball
        position: Qt.vector3d(0, 0, 0)
        gravityEnabled: true
        collisionShapes: ConvexMeshShape {
            id: sphereShape
            source: "../../assets/models/ball/meshes/icosphere_mesh.cooked.cvx"
        }
        Ball {
        }
    }

        Keys.onPressed: (event) => {
            event.accepted = true;  // ⚡ 他の要素にイベントを渡さない
            if (event.key === Qt.Key_W) {
                _bot.velocity.z -= _bot.acceleration;
            } else if (event.key === Qt.Key_S) {
                _bot.velocity.z += _bot.acceleration;
            } else if (event.key === Qt.Key_A) {
                _bot.velocity.x -= _bot.acceleration;
            } else if (event.key === Qt.Key_D) {
                _bot.velocity.x += _bot.acceleration;
            }
        }

    Timer {
        interval: 16
        running: true
        repeat: true
        onTriggered: {
            let blueBotPositions = []
            let blueBotRotations = []
            for (let i = 0; i < frame_blue_bots.count; i++) {
                let frame = frame_blue_bots.children[i];
                let bot = blueBotsRepeater.children[i];

                frame.setLinearVelocity(Qt.vector3d(-bbot_vel_tangents[i]*60.0, 0, -bbot_vel_normals[i]*60.0));
                frame.setAngularVelocity(Qt.vector3d(0, bbot_vel_angulars[i], 0));
                bot.position = Qt.vector3d(frame.position.x, frame.position.y, frame.position.z);
                bot.eulerRotation = Qt.vector3d(frame.eulerRotation.x, frame.eulerRotation.y, frame.eulerRotation.z);
                blueBotPositions.push(Qt.vector3d(frame.position.x, -frame.position.z, frame.eulerRotation.y+90));
            }
            let yellowBotPositions = []
            let yellowBotRotations = []
            for (let i = 0; i < frame_yellow_bots.count; i++) {
                let frame = frame_yellow_bots.children[i];
                let bot = yellowBotsRepeater.children[i];
                frame.setLinearVelocity(Qt.vector3d(-ybot_vel_tangents[i]*60, 0, -ybot_vel_normals[i]*60));
                frame.setAngularVelocity(Qt.vector3d(0, ybot_vel_angulars[i], 0));
                bot.position = Qt.vector3d(frame.position.x, frame.position.y, frame.position.z);
                bot.eulerRotation = Qt.vector3d(frame.eulerRotation.x, frame.eulerRotation.y, frame.eulerRotation.z);
                
                yellowBotPositions.push(Qt.vector3d(frame.position.x, -frame.position.z, frame.eulerRotation.y));
            }
            let ballPosition = Qt.vector3d(ball.position.x, -ball.position.z, ball.position.y);
            observer.updateObjects(blueBotPositions, yellowBotPositions, ballPosition);
            
            let ballFriction = 0.99;
            velocity.x *= ballFriction;
            velocity.z *= ballFriction;
            ball.setLinearVelocity(Qt.vector3d(velocity.x*100, 0, velocity.z*100));
            
        }
    }
}
