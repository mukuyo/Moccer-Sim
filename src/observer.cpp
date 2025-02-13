#include "observer.h"

Observer::Observer(QObject *parent)
    : QObject(parent), worker(new ReceiverWorker(nullptr)) {
    worker->moveToThread(&receiverThread);

    connect(&receiverThread, &QThread::started, worker, [this]() {
        worker->startListening(20011);  // grSim のデフォルトポート
    });

    connect(&receiverThread, &QThread::finished, worker, &QObject::deleteLater);

    receiverThread.start();
}

Observer::~Observer() {
    stop();
}

void Observer::stop() {
    if (receiverThread.isRunning()) {
        worker->stopListening();
        receiverThread.quit();
        receiverThread.wait();
    }
}
