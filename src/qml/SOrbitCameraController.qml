import QtQuick3D
import QtQuick
import Qt3D.Input

Node {
    id: root
    property PerspectiveCamera camera
    property real dt: 0.001
    property real linearSpeed: 1
    property real lookSpeed: 500
    property real zoomLimit: 0.16

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        property point lastPos
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton

        onPressed: (event) => {
            lastPos = Qt.point(event.x, event.y)
        }

        onPositionChanged: (event) => {
            if (mouseArea.pressedButtons & Qt.LeftButton) { // Rotate
                let pan = -(event.x - lastPos.x) * dt * lookSpeed
                let tilt = (event.y - lastPos.y) * dt * lookSpeed
                rotateCamera(pan, tilt)
            } else if (mouseArea.pressedButtons & Qt.RightButton) { // Translate
                let rx = -(event.x - lastPos.x) * dt * linearSpeed
                let ry = (event.y - lastPos.y) * dt * linearSpeed
                camera.position.x += rx
                camera.position.y += ry
            } else if (mouseArea.pressedButtons & Qt.MiddleButton) { // Zoom
                let rz = (event.y - lastPos.y) * dt * linearSpeed
                zoom(rz)
            }
            lastPos = Qt.point(event.x, event.y)
        }

        onWheel: (wheel) => {
            let rz = wheel.angleDelta.y * dt * linearSpeed
            zoom(rz)
        }
    }

    function rotateCamera(pan, tilt) {
        camera.eulerRotation.y += pan
        camera.eulerRotation.x += tilt
    }

    function zoom(rz) {
        let distance = camera.position.length()
        if (rz > 0 && distance < zoomLimit) return
        camera.position.z += rz
    }
}
