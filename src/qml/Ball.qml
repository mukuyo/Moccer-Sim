import QtQuick
import QtQuick3D
import MOC

import "../../assets/models/ball/"

Node {
    id: ballNode

    property var position: Qt.vector3d(0, 2.3, 0)
    
    Ball {
        id: ball
        position: Qt.vector3d(0, 2.3, 0)
    }
}