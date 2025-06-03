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
        id: displayItems
        ListElement { name: "Width"; detail: ""; slider: true; toggle: false; InitValue: 1100; MaxValue: 2560 }
        ListElement { name: "Height"; detail: ""; slider: true; toggle: false; InitValue: 720; MaxValue: 1240 }
        ListElement { name: "Force Debug Draw"; detail: "This property enables drawing \nof all active shapes in the physics world"; slider: false; toggle: true; InitValue: 0 }
    }
    ListModel {
        id: physicsItems
        ListElement { name: "Desired FPS"; detail: ""; slider: true; toggle: false; InitValue: 60; MaxValue: 120 }
        ListElement { name: "Gravity"; detail: ""; slider: true; toggle: false; InitValue: 9.81; MaxValue: 100 }
        ListElement { name: "CCD"; detail: "Continuous Collision Detection"; slider: false; toggle: true; InitValue: 1 }
        ListElement { name: "Ball Radius"; detail: ""; slider: true; toggle: false; InitValue: 0.1; MaxValue: 0.5 }
        ListElement { name: "Ball Mass"; detail: ""; slider: true; toggle: false; InitValue: 0.043; MaxValue: 10 }
        ListElement { name: "Ball Static Friction"; detail: ""; slider: true; toggle: false; InitValue: 0.3; MaxValue: 1 }
        ListElement { name: "Ball Dynamic Friction"; detail: ""; slider: true; toggle: false; InitValue: 0.2; MaxValue: 1 }
        ListElement { name: "Ball Restitution"; detail: ""; slider: true; toggle: false; InitValue: 0.0; MaxValue: 1 }
    }
    ListModel {
        id: geometryItems
        ListElement {name: "Line Thickness"; detail: ""; slider: true; toggle: false; InitValue: 0.5; MaxValue: 2 }
        ListElement { name: "Field Width"; detail: ""; slider: true; toggle: false; InitValue: 68; MaxValue: 100 }
        ListElement { name: "Field Height"; detail: ""; slider: true; toggle: false; InitValue: 105; MaxValue: 150 }
        ListElement { name: "Goal Width"; detail: ""; slider: true; toggle: false; InitValue: 7.32; MaxValue: 10 }
        ListElement { name: "Goal Depth"; detail: ""; slider: true; toggle: false; InitValue: 2.44; MaxValue: 5 }
        ListElement { name: "Goal Height"; detail: ""; slider: true; toggle: false; InitValue: 2.44; MaxValue: 5 }
        ListElement { name: "Penalty Area Width"; detail: ""; slider: true; toggle: false; InitValue: 16.5; MaxValue: 20 }
        ListElement { name: "Penalty Area Depth"; detail: ""; slider: true; toggle: false; InitValue: 40.3; MaxValue: 50 }
    }
    ListModel {
        id: robotItems
        ListElement { name: "Lightweight Mode"; detail: "This property enables lightweight mode for robots"; slider: false; toggle: true; InitValue: 0 }
        ListElement { name: "Blue Robot Counts"; detail: ""; slider: true; toggle: false; InitValue: 9; MaxValue: 16 }
        ListElement { name: "Yellow Robot Counts"; detail: ""; slider: true; toggle: false; InitValue: 9; MaxValue: 16 }
    }
    ListModel {
        id: cameraItems
        ListElement { name: "Camera Distance"; detail: ""; slider: true; toggle: false; InitValue: 10; MaxValue: 20 }
        ListElement { name: "Camera Height"; detail: ""; slider: true; toggle: false; InitValue: 5; MaxValue: 10 }
        ListElement { name: "Camera Angle"; detail: ""; slider: true; toggle: false; InitValue: 30; MaxValue: 60 }
    }
    ListModel {
        id: communicationItems
        ListElement { name: "Vision Multicast Address"; detail: "Address for vision data multicast"; slider: false; toggle: false; InitValue: -1; InitString: "-1" }
        ListElement { name: "Vision Multicast Port"; detail: "Port for vision data multicast"; slider: false; toggle: false; InitValue: 12345 }
        ListElement { name: "Command Listen Port"; detail: "Port for command listening"; slider: false; toggle: false; InitValue: 12346 }
        ListElement { name: "Blue Control Port"; detail: "Port for blue team control"; slider: false; toggle: false; InitValue: 12347 }
        ListElement { name: "Yellow Control Port"; detail: "Port for yellow team control"; slider: false; toggle: false; InitValue: 12348 }
    }
    ListModel {
        id: itemModel
    }
    Component.onCompleted: {
        if (label == "Display") {
            itemModel.clear();
            for (var i = 0; i < displayItems.count; i++) {
                itemModel.append(displayItems.get(i));
            }
        } else if (label == "Physics") {
            itemModel.clear();
            for (var i = 0; i < physicsItems.count; i++) {
                itemModel.append(physicsItems.get(i));
            }
        } else if (label == "Geometry") {
            itemModel.clear();
            for (var i = 0; i < geometryItems.count; i++) {
                itemModel.append(geometryItems.get(i));
            }
        } else if (label == "Robots") {
            itemModel.clear();
            for (var i = 0; i < robotItems.count; i++) {
                itemModel.append(robotItems.get(i));
            }
        } else if (label == "Camera") {
            itemModel.clear();
            for (var i = 0; i < cameraItems.count; i++) {
                itemModel.append(cameraItems.get(i));
            }
        } else if (label == "Communication") {
            itemModel.clear();
            for (var i = 0; i < communicationItems.count; i++) {
                itemModel.append(communicationItems.get(i));
            }
        }
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
                heightAnim.to = menuVisible ? heightValue : 0
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
            spacing: 2

            Repeater {
                model: itemModel
                Column {
                    property int index: index
                    spacing: 3

                    Text {
                        height: 55
                        text: "・" + model.name
                        color: "white"
                        font.pixelSize: 18
                    }
                    Item {
                        x: 215
                        visible: model.InitValue === -1
                        Column {
                            spacing: 5

                            TextField {
                                width: 90
                                text: model.InitString || ""
                                placeholderText: "ex: 192.168.0.1"
                                font.pixelSize: 14
                                validator: RegularExpressionValidator {
                                    regularExpression: /^((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)\.){3}(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)$/
                                }
                                horizontalAlignment: Text.AlignHCenter
                                Component.onCompleted: {
                                    text = observer.visionMulticastAddress
                                }
                                onEditingFinished: {
                                    if (text !== "") {
                                        model.InitString = text;
                                        if (model.name === "Vision Multicast Address") {
                                            observer.visionMulticastAddress = text;
                                        }
                                    } else {
                                        text = model.InitString || "";
                                    }
                                }
                            }
                        }
                    }
                    Item {
                        visible: !model.slider && !model.toggle && model.InitValue !== -1

                        TextField {
                            x: 250
                            width: 50
                            height: 24
                            text: model.InitValue.toString()
                            font.pixelSize: 14
                            color: "white"
                            horizontalAlignment: Text.AlignRight
                            Component.onCompleted: {
                                if (model.name === "Vision Multicast Port") {
                                    text = observer.visionMulticastPort.toString();
                                } else if (model.name === "Height") {
                                    text = tempWindowHeight.toString();
                                } else {
                                    text = model.InitValue.toString();
                                }
                            }
                            onEditingFinished: {
                                let newValue = parseInt(text)
                                if (!isNaN(newValue) && newValue >= 0) {
                                    model.InitValue = newValue;
                                    model.value = newValue;
                                    if (model.name === "Vision Multicast Port") {
                                        observer.visionMulticastPort = newValue;
                                    } else if (model.name === "Height") {
                                        tempWindowHeight = newValue;
                                    }
                                } else {
                                    text = model.InitValue.toString()
                                }
                            }
                        }
                    }
                    Item {
                        y: 25
                        visible: model.detail !== "" || model.toggle || model.slider
                        Text {
                            text: model.detail
                            x: 18
                            height: 30
                            color: "white"
                            opacity: 0.7
                            font.pixelSize: 14
                            visible: model.detail !== ""
                        }
                        
                        ToggleSwitch {
                            id: toggleSwitch
                            x: 270
                            y: 0
                            visible: model.toggle
                            // switchState: model.value === 1
                            // onSwitchStateChanged: {
                            //     model.value = switchState ? 1 : 0;
                            //     if (model.name === "CCD") {
                            //         observer.enableCCD = switchState;
                            //     }
                            // }
                        }
                    }
                    Item {
                        width: 280
                        visible: model.slider

                        Slider {
                            id: slider
                            width: parent.width-60
                            x: 15
                            y: 25
                            from: 0
                            to: model.MaxValue
                            stepSize: 1
                            value: model.InitValue

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
                            y: 25
                            width: 40
                            // height: 24
                            text: model.InitValue.toString()
                            
                            font.pixelSize: 14
                            color: "white"
                            horizontalAlignment: Text.AlignRight

                            onEditingFinished: {
                                let newValue = parseInt(text)
                                if (!isNaN(newValue) && newValue >= slider.from && newValue <= slider.to) {
                                    slider.value = newValue
                                    model.InitValue = newValue
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

    // Component.onCompleted: {
        // let currentValue = communicationItems.get(0).InitString
        // if (communicationItems.)
        // communicationItems.setProperty(0, "InitString", observer.visionMulticastAddress);
        // settingItems.setProperty(0, "MaxValue", Screen.width);
        // settingItems.setProperty(1, "MaxValue", Screen.height);
        // settingItems.setProperty(0, "value", observer.windowWidth);
        // settingItems.setProperty(1, "value", observer.windowHeight);
    // }
}
