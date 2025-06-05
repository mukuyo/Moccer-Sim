import QtQuick
import QtQuick.Controls

Item {
    property bool switchState: false

    Rectangle {
        id: toggleBackground
        width: 44
        height: 20
        radius: 10
        anchors.centerIn: parent
        color: switchState ? "#4cd964" : "#ccc"

        Rectangle {
            id: knob
            width: 18
            height: 18
            radius: 12
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
            onClicked: {
                switchState = !switchState;
                if (model.name === "Force Debug Draw") {
                    isForceDebugDraw = !isForceDebugDraw
                } else if (model.name === "Lightweight Mode") {
                    isLightweightMode = !isLightweightMode
                    console.log("Lightweight Mode:", isLightweightMode);
                }
            }
        }
    }
}