#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include "src/include/geometry.h"
#include "src/include/robot.h"

class Moccer {
public:
    Moccer(QQmlApplicationEngine &engine) {
        qmlRegisterType<Robot>("MOC", 1, 0, "Robot");
        qmlRegisterType<Geometry>("Geometry", 1, 0, "Geometry");

        engine.load(QUrl(QStringLiteral("../src/qml/Main.qml")));
    }
};

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    Moccer moccer(engine);
    return app.exec();
}
