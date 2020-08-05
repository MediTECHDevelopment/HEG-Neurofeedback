import QtQuick 2.0
import QtQuick.Dialogs 1.3

//UIDataBase composes all the databaseparts

Item {
    id: element
    Connections
    {
        target: cppDatabaseHandler
        ignoreUnknownSignals: true
        onDeleteButtonDecisionBox:
        {
            deleteClientDialog.title = boxTitle
            deleteClientDialog.text = message
            deleteClientDialog.visible = true
        }
        onDeleteButtonMeasurementDecisionBox:
        {
            deleteMeasurementDialog.title = boxTitle
            deleteMeasurementDialog.text = message
            deleteMeasurementDialog.visible = true
        }
        onSaveAsCSVDecision:
        {
            selectCSVFileNameDialog.open();
        }
    }

    Text
    {
        id: heading
        text: qsTr("Database Manager")
        font.pixelSize: parent.height * 0.02
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: chooseclientpart.top
        anchors.bottomMargin: parent.height * 0.002
    }

    UIChooseClientPart
    {
        id: chooseclientpart
        width: parent.width * 0.95
        anchors.bottom: databasemanagepart.top
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: heading.height * 2
        visible: !uicontroller.showResult
    }

    UIClientDataMainPart
    {
        id: clienddatamainpart
        width: parent.width * 0.95
        height: 100
        anchors.left: parent.left
        anchors.leftMargin: parent.height * 0.005
        anchors.top: parent.top
        anchors.topMargin: heading.height * 2
        visible: uicontroller.showResult
    }

    UIClientMeasurementPart
    {
        id: clientmeasurmentpart
        width: parent.width * 0.95
        height: 50
        anchors.bottom: databasemanagepart.top
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: parent.height * 0.01
        anchors.top: clienddatamainpart.bottom
         visible: uicontroller.showResult
    }

    UIDatabaseManagePart
    {
        id: databasemanagepart
        height: 40
        anchors.right: parent.right
        anchors.rightMargin: 0
        clip: false
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: parent.left
    }

    MessageDialog {
        id: deleteClientDialog
        visible: false
        standardButtons: StandardButton.Yes | StandardButton.Discard

        onYes: {
            cppDatabaseHandler.deleteClientDecision(1)
        }
        onDiscard: {
            cppDatabaseHandler.deleteClientDecision(2)
        }
    }

    MessageDialog {
        id: deleteMeasurementDialog
        visible: false
        standardButtons: StandardButton.Yes | StandardButton.Discard

        onYes: {
            cppDatabaseHandler.deleteMeasurementDecision(1)
        }
        onDiscard: {
            cppDatabaseHandler.deleteMeasurementDecision(2)
        }
    }

    FileDialog {
        id: selectCSVFileNameDialog
        //selectExisting: false
        visible: false
        title: qsTr("Select Directory");
        selectFolder: true
        onAccepted: {
            cppDatabaseHandler.getCSVFilename(fileUrl)
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:3;anchors_height:432}D{i:5;anchors_height:336.8}
D{i:6;anchors_width:640}
}
##^##*/
