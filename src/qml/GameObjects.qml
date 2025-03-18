import QtQuick
import QtQuick3D
import Qt3D.Render
import QtQuick3D.Physics
import MOC

import "../../assets/models/bot/blue/viz/body/" as BlueBody
import "../../assets/models/bot/yellow/viz/body/" as YellowBody
import "../../assets/models/bot/blue/viz/wheel/" as BlueWheel
import "../../assets/models/bot/yellow/viz/wheel/" as YellowWheel
import "../../assets/models/bot/blue/rigid_body/dribbler/" as BlueDribbler
// import "../../assets/models/bot/yellow/rigid_body/dribbler/" as YellowDribbler
import "../../assets/models/ball/"


Node {
    id: robotNode
    property real blue_bots_count: 1
    property real yellow_bots_count: 0

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
        Qt.vector3d(-10, 0, 0),
        Qt.vector3d(-50, 0, -300),
        Qt.vector3d(-75, 0, -300),
        Qt.vector3d(-200, 0, 150),
        Qt.vector3d(-200, 0, -150),
        Qt.vector3d(-350, 0, 0),
        Qt.vector3d(-350, 0, 400),
        Qt.vector3d(-350, 0, -400),
        Qt.vector3d(-500, 0, 300),
        Qt.vector3d(-500, 0, -300),
        Qt.vector3d(-600, 0, 0),
    ]

    property var yellow_bots_pos: [
        Qt.vector3d(50, 0, 0),
        Qt.vector3d(75, 0, 300),
        Qt.vector3d(75, 0, -300),
        Qt.vector3d(200, 0, 150),
        Qt.vector3d(200, 0, -150),
        Qt.vector3d(350, 0, 0),
        Qt.vector3d(350, 0, 400),
        Qt.vector3d(350, 0, -400),
        Qt.vector3d(500, 0, 300),
        Qt.vector3d(500, 0, -300),
        Qt.vector3d(600, 0, 0),
    ]

    property var blue_bot_radians: new Array(16).fill(0)
    property var bbot_vel_normals: new Array(16).fill(0.0)
    property var bbot_vel_tangents: new Array(16).fill(0.0)
    property var bbot_vel_angulars: new Array(16).fill(0.0)
    property var bbot_kickspeeds: new Array(16).fill(Qt.vector3d(0, 0, 0))
    property var bbot_distance_ball: new Array(16).fill(0.0)
    property var bbot_radian_ball: new Array(16).fill(0.0)

    property var yellow_bot_radians: new Array(16).fill(0)
    property var ybot_vel_normals: new Array(16).fill(0.0)
    property var ybot_vel_tangents: new Array(16).fill(0.0)
    property var ybot_vel_angulars: new Array(16).fill(0.0)
    property var ybot_kickspeeds: new Array(16).fill(Qt.vector3d(0, 0, 0))
    property var ybot_distance_ball: new Array(16).fill(0.0)
    property var ybot_radian_ball: new Array(16).fill(0.0)

    property real radian_offset: -Math.atan(35.0/54.772)

    property var previousPos : Qt.vector3d(0, 0, 0)
    property var currentPos : Qt.vector3d(0, 0, 0)
    property var ballVelocity : Qt.vector3d(0, 0, 0)
    property real lastUpdateTime: Date.now()

    property var obj_name: ""
    property real bot_cursor_id: 0
    property var count: 0

    function lerp(start, end, alpha) {
        return start * (1 - alpha) + end * alpha;
    }

    Connections {
        target: observer
        function onBlueRobotsChanged() {
            for (var i = 0; i < blue_bots_count; i++) {
                let bot = blueBotsRepeater.children[i];
                if (Math.abs(observer.blue_robots[i].velnormal) < 10) {
                    // bbot_vel_normals[i] = observer.blue_robots[i].velnormal * 60 * 1.5;
                    bbot_vel_normals[i] = lerp(bbot_vel_normals[i], observer.blue_robots[i].velnormal * 60 * 1.5, 0.1);
                }
                if (Math.abs(observer.blue_robots[i].veltangent) < 10) {
                    // bbot_vel_tangents[i] = -observer.blue_robots[i].veltangent * 60 * 1.5;
                    bbot_vel_tangents[i] = lerp(bbot_vel_tangents[i], -observer.blue_robots[i].veltangent * 60 * 1.5, 0.1);
                }
                if (Math.abs(observer.blue_robots[i].velangular) < 10) {
                    bbot_vel_angulars[i] = observer.blue_robots[i].velangular;
                }
                bbot_kickspeeds[i] = Qt.vector3d(observer.blue_robots[i].kickspeedx, 0, observer.blue_robots[i].kickspeedz);
                bbot_distance_ball[i] = Math.sqrt(Math.pow(bot.position.x - ball.position.x, 2) + Math.pow(bot.position.y - ball.position.y, 2) + Math.pow(bot.position.z - ball.position.z, 2));
                bbot_radian_ball[i] = Math.atan2(ball.position.z-bot.position.z, ball.position.x-bot.position.x);
            }
        }
        function onYellowRobotsChanged() {
            for (var i = 0; i < yellow_bots_count; i++) {
                let bot = yellowBotsRepeater.children[i];
                if (Math.abs(observer.yellow_robots[i].velnormal) < 10) {
                    // ybot_vel_normals[i] = observer.yellow_robots[i].velnormal * 60 * 1.5;
                    ybot_vel_normals[i] = lerp(ybot_vel_normals[i], observer.yellow_robots[i].velnormal * 60 * 1.5, 0.1);
                }
                if (Math.abs(observer.yellow_robots[i].veltangent) < 10) {
                    // ybot_vel_tangents[i] = -observer.yellow_robots[i].veltangent * 60 * 1.5;
                    ybot_vel_tangents[i] = lerp(ybot_vel_tangents[i], -observer.yellow_robots[i].veltangent * 60 * 1.5, 0.1);
                }
                if (Math.abs(observer.yellow_robots[i].velangular) < 10) {
                    ybot_vel_angulars[i] = observer.yellow_robots[i].velangular;
                }
                ybot_kickspeeds[i] = Qt.vector3d(observer.yellow_robots[i].kickspeedx, 0, observer.yellow_robots[i].kickspeedz);
                ybot_distance_ball[i] = Math.sqrt(Math.pow(bot.position.x - ball.position.x, 2) + Math.pow(bot.position.y - ball.position.y, 2) + Math.pow(bot.position.z - ball.position.z, 2));
                ybot_radian_ball[i] = Math.atan2(ball.position.z-bot.position.z, ball.position.x-bot.position.x);
            }
        }
    }



    Repeater3D {
        id: frame_blue_bots
        model: blue_bots_count
        DynamicRigidBody {
            // gravityEnabled: false
            physicsMaterial: physicsMaterial
            position: Qt.vector3d(blue_bots_pos[index].x, 0, blue_bots_pos[index].z)
            eulerRotation: Qt.vector3d(0, -90, 0)
            collisionShapes: [
                ConvexMeshShape {
                    source: "../../assets/models/plane/meshes/plane_mesh.cooked.cvx"
                }
                // ConvexMeshShape {
                //     source: "../../assets/models/bot/blue/rigid_body/frame/meshes/frame_mesh.cooked.cvx"
                // }
                // TriangleMeshShape {
                //     source: "../../assets/models/bot/blue/rigid_body/frame/meshes/frame_mesh.cooked.tri"
                // }
            ]
        }
    }
    PhysicsMaterial {
        id: physicsDribbler
        staticFriction: 0.5
        dynamicFriction: 0.5
        restitution:0.0
    }
    Repeater3D {
        id: dribbler_blue_bots
        model: blue_bots_count
        DynamicRigidBody {
            mass: 0
            // massMode: DynamicRigidBody.Mass
            // isKinematic: true
            simulationEnabled: false
            // gravityEnabled: false
        // kinematicPivot: Qt.vector3d(0, 6, 0)
    // kinematicPosition: Qt.vector3d(0, 0, 0)
            physicsMaterial: physicsDribbler
            position: Qt.vector3d(blue_bots_pos[index].x, 0, blue_bots_pos[index].z)
            kinematicPosition: Qt.vector3d(blue_bots_pos[index].x, 0, blue_bots_pos[index].z)
            kinematicPivot: Qt.vector3d(blue_bots_pos[index].x, 0, blue_bots_pos[index].z)
            eulerRotation: Qt.vector3d(0, -90, 0)
            // linearAxisLock: DynamicRigidBody.LockY
            // angularAxisLock: DynamicRigidBody.LockX | DynamicRigidBody.LockY
            collisionShapes: [
                ConvexMeshShape {
                    source: "../../assets/models/bot/blue/rigid_body/dribbler/meshes/dribbler_mesh.cooked.cvx"
                }
            ]
            BlueDribbler.Dribbler {
                position: Qt.vector3d(0, 0, 0)
            }
            // Model {
            //     source: "../../assets/models/bot/blue/rigid_body/dribbler/meshes/dribbler_mesh.mesh"
            //     materials: PrincipledMaterial {
            //         baseColor: "#FF0000"
            //         roughness: 1
            //         metalness: 1
            //     }
            // }
        }
    }
    Repeater3D {
        id: frame_yellow_bots
        model: yellow_bots_count
        DynamicRigidBody {
            // gravityEnabled: false
            physicsMaterial: physicsMaterial
            eulerRotation: Qt.vector3d(0, 90, 0)
            position: Qt.vector3d(yellow_bots_pos[index].x, 0, yellow_bots_pos[index].z)
            collisionShapes: [
                ConvexMeshShape {
                    source: "../../assets/models/plane/meshes/plane_mesh.cooked.cvx"
                },
                ConvexMeshShape {
                    source: "../../assets/models/bot/yellow/rigid_body/meshes/frame_mesh.cooked.cvx"
                }
            ]
        }
    }

    Repeater3D {
        id: blueBotsRepeater
        model: blue_bots_count
        delegate: Node {
            property int botIndex: index
            // BlueBody.Body {
            //     position: Qt.vector3d(0, 0.5, 0)
            // }
            Model {
                source: "#Cylinder"
                pickable: true
                objectName: "b"+String(index)
                scale: Qt.vector3d(0.25, 0.13, 0.25)
            }
            Model {
                source: "#Cylinder"
                scale: Qt.vector3d(0.05, 0.001, 0.05)
                position: Qt.vector3d(0, 12.8, 0)
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
                            12.8,
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
                BlueWheel.Wheel {
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
        model: yellow_bots_count
        delegate: Node {
            property int botIndex: index
            YellowBody.Body {
                position: Qt.vector3d(0, 0.5, 0)
            }
            Model {
                source: "#Cylinder"
                pickable: true
                objectName: "y"+String(index)
                scale: Qt.vector3d(0.25, 0.13, 0.25)
            }
            Model {
                source: "#Cylinder"
                scale: Qt.vector3d(0.05, 0.001, 0.05)
                position: Qt.vector3d(0, 14.3, 0)
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
                            14.3,
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
                YellowWheel.Wheel {
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
    PhysicsMaterial {
        id: fieldMaterial
        staticFriction: 0
        dynamicFriction: 0
        restitution: 0
    }
    DynamicRigidBody {
        id: ball
        // mass: 1
        // massMode: DynamicRigidBody.Mass
        position: Qt.vector3d(0, 0, 0)
        eulerRotation: Qt.vector3d(0, 0, 0)
        physicsMaterial: PhysicsMaterial
        collisionShapes: [
            SphereShape {
                id: sphere0
                diameter:  4.3
            }
        ]
        Ball {
            position: Qt.vector3d(0, 0, 0)
        }
    }
    function resetBallPosition(result) {
        ball.reset(result.scenePosition, Qt.vector3d(0, 0, 0));
    }
    function resetBotPosition(results) {
        let scenePosition = Qt.vector3d(0, 0, 0);
        for (let i = 0; i < results.length; i++) {
            if (results[i].objectHit.objectName == "field") scenePosition = results[i].scenePosition;
        }
        for (let i = 0; i < results.length; i++) {
            if (results[i].objectHit.objectName.startsWith("b")) {
                obj_name = "b";
                bot_cursor_id = parseInt(results[i].objectHit.objectName.slice(1));;
            } else if (results[i].objectHit.objectName.startsWith("y")) {
                obj_name = "y";
                bot_cursor_id = parseInt(results[i].objectHit.objectName.slice(1));;
            }
        }
        if (obj_name == "b") {
            frame_blue_bots.children[bot_cursor_id].reset(scenePosition, Qt.vector3d(0, -90, 0));
        } else if (obj_name == "y") {
            frame_yellow_bots.children[bot_cursor_id].reset(scenePosition, Qt.vector3d(0, 90, 0));
        }
    }

    Timer {
        interval: 16
        running: true
        repeat: true
        onTriggered: {
            let blueBotPositions = []
            let blueBotRotations = []
            let distance_ball = 0;
            let kick_flag = false;
            
            for (let i = 0; i < blue_bots_count; i++) {
                let frame = frame_blue_bots.children[i];
                let bot = blueBotsRepeater.children[i];
                let dribbler = dribbler_blue_bots.children[i];
                let radian = bot.eulerRotation.y * Math.PI / 180.0;
                // frame.reset(Qt.vector3d(bot.position.x+(-bbot_vel_normals[i]*Math.cos(radian) + bbot_vel_tangents[i]*Math.sin(radian)), 0, bot.position.z+(bbot_vel_normals[i]*Math.sin(radian) + bbot_vel_tangents[i]*Math.cos(radian))), Qt.vector3d(0, -90, 0));
                frame.setLinearVelocity(Qt.vector3d(-bbot_vel_normals[i]*Math.cos(radian) + bbot_vel_tangents[i]*Math.sin(radian), 0,  bbot_vel_normals[i]*Math.sin(radian) + bbot_vel_tangents[i]*Math.cos(radian)));
                frame.setAngularVelocity(Qt.vector3d(0, bbot_vel_angulars[i], 0));
                bot.position = Qt.vector3d(frame.position.x, frame.position.y, frame.position.z);
                bot.eulerRotation = Qt.vector3d(frame.eulerRotation.x, frame.eulerRotation.y, frame.eulerRotation.z);
                blueBotPositions.push(Qt.vector3d(frame.position.x, -frame.position.z, frame.eulerRotation.y+90));
                if (bbot_distance_ball[i] < 10.25 && Math.abs(Math.abs(bbot_radian_ball[i])-(Math.abs(radian+Math.PI/2))) < Math.PI/3.0) {
                    if (bbot_kickspeeds[i].x != 0 || bbot_kickspeeds[i].z != 0) {
                        kick_flag = true;
                        velocity.x = bbot_kickspeeds[i].x*100;
                        velocity.y = bbot_kickspeeds[i].z*100;
                        velocity.z = 0;
                        ball.applyCentralForce(Qt.vector3d(velocity.x*Math.cos(radian + Math.PI/2), velocity.y, velocity.x*Math.sin(radian - Math.PI/2)));
                    }
                }
                // dribbler.setAngularVelocity(Qt.vector3d(50, 50, 50))
                count = count + 1
                dribbler.kinematicRotation = Qt.vector3d(0, 0, count)
                // if (velocity.x != 0 || velocity.y != 0 || velocity.z != 0)
                    // dribbler.simulationEnabled = true;
                // dribbler.applyCentralForce(Qt.vector3d(100, 100, 100));
            }
            let yellowBotPositions = []
            let yellowBotRotations = []
            for (let i = 0; i < yellow_bots_count; i++) {
                let frame = frame_yellow_bots.children[i];
                let bot = yellowBotsRepeater.children[i];
                let radian = bot.eulerRotation.y * Math.PI / 180.0;
                
                frame.setLinearVelocity(Qt.vector3d(-ybot_vel_normals[i]*Math.cos(radian) + ybot_vel_tangents[i]*Math.sin(radian), 0,  ybot_vel_normals[i]*Math.sin(radian) + ybot_vel_tangents[i]*Math.cos(radian)));
                frame.setAngularVelocity(Qt.vector3d(0, ybot_vel_angulars[i], 0));
                bot.position = Qt.vector3d(frame.position.x, frame.position.y, frame.position.z);
                bot.eulerRotation = Qt.vector3d(frame.eulerRotation.x, frame.eulerRotation.y, frame.eulerRotation.z);
                yellowBotPositions.push(Qt.vector3d(frame.position.x, -frame.position.z, frame.eulerRotation.y+90));
            }
            let ballPosition = Qt.vector3d(ball.position.x, -ball.position.z, ball.position.y);
            observer.updateObjects(blueBotPositions, yellowBotPositions, ballPosition);
        
            if (velocity.x != 0 || velocity.y != 0 || velocity.z != 0){
                if (!kick_flag){
                    ball.applyCentralImpulse(Qt.vector3d(velocity.x, velocity.y, velocity.z));
                    
                }
            } else {
                // if (ball.position.x - previousPos.x != 0 || ball.position.y - previousPos.y != 0 || ball.position.z - previousPos.z != 0) {

            }
                let d_time = (Date.now() - lastUpdateTime) / 1000.0;
                ballVelocity = Qt.vector3d(ball.position.x - previousPos.x, ball.position.y - previousPos.y, ball.position.z - previousPos.z);
                ballVelocity = Qt.vector3d(ballVelocity.x / d_time, ballVelocity.y / d_time, ballVelocity.z / d_time);
                // ball.setLinearVelocity(Qt.vector3d(ballVelocity.x, ballVelocity.y, ballVelocity.z));
                
                // console.log("Ball Velocity: ", ballVelocity);
                // console.log("Ball Position: , Previous Position: ", ball.position, previousPos);
                // console.log("time: ", d_time);
                previousPos = Qt.vector3d(ball.position.x, ball.position.y, ball.position.z);
                lastUpdateTime = Date.now();
                velocity = Qt.vector3d(0, 0, 0);
                // }
        }
    }
    Component.onCompleted: {
        for (let i = 0; i < blue_bots_count; i++) {
            let frame = frame_blue_bots.children[i];
            let bot = blueBotsRepeater.children[i];
            bot.position = Qt.vector3d(frame.position.x, frame.position.y, frame.position.z);
            bot.eulerRotation = Qt.vector3d(frame.eulerRotation.x, frame.eulerRotation.y, frame.eulerRotation.z);
        }
        for (let i = 0; i < yellow_bots_count; i++) {
            let frame = frame_yellow_bots.children[i];
            let bot = yellowBotsRepeater.children[i];
            bot.position = Qt.vector3d(frame.position.x, frame.position.y, frame.position.z);
            bot.eulerRotation = Qt.vector3d(frame.eulerRotation.x, frame.eulerRotation.y, frame.eulerRotation.z);
        }
    }
}