import QtQuick
import QtQuick3D
import QtQuick.Shapes

Item {
    id: setting
    width: windowWidth
    height: windowHeight

    ListModel {
        id: menuModel
        ListElement { label: "Display"; expandValue: 62 }
        ListElement { label: "Physics"; expandValue: 65 }
        ListElement { label: "Geometry"; expandValue: 85 }
        ListElement { label: "Robots"; expandValue: 60 }
        ListElement { label: "Camera"; expandValue: 65 }
        ListElement { label: "Communication"; expandValue: 135 }
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
            x: 32
            y: 63
            spacing: 18

            Repeater {
                model: menuModel
                List {
                    label: model.label
                    expandValue: model.expandValue
                }
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
