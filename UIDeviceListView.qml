import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11

Item
{
    id: element

    Component.onCompleted:
    {
        if(!uicontroller.analyseMode)
        {
            var deviceName = cppBLEController.getConnectedDeviceName()
            connectedDeviceText.text= qsTr("HEG device: ") + deviceName
        }
        else
        {
            hideDeviceLabel()
        }
    }

    Button
    {
        id: searchButton
        text: qsTr("Search")
        visible: false
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20

        onClicked:
        {
            cppBLEController.searchForBLE(false);
        }
    }

    Text
    {
        id: searchLabel
        width: 89
        height: 40
        text: qsTr("")
        anchors.left: searchButton.right
        anchors.leftMargin: 6
        anchors.top: parent.top
        anchors.topMargin: 20
        visible: false
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 12
    }

    Text
    {
        id: connectedDeviceText
        width: 200
        height: 40
        text: qsTr("Test")
        horizontalAlignment: Text.AlignRight
        anchors.right: disconnectButton.left
        anchors.rightMargin: 5
        anchors.left: searchLabel.right
        anchors.leftMargin: 5
        anchors.top: parent.top
        anchors.topMargin: 20
        visible: true
        verticalAlignment: Text.AlignVCenter
    }

    Connections
    {
        target: startupConnectionOKButton
        onClicked:
        {
            startupConnectionBackgroundPane.visible = false
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
        }
    }

    Connections
    {
        target: cppBLEController
        onSearchStarted:
        {
            searchLabel.text = qsTr("searching...")
            searchButton.enabled = false
        }
        onSearchFinished:
        {
            searchLabel.text = ""
            searchButton.enabled = true
        }
        onDeviceFound:
        {
            searchingForDeviceBox.visible = false
            connectingToDeviceText.text = qsTr("Connecting to HEG-Device...")
            connectingToDeviceBox.visible = true
        }
        onDeviceConnected:
        {
            uicontroller.isConnectedToDevice = true
            connectedDeviceText.text= qsTr("HEG device: ") + deviceName
            showDeviceLabel()

            startupConnectionBackgroundPane.visible = true
            connectedToDeviceText.text = qsTr("Connected to ") + deviceName
            searchingForDeviceBox.visible = false
            connectingToDeviceBox.visible = false
            cantconnectBox.visible = false
            deviceFoundBox.visible = true

            uicontroller.analyseMode = false
        }

        onCantConnect:
        {
            startupConnectionBackgroundPane.visible = true
            searchingForDeviceBox.visible = false
            connectingToDeviceBox.visible = false
            deviceFoundBox.visible = false
            cantconnectBox.visible = true
        }

        onNoDeviceFound:
        {
            startupConnectionBackgroundPane.visible = true
            searchingForDeviceBox.visible = false
            connectingToDeviceBox.visible = false
            nothingFoundBox.visible = true
        }
    }

    function showDeviceLabel()
    {
        disconnectButton.visible = true
        connectedDeviceText.visible = true
        foundDevicesListView.visible = false
        searchButton.visible = false
        searchLabel.visible = false
    }

    function hideDeviceLabel()
    {
        disconnectButton.visible = false
        connectedDeviceText.visible = false

        foundDevicesListView.visible = true
        searchButton.visible = true
        searchLabel.visible = true
    }


    ListView
    {
        id: foundDevicesListView
        objectName: "foundDevicesListView"
        x: 20
        y: 66
        width: 220
        height: 394
        visible: false
        flickableDirection: Flickable.HorizontalFlick
        spacing: 5
        model: deviceListModel

        delegate: Item
        {
            x: 5
            width: 200
            height: 40

            Row
            {
                id: row1
                spacing: 10
                Rectangle
                { 
                    width: 20
                    height: 40
                    color: model.modelData.color
                }

                Text
                {
                    width: 120
                    height: 40
                    verticalAlignment: Text.AlignVCenter
                    text: name
                    font.bold: true
                    anchors.verticalCenter: parent.verticalCenter
                }

                Button
                {
                    width: 80
                    height: 40
                    text: connectState
                    onClicked:
                    {
                        if (connectState == "connect")
                        {
                            cppBLEController.disconnect();
                            uicontroller.isConnectedToDevice = false

                            connectedDeviceText.text= qsTr("HEG device: ") + name
                            cppBLEController.connectByName(name);

                            startupConnectionBackgroundPane.visible = true
                            searchingForDeviceBox.visible = false
                            deviceFoundBox.visible = false
                            cantconnectBox.visible = false

                        }
                        else
                        {
                            cppBLEController.disconnect();
                            uicontroller.isConnectedToDevice = false
                        }
                    }
                }
            }
        }
    }

    Button
    {
        id: disconnectButton
        x: 20
        text: qsTr("Disconnect")
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 20
        visible: true
        enabled: true
        onClicked:
        {
            hideDeviceLabel()

            cppBLEController.disconnect();
            uicontroller.isConnectedToDevice = false

            cppBLEController.searchForBLE(false);

            uicontroller.analyseMode = true
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
