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
    // DirectionalLight {
    //     // castsShadow: true
    //     // position: Qt.vector3d(0, -500, 0)
    //     eulerRotation.x: -90
    //     // eulerRotation.y: -70
    // }
    DirectionalLight {
        // castsShadow: true
        // position: Qt.vector3d(0, -500, 0)
        eulerRotation.x: -90
        // eulerRotation.y: -70
        // eulerRotation.z: -45
        // brightness: 0.05
    }
    DirectionalLight {
        eulerRotation.x: -45
        brightness: 0.03
    }
    DirectionalLight {
        eulerRotation.x: -135
        brightness: 0.03
    }
    DirectionalLight {
        eulerRotation.y: 45
        brightness: 0.03
    }
    DirectionalLight {
        eulerRotation.y: -45
        brightness: 0.03
    }
    // DirectionalLight {
    //     // castsShadow: true
    //     // position: Qt.vector3d(0, -500, 0)
    //     eulerRotation.x: -30
    //     eulerRotation.y: 70
    //     brightness: 0.05
    // }
    // DirectionalLight {
    //     castsShadow: true
    //     eulerRotation.x: -30
    //     eulerRotation.y: 70
    // }
}
