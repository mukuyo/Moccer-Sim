#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDebug>

#include "src/observer.h"
#include "src/utils/physics.h"

class Moccer {
public:
    Moccer(QQmlApplicationEngine &engine) {
        qmlRegisterType<Observer>("MOC", 1, 0, "Observe");
        qmlRegisterType<Physics>("MOC", 1, 0, "Physics");

        engine.load(QUrl(QStringLiteral("../src/qml/Main.qml")));
    }
};

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    Moccer moccer(engine);
    return app.exec();
}
