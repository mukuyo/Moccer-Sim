import QtQuick
import QtQuick3D
import QtQuick.Shapes

Item {
    id: setting
    width: windowWidth
    height: windowHeight

    property real triangleAngle: 0
    // property real lineEnd: 30
    property real rightLineEnd: 30

    ListModel {
        id: menuModel
        ListElement { label: "Display" }
        ListElement { label: "Physics" }
        ListElement { label: "Geometry" }
        ListElement { label: "Robots" }
        ListElement { label: "Camera" }
        ListElement { label: "Communication" }
    }

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

Column {
    x: 49
    y: 54
    spacing: 14

    Repeater {
        model: menuModel
        Text {
            text: model.label
            font.pixelSize: 20
            color: "white"
        }
    }
}

Column {
    x: 32
    y: 63
    spacing: 18

    Repeater {
        model: menuModel
        List {

        }
    }
}
        // List {
        //     x: 32
        //     y: 61
        // }

        // 右パネルのスライドイン
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
