#include "observer.h"

Observer::Observer(QObject *parent)
    : QObject(parent), worker(new ReceiverWorker(nullptr)), controlBlueWorker(new ControlBlueWorker), sender(new Sender(10694)), senderControl(new SenderControl()) {
    worker->moveToThread(&receiverThread);
    controlBlueWorker->moveToThread(&receiverBlueControlThread);

    connect(&receiverThread, &QThread::started, worker, [this]() {
        worker->startListening(20694);
    });
    connect(&receiverBlueControlThread, &QThread::started, controlBlueWorker, [this]() {
        controlBlueWorker->startListening(10301);
    });

    connect(worker, &ReceiverWorker::receivedPacket, this, &Observer::receive, Qt::QueuedConnection);
    // connect(controlBlueWorker, &ControlBlueWorker::receivedPacket, this, &Observer::receive, Qt::QueuedConnection);

    for (int i = 0; i < 16; ++i) {
        blue_robots[i] = new Robot();
        yellow_robots[i] = new Robot();
    }    

    receiverThread.start();
    receiverBlueControlThread.start();
}

Observer::~Observer() {
    stop();
    for (int i = 0; i < 16; ++i) {
        delete blue_robots[i];
        delete yellow_robots[i];
    }
}

void Observer::receive(const mocSim_Packet& packet) {
    for (int i = 0; i < packet.commands().robot_commands_size(); ++i) {
        if (packet.commands().isteamyellow()) {
            yellow_robots[i]->update(packet.commands().robot_commands(i));
            emit yellowRobotsChanged();
        } else {
            blue_robots[i]->update(packet.commands().robot_commands(i));
            emit blueRobotsChanged();
        }
    }
    
}

void Observer::stop() {
    if (receiverThread.isRunning()) {
        worker->stopListening();
        receiverThread.quit();
        receiverThread.wait();
    }
    if (receiverBlueControlThread.isRunning()) {
        controlBlueWorker->stopListening();
        receiverBlueControlThread.quit();
        receiverBlueControlThread.wait();
    }
}

QList<QObject*> Observer::getBlueRobots() const {
    QList<QObject*> list;
    for (int i = 0; i < 16; ++i) {
        list.append(blue_robots[i]);
    }
    return list;
}

QList<QObject*> Observer::getYellowRobots() const {
    QList<QObject*> list;
    for (int i = 0; i < 16; ++i) {
        list.append(yellow_robots[i]);
    }
    return list;
}

void Observer:: updateObjects(QList<QVector3D> blue_positions, QList<QVector3D> yellow_positions, QVector3D ball_position) {
    sender->send(2, ball_position, blue_positions, yellow_positions);
    // senderControl->send(blue_positions, yellow_positions);
}