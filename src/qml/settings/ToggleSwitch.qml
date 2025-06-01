import QtQuick
import QtQuick.Controls

Item {
    property bool switchState: false

    Rectangle {
        id: toggleBackground
        width: 40
        height: 20
        radius: 10
        anchors.centerIn: parent
        color: switchState ? "#4cd964" : "#ccc"

        Rectangle {
            id: knob
            width: 16
            height: 16
            radius: 8
            color: "white"
            anchors.verticalCenter: parent.verticalCenter
            x: switchState ? parent.width - width - 2 : 2

            Behavior on x {
                NumberAnimation {
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: switchState = !switchState
        }
    }
}