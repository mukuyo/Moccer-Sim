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

        View3D {
            id: topLeftView
            anchors.fill: parent
            FrameAnimation {
                id: frameUpdater
                running: true
            }
            // Camera Setting
            Node {
                id: originNode
                PerspectiveCamera {
                    id: cameraNode
                    clipFar: 1000
                    clipNear: 10
                    fieldOfView: 60
                    position: Qt.vector3d(0, 20, 100)
                    eulerRotation.x: -30
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
                Robot {
                    id: robot
                }
                Timer {
                    interval: 16  // 16msごとに更新 (約60FPS)
                    running: true
                    repeat: true
                    onTriggered: robot.updateWheelSpeeds()
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