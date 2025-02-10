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
    title: "Moccer"
    width: 1280
    height: 720
    visible: true

    Rectangle {
        id: topLeft
        anchors.fill: parent
        color: "#848895"
        border.color: "black"

        Robot {
            id: robot
        }

        Timer {
            interval: 16
            running: true
            repeat: true
            onTriggered: robot.updateInfo()
        }

        View3D {
            id: topLeftView
            anchors.fill: parent
            FrameAnimation {
                id: frameUpdater
                running: true
            }
            Node {
                id: originNode
                // position: Qt.vector3d(0, -500, 500)
                eulerRotation: Qt.vector3d(40, 90, 0)
                PerspectiveCamera {
                    id: cameraNode
                    clipFar: 10000
                    clipNear: 1
                    fieldOfView: 60
                    position: Qt.vector3d(0, -100, 400)
                    // eulerRotation.x: 40
                }
            }
            OrbitCameraController {
                origin: originNode
                camera: cameraNode
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