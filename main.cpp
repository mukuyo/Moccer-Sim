#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include "src/models/robot.h"
#include "src/observer.h"

class Moccer {
public:
    Moccer(QQmlApplicationEngine &engine) {
        qmlRegisterType<Robot>("MOC", 1, 0, "Robot");
        qmlRegisterType<Observer>("MOC", 1, 0, "Observe");

        engine.load(QUrl(QStringLiteral("../src/qml/Main.qml")));
    }
};

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    Moccer moccer(engine);
    return app.exec();
}
