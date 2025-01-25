#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include "src/include/geometry.h"
#include "src/include/robot.h"

class Moccer {
public:
    Moccer(QQmlApplicationEngine &engine) {
        qmlRegisterType<Robot>("MOC", 1, 0, "Robot");

        engine.load(QUrl(QStringLiteral("../src/qml/Main.qml")));

        if (engine.rootObjects().isEmpty()) {
            qWarning() << "Failed to load QML file.";
            return;
        }
        qDebug() << "QML successfully loaded!";
    }
};

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    Moccer moccer(engine);
    return app.exec();
}
