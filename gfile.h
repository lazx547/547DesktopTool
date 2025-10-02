#ifndef FILE_OBJECT_H
#define FILE_OBJECT_H

#include <QObject>
#include <QDir>
#include <QUrl>
#include <QProcess>
#include <QDesktopServices>

class GFile : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
public:
    explicit GFile(QObject *parent = 0);

    Q_INVOKABLE QString read();
    Q_INVOKABLE bool write(const QString& data);
    Q_INVOKABLE bool is(const QString& source);
    Q_INVOKABLE void create(const QString& source);
    Q_INVOKABLE QString getUser();
    Q_INVOKABLE void setSource(const QString& source) { m_source = source; };
    Q_INVOKABLE QString source() { return m_source; }
    Q_INVOKABLE void del(){QFile::remove(m_source);}
    Q_INVOKABLE qreal getSysScale(){return 0;}
    Q_INVOKABLE QString getDesktop();
    Q_INVOKABLE void start(){program.start(m_source);}
    Q_INVOKABLE void openFile(){
        QFileInfo fileInfo(m_source);
        QUrl fileUrl = QUrl::fromLocalFile(m_source);

        if (!QDesktopServices::openUrl(fileUrl)) {
            // 处理打开失败的情况
            qDebug() << "无法打开文件:" << m_source;
        }
    }
    Q_INVOKABLE void showPath(){
        QFileInfo fileInfo(m_source);
        qDebug()<<fileInfo.absoluteFilePath();
        QString param = "/select," + QDir::toNativeSeparators(fileInfo.absoluteFilePath());
        QProcess::startDetached("explorer.exe", QStringList(param));
    }
    QString m_source;


signals:
    void sourceChanged(const QString& source);
private:
    QProcess program;
};

#endif
