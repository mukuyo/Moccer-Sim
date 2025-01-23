
import QtQuick
import QtQuick.Window
import Qt3D.Extras
import QtQuick.Scene3D
import QtQuick.Controls
import QtQuick3D.Helpers 
import QtQuick.Layouts
import QtQuick.Dialogs
import QtQuick3D
import MOC

ApplicationWindow {
    id: window
    title: "Moccer"
    width: 1280
    height: 720
    visible: true

    Rectangle {
        id: topLeft
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width 
        height: parent.height
        color: "#848895"
        border.color: "black"

        View3D {
            id: topLeftView
            anchors.fill: parent

            // Camera Setting
            Node {
                id: originNode
                PerspectiveCamera {
                    id: cameraNode
                    clipFar: 1000
                    clipNear: 10
                    fieldOfView: 60
                    position: Qt.vector3d(0, 0, 100)
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
                Wheel {
                    id: wheel
                }
                Bot {
                    id: robot
                }
                Field {
                    id: field
                }
            }
        }
    }
}
