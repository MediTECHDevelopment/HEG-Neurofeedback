import QtQuick 2.11
import QtCharts 2.3
import QtQuick.Window 2.11
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.11
import QtQuick.Extras 1.4
import QtMultimedia 5.9

import QtWebView 1.1

//every import made in the other files should be made here as well. Exception is here QtQuick.Controls 1.4 (needed in UIAnalyseTablePart), cause QtQuick.Controls 2.x is already imported (and needed in this file), don't import Controls 1 and 2 in one file!

ApplicationWindow
{
    id: mainwindow
    title: qsTr("HEG2_QML")
    visible: true
    width: 1000
    height: 600
    minimumWidth: 870
    minimumHeight: 480
    //    visibility: Window.Maximized
    color: "white"

    Component.onCompleted:
    {
        setTimeout(hideSplashScreen,3000)
    }

    Timer
    {
        id: splashTimer
        running: false
        repeat: false

        property var callback

        onTriggered: callback()
    }

    function setTimeout(callback, delay)
    {
        if (splashTimer.running)
        {
            console.error("nested calls to setTimeout are not supported!");
            return;
        }
        splashTimer.callback = callback;
        // note: an interval of 0 is directly triggered, so add a little padding
        splashTimer.interval = delay + 1;
        splashTimer.running = true;
    }

    function hideSplashScreen()
    {
        splashRectangle.visible = false
    }

    Connections
    {
        target: cppController
        onChangeWindowTitle:
        {
            mainwindow.title = newTitle;
        }
        onDisplayMessages:
        {
            universalMessage.title = messageTitle
            universalMessage.text = message;
            universalMessage.visible = true;
        }
    }


    Connections
    {
        target: cppMainHandler
        onShowCloseDecisionBox:
        {
            closingDialog.title = messageTitle;
            closingDialog.text = message;
            closingDialog.visible = true;
        }
        onResetDecisionBox:
        {
            resetDialog.title = messageTitle;
            resetDialog.text = message;
            resetDialog.visible = true;
        }
    }

    property int closeIt: 1
    property bool firstClose: true
    onClosing:
    {
        if (firstClose)
        {
            close.accepted = false
            closeIt = cppMainHandler.close();
            firstClose = false
            if (closeIt === 0)
            {
                mainwindow.close()
            }
        }
    }




    UIController
    {
        id: uicontroller
    }







    Loader
    {
        id: mainloader
        sourceComponent: maintraining
        active: true
    }








    UIMainMenu
    {
        id: uIMainMenu
        visible: true
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
    }




    UIInfoPage
    {
        id: uIInfoPage
        visible: uicontroller.infoPageStatus
        anchors.fill: parent
    }

    Rectangle
    {
        id: startupConnectionBackgroundPane
        color: "#66000000"
        enabled: true
        visible: true
        anchors.fill: parent

        Rectangle
        {
            id: searchingForDeviceBox
            x: 351
            y: 218
            width: 317
            height: 200
            color: "#ffffff"
            radius: 50
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            BusyIndicator
            {
                id: busyIndicator
                x: 199
                y: 70
            }

            Text
            {
                id: element
                x: 17
                y: 70
                width: 176
                height: 60
                text: qsTr("Searching for HEG Device...")
                font.bold: true
                lineHeight: 1
                fontSizeMode: Text.FixedSize
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 12
            }

        }

        Rectangle
        {
            id: connectingToDeviceBox
            x: 356
            y: 215
            width: 317
            height: 200
            color: "#ffffff"
            radius: 50
            visible: false
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            BusyIndicator {
                id: busyIndicator1
                x: 199
                y: 70
            }

            Text {
                id: connectingToDeviceText
                x: 17
                y: 70
                width: 176
                height: 60
                text: qsTr("Connecting to HEG Device...")
                lineHeight: 1
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                fontSizeMode: Text.FixedSize
                font.pixelSize: 12
            }
        }

        Rectangle
        {
            id: deviceFoundBox
            x: 162
            y: 270
            width: 318
            height: 200
            color: "#ffffff"
            radius: 50
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Text
            {
                id: connectedToDeviceText
                height: 49
                text: qsTr("Text")
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 30
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                font.pixelSize: 12
            }

            Button
            {
                id: startupConnectionOKButton
                x: 109
                y: 115
                text: qsTr("Ok")
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
            }
        }


        Rectangle
        {
            id: cantconnectBox
            x: 336
            y: 200
            width: 322
            height: 200
            color: "#ffffff"
            radius: 50
            visible: false
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter

            Text
            {
                id: element1
                x: 49
                y: 49
                width: 225
                height: 46
                text: qsTr("Cant connect to the Device!                      Try turning it off and on and click Ok")
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                font.pixelSize: 12
            }

            Button
            {
                id: retryConnectButton
                x: 112
                y: 112
                text: qsTr("Ok")
            }
        }


        Rectangle
        {
            id: nothingFoundBox
            x: 339
            y: 200
            width: 319
            height: 200
            color: "#ffffff"
            radius: 50
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            visible: false

            Text
            {
                id: element2
                x: 39
                y: 64
                width: 242
                height: 32
                text: qsTr("no device found. Is the Device Turned on? Try charging it.")
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
                font.pixelSize: 12
            }

            Button
            {
                id: analyseModeButton
                x: 14
                y: 128
                text: qsTr("Analyse Mode")
                anchors.horizontalCenterOffset: -55
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                onClicked:
                {
                    uicontroller.analyseMode = true
                    nothingFoundBox.visible = false
                    startupConnectionBackgroundPane.visible = false
                }
            }

            Button
            {
                id: newSearchButton
                y: 119
                text: qsTr("Search")
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                anchors.left: analyseModeButton.right
                anchors.leftMargin: 10
            }

        }

    }

    Rectangle
    {
        id: splashRectangle
        color: "#ffffff"
        visible: true
        clip: true
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        Image
        {
            id: splashImage
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            visible: true
            source: "/icons/Splash.png"
            fillMode: Image.Stretch
        }
    }


    Component
    {
        id: maintraining
        UITrainingMainWindow
        {
            width: mainwindow.width
            height: mainwindow.height
        }
    }





    Component
    {
        id: mainanalyse
        UIAnalyseMainWindow
        {
            width: mainwindow.width
            height: mainwindow.height
        }
    }





    MessageDialog
    {
        id: universalMessage
        visible: false
    }





    MessageDialog
    {
        id: closingDialog
        visible: false
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes:
        {
            cppMainHandler.saveNotes()
            mainwindow.close()
        }
        onNo:
        {
            mainwindow.close()
        }
    }






    MessageDialog
    {
        id: resetDialog
        visible: false
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes:
        {
            cppMainHandler.resetSaveNotes(1)
        }
        onNo:
        {
            cppMainHandler.resetSaveNotes(2)
        }
    }


    Connections
    {
        target: cppBLEController

        onDeviceFound:
        {
            searchingForDeviceBox.visible = false
            connectingToDeviceText.text = qsTr("Connecting to HEG-Device...")
            connectingToDeviceBox.visible = true
        }

        onDeviceConnected:
        {
            connectedToDeviceText.text = qsTr("Connected to ") + deviceName
            searchingForDeviceBox.visible = false
            connectingToDeviceBox.visible = false
            cantconnectBox.visible = false
            deviceFoundBox.visible = true
        }

        onCantConnect:
        {
            searchingForDeviceBox.visible = false
            connectingToDeviceBox.visible = false
            deviceFoundBox.visible = false
            cantconnectBox.visible = true
        }

        onNoDeviceFound:
        {
            searchingForDeviceBox.visible = false
            connectingToDeviceBox.visible = false
            nothingFoundBox.visible = true
        }
    }

    Connections
    {
        target: startupConnectionOKButton
        onClicked:
        {
            startupConnectionBackgroundPane.visible=false
        }
    }

    Connections
    {
        target: retryConnectButton
        onClicked:
        {
            if(uicontroller.deviceListStatus)
            {
                startupConnectionBackgroundPane.visible = false
                searchingForDeviceBox.visible = false
                deviceFoundBox.visible = false
                cantconnectBox.visible = false
                nothingFoundBox.visible = false
            }
            else
            {
                searchingForDeviceBox.visible = true
                deviceFoundBox.visible = false
                cantconnectBox.visible = false

                cppBLEController.searchForBLE(true)
            }
        }
    }

    Connections
    {
        target: newSearchButton
        onClicked:
        {
            if(uicontroller.deviceListStatus)
            {
                startupConnectionBackgroundPane.visible = false
                searchingForDeviceBox.visible = false
                deviceFoundBox.visible = false
                cantconnectBox.visible = false
                nothingFoundBox.visible = false
            }
            else
            {
                searchingForDeviceBox.visible = true
                nothingFoundBox.visible = false
                cppBLEController.searchForBLE(true)
            }
        }
    }







}





/*##^##
Designer {
    D{i:23;anchors_height:100;anchors_width:100}
}
##^##*/
