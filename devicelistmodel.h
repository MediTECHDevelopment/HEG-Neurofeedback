#ifndef DEVICELISTMODEL_H
#define DEVICELISTMODEL_H

#include <QAbstractItemModel>

class DeviceListModel : public QAbstractItemModel
{
    Q_OBJECT

public:
    explicit DeviceListModel(QObject *parent = nullptr);

    enum ListRoles
    {
        DeviceNameRole,
        ButtonRole
    };

    // Header:
    QVariant headerData(int section, Qt::Orientation orientation, int role = Qt::DisplayRole) const override;

    // Basic functionality:
    QModelIndex index(int row, int column,const QModelIndex &parent = QModelIndex()) const override;
    QModelIndex parent(const QModelIndex &index) const override;

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    int columnCount(const QModelIndex &parent = QModelIndex()) const override;

    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;

private:
};

#endif // DEVICELISTMODEL_H
