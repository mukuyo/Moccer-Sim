import QtQuick
import QtQuick.Window
import Qt3D.Extras
import QtQuick.Scene3D
import QtQuick.Controls
import QtQuick3D.Helpers 
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick3D
import QtQuick3D.Physics
import Qt3D.Render
import MOC

Window {
    id: window
    title: "Moccer-Sim"
    width: 1280
    height: 720
    // width: Screen.width
    // height: Screen.height
    visible: true
    flags: Qt.ExpandedClientAreaHint | Qt.NoTitleBarBackgroundHint

    Item {
        width: parent.width
        height: parent.height
        focus: true

        PhysicsWorld {
            scene: viewport.scene
            maximumTimestep: 16.667
            enableCCD: true
            gravity: Qt.vector3d(0, -9810, 0)
            typicalLength: 1000
            typicalSpeed: 10000
            defaultDensity: 1.0
            // forceDebugDraw: true
        }

        Keys.onPressed: (event) => {
            event.accepted = true;
            if (event.key === Qt.Key_W) {
                game_objects.velocity.z += -game_objects.acceleration;
            } else if (event.key === Qt.Key_S) {
                game_objects.velocity.z += game_objects.acceleration;
            } else if (event.key === Qt.Key_A) {
                game_objects.velocity.x += -game_objects.acceleration;
            } else if (event.key === Qt.Key_D) {
                game_objects.velocity.x += game_objects.acceleration;
            }
        }

        Rectangle {
            anchors.fill: parent
            color: "#848895"
            border.color: "black"

            Observe {
                id: observer
            }

            View3D {
                id: viewport
                anchors.fill: parent
                renderMode: View3D.Offscreen

                FrameAnimation {
                    id: frameUpdater
                    running: true
                }
                Node {
                    id: originNode
                    PerspectiveCamera {
                        id: camera
                        clipFar: 20000
                        clipNear: 1
                        fieldOfView: 60
                        position: Qt.vector3d(0, 5000, 7000)
                        eulerRotation: Qt.vector3d(-47, 0, 0)
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    property real dt: 0.001
                    property real linearSpeed: 2000
                    property real lookSpeed: 100
                    property real zoomLimit: 0.16
                    property point lastPos
                    property point clickPos
                    property bool isDraggingWindow: false
                    property bool selectView: false
                    property bool selectBot: false
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                    onPressed: (event) => {
                        lastPos = Qt.point(event.x, event.y)
                        clickPos = Qt.point(event.x, event.y);
                        isDraggingWindow = (event.y < 25);
                        if (event.button === Qt.RightButton) {
                            game_objects.resetBallPosition(viewport.pick(event.x, event.y));
                        }
                    }
                    onReleased: (event) => {
                        selectBot = false;
                        selectView = false;
                        isDraggingWindow = false;
                    }
                    onPositionChanged: (event) => {
                        let clickDx = event.x - clickPos.x;
                        let clickDy = event.y - clickPos.y;
                        
                        if (isDraggingWindow) {
                            window.x += clickDx
                            window.y += clickDy
                        }
                        let dx = event.x - lastPos.x;
                        let dy = event.y - lastPos.y;
                        
                        let results = viewport.pickAll(event.x, event.y);
                        for (let i = 0; i < results.length; i++) {
                            if (results[i].objectHit.objectName.startsWith("b") || results[i].objectHit.objectName.startsWith("y")) {
                                selectBot = true;
                            }
                        }
                        if (selectBot && !selectView) {
                            game_objects.resetBotPosition(results);
                            return;
                        } else {
                            selectView = true;
                        }

                        if (Math.abs(dx) < 2 && Math.abs(dy) < 2) return;

                        if ((mouseArea.pressedButtons & Qt.LeftButton) && (event.modifiers & Qt.ControlModifier)) { // Rotate
                            let rx = dx * dt * linearSpeed * 8;
                            let ry = -dy * dt * linearSpeed * 8;
                            let rz = dy * dt * linearSpeed * 8;

                            let forward = camera.forward
                            let right = camera.right
                            let distance = camera.position.length()

                            camera.position.x += rx * right.x + rz * forward.x
                            camera.position.y += ry;
                            camera.position.z += rx * right.z + rz * forward.z
                        } else if (mouseArea.pressedButtons & Qt.LeftButton) {
                            let pan = -dx * dt * lookSpeed;
                            let tilt = dy * dt * lookSpeed;
                            camera.eulerRotation.y += pan;
                            camera.eulerRotation.x += tilt;
                        } else if (mouseArea.pressedButtons & Qt.MiddleButton) {
                            let rz = dy * dt * linearSpeed;
                            let distance = camera.position.length();
                            if (rz > 0 && distance < zoomLimit) return;
                            camera.position.z += rz;
                        }
                        lastPos = Qt.point(event.x, event.y);
                    }

                    onWheel: (wheel) => {
                        let rz = wheel.angleDelta.y * dt * linearSpeed
                        let rx = -wheel.angleDelta.x * dt * linearSpeed

                        let forward = camera.forward
                        let right = camera.right
                        let distance = camera.position.length()

                        if (rz > 0 && distance < zoomLimit) return

                        camera.position.x += rx * right.x + rz * forward.x
                        camera.position.z += rx * right.z + rz * forward.z
                    }
                }
                Node {
                    id: node
                    Lighting {}
                    Field {}
                    GameObjects {
                        id: game_objects
                        property vector3d velocity: Qt.vector3d(0, 0, 0)
                        property real acceleration: 40.0
                        property var field_cursor : Qt.vector3d(0, 0, 0)
                    }
                }
            }
        }
    }
}