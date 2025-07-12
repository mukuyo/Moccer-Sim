import QtQuick
import QtQuick3D
import QtQuick.Shapes
import QtQuick.Controls

Item {
    id: vobject
    width: windowWidth
    height: windowHeight

    property real ratio: 13400 / dispWidth
    property real ballRadius: 21.5 / ratio * 3.5
    property real botRadius: 180 / ratio
    property real textRatio: ratio / 44.667
    property var fieldCenter: Qt.vector2d(windowWidth / 2, dispY + dispHeight / 2)

    Repeater {
        model: bBotCount
        Rectangle {
            x: bBot2DPositions[index].x / ratio + fieldCenter.x - botRadius
            y: bBot2DPositions[index].y / ratio + fieldCenter.y - botRadius
            width: botRadius * 2
            height: botRadius * 2
            color: "transparent"
            border.color: "#30A1CE"
            radius: width / 2
            opacity: opacityValue
        }
    }
    Repeater {
        model: bBotCount
        Text {
            x: bBot2DPositions[index].x / ratio + fieldCenter.x - botRadius + (2.2 / textRatio)
            y: bBot2DPositions[index].y / ratio + fieldCenter.y - botRadius + (0.5 / textRatio)
            text: index
            color: "white"
            font.pixelSize: 6 / textRatio
        }
    }
    Repeater {
        model: yBotCount
        Rectangle {
            x: yBot2DPositions[index].x / ratio + fieldCenter.x - botRadius
            y: yBot2DPositions[index].y / ratio + fieldCenter.y - botRadius
            width: botRadius * 2
            height: botRadius * 2
            color: "transparent"
            border.color: "yellow"
            radius: width / 2
            opacity: opacityValue
        }
    }
    Repeater {
        model: yBotCount
        Text {
            x: yBot2DPositions[index].x / ratio + fieldCenter.x - botRadius + (2.2 / textRatio)
            y: yBot2DPositions[index].y / ratio + fieldCenter.y - botRadius + (0.5 / textRatio)
            text: index
            color: "white"
            font.pixelSize: 6 / textRatio
        }
    }
    Rectangle {
        id: vball
        x: ball2DPosition.x / ratio + fieldCenter.x - ballRadius
        y: ball2DPosition.y / ratio + fieldCenter.y - ballRadius
        width: ballRadius * 2
        height: ballRadius * 2
        color: "orange"
        radius: width / 2
        opacity: opacityValue
    }
    Rectangle {
        id: vballMarker
        x: ball2DPosition.x / ratio + fieldCenter.x - ballRadius * 5
        y: ball2DPosition.y / ratio + fieldCenter.y - ballRadius * 5
        width: ballRadius * 10
        height: ballRadius * 10
        color: "transparent"
        border.color: "red"
        radius: width / 2
        opacity: opacityValue
    }
    Component.onCompleted: {
        console.log(ratio)
    }
}