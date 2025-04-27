import QtQuick
import QtQuick3D
import Qt3D.Render
import QtQuick3D.Physics
import Qt.labs.folderlistmodel
import MOC

// import "../../assets/models/bot/blue/viz/body/" as BlueBody
import "../../assets/models/bot/blue/rigid_body/body/" as BlueBody
import "../../assets/models/bot/blue/rigid_body/body/" as YellowBody
// import "../../assets/models/bot/blue/viz/wheel/" as BlueWheel
// import "../../assets/models/bot/yellow/viz/wheel/" as YellowWheel
import "../../assets/models/bot/blue/rigid_body/dribbler/" as BlueDribbler
import "../../assets/models/bot/blue/rigid_body/dribbler/" as YellowDribbler
import "../../assets/models/ball/"


Node {
    id: robotNode
    property real bBotNum: 6
    property real yBotNum: 6

    property real wheelRadius: 8.15
    property real angle0: 0
    property real angle1: 0
    property real angle2: 0
    property real angle3: 0

    property var bBotsPos: [
        Qt.vector3d(-500, 0, 0),
        Qt.vector3d(-750, 0, 3000),
        Qt.vector3d(-750, 0, -3000),
        Qt.vector3d(-2000, 0, 1500),
        Qt.vector3d(-2000, 0, -1500),
        Qt.vector3d(-3500, 0, 0),
        Qt.vector3d(-3500, 0, 4000),
        Qt.vector3d(-3500, 0, -4000),
        Qt.vector3d(-5000, 0, 3000),
        Qt.vector3d(-5000, 0, -3000),
        Qt.vector3d(-6000, 0, 0),
    ]

    property var yBotsPos: [
        Qt.vector3d(500, 0, 0),
        Qt.vector3d(750, 0, 3000),
        Qt.vector3d(750, 0, -3000),
        Qt.vector3d(2000, 0, 1500),
        Qt.vector3d(2000, 0, -1500),
        Qt.vector3d(3500, 0, 0),
        Qt.vector3d(3500, 0, 4000),
        Qt.vector3d(3500, 0, -4000),
        Qt.vector3d(5000, 0, 3000),
        Qt.vector3d(5000, 0, -3000),
        Qt.vector3d(6000, 0, 0),
    ]

    property var bBotRadians: new Array(16).fill(0.0)
    property var bBotVelNormals: new Array(16).fill(0.0)
    property var bBotVelTangents: new Array(16).fill(0.0)
    property var bBotVelAngulars: new Array(16).fill(0.0)
    property var bBotKickspeeds: new Array(16).fill(Qt.vector3d(0, 0, 0))
    property var bBotSpinners: new Array(16).fill(0.0)
    property var bBotDistanceBall: new Array(16).fill(0.0)
    property var bBotRadianBall: new Array(16).fill(0.0)

    property var yBotRadians: new Array(16).fill(0)
    property var yBotVelNormals: new Array(16).fill(0.0)
    property var yBotVelTangents: new Array(16).fill(0.0)
    property var yBotVelAngulars: new Array(16).fill(0.0)
    property var yBotKickspeeds: new Array(16).fill(Qt.vector3d(0, 0, 0))
    property var yBotSpinners: new Array(16).fill(0.0)
    property var yBotDistanceBall: new Array(16).fill(0.0)
    property var yBotRadianBall: new Array(16).fill(0.0)

    property real radianOffset: -Math.atan(350.0/547.72)
    property var objName: ""
    property real botCursorID: 0

    function lerp(start, end, alpha) {
        return start * (1 - alpha) + end * alpha;
    }

    Connections {
        target: observer
        function onBlueRobotsChanged() {
            for (var i = 0; i < bBotNum; i++) {
                let bot = bBotsRepeater.children[i];
                // if (Math.abs(observer.blue_robots[i].velnormal) < 10) {
                    bBotVelNormals[i] = lerp(bBotVelNormals[i], observer.blue_robots[i].velnormal* 1000, 0.5);
                // }
                // if (Math.abs(observer.blue_robots[i].veltangent) < 10) {
                    bBotVelTangents[i] = lerp(bBotVelTangents[i], -observer.blue_robots[i].veltangent * 1000, 0.5);
                // }
                // if (Math.abs(observer.blue_robots[i].velangular) < 5) {
                // if (i == 3)
                    // console.log(observer.blue_robots[i].velangular);
                    bBotVelAngulars[i] = observer.blue_robots[i].velangular;
                    // bBotVelAngulars[i] = lerp(bBotVelAngulars[i], observer.blue_robots[i].velangular, 0.5);
                // }else {
                    // if (observer.blue_robots[i].velangular < 0)
                        // bBotVelAngulars[i] = -5
                    // else
                        // bBotVelAngulars[i] = 5
                // }
                // console.log(bBotVelNormals[i], bBotVelTangents);
                bBotKickspeeds[i] = Qt.vector3d(observer.blue_robots[i].kickspeedx, 0, observer.blue_robots[i].kickspeedz);
                bBotSpinners[i] = observer.blue_robots[i].spinner;
            }
        }
        function onYellowRobotsChanged() {
            for (var i = 0; i < yBotNum; i++) {
                let bot = yBotsRepeater.children[i];
                // if (Math.abs(observer.yellow_robots[i].velnormal) < 8) {
                    yBotVelNormals[i] = lerp(yBotVelNormals[i], observer.yellow_robots[i].velnormal * 1000, 0.5);
                // }
                // if (Math.abs(observer.yellow_robots[i].veltangent) < 6) {
                    yBotVelTangents[i] = lerp(yBotVelTangents[i], -observer.yellow_robots[i].veltangent * 1000, 0.5);
                // }
                if (Math.abs(observer.yellow_robots[i].velangular) < 20) {
                    yBotVelAngulars[i] = observer.yellow_robots[i].velangular;
                }
                yBotKickspeeds[i] = Qt.vector3d(observer.yellow_robots[i].kickspeedx, 0, observer.yellow_robots[i].kickspeedz);
                yBotSpinners[i] = observer.yellow_robots[i].spinner;
            }
        }
    }

    Repeater3D {
        id: bBotsFrame
        model: bBotNum
        DynamicRigidBody {
            linearAxisLock: DynamicRigidBody.LockY
            physicsMaterial: physicsMaterial
            position: Qt.vector3d(bBotsPos[index].x, 0, bBotsPos[index].z)
            sendContactReports: true
            collisionShapes: [
                ConvexMeshShape {
                    source: "../../assets/models/bot/blue/rigid_body/body/meshes/back_mesh.cooked.cvx"
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../assets/models/bot/blue/rigid_body/body/meshes/front_mesh.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../assets/models/bot/blue/rigid_body/body/meshes/left_mesh.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../assets/models/bot/blue/rigid_body/body/meshes/right_mesh.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../assets/models/bot/blue/rigid_body/body/meshes/dribbler_mesh.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape {
                    source: "../../assets/models/bot/blue/rigid_body/body/meshes/chip_mesh.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                }
            ]
        }
    }

    Repeater3D {
        id: yBotsFrame
        model: yBotNum
        DynamicRigidBody {
            linearAxisLock: DynamicRigidBody.LockY
            position: Qt.vector3d(yBotsPos[index].x, 0.5, yBotsPos[index].z)
            collisionShapes: [
                ConvexMeshShape {
                    source: "../../assets/models/bot/blue/rigid_body/body/meshes/back_mesh.cooked.cvx"
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../assets/models/bot/blue/rigid_body/body/meshes/front_mesh.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../assets/models/bot/blue/rigid_body/body/meshes/left_mesh.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../assets/models/bot/blue/rigid_body/body/meshes/right_mesh.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../assets/models/bot/blue/rigid_body/body/meshes/dribbler_mesh.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape {
                    source: "../../assets/models/bot/blue/rigid_body/body/meshes/chip_mesh.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                }
            ]
        }
    }

    Repeater3D {
        id: bBotsRepeater
        model: bBotNum
        delegate: Node {
            property int botIndex: index
            BlueBody.Body {
                eulerRotation: Qt.vector3d(-90, 0, 0)
            }
            Model {
                source: "#Cylinder"
                pickable: true
                objectName: "b"+String(index)
                scale: Qt.vector3d(2.5, 1.3, 2.5)
                eulerRotation: Qt.vector3d(-90, 0, 0)
            }
            Model {
                source: "#Cylinder"
                scale: Qt.vector3d(0.5, 0.1, 0.5)
                position: Qt.vector3d(0, 125, 0)
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
                    scale: Qt.vector3d(0.4, 0.1, 0.4)
                    position: {
                        var offsets = [
                            Qt.vector3d(65*Math.cos(Math.PI-radianOffset-bBotRadians[index]), 0, 65*Math.sin(Math.PI-radianOffset-bBotRadians[index])),  // Left Up
                            Qt.vector3d(65*Math.cos(Math.PI/2.0-radianOffset-bBotRadians[index]), 0, 65*Math.sin(Math.PI/2.0-radianOffset-bBotRadians[index])), // Left Down
                            Qt.vector3d(65*Math.cos(Math.PI/2.0+radianOffset-bBotRadians[index]), 0, 65*Math.sin(Math.PI/2.0+radianOffset-bBotRadians[index])), // Right Down
                            Qt.vector3d(65*Math.cos(radianOffset-bBotRadians[index]), 0, 65*Math.sin(radianOffset-bBotRadians[index]))   // Right Up
                        ];
                        return Qt.vector3d(
                            offsets[index].x,
                            125,
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
        }
    }

    Repeater3D {
        id: yBotsRepeater
        model: yBotNum
        delegate: Node {
            property int botIndex: index
            YellowBody.Body {
                eulerRotation: Qt.vector3d(-90, 0, 0)
            }
            Model {
                source: "#Cylinder"
                pickable: true
                objectName: "y"+String(index)
                scale: Qt.vector3d(2.5, 1.3, 2.5)
                eulerRotation: Qt.vector3d(-90, 0, 0)
            }
            Model {
                source: "#Cylinder"
                scale: Qt.vector3d(0.5, 0.1, 0.5)
                position: Qt.vector3d(0, 125, 0)
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
                    scale: Qt.vector3d(0.4, 0.1, 0.4)
                    position: {
                        var offsets = [
                            Qt.vector3d(65*Math.cos(Math.PI-radianOffset-yBotRadians[index]), 0, 65*Math.sin(Math.PI-radianOffset-yBotRadians[index])), // Left Up
                            Qt.vector3d(65*Math.cos(Math.PI/2.0-radianOffset-yBotRadians[index]), 0, 65*Math.sin(Math.PI/2.0-radianOffset-yBotRadians[index])), // Left Down
                            Qt.vector3d(65*Math.cos(Math.PI/2.0+radianOffset-yBotRadians[index]), 0, 65*Math.sin(Math.PI/2.0+radianOffset-yBotRadians[index])), // Right Down
                            Qt.vector3d(65*Math.cos(radianOffset-yBotRadians[index]), 0, 65*Math.sin(radianOffset-yBotRadians[index]))   // Right Up
                        ];
                        return Qt.vector3d(
                            offsets[index].x,
                            125,
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
        }
    }

    PhysicsMaterial {
        id: ballMaterial
        staticFriction: 0.1
        dynamicFriction: 0.1
        restitution: 0
    }
    DynamicRigidBody {
        id: ball
        position: Qt.vector3d(0, 500, 0)
        physicsMaterial: ballMaterial
        collisionShapes: [
            ConvexMeshShape {
                id: ballShape
                source: "../../assets/models/ball/meshes/ball_mesh.cooked.cvx"
            }
        ]
        Ball {}
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
                objName = "b";
                botCursorID = parseInt(results[i].objectHit.objectName.slice(1));;
            } else if (results[i].objectHit.objectName.startsWith("y")) {
                objName = "y";
                botCursorID = parseInt(results[i].objectHit.objectName.slice(1));;
            }
        }
        if (objName == "b") {
            bBotsFrame.children[botCursorID].reset(scenePosition, Qt.vector3d(0, -210, 0));
        } else if (objName == "y") {
            yBotsFrame.children[botCursorID].reset(scenePosition, Qt.vector3d(0, 90, 0));
        }
    }

    function normalizeRadian(radian) {
        if (radian > Math.PI) {
            return radian - 2 * Math.PI;
        } else if (radian < -Math.PI) {
            return radian + 2 * Math.PI;
        }
        return radian;
    }

    Timer {
        interval: 16
        running: true
        repeat: true
        onTriggered: {
            let bBotPositions = []
            let bBotBallContacts = []
            let kick_flag = false;
            
            for (let i = 0; i < bBotNum; i++) {
                let frame = bBotsFrame.children[i];
                let bot = bBotsRepeater.children[i];
                let radian = bot.eulerRotation.y * Math.PI / 180.0;
                bBotDistanceBall[i] = Math.sqrt(Math.pow(bot.position.x - ball.position.x, 2) + Math.pow(bot.position.y - ball.position.y, 2) + Math.pow(bot.position.z - ball.position.z, 2));
                bBotRadianBall[i] = -normalizeRadian(Math.atan2(bot.position.z-ball.position.z, bot.position.x-ball.position.x)-Math.PI/2);

                frame.setLinearVelocity(Qt.vector3d(-bBotVelNormals[i]*Math.cos(radian) + bBotVelTangents[i]*Math.sin(radian), 0,  bBotVelNormals[i]*Math.sin(radian) +  bBotVelTangents[i]*Math.cos(radian)));
                frame.setAngularVelocity(Qt.vector3d(0, bBotVelAngulars[i], 0));
                if (frame.eulerRotation.x > 0 || frame.eulerRotation.z > 0)
                    frame.eulerRotation = Qt.vector3d(0, frame.eulerRotation.y, 0);
                bot.position = Qt.vector3d(frame.position.x, frame.position.y, frame.position.z);
                bot.eulerRotation = Qt.vector3d(frame.eulerRotation.x, frame.eulerRotation.y, frame.eulerRotation.z);
                bBotPositions.push(Qt.vector3d(frame.position.x, -frame.position.z, frame.eulerRotation.y+90));

                if (bBotDistanceBall[i] < 120 && Math.abs(normalizeRadian(bBotRadianBall[i] - radian)) < Math.PI/15.0) {
                    bBotBallContacts.push(true);

                    if (bBotSpinners[i] > 0) {
                        let ballRadian = Math.atan2(ball.position.z-bot.position.z, ball.position.x-bot.position.x);
                        ball.reset(Qt.vector3d(frame.position.x+95*Math.cos(ballRadian), 0, frame.position.z+95*Math.sin(ballRadian)), Qt.vector3d(0, 0, 0));
                    }

                    if (bBotKickspeeds[i].x != 0 || bBotKickspeeds[i].z != 0) {
                        kick_flag = true;
                        velocity.x = bBotKickspeeds[i].x*1000;
                        velocity.y = bBotKickspeeds[i].z*1000;
                        velocity.z = 0;
                        ball.setLinearVelocity(Qt.vector3d(velocity.x*Math.cos(radian + Math.PI/2), velocity.y, velocity.x*Math.sin(radian - Math.PI/2)));
                    }
                } else {
                    bBotBallContacts.push(false);
                }
            }
            let yBotPositions = []
            let yBotBallContacts = []
            for (let i = 0; i < yBotNum; i++) {
                let frame = yBotsFrame.children[i];
                let bot = yBotsRepeater.children[i];
                let radian = bot.eulerRotation.y * Math.PI / 180.0;
                yBotDistanceBall[i] = Math.sqrt(Math.pow(bot.position.x - ball.position.x, 2) + Math.pow(bot.position.y - ball.position.y, 2) + Math.pow(bot.position.z - ball.position.z, 2));
                yBotRadianBall[i] = -normalizeRadian(Math.atan2(bot.position.z-ball.position.z, bot.position.x-ball.position.x)-Math.PI/2);

                frame.setLinearVelocity(Qt.vector3d(-yBotVelNormals[i]*Math.cos(radian) + yBotVelTangents[i]*Math.sin(radian), 0,  yBotVelNormals[i]*Math.sin(radian) +  yBotVelTangents[i]*Math.cos(radian)));
                frame.setAngularVelocity(Qt.vector3d(0, yBotVelAngulars[i], 0));
                if (frame.eulerRotation.x > 0 || frame.eulerRotation.z > 0)
                    frame.eulerRotation = Qt.vector3d(0, frame.eulerRotation.y, 0);
                bot.position = Qt.vector3d(frame.position.x, frame.position.y, frame.position.z);
                bot.eulerRotation = Qt.vector3d(frame.eulerRotation.x, frame.eulerRotation.y, frame.eulerRotation.z);
                yBotPositions.push(Qt.vector3d(frame.position.x, -frame.position.z, frame.eulerRotation.y+90));

                if (yBotDistanceBall[i] < 120 && Math.abs(normalizeRadian(yBotRadianBall[i] - radian) < Math.PI/15.0)) {
                    yBotBallContacts.push(true);

                    if (yBotSpinners[i] > 0) {
                        let ballRadian = Math.atan2(ball.position.z-bot.position.z, ball.position.x-bot.position.x);
                        ball.reset(Qt.vector3d(frame.position.x+95*Math.cos(ballRadian), 0, frame.position.z+95*Math.sin(ballRadian)), Qt.vector3d(0, 0, 0));
                    }

                    if (yBotKickspeeds[i].x != 0 || yBotKickspeeds[i].z != 0) {
                        kick_flag = true;
                        velocity.x = yBotKickspeeds[i].x*1000
                        velocity.y = yBotKickspeeds[i].z*1000
                        velocity.z = 0;
                        ball.setLinearVelocity(Qt.vector3d(velocity.x*Math.cos(radian + Math.PI/2), velocity.y, velocity.x*Math.sin(radian - Math.PI/2)));
                    }
                } else {
                    yBotBallContacts.push(false);
                }
            }
            let ballPosition = Qt.vector3d(ball.position.x, -ball.position.z, ball.position.y);

            observer.updateObjects(bBotPositions, yBotPositions, bBotBallContacts, yBotBallContacts, ballPosition);
        
            // if (velocity.x != 0 || velocity.y != 0 || velocity.z != 0){
            //     if (!kick_flag) {
            //         // ball.applyCentralImpulse(Qt.vector3d(velocity.x, velocity.y, velocity.z));
            //         // ball.setLinearVelocity(Qt.vector3d(velocity.x, velocity.y, velocity.z));
            //         ball.setLinearVelocity(Qt.vector3d(velocity.x, velocity.y, velocity.z));
            //         // let ballFriction = 0.99;
            //         // velocity.x *= ballFriction;
            //         // velocity.y *= ballFriction;
            //         // velocity.z *= ballFriction;
            //     }
            // }
            // collisionID = -1;
            
        }
    }
    Component.onCompleted: {
        for (let i = 0; i < bBotNum; i++) {
            let frame = bBotsFrame.children[i];
            let bot = bBotsRepeater.children[i];
            frame.reset(Qt.vector3d(frame.position.x, 0, frame.position.z), Qt.vector3d(0, -90, 0));
            bot.position = Qt.vector3d(frame.position.x, frame.position.y, frame.position.z);
            bot.eulerRotation = Qt.vector3d(frame.eulerRotation.x, frame.eulerRotation.y, frame.eulerRotation.z);
        }
        for (let i = 0; i < yBotNum; i++) {
            let frame = yBotsFrame.children[i];
            let bot = yBotsRepeater.children[i];
            frame.reset(Qt.vector3d(frame.position.x, 0, frame.position.z), Qt.vector3d(0, 90, 0));
            bot.position = Qt.vector3d(frame.position.x, frame.position.y, frame.position.z);
            bot.eulerRotation = Qt.vector3d(frame.eulerRotation.x, frame.eulerRotation.y, frame.eulerRotation.z);
        }
    }
}

