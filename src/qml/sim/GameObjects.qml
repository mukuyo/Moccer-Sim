import QtQuick
import QtQuick3D
import Qt3D.Render
import Qt3D.Extras
import QtQuick3D.Physics
import Qt.labs.folderlistmodel
import MOC

import "../../../assets/models/bot/Rione/viz" as BlueBody
import "../../../assets/models/bot/Rione/rigid_body" as BlueLightBody
import "../../../assets/models/bot/Rione/viz" as YellowBody
import "../../../assets/models/bot/Rione/rigid_body" as YellowLightBody
import "../../../assets/models/ball/"
import "../../../assets/models/circle/ball/"

Node {
    id: robotNode
    property real bBotNum: observer.blueRobotCount
    property real yBotNum: observer.yellowRobotCount
    property bool lightBlueRobotMode: observer.lightBlueRobotMode
    property bool lightYellowRobotMode: observer.lightYellowRobotMode
    property real ballStaticFriction: observer.ballStaticFriction
    property real ballDynamicFriction: observer.ballDynamicFriction
    property real ballRestitution: observer.ballRestitution
    property real colorHeight: 0.15

    property var bBotsPos: [
        Qt.vector3d(500, 0, 2000),
        Qt.vector3d(750, 0, 2000),
        Qt.vector3d(750, 0, 3000),
        Qt.vector3d(2000, 0, 1500),
        Qt.vector3d(2000, 0, 1800),
        Qt.vector3d(3500, 0, 2000),
        Qt.vector3d(3500, 0, 4000),
        Qt.vector3d(3500, 0, 4500),
        Qt.vector3d(5000, 0, 3500),
        Qt.vector3d(5000, 0, 3000),
        Qt.vector3d(6000, 0, 0),
    ]

    property var yBotsPos: [
        Qt.vector3d(-2000, 0, 0),
        Qt.vector3d(-2000, 0, 2000),
        Qt.vector3d(-2000, 0, -2000),
        Qt.vector3d(-2000, 0, 1000),
        Qt.vector3d(-2000, 0, -1000),
        Qt.vector3d(-3600, 0, 0),
        Qt.vector3d(-3600, 0, 2000),
        Qt.vector3d(-3600, 0, -2000),
        Qt.vector3d(-3000, 0, 2000),
        Qt.vector3d(-3000, 0, -2000),
        Qt.vector3d(-3000, 0, 0),
        Qt.vector3d(-3000, 0, 1000),
        Qt.vector3d(-3000, 0, -1000),
    ]
    property var bBotRadians: new Array(16).fill(0.0)
    property var bBotVelNormals: new Array(16).fill(0.0)
    property var bBotVelTangents: new Array(16).fill(0.0)
    property var bBotVelAngulars: new Array(16).fill(0.0)
    property var bBotPrePos: new Array(16).fill(Qt.vector3d(0, 0, 0))
    property var bBotVelocity: new Array(16).fill(Qt.vector3d(0, 0, 0))
    property var bBotPreVelocity: new Array(16).fill(Qt.vector3d(0, 0, 0))
    property var bBotKickspeeds: new Array(16).fill(Qt.vector3d(0, 0, 0))
    property var bBotSpinners: new Array(16).fill(0.0)
    property var bBotDistanceBall: new Array(16).fill(0.0)
    property var bBotRadianBall: new Array(16).fill(0.0)
    property var bBotCameraExists: new Array(16).fill(false)
    property var bBotsCamera: []

    property var yBotRadians: new Array(16).fill(0)
    property var yBotVelNormals: new Array(16).fill(0.0)
    property var yBotVelTangents: new Array(16).fill(0.0)
    property var yBotVelAngulars: new Array(16).fill(0.0)
    property var yBotPrePos: new Array(16).fill(Qt.vector3d(0, 0, 0))
    property var yBotVelocity: new Array(16).fill(Qt.vector3d(0, 0, 0))
    property var yBotPreVelocity: new Array(16).fill(Qt.vector3d(0, 0, 0))
    property var yBotKickspeeds: new Array(16).fill(Qt.vector3d(0, 0, 0))
    property var yBotSpinners: new Array(16).fill(0.0)
    property var yBotDistanceBall: new Array(16).fill(0.0)
    property var yBotRadianBall: new Array(16).fill(0.0)
    property var yBotCameraExists: new Array(16).fill(false)
    property var yBotsCamera: []

    property real radianOffset: -Math.atan(350.0/547.72)
    property var selectedRobotColor: "blue"
    property real botCursorID: 0
    property var kick_flag: false
    property var isDribble: false
    property var ballPosition: Qt.vector3d(0, 0, 0)
    property var dribbleNum: -1
    property var dribbleRadian: 0.0

    MotionControl {
        id: motionControl
    }

    onLightBlueRobotModeChanged: {
        if (observer.lightBlueRobotMode) {
            colorHeight = 0.3;
        } else {
            colorHeight = 0.15;
        }
    }
    Connections {
        target: observer
        function onBlueRobotsChanged() {
            for (var i = 0; i < bBotNum; i++) {
                let bot = bBotsRepeater.children[i];
                bBotVelNormals[i] = observer.blue_robots[i].velnormal;
                bBotVelTangents[i] = observer.blue_robots[i].veltangent;
                bBotVelAngulars[i] = observer.blue_robots[i].velangular;
                bBotKickspeeds[i] = Qt.vector3d(observer.blue_robots[i].kickspeedx, observer.blue_robots[i].kickspeedz, observer.blue_robots[i].kickspeedx);
                bBotSpinners[i] = observer.blue_robots[i].spinner;
            }
        }
        function onYellowRobotsChanged() {
            for (var i = 0; i < yBotNum; i++) {
                let bot = yBotsRepeater.children[i];
                yBotVelNormals[i] = observer.yellow_robots[i].velnormal;
                yBotVelTangents[i] = observer.yellow_robots[i].veltangent;
                yBotVelAngulars[i] = observer.yellow_robots[i].velangular;
                yBotKickspeeds[i] = Qt.vector3d(observer.yellow_robots[i].kickspeedx, observer.yellow_robots[i].kickspeedz, observer.yellow_robots[i].kickspeedx);
                yBotSpinners[i] = observer.yellow_robots[i].spinner;
            }
        }
    }
    PhysicsMaterial {
        id: robotMaterial
        staticFriction: 0.0
        dynamicFriction: 0.0
        restitution: 0.0
    }

    Repeater3D {
        id: bBotsFrame
        model: bBotNum
        DynamicRigidBody {
            objectName: "b" + String(index)
            linearAxisLock: DynamicRigidBody.LockY
            physicsMaterial: robotMaterial
            position: Qt.vector3d(bBotsPos[index].x, 0, bBotsPos[index].z)
            collisionShapes: [
                ConvexMeshShape {
                    source: "../../../assets/models/bot/Rione/rigid_body/meshes/body.cooked.cvx"
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../../assets/models/bot/Rione/rigid_body/meshes/centerLeft.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../../assets/models/bot/Rione/rigid_body/meshes/centerRight.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../../assets/models/bot/Rione/rigid_body/meshes/dribbler.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape {
                    source: "../../../assets/models/bot/Rione/rigid_body/meshes/chip.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape {
                    source: "../../../assets/models/ball/meshes/ball.cooked.cvx"
                    position: Qt.vector3d(0, 5000, 0)
                }
            ]
        }
    }

    Repeater3D {
        id: yBotsFrame
        model: yBotNum
        DynamicRigidBody {
            objectName: "y" + String(index)
            linearAxisLock: DynamicRigidBody.LockY
            physicsMaterial: robotMaterial
            position: Qt.vector3d(yBotsPos[index].x, 0, yBotsPos[index].z)
            collisionShapes: [
                ConvexMeshShape {
                    source: "../../../assets/models/bot/Rione/rigid_body/meshes/body.cooked.cvx"
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../../assets/models/bot/Rione/rigid_body/meshes/centerLeft.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../../assets/models/bot/Rione/rigid_body/meshes/centerRight.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../../assets/models/bot/Rione/rigid_body/meshes/dribbler.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape {
                    source: "../../../assets/models/bot/Rione/rigid_body/meshes/chip.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape {
                    source: "../../../assets/models/ball/meshes/ball.cooked.cvx"
                    position: Qt.vector3d(0, 5000, 0)
                }
            ]
        }
    }

    Repeater3D {
        id: bBotsRepeater
        model: bBotNum
        delegate: Node {
            property int botIndex: index
            BlueBody.Visualize {
                visible: !observer.lightBlueRobotMode
                eulerRotation: Qt.vector3d(-90, 0, 0)
                position: Qt.vector3d(0, 0, 0)
            }
            BlueLightBody.Frame {
                visible: observer.lightBlueRobotMode
                eulerRotation: Qt.vector3d(-90, 0, 0)
                position: Qt.vector3d(0, 0, 0)
            }
            PerspectiveCamera {
                id: bRobotCamera
                position: Qt.vector3d(0, 90, -70)
                clipFar: 20000
                clipNear: 1
                fieldOfView: 60
                eulerRotation: Qt.vector3d(-35, 0, 0)
                Component.onCompleted: {
                    bBotsCamera.push(bRobotCamera);
                }
            }
            Model {
                source: "#Cylinder"
                pickable: true
                objectName: "b"+String(index)
                scale: Qt.vector3d(2.3, 1.2, 2.3)
                eulerRotation: Qt.vector3d(-90, 0, 0)
            }
            Model {
                source: "#Cylinder"
                scale: Qt.vector3d(0.5, colorHeight, 0.5)
                position: Qt.vector3d(0, 122, 0)
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
                    scale: Qt.vector3d(0.4, colorHeight, 0.4)
                    position: {
                        var offsets = [
                            Qt.vector3d(65*Math.cos(Math.PI-radianOffset-bBotRadians[index]), 0, 65*Math.sin(Math.PI-radianOffset-bBotRadians[index])),  // Left Up
                            Qt.vector3d(65*Math.cos(Math.PI/2.0-radianOffset-bBotRadians[index]), 0, 65*Math.sin(Math.PI/2.0-radianOffset-bBotRadians[index])), // Left Down
                            Qt.vector3d(65*Math.cos(Math.PI/2.0+radianOffset-bBotRadians[index]), 0, 65*Math.sin(Math.PI/2.0+radianOffset-bBotRadians[index])), // Right Down
                            Qt.vector3d(65*Math.cos(radianOffset-bBotRadians[index]), 0, 65*Math.sin(radianOffset-bBotRadians[index]))   // Right Up
                        ];
                        return Qt.vector3d(
                            offsets[index].x,
                            122,
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
    onBBotNumChanged: {
        bBotsCamera = [];
    }

    Repeater3D {
        id: yBotsRepeater
        model: yBotNum
        delegate: Node {
            property int botIndex: index
            YellowBody.Visualize {
                visible: !observer.lightYellowRobotMode
                eulerRotation: Qt.vector3d(-90, 0, 0)
                position: Qt.vector3d(0, 0, 0)
            }
            YellowLightBody.Frame {
                visible: observer.lightYellowRobotMode
                eulerRotation: Qt.vector3d(-90, 0, 0)
                position: Qt.vector3d(0, 0, 0)
            }
            PerspectiveCamera {
                id: yRobotCamera
                position: Qt.vector3d(0, 90, -70)
                clipFar: 20000
                clipNear: 1
                fieldOfView: 60
                eulerRotation: Qt.vector3d(-35, 0, 0)
                Component.onCompleted: {
                    yBotsCamera.push(yRobotCamera);
                }
            }
            Model {
                source: "#Cylinder"
                pickable: true
                objectName: "y"+String(index)
                scale: Qt.vector3d(2.3, 1.2, 2.3)
                eulerRotation: Qt.vector3d(-90, 0, 0)
            }
            Model {
                source: "#Cylinder"
                scale: Qt.vector3d(0.5, colorHeight, 0.5)
                position: Qt.vector3d(0, 122, 0)
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
                    scale: Qt.vector3d(0.4, colorHeight, 0.4)
                    position: {
                        var offsets = [
                            Qt.vector3d(65*Math.cos(Math.PI-radianOffset-yBotRadians[index]), 0, 65*Math.sin(Math.PI-radianOffset-yBotRadians[index])), // Left Up
                            Qt.vector3d(65*Math.cos(Math.PI/2.0-radianOffset-yBotRadians[index]), 0, 65*Math.sin(Math.PI/2.0-radianOffset-yBotRadians[index])), // Left Down
                            Qt.vector3d(65*Math.cos(Math.PI/2.0+radianOffset-yBotRadians[index]), 0, 65*Math.sin(Math.PI/2.0+radianOffset-yBotRadians[index])), // Right Down
                            Qt.vector3d(65*Math.cos(radianOffset-yBotRadians[index]), 0, 65*Math.sin(radianOffset-yBotRadians[index]))   // Right Up
                        ];
                        return Qt.vector3d(
                            offsets[index].x,
                            122,
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
    onYBotNumChanged: {
        yBotsCamera = [];
    }

    PhysicsMaterial {
        id: ballMaterial
        staticFriction: ballStaticFriction
        dynamicFriction: ballDynamicFriction
        restitution: ballRestitution
    }

    DynamicRigidBody {
        id: ball
        objectName: "ball"
        massMode: DynamicRigidBody.Mass
        mass: 0.043
        position: Qt.vector3d(0, 500, 0)
        physicsMaterial: ballMaterial
        collisionShapes: [
            ConvexMeshShape {
                id: ballShape
                source: "../../../assets/models/ball/meshes/ball.cooked.cvx"
            }
        ]
    }
    Ball {
        id: tempBall
    }
    function resetPosition(target, result) {
        if (target == "ball") {
            dribbleNum = -1;
            teleopVelocity = Qt.vector3d(0, 0, 0);
            ball.reset(result.scenePosition, Qt.vector3d(0, 0, 0));
            for (let i = 0; i < bBotNum; i++) {
                bBotsFrame.children[i].collisionShapes[5].position = Qt.vector3d(0, 5000, 0);
            }
            for (let i = 0; i < yBotNum; i++) {
                yBotsFrame.children[i].collisionShapes[5].position = Qt.vector3d(0, 5000, 0);
            }
        } else if (target == "bot") {
            if (selectedRobotColor == "blue") {
                bBotsFrame.children[botCursorID].reset(result.scenePosition, Qt.vector3d(0, -90, 0));
            } else if (selectedRobotColor == "yellow") {
                yBotsFrame.children[botCursorID].reset(result.scenePosition, Qt.vector3d(0, 90, 0));
            }
        }
    }
    function resetBotPosition(results) {
        let scenePosition = Qt.vector3d(0, 0, 0);
        for (let i = 0; i < results.length; i++) {
            if (results[i].objectHit.objectName == "field") scenePosition = results[i].scenePosition;
        }
        for (let i = 0; i < results.length; i++) {
            if (results[i].objectHit.objectName.startsWith("b")) {
                selectedRobotColor = "blue";
                botCursorID = parseInt(results[i].objectHit.objectName.slice(1));;
            } else if (results[i].objectHit.objectName.startsWith("y")) {
                selectedRobotColor = "yellow";
                botCursorID = parseInt(results[i].objectHit.objectName.slice(1));;
            }
        }
        if (selectedRobotColor == "blue") {
            bBotsFrame.children[botCursorID].reset(scenePosition, Qt.vector3d(0, -90, 0));
        } else if (selectedRobotColor == "yellow") {
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

    function botMovement(isYellow, timestep) {
        let botPositions = []
        let botBallContacts = []
        let ballPixels = []
        
        let botNum = isYellow ? yBotNum : bBotNum;
        let botFrame = isYellow ? yBotsFrame : bBotsFrame;
        let botRepeater = isYellow ? yBotsRepeater : bBotsRepeater;
        let botVelNormals = isYellow ? yBotVelNormals : bBotVelNormals;
        let botVelTangents = isYellow ? yBotVelTangents : bBotVelTangents;
        let botVelAngulars = isYellow ? yBotVelAngulars : bBotVelAngulars;
        let botPrePositions = isYellow ? yBotPrePos : bBotPrePos;
        let botPreVelocity = isYellow ? yBotPreVelocity : bBotPreVelocity;
        let botVelocity = isYellow ? yBotVelocity : bBotVelocity;
        let botKickspeeds = isYellow ? yBotKickspeeds : bBotKickspeeds;
        let botSpinners = isYellow ? yBotSpinners : bBotSpinners;
        let botPixelBalls = isYellow ? window.yBotPixelBalls : window.bBotPixelBalls;
        let botIDTexts = isYellow ? yBotIDTexts : bBotIDTexts;
        let botCamera = isYellow ? yBotsCamera : bBotsCamera;
        let botCameraExists = isYellow ? yBotCameraExists : bBotCameraExists;
        let bot2DPositions = isYellow ? yBot2DPositions : bBot2DPositions;

        for (let i = 0; i < botNum; i++) {
            let frame = botFrame.children[i];
            let bot = botRepeater.children[i];
            let radian = normalizeRadian((bot.eulerRotation.y+90) * Math.PI / 180.0);

            let botDistanceBall = Math.sqrt(Math.pow(frame.position.x - ball.position.x, 2) + Math.pow(frame.position.z - ball.position.z, 2) + Math.pow(frame.position.y - ball.position.y, 2));
            if (ball.position.x > 50000) {
                botDistanceBall = Math.sqrt(Math.pow(frame.position.x - tempBall.position.x, 2) + Math.pow(frame.position.z - tempBall.position.z, 2) + Math.pow(frame.position.y - tempBall.position.y, 2));
                if (dribbleNum == (isYellow ? i + 10 : i)) {
                    botDistanceBall = 95;
                }
            }
            let botRadianBall = normalizeRadian(Math.atan2(frame.position.z - ball.position.z, frame.position.x - ball.position.x) - Math.PI + radian);
            if (ball.position.x > 50000) {
                botRadianBall = normalizeRadian(Math.atan2(frame.position.z - tempBall.position.z, frame.position.x - tempBall.position.x) - Math.PI + radian);
                if (dribbleNum == (isYellow ? i + 10 : i)) {
                    botRadianBall = dribbleRadian;
                }
            }

            let botWorldVelocity = Qt.vector3d(
                (frame.position.x - botPrePositions[i].x) / timestep,
                (frame.position.z - botPrePositions[i].z) / timestep,
                normalizeRadian(radian - botPrePositions[i].y) / timestep
            );
            botVelocity[i] = Qt.vector3d(
                botWorldVelocity.x * Math.cos(radian) - botWorldVelocity.y * Math.sin(radian),
                -botWorldVelocity.x * Math.sin(radian) - botWorldVelocity.y * Math.cos(radian),
                botWorldVelocity.z
            );
            let newVelocity = motionControl.calcSpeed(Qt.vector3d(botVelTangents[i], botVelNormals[i], botVelAngulars[i]), botVelocity[i], botPreVelocity[i], timestep, radian);

            botPrePositions[i] = Qt.vector3d(frame.position.x, radian, frame.position.z);
            botPreVelocity[i] = Qt.vector3d(newVelocity.x, newVelocity.y, newVelocity.z);
            
            frame.setLinearVelocity(Qt.vector3d(newVelocity.x*Math.cos(radian) - newVelocity.y*Math.sin(radian), 0, -newVelocity.x*Math.sin(radian) - newVelocity.y*Math.cos(radian)));
            frame.setAngularVelocity(Qt.vector3d(0, newVelocity.z, 0));

            if (frame.eulerRotation.x > 0 || frame.eulerRotation.z > 0)
                frame.eulerRotation = Qt.vector3d(0, frame.eulerRotation.y, 0);


            botPositions.push(Qt.vector3d(frame.position.x, -frame.position.z, frame.eulerRotation.y+90));

            if (dribbleNum == (isYellow ? i + 10 : i) && botSpinners[i] == 0) {
                frame.collisionShapes[5].position = Qt.vector3d(0, 5000, 0);
                if (ball.position.x > 50000) {
                    ball.reset(Qt.vector3d(frame.position.x + (95 * Math.cos(normalizeRadian(-radian + dribbleRadian))), 25, (frame.position.z + (95 * Math.sin(normalizeRadian(-radian + dribbleRadian))))), Qt.vector3d(0, 0, 0));
                }
                dribbleNum = -1;
            }

            if ((botDistanceBall < 105 * Math.cos(Math.abs(botRadianBall)) && Math.abs(botRadianBall) < Math.PI/15.0)) {
                botBallContacts.push(true);
                isDribble = true;
                if (botSpinners[i] > 0 && (botKickspeeds[i].x == 0 && botKickspeeds[i].y == 0)) {
                    if (dribbleNum == (isYellow ? i + 10 : i) || dribbleNum == -1) {
                        dribbleNum = isYellow ? i + 10 : i;
                        dribbleRadian = botRadianBall;
                        ball.reset(Qt.vector3d(100000, 0, 100000), Qt.vector3d(0, 0, 0));
                        frame.collisionShapes[5].position = Qt.vector3d(95*Math.tan(dribbleRadian), 25, -95);
                        ballPosition = Qt.vector3d(bot.position.x + (95 * Math.cos(-radian + dribbleRadian)), -(bot.position.z + (95 * Math.sin(-radian + dribbleRadian))), 25);
                    }
                }
                if (botKickspeeds[i].x != 0 || botKickspeeds[i].y != 0) {
                    frame.collisionShapes[5].position = Qt.vector3d(0, 5000, 0);
                    if (ball.position.x > 50000) {
                        ball.reset(Qt.vector3d(frame.position.x + (95 * Math.cos(-radian)), 25, (frame.position.z + (95 * Math.sin(-radian)))), Qt.vector3d(0, 0, 0));
                    }
                    dribbleNum = -1;
                    // ball.setLinearVelocity(Qt.vector3d(
                    //     botKickspeeds[i].x * Math.cos(radian),
                    //     botKickspeeds[i].y,
                    //     -botKickspeeds[i].x * Math.sin(radian)
                    // ));
                    let rg =0.043;
                    if (!kick_flag) {
                        kick_flag = true;
                        ball.applyCentralImpulse(Qt.vector3d(
                            botKickspeeds[i].x * Math.cos(radian)*rg,
                            botKickspeeds[i].y*rg,
                            -botKickspeeds[i].x * Math.sin(radian)*rg
                        ));
                    }
                }
            } else {
                botBallContacts.push(false);
            }
            let frame2D = camera.projectToScreen(
                Qt.vector3d(frame.position.x-15, frame.position.y + 128, frame.position.z-86.5), overviewCamera.position, overviewCamera.forward, overviewCamera.up, window.width, window.height, overviewCamera.fieldOfView, 1.0, 20000
            );
            if (i >= 10) {
                botIDTexts.children[i].x = frame2D.x - 5;
            } else {
                botIDTexts.children[i].x = frame2D.x - 2;
            }
            botIDTexts.children[i].y = frame2D.y - 14;

            let cameraPosition = Qt.vector3d(-70*Math.sin(radian)+frame.position.x, botCamera[i].position.y + frame.position.y, -70*Math.cos(radian)+frame.position.z);
            let tempBallPixel = camera.getBallPosition(ball.position, cameraPosition, botCamera[i].forward, botCamera[i].up, 640, 480, 60);
            if (tempBallPixel.x !=-1 && tempBallPixel.y != -1) {
                botPixelBalls[i] = tempBallPixel;
                botCameraExists[i] = true;
            } else {
                botCameraExists[i] = false;
            }
            bot2DPositions[i] = Qt.vector2d(bot.position.x, bot.position.z);
            if (!isYellow) {
                bBot2DPositions = bBot2DPositions
            } else {
                yBot2DPositions = yBot2DPositions
            }
        }
        return { positions: botPositions, ballContacts: botBallContacts, pixels: botPixelBalls, cameraExists: botCameraExists };
    }

    function updateGameObjects(timestep) 
    {
        isDribble = false;
        let blueBotData = botMovement(false, timestep);
        let yellowBotData = botMovement(true, timestep);
        // if (ball.position.x < 50000) {
        //     tempBall.position = Qt.vector3d(ball.position.x, ball.position.y, ball.position.z);
        //     ballPosition = Qt.vector3d(ball.position.x, -ball.position.z, ball.position.y);
        // } else {
        //     tempBall.position = Qt.vector3d(ballPosition.x, ballPosition.z, -ballPosition.y);
        // }
        if(!isDribble){
            kick_flag = false;
        }
        observer.updateObjects(
            blueBotData.positions, 
            yellowBotData.positions, 
            blueBotData.pixels,
            yellowBotData.pixels,
            blueBotData.cameraExists,
            yellowBotData.cameraExists, 
            blueBotData.ballContacts, 
            yellowBotData.ballContacts,
            ballPosition
        );
        ball2DPosition = Qt.vector2d(ball.position.x, ball.position.z);
        if (teleopVelocity.x != 0 || teleopVelocity.y != 0 || teleopVelocity.z != 0){
            if (!kick_flag) {
                ball.setLinearVelocity(Qt.vector3d(teleopVelocity.x, teleopVelocity.y, teleopVelocity.z));
                let ballFriction = 0.99;
                teleopVelocity = Qt.vector3d(teleopVelocity.x * ballFriction, teleopVelocity.y * ballFriction, teleopVelocity.z * ballFriction);
            } else {
                teleopVelocity = Qt.vector3d(0, 0, 0);
            }
        }
    }

    function syncGameObjects() {
        for (let i = 0; i < bBotNum; i++) {
            let frame = bBotsFrame.children[i];
            let bot = bBotsRepeater.children[i];
            bot.position = Qt.vector3d(frame.position.x, frame.position.y, frame.position.z);
            bot.eulerRotation = Qt.vector3d(frame.eulerRotation.x, frame.eulerRotation.y, frame.eulerRotation.z);
        }
        for (let i = 0; i < yBotNum; i++) {
            let frame = yBotsFrame.children[i];
            let bot = yBotsRepeater.children[i];
            bot.position = Qt.vector3d(frame.position.x, frame.position.y, frame.position.z);
            bot.eulerRotation = Qt.vector3d(frame.eulerRotation.x, frame.eulerRotation.y, frame.eulerRotation.z);
        }
        if (ball.position.x < 50000) {
            tempBall.position = Qt.vector3d(ball.position.x, ball.position.y, ball.position.z);
            ballPosition = Qt.vector3d(ball.position.x, -ball.position.z, ball.position.y);
        } else {
            tempBall.position = Qt.vector3d(ballPosition.x, ballPosition.z, -ballPosition.y);
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

