import QtQuick
import QtQuick3D

Node {
    id: lightRoot

    DirectionalLight {
        eulerRotation.x: -90
        brightness: 2.0
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
}
