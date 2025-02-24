#include "observer.h"

Observer::Observer(QObject *parent)
    : QObject(parent), worker(new ReceiverWorker(nullptr)){
    worker->moveToThread(&receiverThread);

    connect(&receiverThread, &QThread::started, worker, [this]() {
        worker->startListening(20011);  // grSim のデフォルトポート
    });

    connect(worker, &ReceiverWorker::receivedPacket, this, &Observer::receive, Qt::QueuedConnection);

    for (int i = 0; i < 16; ++i) {
        robots[i] = new Robot();
    }    

    receiverThread.start();
}

Observer::~Observer() {
    stop();
    for (int i = 0; i < 16; ++i) {  // メモリリーク修正
        delete robots[i];
    }
}

void Observer::receive(const mocSim_Packet& packet) {
    for (int i = 0; i < packet.commands().robot_commands_size(); ++i) {
        robots[i]->update(packet.commands().robot_commands(i));
    }
    emit robotsChanged();
}

void Observer::stop() {
    if (receiverThread.isRunning()) {
        worker->stopListening();
        receiverThread.quit();
        receiverThread.wait();
    }
}

QList<QObject*> Observer::getRobots() const {
    QList<QObject*> list;
    for (int i = 0; i < 16; ++i) {
        list.append(robots[i]);
    }
    return list;
}
