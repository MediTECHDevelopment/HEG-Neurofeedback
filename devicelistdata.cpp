#include "devicelistdata.h"

#include <QDebug>

DeviceListData::DeviceListData(QObject *parent): QObject(parent)
{
}

DeviceListData::DeviceListData(const QString &name, const QString &color, const QString &connectState, QObject *parent) : QObject(parent), m_name(name), m_color(color) , m_connectState(connectState)
{
}

QString DeviceListData::name() const
{
    return m_name;
}

void DeviceListData::setName(const QString &name)
{
    if (name != m_name)
    {
        m_name = name;
        emit nameChanged();
    }
}

QString DeviceListData::color() const
{
    return m_color;
}

void DeviceListData::setColor(const QString &color)
{
    if (color != m_color)
    {
        m_color = color;
        emit colorChanged();
    }
}

QString DeviceListData::connectState() const
{
    return m_connectState;
}

void DeviceListData::setConnectState(const QString &connectState)
{
    if (connectState != m_connectState)
    {
        m_connectState = connectState;
        emit connectStateChanged();
    }

}
