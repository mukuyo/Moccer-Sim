import QtQuick
import QtQuick3D

Node {
    id: lightRoot

    DirectionalLight {
        // castsShadow: true
        eulerRotation.x: -90
        brightness: 2.0
    }
    // DirectionalLight {
    //     // castsShadow: true
    //     eulerRotation.x: -90
    // }
    // DirectionalLight {
    //     // castsShadow: true
    //     eulerRotation.x: 60
    // }
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
}
