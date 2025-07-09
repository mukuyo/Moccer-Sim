import QtQuick
import QtQuick3D
import QtQuick.Shapes
import QtQuick.Controls

Item {
    id: paint
    width: windowWidth
    height: windowHeight
    property int dispX: windowWidth / 3
    property int dispY: windowHeight - 220
    property int dispWidth: windowWidth / 3
    property int dispHeight: 200

    Rectangle {
        x: dispX
        y: dispY
        width: dispWidth
        height: dispHeight
        color: "black"
        opacity: 0.2
    }
    Rectangle {
        x: dispX
        y: dispY
        width: 2
        height: 16
        color: "transparent"
        border.color: "white"
        border.width: 2
    }
    Rectangle {
        x: dispX
        y: dispY
        width: 16
        height: 2
        color: "transparent"
        border.color: "white"
        border.width: 2
    }
    Rectangle {
        x: dispX
        y: dispY + dispHeight - 16
        width: 2
        height: 16
        color: "transparent"
        border.color: "white"
        border.width: 2
    }
    Rectangle {
        x: dispX
        y: dispY + dispHeight
        width: 16
        height: 2
        color: "transparent"
        border.color: "white"
        border.width: 2
    }
    Rectangle {
        x: dispX + dispWidth - 16
        y: dispY
        width: 16
        height: 2
        color: "transparent"
        border.color: "white"
        border.width: 2
    }
    Rectangle {
        x: dispX + dispWidth - 2
        y: dispY
        width: 2
        height: 16
        color: "transparent"
        border.color: "white"
        border.width: 2
    }
    Rectangle {
        x: dispX + dispWidth - 16
        y: dispY + dispHeight - 2
        width: 16
        height: 2
        color: "transparent"
        border.color: "white"
        border.width: 2
    }
    Rectangle {
        x: dispX + dispWidth - 2
        y: dispY + dispHeight - 16
        width: 2
        height: 16
        color: "transparent"
        border.color: "white"
        border.width: 2
    }
}