import QtQuick
import QtQuick3D
import QtQuick.Shapes

Item {
    id: triangleContainer
    property real lineEnd: 0
    width: 80
    height: 20
    // x: 32
    // y: 61

    Item {
        id: triangleVisual
        transform: Rotation {
            id: triangleRotation
            origin.x: 4
            origin.y: 4
            axis { x: 0; y: 0; z: 1 }
            angle: triangleAngle
        }

        Shape {
            anchors.fill: parent
            ShapePath {
                strokeWidth: 0
                fillColor: "white"
                PathMove { x: 0; y: 0 }
                PathLine { x: 8; y: 4 }
                PathLine { x: 0; y: 8 }
            }
        }

        NumberAnimation {
            id: lineAnim
            target: triangleContainer
            property: "lineEnd"
            to: 65
            duration: 400
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            id: lineAnimBack
            target: triangleContainer
            property: "lineEnd"
            to: 0
            duration: 400
            easing.type: Easing.InOutQuad
        }
    }
    Shape {
        ShapePath {
            strokeColor: "white"
            strokeWidth: 1
            fillColor: "transparent"

            PathMove { x: 16; y: 16 }
            PathLine { x: 16 + triangleContainer.lineEnd; y: 16 }
        }
    }
    // クリック判定エリア（回転しない）
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: { lineAnim.running = true }
        onExited: { lineAnimBack.running = true }
        onClicked: {
            triangleAnim.from = triangleAngle
            triangleAngle += 90
            if (triangleAngle >= 180) {
                triangleAngle = 0
            }
            triangleAnim.to = triangleAngle
            triangleAnim.running = true
        }
        cursorShape: Qt.PointingHandCursor
    }

    NumberAnimation {
        id: triangleAnim
        target: triangleRotation
        property: "angle"
        duration: 500
        easing.type: Easing.InOutQuad
    }
}