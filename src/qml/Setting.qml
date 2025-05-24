import QtQuick
import QtQuick3D
import QtQuick.Shapes
import QtQuick 2.15
import QtQuick.Controls 2.15

import QtQuick 2.15
import QtQuick.Controls 2.15

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
    Item {
        id: menuContainer
        x: windowWidth - 40
        width: 40
        height: 40

        Rectangle {
            x: 5
            y: 10
            width: 25
            height: 3
            radius: 2
            color: "white"
            opacity: 0.6
        }

        Rectangle {
            x: 5
            y: 18
            width: 25
            height: 3
            radius: 2
            color: "white"
            opacity: 0.6
        }

        Rectangle {
            x: 5
            y: 26
            width: 25
            height: 3
            radius: 2
            color: "white"
            opacity: 0.6
        }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (leftRect.x === 0) {
                    leftAnim.running = false;
                    rightAnim.running = false;
                    leftReverseAnim.running = true;
                    rightReverseAnim.running = true;
                } else {
                    leftAnim.running = true;
                    rightAnim.running = true;
                    leftReverseAnim.running = false;
                    rightReverseAnim.running = false;
                }
                console.log("Clicked red area")
            }
        }

    }

    // Rectangle {
    //     x: windowWidth - 43
    //     y: 2
    //     width: 40
    //     height: 34
    //     radius: 2
    //     color: "black"
    //     opacity: 0.5
    // }
    Rectangle {
        id: leftRect
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

        // Column {
        //     x: 49
        //     y: 54
        //     spacing: 14

        //     Repeater {
        //         model: menuModel
        //         Text {
        //             text: model.label
        //             font.pixelSize: 20
        //             color: "white"
        //         }
        //     }
        // }

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
    }
}
