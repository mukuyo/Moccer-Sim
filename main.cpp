#include <QApplication>
#include <QQmlApplicationEngine>
#include <QDebug>

#include "src/observer.h"
#include "src/models/camera.h"
#include "src/utils/motionControl.h"

class m2 {
public:
    explicit m2(QQmlApplicationEngine &engine) {
        qmlRegisterType<Observer>("MOC", 1, 0, "Observe");
        qmlRegisterType<Camera>("MOC", 1, 0, "Camera");
        qmlRegisterType<MotionControl>("MOC", 1, 0, "MotionControl");
        engine.load(QUrl(QStringLiteral("../src/qml/Main.qml")));
    }
};

int main(int argc, char *argv[]) {
    QApplication app(argc, argv);
    QQmlApplicationEngine engine;
    m2 m2(engine);
    (void) m2;
    return app.exec();
}
