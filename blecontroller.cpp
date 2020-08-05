#include "blecontroller.h"

#include <QDebug>
#include <QThread>

#include "devicelistdata.h"

BLEController::BLEController(QQmlContext* rootContext,HEGDevice* hegDevice)
{
    m_connectionTimer = new QTimer(this);
    connect(m_connectionTimer, SIGNAL(timeout()), this, SLOT(connectionTimerTimeout()));

    m_rootContext = rootContext;

    qInfo( "ZUUL:SEARCH setup" );

    m_discoveryAgent->setLowEnergyDiscoveryTimeout(10000);

    BLEController::connect(m_discoveryAgent, SIGNAL( deviceDiscovered(QBluetoothDeviceInfo) ), this, SLOT( deviceDiscovered(QBluetoothDeviceInfo) ) );

    //BLEController::connect(discoveryAgent, SIGNAL( error(QBluetoothDeviceDiscoveryAgent::Error error) ), this, SLOT( scanError(QBluetoothDeviceDiscoveryAgent::Error error) ) );
    connect(m_discoveryAgent, static_cast<void (QBluetoothDeviceDiscoveryAgent::*)(QBluetoothDeviceDiscoveryAgent::Error)>(&QBluetoothDeviceDiscoveryAgent::error), this, &BLEController::scanError);

    BLEController::connect(m_discoveryAgent, SIGNAL( finished() ), this, SLOT( scanFinished() ) );
    BLEController::connect(m_discoveryAgent, SIGNAL( canceled() ), this, SLOT( scanCancled() ) );

    m_HEGDevice = hegDevice;
}

BLEController::~BLEController()
{
    delete m_discoveryAgent;
    delete m_hegMonitorController;
    delete m_valuesCharCharactersitic;
    delete m_rootContext;
    delete m_connectionTimer;
}

void BLEController::searchForBLE(bool autoconnectToFirstDevice)
{
    m_shouldAutoconnectToFirstFoundDevice = autoconnectToFirstDevice;

    qInfo( "ZUUL:SEARCH start" );

    Q_EMIT searchStarted();

    m_foundBluetoothDevices = std::list<QBluetoothDeviceInfo>();

    m_dataListModel = {};
    m_rootContext->setContextProperty("deviceListModel",QVariant::fromValue(m_dataListModel));

    m_discoveryAgent->start(QBluetoothDeviceDiscoveryAgent::LowEnergyMethod);
}

void BLEController::deviceDiscovered(const QBluetoothDeviceInfo &device)
{
    qDebug() << "Found new device:" << device.name() << '(' << device.address().toString() << ')';

    auto deviceNameStart = device.name().left(3);

    if(deviceNameStart == "HEG")
    {
        addDeviceToList(device);
    }
}

void BLEController::addDeviceToList(const QBluetoothDeviceInfo &device)
{
    m_foundBluetoothDevices.push_back(device);
    qInfo("added");

    Q_EMIT deviceFound(m_foundBluetoothDevices);

    m_dataListModel.append(new DeviceListData(device.name(), "red" , "connect"));

    m_rootContext->setContextProperty("deviceListModel",QVariant::fromValue(m_dataListModel));

    if(m_shouldAutoconnectToFirstFoundDevice)
    {
        m_discoveryAgent->stop();
        m_connectionTimer->start(m_timeoutInterval);
        connectToDevice(device);
    }
}

void BLEController::scanError(QBluetoothDeviceDiscoveryAgent::Error error)
{
    if (error == QBluetoothDeviceDiscoveryAgent::PoweredOffError)
    {
        qInfo("The Bluetooth adaptor is powered off, power it on before doing discovery.");
    }
    else if (error == QBluetoothDeviceDiscoveryAgent::InputOutputError)
    {
        qInfo("Writing or reading from the device resulted in an error.");
    }
    else
    {
        qInfo("An unknown scan error has occurred.");
    }

    Q_EMIT searchFinished();
}

void BLEController::scanCancled()
{
    qInfo( "scan canceled" );
    Q_EMIT searchFinished();
}

void BLEController::scanFinished()
{
    qInfo( "scan finished" );

    Q_EMIT searchFinished();

    std::list<QBluetoothDeviceInfo>::iterator it;
    for(it = m_foundBluetoothDevices.begin(); it != m_foundBluetoothDevices.end(); ++it)
    {
        qDebug() << "Device in list:" << (*it).name() << '(' << (*it).address().toString() << ')';
    }

    if(m_foundBluetoothDevices.size() == 0)
    {
        Q_EMIT noDeviceFound();
    }
}

void BLEController::connectByName(const QString &deviceName)
{
    m_discoveryAgent->stop();

    QBluetoothDeviceInfo deviceToConnectTo;

    qDebug() << "connect to: " << deviceName;

    bool found = false;

    std::list<QBluetoothDeviceInfo>::iterator it;
    for(it = m_foundBluetoothDevices.begin(); it != m_foundBluetoothDevices.end(); ++it)
    {
        qDebug() << "Device in list:" << (*it).name() << '(' << (*it).address().toString() << ')';
        if( (*it).name() == deviceName )
        {
            qDebug() << "found:" << (*it).name() << '(' << (*it).address().toString() << ')';
            deviceToConnectTo = (*it);
            found = true;
            break;
        }
    }

    if(found)
    {
        m_connectionTimer->start(m_timeoutInterval);
        connectToDevice(deviceToConnectTo);
    }

}

void BLEController::disconnect()
{
    if(m_hegMonitorController != NULL)
    {
        m_hegMonitorController->disconnectFromDevice();
    }
}

void BLEController::connectToDevice(const QBluetoothDeviceInfo &device)
{
    m_targetDeviceForConnection = device;

    m_hegMonitorController = QLowEnergyController::createCentral(device, this);

    connect(m_hegMonitorController, &QLowEnergyController::serviceDiscovered ,this, &BLEController::serviceDiscovered );
    connect(m_hegMonitorController,SIGNAL( discoveryFinished() ),this, SLOT( discoveryFinished() ) );
    connect(m_hegMonitorController,SIGNAL( connected() ),this, SLOT( connected() ) );
    connect(m_hegMonitorController,SIGNAL( disconnected() ),this, SLOT( disconnected() ) );

    connect(m_hegMonitorController, static_cast<void (QLowEnergyController::*)(QLowEnergyController::Error)>(&QLowEnergyController::error),this,
        [this](QLowEnergyController::Error error)
        {
            qInfo("Cannot connect to remote device.");
            m_connectionTimer->stop();
            Q_EMIT cantConnect();
        });

    qInfo( "ZUUL:CONNECT" );
    m_hegMonitorController->connectToDevice();
}

void BLEController::serviceDiscovered(const QBluetoothUuid &newService)
{
    auto pinServiceUUIIDString = "{00001826-0000-1000-8000-00805f9b34fb}";

    qInfo( "new serviceDiscovered: " + newService.toString().toUtf8() );

    if( newService.toString().toUtf8() == pinServiceUUIIDString )
    {
        qInfo( "pin serviceDiscovered" );
        m_pinService = m_hegMonitorController->createServiceObject(newService, this);
    }
}
void BLEController::stateChanged(QLowEnergyController::ControllerState state)
{
    qInfo( "stateChanged" );
}
void BLEController::discoveryFinished()
{
    qInfo( "discoveryFinished" );

    connect(m_pinService, &QLowEnergyService::stateChanged, this, &BLEController::serviceStateChanged);
    connect(m_pinService, &QLowEnergyService::characteristicChanged, this, &BLEController::updatePinValue);
    connect(m_pinService, &QLowEnergyService::descriptorWritten, this, &BLEController::confirmedDescriptorWrite);
    m_pinService->discoverDetails();
}
void BLEController::connected()
{
    qInfo( "connected" );

    m_hegMonitorController->discoverServices();
}
void BLEController::disconnected()
{
    m_HEGDevice->resetHEGDevice();

    qInfo( "disconnected" );
}
void BLEController::connectionUpdated(const QLowEnergyConnectionParameters &newParameters)
{
    qInfo( "connectionUpdated" );
}

void BLEController::serviceStateChanged(QLowEnergyService::ServiceState s)
{
    qInfo( "serviceStateChanged" );

    switch(s)
    {
        case QLowEnergyService::DiscoveringServices:
            qInfo("Discovering services...");
            break;
        case QLowEnergyService::ServiceDiscovered:
        {
            m_connectionTimer->stop();

            Q_EMIT deviceConnected(m_hegMonitorController->remoteName() );

            QString deviceName = m_hegMonitorController->remoteName();

            int index = 0 ;
            std::list<QBluetoothDeviceInfo>::iterator it;
            for(it = m_foundBluetoothDevices.begin(); it != m_foundBluetoothDevices.end(); ++it)
            {
                if( (*it).name() == deviceName )
                {
                   m_dataListModel.removeAt(index);
                   m_dataListModel.append( new DeviceListData(deviceName , "green" , "disconnect") );
                   m_rootContext->setContextProperty("deviceListModel",QVariant::fromValue(m_dataListModel));
                }
                index +=1;
            }


            qInfo("Service discovered.");

            // 1855
            //QString uuidQString = "1855";
            //QBluetoothUuid valuesCharCharacteristicUuid = QBluetoothUuid(uuidQString);  // funktioniert noch nicht
            //qInfo( "valuesCharacteristic: " + valuesCharCharacteristicUuid.toString().toUtf8() );

            auto allCharacteristics = m_pinService->characteristics();

            auto valuesCharacteristicUUIIDString = "{00001855-0000-1000-8000-00805f9b34fb}";

            QLowEnergyCharacteristic valuesCharCharactersitic;
            foreach( QLowEnergyCharacteristic item, allCharacteristics )
            {
                qInfo( "char: " + item.name().toUtf8() + "  " +  item.uuid().toString().toUtf8() );

                if(item.uuid().toString().toUtf8() == valuesCharacteristicUUIIDString)
                {
                    valuesCharCharactersitic = item;
                }
            }

            //const QLowEnergyCharacteristic valuesCharCharactersitic = m_pinService->characteristic(valuesCharCharacteristicUuid);
            // direct characteristic mit uuid holen ohne der for schleife

            if (!valuesCharCharactersitic.isValid())
            {
                qInfo("ValuesChar Data not found.");
                break;
            }

            m_valuesCharCharactersitic = &valuesCharCharactersitic;

            m_notificationDesc = valuesCharCharactersitic.descriptor(QBluetoothUuid::ClientCharacteristicConfiguration);
            if (m_notificationDesc.isValid())
            {
                m_pinService->writeDescriptor(m_notificationDesc, QByteArray::fromHex("0100"));
            }
            break;
        }
        default:
            //nothing for now
            break;
    }
}

QString BLEController::getConnectedDeviceName()
{
    if(m_hegMonitorController == NULL)
    {
        return "";
    }

    return m_hegMonitorController->remoteName();
}

void BLEController::updatePinValue(const QLowEnergyCharacteristic &c, const QByteArray &value)
{
    if( m_isInPlaystate )
    {
        auto byte1 = ((static_cast<unsigned int>(value[0]) & 0xFF) << 8) + (static_cast<unsigned int>(value[1]) & 0xFF);
        auto byte2 = ((static_cast<unsigned int>(value[2]) & 0xFF) << 8) + (static_cast<unsigned int>(value[3]) & 0xFF);

        /*qInfo("---updatePinValue--- ");
        qInfo("Byte1: " + QString::number(byte1).toUtf8() );
        qInfo("Byte2: " + QString::number(byte2).toUtf8() );*/

        m_HEGDevice->createSample(byte1,byte2);
    }
}

void BLEController::confirmedDescriptorWrite()
{
    qInfo( "confirmedDescriptorWrite" );
}

void BLEController::connectionTimerTimeout()
{
    qInfo( "timeout zuul" );
    connectToDevice(m_targetDeviceForConnection);
}

void BLEController::setIsInPlaystate(bool playstatate)
{
    m_isInPlaystate = playstatate;
}
















