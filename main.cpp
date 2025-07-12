#include "gfile.h"
#include <QGuiApplication>
#include <QApplication>
#include <QQmlApplicationEngine>
#include <gfile.h>
#include <QMessageBox>
#include <QSharedMemory>
#include "clipboardhandler.h"
#include "delbuttontype.h"

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
    QString s=file.read();
    qputenv("QT_SCALE_FACTOR",s.toLatin1());
    QUrl url(QStringLiteral("./file/main.qml"));
    QGuiApplication app(argc, argv);
    QSharedMemory sharedMemory("547DesktopTool_v0.2");
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
    QApplication* app2=new QApplication(argc, argv);
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
    return app.exec();
}
