import QtQuick 2.0
import QtQuick.Controls 2.4

//UITrainingView equivalent to UIAnalyseView

Item {
    Connections{
        target: uicontroller
        ignoreUnknownSignals: true
        onDatabasestatusChanged: {
            if (!uicontroller.databasestatus)
                trainingmainstack.pop()
            else
                trainingmainstack.push(databaseview)
        }
        onSettingsstatusChanged: {
            if (!uicontroller.settingsstatus)
                trainingmainstack.pop()
            else
                trainingmainstack.push(trainingsettings)
        }

        onDeviceListStatusChanged:
        {  //changed through the main-buttons
            if (!uicontroller.deviceListStatus)
                trainingmainstack.pop()
            else
                trainingmainstack.push(deviceListView)
        }
    }

    StackView {
        id: trainingmainstack
        initialItem: trainingpart
        anchors.fill: parent
    }

    Component
    {
        id: trainingpart
        UITrainingStates{}
    }

    Component
    {
        id: trainingsettings
        UITrainingSettings{ }
    }

    Component
    {
        id: databaseview
        UIDatabaseView{ }
    }

    Component
    {
        id: deviceListView
        UIDeviceListView{ }
    }

    BusyIndicator{
//        running: mainstack.status === mainstack.Loading
        running: trainingsettings.status === trainingsettings.Loading
        anchors.centerIn: parent
    }
}
