#include "observer.h"

Observer::Observer(QObject *parent)
    : QObject(parent), worker(new ReceiverWorker(nullptr)){
    worker->moveToThread(&receiverThread);

    connect(&receiverThread, &QThread::started, worker, [this]() {
        worker->startListening(20011);  // grSim のデフォルトポート
    });

    // connect(&receiverThread, &QThread::finished, worker, &QObject::deleteLater);
    connect(worker, &ReceiverWorker::receivedPacket, this, &Observer::receive, Qt::QueuedConnection);

    for (int i = 0; i < 16; ++i) {
        robot[i] = new Robot();
    }    

    receiverThread.start();
}

Observer::~Observer() {
    stop();
    for (int i = 0; i < 11; ++i) {
        delete robot[i];
    }
}

void Observer::receive(const mocSim_Packet& packet) {
    for (int i = 0; i < packet.commands().robot_commands_size(); ++i) {
        robot[i]->update(packet.commands().robot_commands(i));
    }
}

void Observer::stop() {
    if (receiverThread.isRunning()) {
        worker->stopListening();
        receiverThread.quit();
        receiverThread.wait();
    }
}
