import QtQuick

Item {
    id: menuContainer
    x: windowWidth - 40
    width: 40
    height: 40

    Item {
        id: HBMenuItem
        Rectangle {
            id: upLine
            x: 0
            y: 10
            width: 30
            height: 4.2
            radius: 2
            color: "white"
            opacity: 0.6
        }

        Rectangle {
            id: centerLine
            x: 0
            y: 20
            width: 30
            height: 4.2
            radius: 2
            color: "white"
            opacity: 0.6
        }

        Rectangle {
            id: downLine
            x: 0
            y: 30
            width: 30
            height: 4.2
            radius: 2
            color: "white"
            opacity: 0.6
        }
    }

    Item {
        id: crossItemMenu
        Canvas {
            anchors.fill: parent

            onPaint: {
                var ctx = getContext("2d");
                ctx.clearRect(0, 0, width, height);

                ctx.strokeStyle = "#333";
                ctx.lineWidth = 4;
                ctx.lineCap = "round"; // 丸い端

                ctx.beginPath();
                ctx.moveTo(8, 8);
                ctx.lineTo(width - 8, height - 8);
                ctx.moveTo(width - 8, 8);
                ctx.lineTo(8, height - 8);
                ctx.stroke();
            }

            // MouseArea {
            //     anchors.fill: parent
            //     onClicked: console.log("× clicked");
            // }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            if (leftShadowRect.x === 0) {
                upLine.opacity = 0.6;
                centerLine.opacity = 0.6;
                downLine.opacity = 0.6;

                leftAnim.running = false;
                rightAnim.running = false;
                leftReverseAnim.running = true;
                rightReverseAnim.running = true;
            } else {
                upLine.opacity = 0.0;
                centerLine.opacity = 0.0;
                downLine.opacity = 0.0;

                leftAnim.running = true;
                rightAnim.running = true;
                leftReverseAnim.running = false;
                rightReverseAnim.running = false;
            }
        }
    }
}