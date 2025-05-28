import QtQuick
import QtQuick.Controls

Item {
    property bool switchState: false
    
    Rectangle {
        id: toggleBackground
        width: 60
        height: 30
        radius: 15
        anchors.centerIn: parent
        color: switchState ? "#4cd964" : "#ccc"

        Rectangle {
            id: knob
            width: 26
            height: 26
            radius: 13
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