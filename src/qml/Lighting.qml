import QtQuick
import QtQuick3D

Node {
    id: lightRoot

    // PointLight {
    //     id: light1
    //     position: Qt.vector3d(100, 500, 0)
    // }
    // PointLight {
    //     id: light2
    //     position: Qt.vector3d(-100, 500, 0)
    // }
    // PointLight {
    //     id: light3
    //     position: Qt.vector3d(0, -500, 0)
    // }
    DirectionalLight {
        eulerRotation.x: -30
        eulerRotation.y: -70
    }
}
