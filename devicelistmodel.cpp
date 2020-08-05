#include "devicelistmodel.h"

DeviceListModel::DeviceListModel(QObject *parent)
    : QAbstractItemModel(parent)
{
}

QVariant DeviceListModel::headerData(int section, Qt::Orientation orientation, int role) const
{
    // FIXME: Implement me!
}

QModelIndex DeviceListModel::index(int row, int column, const QModelIndex &parent) const
{
    // FIXME: Implement me!
}

QModelIndex DeviceListModel::parent(const QModelIndex &index) const
{
    // FIXME: Implement me!
}

int DeviceListModel::rowCount(const QModelIndex &parent) const
{
    if (!parent.isValid())
        return 0;

    return 4;
    // FIXME: Implement me!
}

int DeviceListModel::columnCount(const QModelIndex &parent) const
{
    if (!parent.isValid())
        return 0;

    return 3;
    // FIXME: Implement me!
}

QVariant DeviceListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    // FIXME: Implement me!
    return QVariant();
}
