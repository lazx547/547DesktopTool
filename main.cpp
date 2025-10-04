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
#include "gfile.h"

// 清除指定目录下所有文件的函数
void clearRelativeDirContents(const QString &relativePath)
{
    QDir dir(relativePath);
    if (!dir.exists()) {//判断目录是否存在
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
    GFile file;

    // 读取程序缩放配置
    file.setSource("./scale.txt");

    // 如果文件不存在就创建
    if(file.is(file.source()))
        file.write("1");
    QString s=file.read();

    // 设置程序缩放 要在app实例创建前
    qputenv("QT_SCALE_FACTOR",s.toLatin1());

    QGuiApplication app(argc, argv);

    //app2看似没用，删就报错，创建MessengeBox需要用app2，它用不了QGuiApplocation，虽然没有指定使用app2，但是会自动用app2
    QApplication* app2=new QApplication(argc, argv);

    //使用共享内存段确保只有一个程序实例运行
    QSharedMemory sharedMemory("547DesktopTool");
    if (sharedMemory.attach()) {
        // 已附加到现有内存段，说明已有实例运行
        QMessageBox::warning(nullptr, "错误", "程序已经在运行中");
        return 3;
    }
    else{
        // 如果没有其他实例运行再执行其他内容

        // 创建共享内存段
        if (!sharedMemory.create(1)) {
            QMessageBox::critical(nullptr, "错误", "无法创建共享内存段");
            return 1;
        }

        // 设置窗口图标（虽然没用）
        app.setWindowIcon(QIcon("qrc:/547dt.png"));

        // 在qml中注册需要用到的内容
        // 在qml中注册EventSennder类，用于从c++主动向qml传递信息
        qmlRegisterType<EventSender>("EventSender",1,2,"EventSender");

        // 在qml中注册GFile类，用于读写文件和获取一些系统信息等
        qmlRegisterType<GFile>("GFile",1,2,"GFile");

        // 在qml中注册ClipboardHandler类，用于读写剪切板，和实现547paster的一些文件操作功能
        // 注册为全局
        qmlRegisterSingletonType<ClipboardHandler>(
            "Clipboard", 1, 0, "Clipboard",
            [](QQmlEngine *engine, QJSEngine *scriptEngine) -> QObject * {
                Q_UNUSED(engine)
                Q_UNUSED(scriptEngine)
                return new ClipboardHandler();
            }
            );
        // 在qml中注册DelButton的类型
        qmlRegisterUncreatableMetaObject(DelButtonType::staticMetaObject, "DelegateUI.Controls", 1, 0
                                         , "DelButtonType", "Access to enums & flags only");

        // 清除547paster贴图保存的临时图片
        clearRelativeDirContents("./file/temp");

        // 程序退出前也清除547paster贴图保存的临时图片
        QObject::connect(&app, &QGuiApplication::aboutToQuit, []() {
            clearRelativeDirContents("./file/temp");
        });

        // 定义main.qml的位置，之所以不用常量是因为在过去的版本中会根据不同情况读取不同main.qml
        QUrl url(QStringLiteral("./file/main.qml"));

        // 创建qml引擎
        QQmlApplicationEngine engine;

        // Qt自动生成，不知道干嘛的
        QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,&app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-2);
        }, Qt::QueuedConnection);

        // 判断main.qml是否存在
        if(!file.is(url.toString())){
            QMessageBox::critical(nullptr, "错误", "未找到main.qml");
            return 2;
        }
        else
        {
            // main.qml存在再加载
            engine.load(url);
        }

        // 查找EventSender实例以从c++主动向qml传递信息，用于全局快捷键
        // 判断main.qml是否加载
        QObject *rootObject = engine.rootObjects().first();
        if (!rootObject) {
            qWarning() << "No root object found!";
        }

        // 尝试通过objectName查找EventSender实例
        QObject *eventSender = rootObject->findChild<QObject*>("eventSender");

        // 如果没找到，尝试搜索所有对象
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
        // 即使无法找到EventSender也继续运行程序，这只影响全局快捷键

        if(eventSender)
        {
            // 设置全局快捷键，仅在找到EventSender的情况下进行
            // 读取全局快捷键的配置文件
            file.setSource("./hotkey.ini");

            //
            QString shot,paster,time;
            s=file.read();
            if(s=="")
            {
                s="Ctrl+Alt+S,Ctrl+Alt+P,Ctrl+Alt+T,";
                file.write(s);
            }
            shot=s.mid(0,s.indexOf(","));
            s=s.mid(s.indexOf(",")+1,s.length());
            if(s=="")
            {
                s="Ctrl+Alt+P,Ctrl+Alt+T,";
                file.write("Ctrl+Alt+S,Ctrl+Alt+P,Ctrl+Alt+T,");
            }
            paster=s.mid(0,s.indexOf(","));
            s=s.mid(s.indexOf(",")+1,s.length());
            if(s=="")
            {
                s="Ctrl+Alt+T,";
                file.write("Ctrl+Alt+S,Ctrl+Alt+P,Ctrl+Alt+T,");
            }
            time=s.mid(0,s.indexOf(","));
            QHotkey *hotkey_shot = new QHotkey(QKeySequence(shot), true, &app),
                *hotkey_paster =new QHotkey(QKeySequence(paster), true, &app),
                    *hotkey_time = new QHotkey(QKeySequence(time), true, &app);

            // 绑定全局快捷键信号
            QObject::connect(hotkey_shot, &QHotkey::activated,[eventSender]() {
                QMetaObject::invokeMethod(eventSender, "send", Q_ARG(QVariant, 0));
            });

            QObject::connect(hotkey_paster, &QHotkey::activated, [eventSender]() {
                QMetaObject::invokeMethod(eventSender, "send", Q_ARG(QVariant, 1));
            });
            QObject::connect(hotkey_time, &QHotkey::activated, [eventSender]() {
                QMetaObject::invokeMethod(eventSender, "send", Q_ARG(QVariant, 2));
            });
            // 检查全局快捷键是否注册成功
            if (!hotkey_shot->isRegistered()||!hotkey_paster->isRegistered()||!hotkey_time->isRegistered()) {
                QMessageBox::warning(nullptr, "错误", "注册全局快捷键出错\n部分或全部快捷键将无法使用");
            }
        }
        else
            QMessageBox::critical(nullptr, "错误", "无法找到EventSender\n全局快捷键将无法使用");
        return app.exec();
    }
}
