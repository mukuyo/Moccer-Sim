import QtQuick
import QtQuick3D
import QtQuick.Shapes
import QtQuick.Controls

Item {
    id: vobject
    width: windowWidth
    height: windowHeight

    property real ratio: 13400 / dispWidth
    property real ballRadius: 21.5 / ratio * 3
    property real botRadius: 180 / ratio
    property var fieldCenter: Qt.vector2d(windowWidth / 2, dispY + dispHeight / 2)

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
    Repeater {
        model: bBotCount
        Rectangle {
            x: bBot2DPositions[index].x / ratio + fieldCenter.x - botRadius
            y: bBot2DPositions[index].y / ratio + fieldCenter.y - botRadius
            width: botRadius * 2
            height: botRadius * 2
            color: "#30A1CE"
            radius: width / 2
            opacity: opacityValue
        }
    }
    Repeater {
        model: yBotCount
        Rectangle {
            x: yBot2DPositions[index].x / ratio + fieldCenter.x - botRadius
            y: yBot2DPositions[index].y / ratio + fieldCenter.y - botRadius
            width: botRadius * 2
            height: botRadius * 2
            color: "yellow"
            radius: width / 2
            opacity: opacityValue
        }
    }
}