#include "gfile.h"

#include <QDebug>
#include <QFile>
#include <QFileInfo>
#include <QTextStream>
#include <QStandardPaths>
#include <QApplication>
#include <QCoreApplication>
GFile::GFile(QObject *parent) :
    QObject(parent)
{

}

QString GFile::read()
{
    QString content;
    QFile file(m_source);
    if ( file.open(QIODevice::ReadOnly) ) {
        content = file.readAll();
        file.close();
    }

    return content;
}

bool GFile::write(const QString& data)
{
    QFile file(m_source);
    if ( file.open(QFile::WriteOnly) ) {
        QTextStream out(&file);
           out<<data;
        file.close();
        return true;
    }
    else {
        return false;
    }
}


bool GFile::is(const QString &source)
{
    QFileInfo file(source);
    return file.isFile();
}

void GFile::create(const QString &source)
{
    QString source_=QCoreApplication::applicationDirPath()+source.sliced(1,source.indexOf("\\"))+"/";
    QDir qDir=source_;
    qDebug()<<qDir;
    qDebug()<<qDir.mkpath(source);
}

QString GFile::getUser()
{
    return QDir::home().dirName();
}

QString GFile::getDesktop()
{
    return QStandardPaths::writableLocation(QStandardPaths::DesktopLocation);
}
