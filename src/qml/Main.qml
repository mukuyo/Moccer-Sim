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

    Rectangle {
        id: topLeft
        anchors.fill: parent
        color: "#848895"
        border.color: "black"

        Observe {
            id: observer
        }


        // Timer {
        //     interval: 16
        //     running: true
        //     repeat: true
        //     onTriggered: robot.updateInfo()
        // }

        View3D {
            id: topLeftView
            anchors.fill: parent

            FrameAnimation {
                id: frameUpdater
                running: true
            }
            Node {
                id: originNode
                PerspectiveCamera {
                    id: camera
                    clipFar: 10000
                    clipNear: 1
                    fieldOfView: 90
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
                    if (mouseArea.pressedButtons & Qt.LeftButton) { // Rotate
                        let pan = -(event.x - lastPos.x) * dt * lookSpeed
                        let tilt = (event.y - lastPos.y) * dt * lookSpeed
                        camera.eulerRotation.y += pan
                        camera.eulerRotation.x += tilt
                    } else if (mouseArea.pressedButtons & Qt.RightButton) { // Translate
                        let rx = -(event.x - lastPos.x) * dt * linearSpeed*8
                        let ry = (event.y - lastPos.y) * dt * linearSpeed*8
                        camera.position.x += rx
                        camera.position.y += ry
                    } else if (mouseArea.pressedButtons & Qt.MiddleButton) { // Zoom
                        let rz = (event.y - lastPos.y) * dt * linearSpeed
                        let distance = camera.position.length()
                        if (rz > 0 && distance < zoomLimit) return
                        camera.position.z += rz
                    }
                    lastPos = Qt.point(event.x, event.y)
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
                    id: lighting
                }
                Bot {
                    id: bot
                }
                Wheel {
                    id: wheel
                }
                Field {
                    id: field
                }
            }
        }
    }
}