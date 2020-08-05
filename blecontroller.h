#ifndef BLECONTROLLER_H
#define BLECONTROLLER_H

#include <QObject>

#include <list>

#include <qbluetoothdevicediscoveryagent.h>
#include <QLowEnergyController>
#include <QtBluetooth>

#include <QQmlContext>

#include <QTimer>

#include "hegdevice.h"

#include "devicelistdata.h"

class BLEController : public QObject
{
    Q_OBJECT
public:    
    QBluetoothDeviceDiscoveryAgent* m_discoveryAgent = new QBluetoothDeviceDiscoveryAgent;

    QLowEnergyController* m_hegMonitorController;

    QLowEnergyService *m_pinService;

    QLowEnergyCharacteristic* m_valuesCharCharactersitic;

    QLowEnergyDescriptor m_notificationDesc;

    std::list<QBluetoothDeviceInfo> m_foundBluetoothDevices;

    QQmlContext* m_rootContext;

    QList<QObject*> m_dataListModel;

    HEGDevice *m_HEGDevice;

    BLEController(QQmlContext* rootContext,HEGDevice* hegDevice);
    ~BLEController();

    void connectToDevice(const QBluetoothDeviceInfo &device);

    void addDeviceToList(const QBluetoothDeviceInfo &device);

    Q_INVOKABLE void setIsInPlaystate(bool playstatate);

    Q_INVOKABLE void searchForBLE(bool autoconnectToFirstDevice);
    Q_INVOKABLE void connectByName(const QString &deviceName);
    Q_INVOKABLE void disconnect();
    Q_INVOKABLE QString getConnectedDeviceName();

    Q_SIGNAL void searchStarted();
    Q_SIGNAL void searchFinished();
    Q_SIGNAL void deviceFound(const std::list<QBluetoothDeviceInfo> &deviceList);
    Q_SIGNAL void deviceConnected(const QString &deviceName);
    Q_SIGNAL void cantConnect();
    Q_SIGNAL void noDeviceFound();

private:
    QBluetoothDeviceInfo m_targetDeviceForConnection;
    bool m_shouldAutoconnectToFirstFoundDevice = false;
    QTimer *m_connectionTimer;
    int m_timeoutInterval = 5000;

    bool m_isInPlaystate = false;

public slots:
    void deviceDiscovered(const QBluetoothDeviceInfo &device);
    void scanError(QBluetoothDeviceDiscoveryAgent::Error error);
    void scanFinished();
    void scanCancled();

    void serviceDiscovered(const QBluetoothUuid &newService);
    void stateChanged(QLowEnergyController::ControllerState state);
    void discoveryFinished();
    void connected();
    void disconnected();
    void connectionUpdated(const QLowEnergyConnectionParameters &newParameters);

    void serviceStateChanged(QLowEnergyService::ServiceState s);
    void updatePinValue(const QLowEnergyCharacteristic &c, const QByteArray &value);
    void confirmedDescriptorWrite();

private slots:
    void connectionTimerTimeout();

};

#endif // BLECONTROLLER_H
