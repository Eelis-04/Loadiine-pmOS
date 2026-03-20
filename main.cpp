#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "AppModel.h"

int main(int argc, char *argv[]) {
    QGuiApplication app(argc, argv);

    qmlRegisterType<AppModel>("AppLauncher", 1, 0, "AppModel");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    return app.exec();
}

// working on the GUI first