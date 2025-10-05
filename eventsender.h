#ifndef EVENTSENDER_H
#define EVENTSENDER_H

#include <QObject>
#include <QVariant>
#include <windows.h>
#include <QTimer>

class EventSender : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QVariant data READ data NOTIFY dataChanged)
public:
    QVariant data() const { return m_data; }
    // 直接发射信号的函数
    Q_INVOKABLE void send(const QVariant &_data)
    {
        m_data=_data;
        emit dataChanged(m_data);
    }
    QVariant m_data;

signals:
    void dataChanged(const QVariant &data);
};
#endif // EVENTSENDER_H
