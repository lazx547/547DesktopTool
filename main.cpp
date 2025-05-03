#include "gfile.h"
#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <gfile.h>
#include "erwindow.h"
#include "clipboardhandler.h"

int main(int argc, char *argv[])
{

    QGuiApplication::setAttribute(Qt::AA_Use96Dpi);
    GFile file;
    file.setSource("./scale.txt");
    QString s=file.read();
    qputenv("QT_SCALE_FACTOR",s.toLatin1());
    QUrl url(QStringLiteral("./file/main.qml"));

    QGuiApplication app(argc, argv);
    QApplication* app2=new QApplication(argc, argv);
    ErWindow w;
    qmlRegisterType<GFile>("GFile",1,2,"GFile");
    qmlRegisterSingletonType<ClipboardHandler>(
        "Clipboard", 1, 0, "Clipboard",
        [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
            Q_UNUSED(engine)
            Q_UNUSED(scriptEngine)
            return new ClipboardHandler();
        }
        );
    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,&app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
            QCoreApplication::exit(-2);
    }, Qt::QueuedConnection);
    if(!file.is(url.toString())){
        w.show();
    }
    else
    {
        app2->destroyed();
        QObject::connect(&engine, &QQmlApplicationEngine::warnings, [](const QList<QQmlError> &errors) {
            for (const auto &error : errors) {
                qDebug() << "QML Error:" << error.toString();
            }
        });
        engine.load(url);
    }
    return app.exec();
}
