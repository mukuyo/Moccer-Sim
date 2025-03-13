#include "receiver.h"

ReceiverWorker::ReceiverWorker(QObject *parent)
    : QObject(parent), udpSocket(nullptr), running(false) {}

ReceiverWorker::~ReceiverWorker() {
    stopListening();
}

void ReceiverWorker::startListening(quint16 port) {
    udpSocket = new QUdpSocket(this);
    if (udpSocket->bind(QHostAddress("224.5.23.2"), port)) {
        connect(udpSocket, &QUdpSocket::readyRead, this, &ReceiverWorker::receive);
        running = true;
        std::cout << "Listening on port " << port << " (in thread)" << std::endl;
    } else {
        std::cerr << "Failed to bind UDP socket to port " << port << std::endl;
    }
}

void ReceiverWorker::receive() {
    while (udpSocket->hasPendingDatagrams()) {
        QByteArray datagram;
        datagram.resize(static_cast<int>(udpSocket->pendingDatagramSize()));
        udpSocket->readDatagram(datagram.data(), datagram.size());
        
        mocSim_Packet packet;
        if (packet.ParseFromArray(datagram.data(), datagram.size())) {
            emit receivedPacket(packet);
        } else {
            std::cerr << "Failed to parse Protobuf packet" << std::endl;
        }
    }
}

void ReceiverWorker::stopListening() {
    running = false;
    if (udpSocket) {
        udpSocket->close();
        udpSocket->deleteLater();
        udpSocket = nullptr;
    }
}

ControlBlueWorker::ControlBlueWorker(QObject *parent) : QObject(parent), udpSocket(nullptr), running(false) {}

ControlBlueWorker::~ControlBlueWorker() {
    stopListening();
}

void ControlBlueWorker::startListening(quint16 port) {
    udpSocket = new QUdpSocket(this);
    if (udpSocket->bind(QHostAddress(QHostAddress("127.0.0.1")), port)) {
        connect(udpSocket, &QUdpSocket::readyRead, this, &ControlBlueWorker::receive);
        running = true;
        std::cout << "Listening on port " << port << " (in thread)" << std::endl;
    } else {
        std::cerr << "Failed to bind UDP socket to port " << port << std::endl;
    }
}

void ControlBlueWorker::receive() {
    RobotControl robotControl;
    while (udpSocket->hasPendingDatagrams()) {
        QNetworkDatagram datagram = udpSocket->receiveDatagram();
        if (!datagram.isValid()) {
            continue;
        }
        robotControl.ParseFromArray(datagram.data().data(), datagram.data().size());
        RobotControlResponse robotControlResponse;
        processRobotControl(robotControl, robotControlResponse, "blue");

        QByteArray buffer(robotControlResponse.ByteSizeLong(), 0);
        robotControlResponse.SerializeToArray(buffer.data(), buffer.size());
        udpSocket->writeDatagram(buffer.data(), buffer.size(), datagram.senderAddress(), datagram.senderPort());
    }
}

// int ControlBlueWorker::robotIndex(int robot,int team) {
//     if (robot >= cfg->Robots_Count()) return -1;
//     return robot + team*cfg->Robots_Count();
// }

void ControlBlueWorker::processRobotControl(const RobotControl &robotControl, RobotControlResponse &robotControlResponse, string team) {
    for (const auto& robotCommand : robotControl.robot_commands()) {
        int id = robotCommand.id();
        // int id = robotIndex(robotCommand.id(), team == "yellow" ? 1 : 0);
        // if (id < 0) continue;
        // auto robot = robots[id];
        // auto robotCfg = team == YELLOW ? cfg->yellowSettings : cfg->blueSettings;

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
            // processMoveCommand(robotControlResponse, robotCommand.move_command(), robot);
        }
        
        auto feedback = robotControlResponse.add_feedback();
        feedback->set_id(id);
        feedback->set_dribbler_ball_contact(false);
        // feedback->set_dribbler_ball_contact(robot->kicker->isTouchingBall());
    }
}

// void ControlBlueWorker::processMoveCommand(RobotControlResponse &robotControlResponse, const RobotMoveCommand &moveCommand, Robot *robot) {
//     if (moveCommand.has_wheel_velocity()) {
//         auto &wheelVel = moveCommand.wheel_velocity();
//         robot->setSpeed(0, wheelVel.front_right());
//         robot->setSpeed(1, wheelVel.back_right());
//         robot->setSpeed(2, wheelVel.back_left());
//         robot->setSpeed(3, wheelVel.front_left());
//     } else if (moveCommand.has_local_velocity()) {
//         auto &vel = moveCommand.local_velocity();
//         robot->setSpeed(vel.forward(), vel.left(), vel.angular());
//     } else if(moveCommand.has_global_velocity()) {
//         auto &vel = moveCommand.global_velocity();
//         dReal orientation = -robot->getDir() * M_PI / 180.0;
//         dReal vx = (vel.x() * cos(orientation)) - (vel.y() * sin(orientation));
//         dReal vy = (vel.y() * cos(orientation)) + (vel.x() * sin(orientation));
//         robot->setSpeed(vx, vy, vel.angular());
//     }  else {
//         SimulatorError *pError = robotControlResponse.add_errors();
//         pError->set_code("GRSIM_UNSUPPORTED_MOVE_COMMAND");
//         pError->set_message("Unsupported move command");
//     }
// }

void ControlBlueWorker::stopListening() {
    running = false;
    if (udpSocket) {
        udpSocket->close();
        udpSocket->deleteLater();
        udpSocket = nullptr;
    }
}

// void SSLWorld::yellowControlSocketReady() {
//     RobotControl robotControl;
//     while (yellowControlSocket->hasPendingDatagrams()) {
//         QNetworkDatagram datagram = yellowControlSocket->receiveDatagram();
//         if (!datagram.isValid()) {
//             continue;
//         }
//         robotControl.ParseFromArray(datagram.data().data(), datagram.data().size());

//         RobotControlResponse robotControlResponse;
//         processRobotControl(robotControl, robotControlResponse, YELLOW);
        
//         QByteArray buffer(robotControlResponse.ByteSize(), 0);
//         robotControlResponse.SerializeToArray(buffer.data(), buffer.size());
//         yellowControlSocket->writeDatagram(buffer.data(), buffer.size(), datagram.senderAddress(), datagram.senderPort());
//     }

//     elapsedLastPackageYellow.start();
// }

// ControlYellowWorker::ControlYellowWorker(QObject *parent) : QObject(parent), udpSocket(nullptr), running(false) {}

// ControlYellowWorker::~ControlYellowWorker() {
//     stopListening();
// }

// void ControlYellowWorker::startListening(quint16 port) {
//     udpSocket = new QUdpSocket(this);
//     // if (udpSocket->bind(QHostAddress(QHostAddress("


// void ControlYellowWorker::receive() {
//     RobotControl robotControl;
//     // while (udpSocket->hasPendingDatagrams()) {
//     //     QByteArray datagram;
//     //     datagram.resize(static_cast<int>(udpSocket->pendingDatagramSize()));
//     //     udpSocket->readDatagram(datagram.data(), datagram.size());
        
//     //     robotControl.ParseFromArray(datagram.data(), datagram.size());

//     //     RobotControlResponse robotControlResponse;
//     //     processRobotControl(robotControl, robotControlResponse, "YELLOW");
        
//     //     QByteArray buffer(robotControlResponse.ByteSize(), 0);
//     //     robotControlResponse.SerializeToArray(buffer.data(), buffer.size());
//     //     yellowControlSocket->writeDatagram(buffer.data(), buffer.size(), datagram.senderAddress(), datagram.senderPort());
//     // }
// }

// void ControlYellowWorker::stopListening() {
//     running = false;
//     if (udpSocket) {
//         udpSocket->close();
//         udpSocket->deleteLater();
//         udpSocket = nullptr;
//     }
// }