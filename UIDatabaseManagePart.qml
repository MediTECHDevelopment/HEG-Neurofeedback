import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.3

//UIDatabaseManagePart includes most of the databasebuttons

Rectangle
{
    id: rectangle
    height: 50

    Connections
    {
        target: cppDatabaseHandler
        ignoreUnknownSignals: true
        onNoClientLayout:
        {
            newClientButton.enabled = true;
            editClientButton.enabled = false;
            deleteClientButton.enabled = false;
            //loadMeasurementButton.enabled = false;
            saveMeasurementButton.enabled = false;
            activateMeasurementButton.enabled = false;
        }
        onNewButtonActive:
        {
            newClientButton.enabled = newActive;
        }
        onEditButtonActive:
        {
            editClientButton.enabled = editActive;
        }
        onDeleteButtonActive:
        {
            deleteClientButton.enabled = deleteActive;
        }
        onLoadButtonActive:
        {
            //loadMeasurementButton.enabled = loadActive;
        }
        onSaveButtonActive:
        {
            //saveMeasurementButton.enabled = saveActive;
        }
        onActivateButtonActive:
        {
            activateMeasurementButton.enabled = activateActive;
        }

        onSaveButtonDecisionBox:
        {
            saveButtonDialog.text = message;
            saveButtonDialog.visible = true;
        }
        onLastMeasurementDeleted:
        {
            if(uicontroller.showResult)
            {
                uicontroller.deletedLastResult = true
                uicontroller.addedResultToActiveClient = false
                uicontroller.resultActive = false
                uicontroller.databasestatus = false
                uicontroller.showResult = false
                uicontroller.mainMenuStatus = true
            }
        }
    }

    Rectangle
    {
        id: clientpart
        width: 390
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        clip: false
        anchors.leftMargin: 5
        anchors.left: parent.left

        Row
        {
            width: 286
            height: 480
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            visible:  uicontroller.clientsActive
            spacing: 5
            Button
            {
                id: newClientButton
                width: 90
                height: rectangle.height
                enabled: true
                text: qsTr("New")
                visible: !uicontroller.showResult
                onClicked:
                {
                    cppDatabaseHandler.setNewClientBool(true);
                    databaseStack.push(clientbase)
                }
            }
            Button
            {
                id: editClientButton
                width: 90
                height: rectangle.height
                enabled: false
                text: qsTr("Edit")
                visible: !uicontroller.showResult
                onClicked:
                {
                    databaseStack.push(clientbase)
                    cppDatabaseHandler.editButton();
                }
            }
            Button
            {
                id: deleteClientButton
                width: 90
                height: rectangle.height
                enabled: false
                text: qsTr("Delete")
                visible: !uicontroller.showResult
                onClicked:
                {
                    cppDatabaseHandler.deleteButton();
                }
            }

            Button
            {
                id: activateMeasurementButton
                width: 90
                height: rectangle.height
                enabled: false
                text: qsTr("Activate")
                visible: !uicontroller.showResult
                onClicked:
                {
                    cppDatabaseHandler.acceptActivate();
                }
            }
        }

    }


    Rectangle
    {
        id: rectangle1
        x: 310
        width: 185
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        clip: true
        anchors.rightMargin: 5
        anchors.right: parent.right
        Row
        {
            width: 290
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            spacing: 5

            Button
            {
                id: loadMeasurementButton
                width: 90
                height: rectangle.height
                enabled: true
                text: qsTr("Load")
                visible: uicontroller.showResult
                onClicked:
                {
                    uicontroller.firstRuntimeSettings = true
                    cppDatabaseHandler.loadButton();
                    uicontroller.totalselect = true
                    uicontroller.firstselect = false
                    uicontroller.secondselect = false
                    uicontroller.thirdselect = false
                    uicontroller.forthselect = false

                    uicontroller.barstate = false
                    uicontroller.layoutid = uicontroller.layoutchange(uicontroller.barstate, uicontroller.linestate, uicontroller.vidstate)
                    cppMainHandler.changeTableHeader()

                    uicontroller.showSettingsButton = true
                    uicontroller.showBackToMenuButton = false
                    uicontroller.showResultFinishButton = true
                    uicontroller.showSelectionPart = true
                }
            }

            Button
            {
                id: deleteMeasurementButton
                width: 90
                height: rectangle.height
                text: qsTr("Delete")
                enabled: true
                visible: uicontroller.showResult
                onClicked:
                {
                    cppDatabaseHandler.deleteButton();
                }
            }
            /*Button
            {
                id: saveMeasurementButton
                width: 90
                height: rectangle.height
                enabled: false
                text: qsTr("Save")
                visible: uicontroller.showResult
                onClicked:
                {
                    cppDatabaseHandler.saveButton();
                }
            }*/

        }
    }

    MessageDialog
    {
        id: saveButtonDialog
        title: qsTr("Save treshold and videopath?")
        text: ""
        visible: false
        standardButtons: StandardButton.Yes | StandardButton.No | StandardButton.Cancel

        onNo:
        {
            cppDatabaseHandler.saveButtonDecision(1);
            uicontroller.databasestatus = false;
        }
        onYes:
        {
            cppDatabaseHandler.saveButtonDecision(2);
            uicontroller.databasestatus = false;
        }
        onRejected:
        {
            cppDatabaseHandler.saveButtonDecision(3);
        }
    }
}

/*##^##
Designer {
    D{i:7;anchors_height:480;anchors_width:294.40000000000003;anchors_y:0}D{i:3;anchors_width:300;anchors_x:0}
D{i:2;anchors_height:480}D{i:9;anchors_width:360;anchors_x:0}D{i:8;anchors_height:480;anchors_width:360;anchors_x:0;anchors_y:0}
}
##^##*/
