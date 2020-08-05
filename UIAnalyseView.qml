import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.3

//UIAnalyseView controls the different main-Components for the Analyse-Window (the Dataview itself, Settings and Database)

Item
{
    Connections
    {
        target: uicontroller
        ignoreUnknownSignals: true
        onDatabasestatusChanged:
        {  //changed through the main-buttons
            if (!uicontroller.databasestatus)
                analysemainstack.pop()
            else
                analysemainstack.push(databaseview)
        }

        onSettingsstatusChanged:
        {  //changed through the main-buttons
            if (!uicontroller.settingsstatus)
                analysemainstack.pop()
            else
                analysemainstack.push(analysesettings)
        }

        onDeviceListStatusChanged:
        {  //changed through the main-buttons
            if (!uicontroller.deviceListStatus)
                analysemainstack.pop()
            else
                analysemainstack.push(deviceListView)
        }


    }

    StackView
    {
        id: analysemainstack
        initialItem: analysepart
        anchors.fill: parent
    }

    Component
    {
        id: analysepart
        UIAnalyseStates {}
    }

    Component
    {
        id: analysesettings
        UIAnalyseSettings{ }
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

    MessageDialog
    {
        id: saveStopMeasurementDialog
        visible: false
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes:
        {
            cppMainHandler.changeTableHeader()
            cppTrainingHandler.stopSaveDecision(1)
        }
        onNo:
        {
            cppMainHandler.changeTableHeader()
            cppTrainingHandler.stopSaveDecision(2)
        }
    }

}
