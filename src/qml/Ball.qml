import QtQuick
import QtQuick3D
import MOC

import "../../assets/models/ball/"

Node {
    id: ballNode
    property real friction: 0.05
    Ball {
        id: ball
        position: Qt.vector3d(0, 2.3, 0)
    }
    Timer {
        interval: 32
        running: true
        repeat: true
        onTriggered: {
            // 速度を少しずつ減少させる
            velocity.x *= (1 - friction);
            velocity.z *= (1 - friction);

            // 速度が十分小さくなったら 0 にする
            if (Math.abs(velocity.x) < 0.001) velocity.x = 0;
            if (Math.abs(velocity.z) < 0.001) velocity.z = 0;

            // 位置を更新
            ball.position = Qt.vector3d(
                ball.position.x + velocity.x,
                ball.position.y + velocity.y,
                ball.position.z + velocity.z
            );
        }
    }
}