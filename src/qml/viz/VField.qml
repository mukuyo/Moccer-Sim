import QtQuick
import QtQuick3D
import QtQuick.Shapes
import QtQuick.Controls

Item {
    id: vfield
    width: windowWidth
    height: windowHeight

    property real ratio: 13400 / dispWidth
    property real pointRadius: 4
    property real circleRadius: 1000 / ratio
    property real fieldWidth: 12000 / ratio
    property real fieldHeight: 9000 / ratio
    property real goalWidth: 200 / ratio
    property real goalHeight: 1840 / ratio
    property var fieldCenter: Qt.vector2d(windowWidth / 2, dispY + dispHeight / 2)

    Rectangle {
        id: centerPoint
        x: fieldCenter.x - pointRadius / 2
        y: dispY + dispHeight / 2 - pointRadius / 2
        width: pointRadius
        height: pointRadius
        color: "#C8D3D6"
        radius: width / 2
        opacity: opacityValue
    }
    Rectangle {
        id: centerCircle
        x: fieldCenter.x - circleRadius / 2
        y: dispY + dispHeight / 2 - circleRadius / 2
        width: circleRadius
        height: circleRadius
        color: "transparent"
        border.color: "#C8D3D6"
        radius: width / 2
        opacity: opacityValue
    }
    Rectangle {
        id: fieldLine
        x: fieldCenter.x - fieldWidth / 2
        y: fieldCenter.y - fieldHeight / 2
        width: fieldWidth
        height: fieldHeight
        color: "transparent"
        border.color: "#C8D3D6"
        opacity: opacityValue
    }
    Rectangle {
        id: virticalLine
        x: fieldCenter.x - fieldWidth / 2 + fieldWidth / 2 - 0.5
        y: fieldCenter.y - fieldHeight / 2
        width: 1
        height: fieldHeight
        color: "transparent"
        border.color: "#C8D3D6"
        opacity: opacityValue
    }
    Rectangle {
        id: horizontalLine
        x: fieldCenter.x - fieldWidth / 2
        y: fieldCenter.y - fieldHeight / 2 + fieldHeight / 2 - 0.5
        width: fieldWidth
        height: 1
        color: "transparent"
        border.color: "#C8D3D6"
        opacity: opacityValue
    }
    Rectangle {
        id: leftPenalty
        x: fieldCenter.x - fieldWidth / 2
        y: fieldCenter.y - leftPenalty.width
        width: fieldHeight / 5
        height: leftPenalty.width * 2
        color: "transparent"
        border.color: "#C8D3D6"
        opacity: opacityValue
    }
    Rectangle {
        id: rightPenalty
        x: fieldCenter.x + fieldWidth / 2 - rightPenalty.width
        y: fieldCenter.y - rightPenalty.width
        width: fieldHeight / 5
        height: rightPenalty.width * 2
        color: "transparent"
        border.color: "#C8D3D6"
        opacity: opacityValue
    }
    Rectangle {
        id: leftGoal
        x: fieldCenter.x - fieldWidth / 2 - leftGoal.width
        y: fieldCenter.y - leftGoal.height / 2
        width: goalWidth
        height: goalHeight
        color: "transparent"
        border.color: "black"
        border.width: 1
        opacity: opacityValue
    }
    Rectangle {
        id: rightGoal
        x: fieldCenter.x + fieldWidth / 2
        y: fieldCenter.y - rightGoal.height / 2
        width: goalWidth
        height: goalHeight
        color: "transparent"
        border.color: "black"
        border.width: 1
        opacity: opacityValue
    }

}