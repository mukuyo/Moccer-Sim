#include "receiver.h"

ReceiverWorker::ReceiverWorker(QObject *parent)
    : QObject(parent), udpSocket(nullptr), running(false) {}

ReceiverWorker::~ReceiverWorker() {
    stopListening();
}

void ReceiverWorker::startListening(quint16 port) {
    udpSocket = new QUdpSocket(this);
    if (udpSocket->bind(QHostAddress("127.0.0.1"), port)) {
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

        cout << "Received robot control" << endl;
        RobotControlResponse robotControlResponse;
        processRobotControl(robotControl, robotControlResponse, "blue");
        // for (int i = 0; i < 1; i++) {
        //     RobotFeedback* feedback = robotControlResponse.add_feedback();
        //     feedback->set_id(i);
        //     feedback->set_dribbler_ball_contact(false);
        // }
        // std::string serializedData;
        // if (!robotControlResponse.SerializeToString(&serializedData)) {
        //     std::cerr << "Failed to serialize command." << std::endl;
        //     return;
        // }
        // udpSocket->writeDatagram(serializedData.c_str(), serializedData.size(), datagram.senderAddress(), datagram.senderPort());
        QByteArray buffer(robotControlResponse.ByteSize(), 0);
        robotControlResponse.SerializeToArray(buffer.data(), buffer.size());
        udpSocket->writeDatagram(buffer.data(), buffer.size(), datagram.senderAddress(), datagram.senderPort());
        // QByteArray buffer(robotControlResponse.ByteSize(), 0);
        // robotControlResponse.SerializeToArray(buffer.data(), buffer.size());
        // udpSocket->writeDatagram(buffer.data(), buffer.size(), "192.168.1.184", 10301);
    }

    // elapsedLastPackageBlue.start();
}

void ControlBlueWorker::processRobotControl(const RobotControl &robotControl, RobotControlResponse &robotControlResponse, string team) {
    for (const auto &robotCommand : robotControl.robot_commands()) {
        // int id = robotIndex(robotCommand.id(), team == "yellow" ? 1 : 0);
        int id = robotCommand.id();
        if (id < 0) {
            continue;
        }
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

        // if (robotCommand.has_move_command()) {
        //     processMoveCommand(robotControlResponse, robotCommand.move_command(), robot);
        // }
        
        auto feedback = robotControlResponse.add_feedback();
        feedback->set_id(robotCommand.id());
        feedback->set_dribbler_ball_contact(false);
        // feedback->set_dribbler_ball_contact(robot->kicker->isTouchingBall());
    }
}

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