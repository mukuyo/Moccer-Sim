import QtQuick
import QtQuick3D
import QtQuick.Shapes
import QtQuick.Controls

Item {
    id: triangleContainer
    property string label: ""
    property real lineEnd: 0
    property real expandValue: 65
    property real triangleAngle: 0
    property bool menuVisible: false
    property real menuHeight: 0
    width: 80 * (expandValue / 65)
    height: 20 + menuHeight

    // 設定項目モデル
    ListModel {
        id: settingItems
        ListElement { name: "Width"; value: 50 }
        ListElement { name: "Height"; value: 75 }
        ListElement { name: "Continuous Collision Detection"; value: 0 }
    }

    Text {
        x: 15
        y: -9
        height: menuHeight
        text: label
        font.pixelSize: 20
        color: "white"
    }

    // 三角形ボタン
    Item {
        id: triangleVisual
        width: 300
        height: 16
        Item {
            id: triangleRotated
            width: parent.width
            height: parent.height
            anchors.fill: parent
            transform: Rotation {
                id: triangleRotation
                origin.x: 4
                origin.y: 4
                axis { x: 0; y: 0; z: 1 }
                angle: triangleAngle
            }

            Shape {
                anchors.fill: parent
                ShapePath {
                    strokeWidth: 0
                    fillColor: "white"
                    PathMove { x: 0; y: 0 }
                    PathLine { x: 8; y: 4 }
                    PathLine { x: 0; y: 8 }
                }
            }

            NumberAnimation {
                id: lineAnim
                target: triangleContainer
                property: "lineEnd"
                to: expandValue
                duration: 400
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                id: lineAnimBack
                target: triangleContainer
                property: "lineEnd"
                to: 0
                duration: 400
                easing.type: Easing.InOutQuad
            }
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onEntered: lineAnim.running = true
            onExited: lineAnimBack.running = true
            onClicked: {
                triangleAnim.from = triangleAngle
                triangleAngle += 90
                if (triangleAngle >= 180) triangleAngle = 0
                triangleAnim.to = triangleAngle
                triangleAnim.running = true

                menuVisible = !menuVisible
                heightAnim.from = menuHeight
                heightAnim.to = menuVisible ? 170 : 0
                heightAnim.running = true
            }
            cursorShape: Qt.PointingHandCursor
        }
    }

    // ライン描画
    Shape {
        ShapePath {
            strokeColor: "white"
            strokeWidth: 1
            fillColor: "transparent"
            PathMove { x: 16; y: 16 }
            PathLine { x: 16 + triangleContainer.lineEnd; y: 16 }
        }
    }

    // メニュー（スライダー付き）
    Item {
        id: menuWrapper
        width: 340
        height: menuHeight
        anchors.top: triangleVisual.bottom
        anchors.left: triangleVisual.left
        anchors.topMargin: 8
        clip: true

        Column {
            id: menuColumn
            x: 12
            spacing: 0

            Repeater {
                model: settingItems
                Column {
                    spacing: 3

                    Text {
                        text: "・" + model.name
                        color: "white"
                        font.pixelSize: 18
                    }

Item {
    width: 280
    height: 30

    Slider {
        id: slider
        width: parent.width-60
        x: 15
        from: 0
        to: 100
        stepSize: 1
        value: model.value

        onValueChanged: {
            if (textField.text !== Math.round(value).toString()) {
                model.value = value
                textField.text = Math.round(value).toString()
            }
        }
    }

    TextField {
        id: textField
        x: parent.width - 30
        width: 40
        height: 24
        text: model.value.toString()
        
        font.pixelSize: 14
        color: "white"
        horizontalAlignment: Text.AlignRight
        // background: Rectangle {
        //     color: "#222"
        //     radius: 4
        // }

        onEditingFinished: {
            let newValue = parseInt(text)
            if (!isNaN(newValue) && newValue >= slider.from && newValue <= slider.to) {
                slider.value = newValue
                model.value = newValue
            } else {
                text = slider.value.toString() // 無効な入力をリセット
            }
        }
    }
}

                }
            }
        }
    }
    NumberAnimation {
        id: triangleAnim
        target: triangleRotation
        property: "angle"
        duration: 500
        easing.type: Easing.InOutQuad
    }

    NumberAnimation {
        id: heightAnim
        target: triangleContainer
        property: "menuHeight"
        duration: 300
        easing.type: Easing.InOutQuad
    }
}
