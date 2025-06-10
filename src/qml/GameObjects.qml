import QtQuick
import QtQuick3D
import Qt3D.Render
import Qt3D.Extras
import QtQuick3D.Physics
import Qt.labs.folderlistmodel
import MOC

import "../../assets/models/bot/blue/viz/Rione" as BlueBody
import "../../assets/models/bot/blue/rigid_body" as BlueLightBody
import "../../assets/models/bot/blue/viz/Rione" as YellowBody
import "../../assets/models/bot/blue/rigid_body" as YellowLightBody
import "../../assets/models/ball/"
import "../../assets/models/circle/ball/"


Node {
    id: robotNode
    property real bBotNum: observer.blueRobotCount
    property real yBotNum: observer.yellowRobotCount

    property real wheelRadius: 8.15
    property real angle0: 0
    property real angle1: 0
    property real angle2: 0
    property real angle3: 0

    property real pre_x: 0
    property real pre_y: 0
    property real pre_theta: 0

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
    property var bBotsCamera: []

    property var yBotRadians: new Array(16).fill(0)
    property var yBotVelNormals: new Array(16).fill(0.0)
    property var yBotVelTangents: new Array(16).fill(0.0)
    property var yBotVelAngulars: new Array(16).fill(0.0)
    property var yBotKickspeeds: new Array(16).fill(Qt.vector3d(0, 0, 0))
    property var yBotSpinners: new Array(16).fill(0.0)
    property var yBotDistanceBall: new Array(16).fill(0.0)
    property var yBotRadianBall: new Array(16).fill(0.0)
    property var yBotsCamera: []

    property real radianOffset: -Math.atan(350.0/547.72)
    property var objName: ""
    property real botCursorID: 0
    property var kick_flag: false

    function lerp(start, end, alpha) {
        return start * (1 - alpha) + end * alpha;
    }

    Connections {
        target: observer
        function onBlueRobotsChanged() {
            for (var i = 0; i < bBotNum; i++) {
                let bot = bBotsRepeater.children[i];
                bBotVelNormals[i] = observer.blue_robots[i].velnormal;
                bBotVelTangents[i] = -observer.blue_robots[i].veltangent;
                bBotVelAngulars[i] = observer.blue_robots[i].velangular;
                bBotKickspeeds[i] = Qt.vector3d(observer.blue_robots[i].kickspeedx, observer.blue_robots[i].kickspeedz, observer.blue_robots[i].kickspeedx);
                bBotSpinners[i] = observer.blue_robots[i].spinner;
            }
        }
        function onYellowRobotsChanged() {
            for (var i = 0; i < yBotNum; i++) {
                let bot = yBotsRepeater.children[i];
                yBotVelNormals[i] = observer.yellow_robots[i].velnormal;
                yBotVelTangents[i] = -observer.yellow_robots[i].veltangent;
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
            linearAxisLock: DynamicRigidBody.LockY
            physicsMaterial: robotMaterial
            position: Qt.vector3d(bBotsPos[index].x, 0, bBotsPos[index].z)
            sendContactReports: true
            collisionShapes: [
                ConvexMeshShape {
                    source: "../../assets/models/bot/blue/rigid_body/meshes/body.cooked.cvx"
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../assets/models/bot/blue/rigid_body/meshes/centerLeft.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../assets/models/bot/blue/rigid_body/meshes/centerRight.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../assets/models/bot/blue/rigid_body/meshes/dribbler.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape {
                    source: "../../assets/models/bot/blue/rigid_body/meshes/chip.cooked.cvx" 
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
            physicsMaterial: robotMaterial
            position: Qt.vector3d(yBotsPos[index].x, 0, yBotsPos[index].z)
            sendContactReports: true
            collisionShapes: [
                ConvexMeshShape {
                    source: "../../assets/models/bot/blue/rigid_body/meshes/body.cooked.cvx"
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../assets/models/bot/blue/rigid_body/meshes/centerLeft.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../assets/models/bot/blue/rigid_body/meshes/centerRight.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape { 
                    source: "../../assets/models/bot/blue/rigid_body/meshes/dribbler.cooked.cvx" 
                    eulerRotation: Qt.vector3d(-90, 0, 0)
                },
                ConvexMeshShape {
                    source: "../../assets/models/bot/blue/rigid_body/meshes/chip.cooked.cvx" 
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
            BlueBody.Rione {
                visible: !observer.lightWeightMode
                eulerRotation: Qt.vector3d(-90, 0, 0)
                position: Qt.vector3d(0, 0, 0)
            }
            BlueLightBody.Frame {
                visible: observer.lightWeightMode
                eulerRotation: Qt.vector3d(-90, 0, 0)
                position: Qt.vector3d(0, 0, 0)
            }
            PerspectiveCamera {
                id: pCamera
                position: Qt.vector3d(0, 90, -70)
                clipFar: 20000
                clipNear: 1
                fieldOfView: 60
                eulerRotation: Qt.vector3d(-35, 0, 0)
                Component.onCompleted: {
                    bBotsCamera.push(pCamera);
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
                scale: Qt.vector3d(0.5, 0.14, 0.5)
                position: Qt.vector3d(0, 128, 0)
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
                    scale: Qt.vector3d(0.4, 0.14, 0.4)
                    position: {
                        var offsets = [
                            Qt.vector3d(65*Math.cos(Math.PI-radianOffset-bBotRadians[index]), 0, 65*Math.sin(Math.PI-radianOffset-bBotRadians[index])),  // Left Up
                            Qt.vector3d(65*Math.cos(Math.PI/2.0-radianOffset-bBotRadians[index]), 0, 65*Math.sin(Math.PI/2.0-radianOffset-bBotRadians[index])), // Left Down
                            Qt.vector3d(65*Math.cos(Math.PI/2.0+radianOffset-bBotRadians[index]), 0, 65*Math.sin(Math.PI/2.0+radianOffset-bBotRadians[index])), // Right Down
                            Qt.vector3d(65*Math.cos(radianOffset-bBotRadians[index]), 0, 65*Math.sin(radianOffset-bBotRadians[index]))   // Right Up
                        ];
                        return Qt.vector3d(
                            offsets[index].x,
                            128,
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
            YellowBody.Rione {
                visible: !observer.lightWeightMode
                eulerRotation: Qt.vector3d(-90, 0, 0)
                position: Qt.vector3d(0, 0, 0)
            }
            YellowLightBody.Frame {
                visible: observer.lightWeightMode
                eulerRotation: Qt.vector3d(-90, 0, 0)
                position: Qt.vector3d(0, 0, 0)
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
                scale: Qt.vector3d(0.5, 0.14, 0.5)
                position: Qt.vector3d(0, 128, 0)
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
                    scale: Qt.vector3d(0.4, 0.14, 0.4)
                    position: {
                        var offsets = [
                            Qt.vector3d(65*Math.cos(Math.PI-radianOffset-yBotRadians[index]), 0, 65*Math.sin(Math.PI-radianOffset-yBotRadians[index])), // Left Up
                            Qt.vector3d(65*Math.cos(Math.PI/2.0-radianOffset-yBotRadians[index]), 0, 65*Math.sin(Math.PI/2.0-radianOffset-yBotRadians[index])), // Left Down
                            Qt.vector3d(65*Math.cos(Math.PI/2.0+radianOffset-yBotRadians[index]), 0, 65*Math.sin(Math.PI/2.0+radianOffset-yBotRadians[index])), // Right Down
                            Qt.vector3d(65*Math.cos(radianOffset-yBotRadians[index]), 0, 65*Math.sin(radianOffset-yBotRadians[index]))   // Right Up
                        ];
                        return Qt.vector3d(
                            offsets[index].x,
                            128,
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
        staticFriction: 0.15
        dynamicFriction: 0.15
        restitution: 0
    }
    DynamicRigidBody {
        id: ball
        position: Qt.vector3d(0, 500, 0)
        physicsMaterial: ballMaterial
        collisionShapes: [
            ConvexMeshShape {
                id: ballShape
                source: "../../assets/models/ball/meshes/ball.cooked.cvx"
            }
        ]
        Ball {}
    }

    function resetBallPosition(result) {
        teleopVelocity = Qt.vector3d(0, 0, 0);
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
            bBotsFrame.children[botCursorID].reset(scenePosition, Qt.vector3d(0, -90, 0));
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

    function worldToScreen(worldPosition) {
        // 4次元ベクトルを作る
        let pos = Qt.vector4d(worldPosition.x, worldPosition.y, worldPosition.z, 1.0);

        // カメラのView行列とProjection行列
        let viewMatrix = camera.viewMatrix;
        let projectionMatrix = camera.projectionMatrix;

        // ViewProjection変換
        let clipSpacePos = projectionMatrix.times(viewMatrix.times(pos));

        // Clip Space → NDC (Normalized Device Coordinates)
        let ndc = Qt.vector3d(
            clipSpacePos.x / clipSpacePos.w,
            clipSpacePos.y / clipSpacePos.w,
            clipSpacePos.z / clipSpacePos.w
        );

        // NDC → スクリーン座標（ピクセル）
        let screenX = (ndc.x * 0.5 + 0.5) * viewport.width;
        let screenY = (1.0 - (ndc.y * 0.5 + 0.5)) * viewport.height; // Y軸は反転

        return Qt.point(screenX, screenY);
    }
    function botMovement(isYellow) {
        let botPositions = []
        let botBallContacts = []
        let ballPixels = []

        let botNum = isYellow ? yBotNum : bBotNum;
        let botFrame = isYellow ? yBotsFrame : bBotsFrame;
        let botRepeater = isYellow ? yBotsRepeater : bBotsRepeater;
        let botVelNormals = isYellow ? yBotVelNormals : bBotVelNormals;
        let botVelTangents = isYellow ? yBotVelTangents : bBotVelTangents;
        let botVelAngulars = isYellow ? yBotVelAngulars : bBotVelAngulars;
        let botKickspeeds = isYellow ? yBotKickspeeds : bBotKickspeeds;
        let botSpinners = isYellow ? yBotSpinners : bBotSpinners;
        let botPixelBalls = isYellow ? window.yBotPixelBalls : window.bBotPixelBalls;
        let botIDTexts = isYellow ? yBotIDTexts : bBotIDTexts;

        for (let i = 0; i < botNum; i++) {
            let frame = botFrame.children[i];
            let bot = botRepeater.children[i];
            let radian = bot.eulerRotation.y * Math.PI / 180.0;
            let botDistanceBall = Math.sqrt(Math.pow(bot.position.x - ball.position.x, 2) + Math.pow(bot.position.y - ball.position.y, 2) + Math.pow(bot.position.z - ball.position.z, 2));
            let botRadianBall = -normalizeRadian(Math.atan2(bot.position.z-ball.position.z, bot.position.x-ball.position.x)-Math.PI/2);

            frame.setLinearVelocity(Qt.vector3d(-botVelNormals[i]*Math.cos(radian) + botVelTangents[i]*Math.sin(radian), 0,  botVelNormals[i]*Math.sin(radian) +  botVelTangents[i]*Math.cos(radian)));
            frame.setAngularVelocity(Qt.vector3d(0, botVelAngulars[i], 0));
            if (frame.eulerRotation.x > 0 || frame.eulerRotation.z > 0)
                frame.eulerRotation = Qt.vector3d(0, frame.eulerRotation.y, 0);
            bot.position = Qt.vector3d(frame.position.x, frame.position.y, frame.position.z);
            bot.eulerRotation = Qt.vector3d(frame.eulerRotation.x, frame.eulerRotation.y, frame.eulerRotation.z);
            botPositions.push(Qt.vector3d(frame.position.x, -frame.position.z, frame.eulerRotation.y+90));

            if (botDistanceBall < 120 && Math.abs(normalizeRadian(botRadianBall - radian)) < Math.PI/15.0) {
                botBallContacts.push(true);
                if (botSpinners[i] > 0 && (botKickspeeds[i].x == 0 && botKickspeeds[i].y == 0)) {
                    let ballRadian = -bot.eulerRotation.y * Math.PI / 180.0 - Math.PI/2
                    ball.simulationEnabled = false;
                    ball.reset(Qt.vector3d(frame.position.x+90*Math.cos(ballRadian), 25, frame.position.z+90*Math.sin(ballRadian)), Qt.vector3d(0, 0, 0));
                } else {
                    ball.simulationEnabled = true;
                }

                if (botKickspeeds[i].x != 0 || botKickspeeds[i].y != 0) {
                    kick_flag = true;
                    ball.setLinearVelocity(Qt.vector3d(botKickspeeds[i].x*Math.cos(radian + Math.PI/2), botKickspeeds[i].y, botKickspeeds[i].x*Math.sin(radian - Math.PI/2)));
                }
            } else {
                botBallContacts.push(false);
                ball.simulationEnabled = true;
            }
            let frame2D = camera.projectToScreen(
                Qt.vector3d(frame.position.x-15, frame.position.y + 128, frame.position.z-86.5),
                worldCamera.position,
                worldCamera.forward,
                worldCamera.up,
                windowWidth,
                windowHeight,
                worldCamera.fieldOfView,
                1.0,
                20000
            );
            if (i >= 10) {
                botIDTexts.children[i].x = frame2D.x - 5;
            } else {
                botIDTexts.children[i].x = frame2D.x - 2;
            }
            botIDTexts.children[i].y = frame2D.y - 14;
            
            // if (!isYellow) {
            //     let cameraPosition = Qt.vector3d(-70*Math.sin(radian)+frame.position.x, bBotsCamera[i].position.y + frame.position.y, -70*Math.cos(radian)+frame.position.z);
            //     botPixelBalls[i] = camera.getBallPosition(ball.position, cameraPosition, bBotsCamera[i].forward, bBotsCamera[i].up, 640, 480, 60);
            // }
        }
        return { positions: botPositions, ballContacts: botBallContacts, pixels: botPixelBalls };
    }
    Camera {
        id: camera
    }

    function updateGameObjects(timestep) 
    {
        let blueBotData = botMovement(false);
        let yellowBotData = botMovement(true);

        let ballPosition = Qt.vector3d(ball.position.x, -ball.position.z, ball.position.y);
        observer.updateObjects(blueBotData.positions, yellowBotData.positions, blueBotData.ballContacts, yellowBotData.ballContacts, ballPosition);
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
        
    //    const camObj = bBotsRepeater.itemAt(1).findChild(PerspectiveCamera);
        // view3D.camera = bBotsCamera[0];

    }
}

