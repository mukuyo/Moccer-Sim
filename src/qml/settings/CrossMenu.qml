import QtQuick

Item {
    x: rightRect.width - 40
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
            ctx.moveTo(8, 8);
            ctx.lineTo(width - 18, height - 18);
            ctx.moveTo(width - 18, 8);
            ctx.lineTo(8, height - 18);
            ctx.stroke();
        }
    }
}