import QtQuick
import QtQuick.Window
import Qt3D.Extras
import QtQuick.Scene3D
import QtQuick.Controls
import QtQuick3D.Helpers 
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick3D
import Qt3D.Render
import MOC

ApplicationWindow {
    id: window
    title: "Moccer-Sim"
    width: 1280
    height: 720
    visible: true
    Item {
        id: ro
        width: parent.width
        height: parent.height
        focus: true

        Keys.onPressed: (event) => {
            event.accepted = true;  // ⚡ 他の要素にイベントを渡さない
            if (event.key === Qt.Key_W) {
                _ball.velocity.z -= _ball.acceleration;
            } else if (event.key === Qt.Key_S) {
                _ball.velocity.z += _ball.acceleration;
            } else if (event.key === Qt.Key_A) {
                _ball.velocity.x -= _ball.acceleration;
            } else if (event.key === Qt.Key_D) {
                _ball.velocity.x += _ball.acceleration;
            }
        }

        Rectangle {
            id: topLeft
            anchors.fill: parent
            color: "#848895"
            border.color: "black"

            Observe {
                id: observer
            }
            Collision {
                id: collision
            }

            View3D {
                id: topLeftView
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
                        clipFar: 2000
                        clipNear: 10
                        fieldOfView: 60
                        position: Qt.vector3d(0, 300, 400)
                        eulerRotation: Qt.vector3d(-45, 0, 0)
                    }
                }
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    property real dt: 0.001
                    property real linearSpeed: 100
                    property real lookSpeed: 100
                    property real zoomLimit: 0.16
                    property point lastPos
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

                    onPressed: (event) => {
                        lastPos = Qt.point(event.x, event.y)
                    }

                    onPositionChanged: (event) => {
                        let dx = event.x - lastPos.x;
                        let dy = event.y - lastPos.y;

                        if (Math.abs(dx) < 2 && Math.abs(dy) < 2) return;

                        if (mouseArea.pressedButtons & Qt.LeftButton) { // Rotate
                            let pan = -dx * dt * lookSpeed;
                            let tilt = dy * dt * lookSpeed;
                            camera.eulerRotation.y += pan;
                            camera.eulerRotation.x += tilt;
                        } else if (mouseArea.pressedButtons & Qt.RightButton) { // Translate
                            let rx = -dx * dt * linearSpeed * 8;
                            let ry = dy * dt * linearSpeed * 8;
                            camera.position.x += rx;
                            camera.position.y += ry;
                        } else if (mouseArea.pressedButtons & Qt.MiddleButton) { // Zoom
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
                    id: root
                    Lighting {
                        id: _lighting
                    }
                    Bot {
                        id: _bot
                    }
                    Field {
                        id: _field
                    }
                    Ball {
                        id: _ball
                        property vector3d velocity: Qt.vector3d(0, 0, 0)
                        property real acceleration: 0.3
                    }
                    Timer {
                        id: timer
                        interval: 16
                        repeat: true
                        running: true
                        onTriggered: {
                            var flag = collision.ball_check(_ball.position, _bot.blue_bots, _bot.yellow_bots)
                            // console.log(flag)
                            // observer.update()
                            // collision.update()
                        }
                    }
                }
            }
        }
    }
}