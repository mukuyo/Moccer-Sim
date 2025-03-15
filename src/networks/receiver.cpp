#include "receiver.h"

VisionReceiver::VisionReceiver(QObject *parent) : QObject(parent), udpSocket(new QUdpSocket(this)) {
}

VisionReceiver::~VisionReceiver() {
    stopListening();
}

void VisionReceiver::startListening(quint16 port) {
    if (udpSocket->bind(QHostAddress("127.0.0.1"), port)) {
        connect(udpSocket, &QUdpSocket::readyRead, this, &VisionReceiver::receive);
        std::cout << "Listening on port " << port << std::endl;
    } else {
        std::cerr << "Failed to bind UDP socket to port " << port << std::endl;
    }
}

void VisionReceiver::receive() {
    mocSim_Packet packet;
    while (udpSocket->hasPendingDatagrams()) {
        QNetworkDatagram datagram = udpSocket->receiveDatagram();
        if (!datagram.isValid()) continue;
        packet.ParseFromArray(datagram.data().data(), datagram.data().size());
        emit receivedPacket(packet);
    }
}

void VisionReceiver::stopListening() {
    if (udpSocket) {
        udpSocket->close();
        udpSocket->deleteLater();
        udpSocket = nullptr;
    }
}

ControlReceiver::ControlReceiver(QObject *parent)
    : QObject(parent), udpSocket(nullptr){}

ControlReceiver::~ControlReceiver() {
    stopListening();
}

void ControlReceiver::startListening(quint16 port) {
    udpSocket = new QUdpSocket(this);
    if (udpSocket->bind(QHostAddress("127.0.0.1"), port)) {
        connect(udpSocket, &QUdpSocket::readyRead, this, &ControlReceiver::receive);
        std::cout << "Listening on port " << port << " (in thread)" << std::endl;
    } else {
        std::cerr << "Failed to bind UDP socket to port " << port << std::endl;
    }
}

void ControlReceiver::receive() {
    RobotControl packet;
    while (udpSocket->hasPendingDatagrams()) {
        QNetworkDatagram datagram = udpSocket->receiveDatagram();
        if (!datagram.isValid()) continue;
        packet.ParseFromArray(datagram.data().data(), datagram.data().size());
        emit receivedPacket(packet, false);
        // RobotControlResponse robotControlResponse;
        // processRobotControl(robotControl, robotControlResponse, "blue");

        // QByteArray buffer(robotControlResponse.ByteSizeLong(), 0);
        // robotControlResponse.SerializeToArray(buffer.data(), buffer.size());
        // udpSocket->writeDatagram(buffer.data(), buffer.size(), datagram.senderAddress(), datagram.senderPort());
    }
}

void ControlReceiver::processRobotControl(const RobotControl &robotControl, RobotControlResponse &robotControlResponse, std::string team) {
    for (const auto& robotCommand : robotControl.robot_commands()) {
        int id = robotCommand.id();

        if (robotCommand.has_kick_speed() && robotCommand.kick_speed() > 0) {
            double kickSpeed = robotCommand.kick_speed();
            double limit = robotCommand.kick_angle() > 0 ? 10 : 10;
            if (kickSpeed > limit) {
                kickSpeed = limit;
            }
            double kickAngle = robotCommand.kick_angle() * M_PI / 180.0;
            double length = cos(kickAngle) * kickSpeed;
            double z = sin(kickAngle) * kickSpeed;
            // robot->kicker->kick(length, z);
        }

        if (robotCommand.has_dribbler_speed()) {
            // robot->kicker->setRoller(robotCommand.dribbler_speed() > 0 ? 1 : 0);
        }

        if (robotCommand.has_move_command()) {
            // processMoveCommand(robotControlResponse, robotCommand.move_command(), nullptr); // 仮のnullptr
        }

        auto feedback = robotControlResponse.add_feedback();
        feedback->set_id(id);
        // feedback->set_dribbler_ball_contact(false);
    }
}

// void ControlReceiver::processMoveCommand(RobotControlResponse &robotControlResponse, const RobotMoveCommand &moveCommand, Robot *robot) {
//     if (moveCommand.has_wheel_velocity()) {
//         // auto &wheelVel = moveCommand.wheel_velocity();
//         // robot->setSpeed(0, wheelVel.front_right());
//     } else if (moveCommand.has_local_velocity()) {
//         auto &vel = moveCommand.local_velocity();
//         robot->setSpeed(vel.forward(), vel.left(), vel.angular());
//     } else if(moveCommand.has_global_velocity()) {
//         // auto &vel = moveCommand.global_velocity();
//     } else {
//         // SimulatorError *pError = robotControlResponse.add_errors();
//     }
// }

void ControlReceiver::stopListening() {
    if (udpSocket) {
        udpSocket->close();
        udpSocket->deleteLater();
        udpSocket = nullptr;
    }
}
