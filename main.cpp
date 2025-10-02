#include "gfile.h"
#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <gfile.h>
#include <QMessageBox>
#include <QSharedMemory>
#include "clipboardhandler.h"
#include "delbuttontype.h"
#include "qhotkey.h"
#include "eventsender.h"

void clearRelativeDirContents(const QString &relativePath)
{
    QDir dir(relativePath);
    if (!dir.exists()) {
        qWarning() << "Directory does not exist:" << dir.absolutePath();
        return;
    }
    // 删除所有文件
    QStringList files = dir.entryList(QDir::Files);
    for (const QString &file : std::as_const(files)) {
        if (!dir.remove(file)) {
            qWarning() << "Failed to remove file:" << file;
        }
    }
    // 删除所有子目录
    QStringList subDirs = dir.entryList(QDir::Dirs | QDir::NoDotAndDotDot);
    for (const QString &subDir : std::as_const(subDirs)) {
        if (!dir.rmdir(subDir)) {
            // 如果子目录非空，需要递归删除
            QDir subDirFull(dir.filePath(subDir));
            if (!subDirFull.removeRecursively()) {
                qWarning() << "Failed to remove subdirectory:" << subDir;
            }
        }
    }
}

int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_Use96Dpi);
    GFile file;

    file.setSource("./scale.txt");
    if(file.is(file.source()))
        file.write("1");
    QString s=file.read();
    qputenv("QT_SCALE_FACTOR",s.toLatin1());
    QUrl url(QStringLiteral("./file/main.qml"));

    QGuiApplication app(argc, argv);

    EventSender *sender = new EventSender(&app);
    app.setWindowIcon(QIcon("qrc:/547dt.png"));

    QSharedMemory sharedMemory("547DesktopTool_v0.3");
    if (sharedMemory.attach()) {
        // 已附加到现有内存段，说明已有实例运行
        QMessageBox::warning(nullptr, "警告", "程序已经在运行中");
        return 0;
    }
    // 创建共享内存段
    if (!sharedMemory.create(1)) {
        QMessageBox::critical(nullptr, "错误", "无法创建共享内存段");
        return 1;
    }


    QApplication* app2=new QApplication(argc, argv);//看似没用，删就报错（其实是MessengeBox使用的，不在main函数中）
    qmlRegisterType<EventSender>("EventSender",1,2,"EventSender");
    qmlRegisterType<GFile>("GFile",1,2,"GFile");
    qmlRegisterSingletonType<ClipboardHandler>(
        "Clipboard", 1, 0, "Clipboard",
        [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
            Q_UNUSED(engine)
            Q_UNUSED(scriptEngine)
            return new ClipboardHandler();
        }
        );

    qmlRegisterUncreatableMetaObject(DelButtonType::staticMetaObject, "DelegateUI.Controls", 1, 0
                                     , "DelButtonType", "Access to enums & flags only");

    clearRelativeDirContents("./file/temp");
    QObject::connect(&app, &QGuiApplication::aboutToQuit, []() {
        clearRelativeDirContents("./file/temp");
    });

    QQmlApplicationEngine engine;
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,&app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-2);
    }, Qt::QueuedConnection);
    if(!file.is(url.toString())){
        QMessageBox::critical(nullptr, "错误", "未找到main.qml");
        return 2;
    }
    else
    {
        engine.load(url);
    }
    QObject *rootObject = engine.rootObjects().first();
    if (!rootObject) {
        qWarning() << "No root object found!";
    }
    QObject *eventSender = rootObject->findChild<QObject*>("eventSender");
    if (!eventSender) {
        auto allObjects = rootObject->findChildren<QObject*>();
        for (auto obj : std::as_const(allObjects)) {
            if (obj->inherits("EventSender")) {
                eventSender = obj;
                qDebug() << "Found EventSender";
                break;
            }
        }
    }
    file.setSource("./hotkey.ini");
    QString shot,paster;
    s=file.read();
    if(s=="")
    {
        s="Ctrl+Alt+S,Ctrl+Alt+P,";
        file.write(s);
    }
    shot=s.mid(0,s.indexOf(","));
    s=s.mid(s.indexOf(",")+1,s.length());
    if(s=="")
    {
        s="Ctrl+Alt+P,";
        file.write(s);
    }
    paster=s.mid(0,s.indexOf(","));
    QHotkey *hotkey_shot = new QHotkey(QKeySequence(shot), true, &app),
        *hotkey_paster =new QHotkey(QKeySequence(paster), true, &app);

    // Connect the activated signal
    QObject::connect(hotkey_shot, &QHotkey::activated,[eventSender]() {
        QMetaObject::invokeMethod(eventSender, "send", Q_ARG(QVariant, 0));
    });

    QObject::connect(hotkey_paster, &QHotkey::activated, [eventSender]() {
        QMetaObject::invokeMethod(eventSender, "send", Q_ARG(QVariant, 1));
    });
    // Check if registration was successful
    if (!hotkey_shot->isRegistered()||!hotkey_paster->isRegistered()) {
        QMessageBox::warning(nullptr, "Error", "Failed to register hotkey!");
    }
    return app.exec();
}
