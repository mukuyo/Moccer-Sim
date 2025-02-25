import QtQuick
import QtQuick3D
import MOC

import "../../assets/models/ball/"

Node {
    id: ballNode

    Ball {
        id: ball
        position: Qt.vector3d(0, 2.3, 0)
    }
}