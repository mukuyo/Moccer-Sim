import QtQuick
import QtQuick3D
import QtQuick.Shapes
import QtQuick.Controls

Item {
    id: setting
    width: windowWidth
    height: windowHeight
    property int tempWindowWidth: observer.windowWidth
    property int tempWindowHeight: observer.windowHeight

    ListModel {
        id: menuModel
        ListElement { label: "Display"; expandValue: 62 }
        ListElement { label: "Physics"; expandValue: 65 }
        ListElement { label: "Geometry"; expandValue: 85 }
        ListElement { label: "Robots"; expandValue: 60 }
        ListElement { label: "Camera"; expandValue: 65 }
        ListElement { label: "Communication"; expandValue: 135 }
    }

    HBMenu {}

    Rectangle {
        id: rightRect
        width: windowWidth / 3
        height: windowHeight
        color: "black"
        opacity: 0.8
        x: windowWidth

        CrossMenu {}

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
            running: false
            NumberAnimation {
                to: windowWidth * 2 / 3
                duration: 1000
                easing.type: Easing.OutCubic
            }
        }
        SequentialAnimation on x {
            id: rightReverseAnim
            running: false
            NumberAnimation {
                to: windowWidth
                duration: 1000
                easing.type: Easing.OutCubic
            }
        }

        Rectangle {
            id: saveButton
            width: windowWidth / 3 - 60
            height: 45
            x: 30
            y: windowHeight - 65
            color: "#8A8F91"
            opacity: 1.0
            radius: 5
            Text {
                anchors.centerIn: parent
                text: "Save"
                font.pixelSize: 18
                color: "white"
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    observer.windowWidth = tempWindowWidth;
                    observer.windowHeight = tempWindowHeight;
                }
            }
        }
    }

    Rectangle {
        id: leftShadowRect
        width: windowWidth * 2 / 3
        height: windowHeight
        color: "black"
        opacity: 0.5
        x: -width

        SequentialAnimation on x {
            id: leftAnim
            running: false
            NumberAnimation {
                to: 0
                duration: 1000
                easing.type: Easing.OutCubic
            }
        }
        SequentialAnimation on x {
            id: leftReverseAnim
            running: false
            NumberAnimation {
                to: -width
                duration: 1000
                easing.type: Easing.OutCubic
            }
        }
    }
}
