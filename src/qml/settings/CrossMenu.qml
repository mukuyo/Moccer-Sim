import QtQuick

Item {
    x: rightShadowRect.width - 40
    width: 40
    height: 40

    Canvas {
        anchors.fill: parent

        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);

            ctx.strokeStyle = "rgba(255, 255, 255, 0.5)";
            ctx.lineWidth = 4;
            ctx.lineCap = "round"; // 丸い端

            ctx.beginPath();
            ctx.moveTo(5, 13);
            ctx.lineTo(width - 16, height - 9);
            ctx.moveTo(width - 16, 13);
            ctx.lineTo(5, height - 9);
            ctx.stroke();
        }
    }
}