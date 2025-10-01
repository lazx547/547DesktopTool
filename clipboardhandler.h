#include <QObject>
#include <QGuiApplication>
#include <QApplication>
#include <QFileDialog>
#include <QMessageBox>
#include <QClipboard>
#include <QMimeData>
#include <QProcess>
#include <QImage>
#include <QUuid>
#include <QPixmap>
#include <QScreen>
#include <QFile>
#include <QMimeData>
#include <QQuickItemGrabResult>

class ClipboardHandler : public QObject {
    Q_OBJECT
public:
    explicit ClipboardHandler(QObject *parent = nullptr) : QObject(parent) {}

    Q_INVOKABLE void copyText(const QString &text) {
        QGuiApplication::clipboard()->setText(text);
    }
    Q_INVOKABLE void copyImage(const QString name,int type) {
        QString source;
        switch(type){
        case 0:source="./file/temp/"+name+".png";
            break;
        case 1:source=name;
            break;
        case 2:{QMessageBox* msgBox = new QMessageBox(QMessageBox::Critical,
                                                  "错误",
                                                  "不支持复制网络图片",
                                                  QMessageBox::Ok);
            msgBox->setWindowFlags(Qt::Dialog | Qt::WindowStaysOnTopHint);
            msgBox->setAttribute(Qt::WA_DeleteOnClose);
            msgBox->show();
            return;}
        }
        QGuiApplication::clipboard()->setImage(QImage(source));
    }

    Q_INVOKABLE void copyText(const QImage &image) {
        QGuiApplication::clipboard()->setImage(image);
    }


    Q_INVOKABLE QString pasteText() {
        return QGuiApplication::clipboard()->text();
    }
    Q_INVOKABLE bool hasImage() const
    {
        if (!m_app) return false;
        return m_app->clipboard()->mimeData()->hasImage();
    }

    Q_INVOKABLE bool isEmpty() {
        const QMimeData *m = QGuiApplication::clipboard()->mimeData();
        // 检查是否有任何数据
        return !m || m->formats().isEmpty();
    }

    Q_INVOKABLE QStringList showType(){
        return QGuiApplication::clipboard()->mimeData()->formats();
    }
    QImage getImage() const
    {
        if (!hasImage()) return QImage();
        return qvariant_cast<QImage>(m_app->clipboard()->mimeData()->imageData());
    }
    Q_INVOKABLE QString saveImage()
    {
        if (!hasImage()) return "empty";
        QImage image=getImage();
        QString path,name;
        name=QUuid::createUuid().toString(QUuid::Id128).left(8);
        path = "./file/temp/"+name+".png";
        image.save(path,"PNG");
        return "./temp/"+name+".png";
    }
    QString saveImage(QPixmap i)
    {
        QString path,name;
        name=QUuid::createUuid().toString(QUuid::Id128).left(8);
        path = "./file/temp/"+name+".png";
        i.save(path,"PNG");
        return "./temp/"+name+".png";
    }
    QString saveImage(QImage i)
    {
        QString path,name;
        name=QUuid::createUuid().toString(QUuid::Id128).left(8);
        path = "./file/temp/"+name+".png";
        i.save(path,"PNG");
        return "./temp/"+name+".png";
    }
    void saveImage(QImage i,QString path)
    {
        i.save(path,"PNG");
    }
    Q_INVOKABLE void saveAs(QImage i){
        QString destinationPath = QFileDialog::getSaveFileName(nullptr, "另存为",
                                                               "",
                                                               "PNG 文件 (*.png);;JPEG 文件 (*.jpg *.jpeg);;BMP 文件 (*.bmp)");
        saveImage(i,destinationPath);
    }
    Q_INVOKABLE void restart()
    {
        QProcess::startDetached(QGuiApplication::applicationFilePath(), QGuiApplication::arguments());
        QGuiApplication::quit();
    }
    Q_INVOKABLE void saveAs(const QString &name,int type=0){
        QString destinationPath = QFileDialog::getSaveFileName(nullptr, "另存为",
                                                               "",
                                                               "PNG 文件 (*.png);;JPEG 文件 (*.jpg *.jpeg);;BMP 文件 (*.bmp)");
        if (destinationPath.isEmpty()) {
            return;
        }
        QString source;
        // 读取并保存图片
        switch(type){
        case 0:source="./file/temp/"+name+".png";
            break;
        case 1:source=name;
            break;
        case 2:{QMessageBox* msgBox = new QMessageBox(QMessageBox::Critical,
                                                 "错误",
                                                 "不支持保存网络图片",
                                                 QMessageBox::Ok);
            msgBox->setWindowFlags(Qt::Dialog | Qt::WindowStaysOnTopHint);
            msgBox->setAttribute(Qt::WA_DeleteOnClose);
            msgBox->show();
            return;}
        case 3:
            QByteArray imageData = QByteArray::fromBase64(name.mid(22).toUtf8());
            QImage image;
            image.loadFromData(imageData, "PNG");
            saveImage(image);
            return;
        }
        QImage image(source);
        if (image.isNull()) {
            QMessageBox* msgBox = new QMessageBox(QMessageBox::Critical,
                                                  "错误",
                                                  "加载图片失败",
                                                  QMessageBox::Ok);
            msgBox->setWindowFlags(Qt::Dialog | Qt::WindowStaysOnTopHint);
            msgBox->setAttribute(Qt::WA_DeleteOnClose);
            msgBox->show();
            return;
        }

        if (!image.save(destinationPath)) {
            QMessageBox* msgBox = new QMessageBox(QMessageBox::Critical,
                                                  "错误",
                                                  "保存图片失败",
                                                  QMessageBox::Ok);
            msgBox->setWindowFlags(Qt::Dialog | Qt::WindowStaysOnTopHint);
            msgBox->setAttribute(Qt::WA_DeleteOnClose);
            msgBox->show();
            return;
        }
    }
    Q_INVOKABLE void shot(int x,int y,int w,int h,QString name){
        QImage image("./file/temp/"+name+".png");
        qreal dpr = QGuiApplication::primaryScreen()->devicePixelRatio();
        QRect cropArea(x*dpr, y*dpr,w*dpr,h*dpr);
        QGuiApplication::clipboard()->setImage(image.copy(cropArea));

    }
    Q_INVOKABLE QString shot(){
        QScreen *screen = QGuiApplication::primaryScreen();
        QPixmap screenshot = screen->grabWindow();
        return saveImage(screenshot);
    }
private:
    QGuiApplication *m_app;
    int n;
};
