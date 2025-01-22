
import QtQuick
import QtQuick.Window

import Qt3D.Extras
import QtQuick.Scene3D
import QtQuick.Controls

import QtQuick3D.Helpers 

import QtQuick.Layouts
import QtQuick.Dialogs

// import Qt3D.Core
// import Qt3D.Render
import QtQuick3D
// import Qt3D.Input

ApplicationWindow {
    id: window
    title: "Moccer"
    width: 1280
    height: 720
    
    visible: true

    // The root scene
    Node {
        id: standAloneScene

        DirectionalLight {
            ambientColor: Qt.rgba(1.0, 1.0, 1.0, 1.0)
        }


        Node {
            id: airplaneRoot

            scale: Qt.vector3d(1000, 1000, 1000)
            Side {

            }
        }

        // AxisHelper {
        //     id: axisHelper
        // }



        // // The predefined cameras. They have to be part of the scene, i.e. inside the root node.
        // // Animated perspective camera
        // Node {
        //     PerspectiveCamera {
        //         id: cameraPerspectiveOne
        //         z: 600
        //     }

        //     PropertyAnimation on eulerRotation.x {
        //         loops: Animation.Infinite
        //         duration: 5000
        //         to: -360
        //         from: 0
        //     }
        // }

        // // Stationary perspective camera
        // PerspectiveCamera {
        //     id: cameraPerspectiveTwo
        //     z: 600
        // }

        // // Second animated perspective camera
        // Node {
        //     PerspectiveCamera {
        //         id: cameraPerspectiveThree
        //         x: 500
        //         eulerRotation.y: 90
        //     }
        //     PropertyAnimation on eulerRotation.y {
        //         loops: Animation.Infinite
        //         duration: 5000
        //         to: 0
        //         from: -360
        //     }
        // }

        // // Stationary orthographic camera viewing from the top
        // OrthographicCamera {
        //     id: cameraOrthographicTop
        //     y: 600
        //     eulerRotation.x: -90
        // }

        // Stationary orthographic camera viewing from the front
// View3D {
//     camera: cameraNode
//     Node {
//         id: originNode
//         PerspectiveCamera {
//             id: cameraNode
//             z: 100
//         }
//     }
//     OrbitCameraController {
//         anchors.fill: parent
//         origin: originNode
//         camera: cameraNode
//     }
// }
        // camera: cameraNode
        // // Stationary orthographic camera viewing from left
        // OrthographicCamera {
        //     id: cameraOrthographicLeft
        //     x: -600
        //     eulerRotation.y: -90
        // }
        // OrbitCameraController {
        //     // anchors.fill: parent
        //     origin: standAloneScene
        //     camera: cameraOrthographicLeft
        //     mouseEnabled: true
        //     panEnabled: true
        //     xSpeed: 0.5
        // }


        // Camera
        // {
        //     id: camera
        //     projectionType: CameraLens.PerspectiveProjection
        //     fieldOfView: 30
        //     aspectRatio: 16/9
        //     nearPlane : 0.1
        //     farPlane : 1000.0
        //     position: Qt.vector3d( 10.0, 0.0, 0.0 )
        //     upVector: Qt.vector3d( 0.0, 1.0, 0.0 )
        //     viewCenter: Qt.vector3d( 0.0, 0.0, 0.0 )
        // }

        // OrbitCameraController
        // {
        //     camera: camera
        // }
    }

    // The views
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
                importScene: standAloneScene
                // camera: CustomCamera

                Node {
                    id: originNode
                    PerspectiveCamera {
                        id: cameraNode
                        z: 100
                    }
                    // CustomCamera {
                    //     id: custom
                    //     position: Qt.vector3d(0, 200, 300)
                    //     eulerRotation.x: -30

                    //     property real near: 10.0
                    //     property real far: 10000.0
                    //     property real fov: 60.0 * Math.PI / 180.0
                    //     projection: Qt.matrix4x4(Math.cos(fov / 2) / Math.sin(fov / 2) * (window.height / window.width), 0, 0, 0,
                    //                             0, Math.cos(fov / 2) / Math.sin(fov / 2), 0, 0,
                    //                             0, 0, -(near + far) / (far - near), -(2.0 * near * far) / (far - near),
                    //                             0, 0, -1, 0);
                    // }
                }
                OrbitCameraController {
                    // anchors.fill: parent
                    origin: originNode
                    camera: cameraNode
                    // mouseEnabled: true
                    // panEnabled: true
                }
            
        }

        Label {
            text: "Front"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 10
            color: "#222840"
            font.pointSize: 14
        }
    }

//     Rectangle {
//         id: topRight
//         anchors.top: parent.top
//         anchors.right: parent.right
//         width: parent.width * 0.5
//         height: parent.height * 0.5
//         color: "transparent"
//         border.color: "black"

//         Label {
//             text: "Perspective"
//             anchors.top: parent.top
//             anchors.right: parent.right
//             anchors.margins: 10
//             color: "#222840"
//             font.pointSize: 14
//         }

//         View3D {
//             id: topRightView
//             anchors.top: parent.top
//             anchors.right: parent.right
//             anchors.left: parent.left
//             anchors.bottom: parent.bottom;
//             camera: cameraPerspectiveOne
//             importScene: standAloneScene
//             renderMode: View3D.Underlay

//             environment: SceneEnvironment {
//                 clearColor: "#848895"
//                 backgroundMode: SceneEnvironment.Color
//             }
//         }

//         Row {
//             id: controlsContainer
//             anchors.bottom: parent.bottom
//             anchors.horizontalCenter: parent.horizontalCenter
//             spacing: 10
//             padding: 10

//             RoundButton {
//                 text: "Camera 1"
//                 highlighted: topRightView.camera == cameraPerspectiveOne
//                 onClicked: {
//                     topRightView.camera = cameraPerspectiveOne
//                 }
//             }
//             RoundButton {
//                 text: "Camera 2"
//                 highlighted: topRightView.camera == cameraPerspectiveTwo
//                 onClicked: {
//                     topRightView.camera = cameraPerspectiveTwo
//                 }
//             }
//             RoundButton {
//                 text: "Camera 3"
//                 highlighted: topRightView.camera == cameraPerspectiveThree
//                 onClicked: {
//                     topRightView.camera = cameraPerspectiveThree
//                 }
//             }
//         }
//     }

//     Rectangle {
//         id: bottomLeft
//         anchors.bottom: parent.bottom
//         anchors.left: parent.left
//         width: parent.width * 0.5
//         height: parent.height * 0.5
//         color: "#848895"
//         border.color: "black"

//         View3D {
//             id: bottomLeftView
//             anchors.fill: parent
//             importScene: standAloneScene
//             camera: cameraOrthographicTop
//         }

//         Label {
//             text: "Top"
//             anchors.top: parent.top
//             anchors.left: parent.left
//             anchors.margins: 10
//             color: "#222840"
//             font.pointSize: 14
//         }
//     }

//     Rectangle {
//         id: bottomRight
//         anchors.bottom: parent.bottom
//         anchors.right: parent.right
//         width: parent.width * 0.5
//         height: parent.height * 0.5
//         color: "#848895"
//         border.color: "black"

//         View3D {
//             id: bottomRightView
//             anchors.fill: parent
//             importScene: standAloneScene
//             camera: cameraOrthographicLeft
//         }

//         Label {
//             text: "Left"
//             anchors.top: parent.top
//             anchors.right: parent.right
//             anchors.margins: 10
//             color: "#222840"
//             font.pointSize: 14
//         }
//     }
}