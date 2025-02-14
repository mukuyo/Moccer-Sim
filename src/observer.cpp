#include "observer.h"

Observer::Observer(QObject *parent)
    : QObject(parent), worker(new ReceiverWorker(nullptr)) {
    worker->moveToThread(&receiverThread);

    connect(&receiverThread, &QThread::started, worker, [this]() {
        worker->startListening(20011);  // grSim のデフォルトポート
    });

    // connect(&receiverThread, &QThread::finished, worker, &QObject::deleteLater);
    connect(worker, &ReceiverWorker::receivedPacket, this, &Observer::receive, Qt::QueuedConnection);
;


    receiverThread.start();
}

Observer::~Observer() {
    stop();
}

void Observer::receive(const mocSim_Packet& packet) {
    for (int i = 0; i < packet.commands().robot_commands_size(); ++i) {
        const auto& robot_command = packet.commands().robot_commands(i);
        qDebug() << "ID:" << robot_command.id()
                 << "KickSpeedx:" << robot_command.kickspeedx()
                 << "KickSpeedz:" << robot_command.kickspeedz();
    }
}


void Observer::stop() {
    if (receiverThread.isRunning()) {
        worker->stopListening();
        receiverThread.quit();
        receiverThread.wait();
    }
}
