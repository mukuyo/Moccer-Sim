import QtQuick
import QtQuick3D
import QtQuick.Shapes

Item {
    id: setting
    width: windowWidth
    height: windowHeight

    Rectangle {
        id: leftRect
        width: windowWidth * 2 / 3
        height: windowHeight
        color: "black"
        opacity: 0.5
        x: -width

        SequentialAnimation on x {
            id: leftAnim
            running: true
            NumberAnimation {
                to: 0
                duration: 1000
                easing.type: Easing.OutCubic
            }
        }
    }

    Rectangle {
        id: rightRect
        width: windowWidth / 3
        height: windowHeight
        color: "black"
        opacity: 0.8
        x: windowWidth

        Text {
            id: settingText
            x: 15
            y: 5
            text: "Setting"
            font.pixelSize: 27
            color: "white"
        }
        Text {
            id: windowText
            x: 45
            y: 52
            text: "Window"
            font.pixelSize: 20
            color: "white"
        }
        // Text {
        //     id: windowToggle
        //     x: 30
        //     y: 52
        //     text: "▶"
        //     font.pixelSize: 15
        //     color: "white"
        // }
Shape {
    // width: 100
    // height: 100
    x: 35
    y: 57

    ShapePath {
        strokeWidth: 1
        strokeColor: "white"
        fillColor: "white"

        PathMove { x: 0; y: 0 }
        PathLine { x: 10; y: 6.25 }
        PathLine { x: 0; y: 12.5 }
    }
}

        SequentialAnimation on x {
            id: rightAnim
            running: true
            NumberAnimation {
                to: windowWidth * 2 / 3
                duration: 1000
                easing.type: Easing.OutCubic
            }
        }
    }
}
