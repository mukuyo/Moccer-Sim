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

    ListModel {
        id: settingItems
        ListElement { name: "Width"; slider: true; toggle: false; value: 1100; MaxValue: 2560 }
        ListElement { name: "Height"; slider: true; toggle: false; value: 720; MaxValue: 1240 }
        ListElement { name: "CCD"; slider: false; toggle: true; value: 0 }
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
                    property int index: index
                    spacing: 3

                    Text {
                        text: "・" + model.name
                        color: "white"
                        font.pixelSize: 18
                    }
                    ToggleSwitch {
                        id: toggleSwitch
                        x: 85
                        y: 12
                        visible: model.toggle
                        // switchState: model.value === 1
                        // onSwitchStateChanged: {
                        //     model.value = switchState ? 1 : 0;
                        //     if (model.name === "CCD") {
                        //         observer.enableCCD = switchState;
                        //     }
                        // }
                    }
                    Item {
                        width: 280
                        height: 30
                        visible: model.slider

                        Slider {
                            id: slider
                            width: parent.width-60
                            x: 15
                            from: 0
                            to: model.MaxValue
                            stepSize: 1
                            value: model.value

                            onValueChanged: {
                                if (textField.text !== Math.round(value).toString()) {
                                    if (model.name === "Width") {
                                        setting.tempWindowWidth = value;
                                    } else if (model.name === "Height") {
                                        tempWindowHeight = value;
                                    }          
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

                            onEditingFinished: {
                                let newValue = parseInt(text)
                                if (!isNaN(newValue) && newValue >= slider.from && newValue <= slider.to) {
                                    slider.value = newValue
                                    model.value = newValue
                                    if (model.name === "Width") {
                                        setting.tempWindowWidth = value;
                                    } else if (model.name === "Height") {
                                        tempWindowHeight = value;
                                    }          
                                } else {
                                    text = slider.value.toString()
                                }
                            }
                        }
                    }

                    // Item {
                    //     width: 280
                    //     height: 30
                    //     visible: model.toggle
                    //     Row {
                    //         spacing: 10
                    //         anchors.centerIn: parent

                    //         ToggleSwitch {
                    //             id: toggleSwitch
                    //             switchState: model.value === 1
                    //             onSwitchStateChanged: {
                    //                 model.value = switchState ? 1 : 0;
                    //                 if (model.name === "CCD") {
                    //                     observer.enableCCD = switchState;
                    //                 }
                    //             }
                    //         }

                    //         Text {
                    //             text: model.name + " " + (model.value === 1 ? "ON" : "OFF")
                    //             color: "white"
                    //             font.pixelSize: 18
                    //         }
                    //     }
                    // }

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

    Component.onCompleted: {
        settingItems.setProperty(0, "MaxValue", Screen.width);
        settingItems.setProperty(1, "MaxValue", Screen.height);
        settingItems.setProperty(0, "value", observer.windowWidth);
        settingItems.setProperty(1, "value", observer.windowHeight);
    }
}
