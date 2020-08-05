import QtQuick 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.4
import QtQuick.Extras 1.4

//UIVideoCtrlPart provides the possibilities to control/ choose the shown video

Item
{
    Connections
    {
        target:cppController
        ignoreUnknownSignals: true
        onUrlButtonEnabled:
        {
            urlButton.enabled = enabled
        }
    }

    Column
    {
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20
        Button
        {
            id: urlButton
            text: qsTr("Open URL")
            onClicked:
            {
                uicontroller.databasestatus = false
                uicontroller.deviceListStatus = false
                uicontroller.settingsstatus = false

                cppController.setWebViewMenueOpen(!uicontroller.webViewControllsMenuOpen)
            }
        }

        CheckBox
        {
            text: qsTr("Mute Video")
            checked: uicontroller.mutestate
            visible: false
            onClicked:
            {
                uicontroller.mutestate = !uicontroller.mutestate
            }
        }
    }

    FileDialog
    {
        id: videoDialog
        title: qsTr("Please choose a videofile")
        folder: shortcuts.home
        nameFilters: "*.mp4"
        onAccepted:
        {
            //uicontroller.videosource = videoDialog.fileUrl

            //uicontroller.videosource = "https://www.radiantmediaplayer.com/media/bbb-360p.mp4"

            uicontroller.videosource = "https://file-examples.com/wp-content/uploads/2017/04/file_example_MP4_640_3MG.mp4"

            cppTrainingHandler.choosenVideoFile(videoDialog.fileUrl);
        }
    }

}
