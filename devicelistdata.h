#ifndef DEVICELISTDATA_H
#define DEVICELISTDATA_H


#include <QObject>

class DeviceListData : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString color READ color WRITE setColor NOTIFY colorChanged)
    Q_PROPERTY(QString connectState READ connectState WRITE setConnectState NOTIFY connectStateChanged)

public:
    DeviceListData(QObject *parent=0);
    DeviceListData(const QString &name, const QString &color,const QString &connectState, QObject *parent=0);

    QString name() const;
    void setName(const QString &name);

    QString color() const;
    void setColor(const QString &color);

    QString connectState() const;
    void setConnectState(const QString &connectState);

signals:
    void nameChanged();
    void colorChanged();
    void connectStateChanged();

private:
    QString m_name;
    QString m_color;
    QString m_connectState;
};

//Q_DECLARE_METATYPE(DeviceListData);

#endif // DEVICELISTDATA_H
