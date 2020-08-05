import QtQuick 2.0
import QtCharts 2.3
import QtQuick.Controls 2.1

//UIPlayButtonPart provides the three Buttons play, pause and stop to control a measurement. Several functions are bound to each button

Item
{
    id: playButtons
    state: "beginning"

    signal newTrainingSignal();
    Column
    {
        id: column
        spacing: 10
        anchors.horizontalCenter: parent.horizontalCenter
        Button
        {
            id: playButton
            width: playButtons.height * 0.15
            height: width
            icon.name: "play"
            icon.source: "/icons/Start.png"
            icon.height: height * 0.7
            icon.width: width * 0.7
            icon.color: "limegreen"
            background: Rectangle
            {
                anchors.fill: parent
                border.width: 1
            }

            onClicked:
            {
                if (uicontroller.playFirstClicked)
                {               
                    uicontroller.timetimerruns = true;
                    uicontroller.playFirstClicked = false;
                }

                cppBLEController.setIsInPlaystate( true )

                cppTrainingHandler.start();
                playButtons.state = "playclicked"
                uicontroller.playstate = true
                uicontroller.pausestate = false
                uicontroller.playVideo = true

                uicontroller.databasestatus = false
                uicontroller.deviceListStatus = false
                uicontroller.settingsstatus = false
                //uicontroller.linestate = false

                cppController.setURLButtonEnabled(false)
            }
        }

        Button
        {
            id: pauseButton
            width: playButtons.height * 0.15
            height: width
            icon.name: "pause"
            icon.source: "/icons/Pause.png"
            icon.height: height * 0.7
            icon.width: width * 0.7
            icon.color: "yellow"
            background: Rectangle
            {
                anchors.fill: parent
                border.width: 1
            }

            onClicked:
            {
                cppBLEController.setIsInPlaystate( false )

                cppTrainingHandler.pause();
                uicontroller.pausestate = true
                uicontroller.playstate = false
                uicontroller.playVideo = false
                playButtons.state = "pauseclicked"
                uicontroller.mainMenuStatus = true

                cppController.setURLButtonEnabled(true)
                uicontroller.clientsActive= false

                uicontroller.showSelectionPart = false
                uicontroller.showBackToMenuButton = true
            }
        }

        Button
        {
            id: stopButton
            width: playButtons.height * 0.15
            height: width

            icon.name: "stop"
            icon.source: "/icons/Stop.png"
            icon.height: height * 0.7
            icon.width: width * 0.7
            icon.color: "red"
            background: Rectangle
            {
                anchors.fill: parent
                border.width: 1
            }

            onClicked:
            {
                cppController.setWebViewVisibility(false)

                cppBLEController.setIsInPlaystate( false )

                cppController.setURLButtonEnabled(true)

                //stop Timer first!!
                cppTrainingHandler.stop();
                uicontroller.timetimerruns = false;
                uicontroller.firstRuntimeSettings = true
                uicontroller.firstselect = false
                uicontroller.secondselect = false
                uicontroller.thirdselect = false
                uicontroller.forthselect = false
                uicontroller.totalselect = true
                uicontroller.runtime = false;
                uicontroller.thresholdGraphColor = "transparent"
                uicontroller.barGraphColor = "transparent"
                uicontroller.playVideo = false
                mainloader.sourceComponent = mainanalyse

                uicontroller.drawOfflineData++;

                uicontroller.clientsActive = true


                uicontroller.barstate = false
                uicontroller.layoutid = uicontroller.layoutchange(uicontroller.barstate, uicontroller.linestate, uicontroller.vidstate)
                cppMainHandler.changeTableHeader()

                uicontroller.playButtonsStatus = false

                cppDatabaseHandler.saveMeasurementForActiveClient();

                uicontroller.showSettingsButton = true
                uicontroller.showBackToMenuButton = false
                uicontroller.showResultFinishButton = true

            }
        }

    }


    Button
    {
        id: abortButton
        height: 40
        text: qsTr("Abort")
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: resetButton.top
        anchors.bottomMargin: 5
        visible: true

        onClicked:
        {
            cppController.setWebViewVisibility(false)

            cppBLEController.setIsInPlaystate( false )

            cppTrainingHandler.stop()

            uicontroller.clientsActive = true
            uicontroller.mainMenuStatus = true
            cppTrainingHandler.stop()
            uicontroller.reload();
            playButtons.state = "beginning"
            playButtons.newTrainingSignal();

            uicontroller.showSelectionPart = false
            uicontroller.showBackToMenuButton = true

        }
    }


    Button
    {
        id: resetButton
        height: 40
        anchors.bottom: playButtons.bottom
        anchors.bottomMargin: playButtons.height * 0.05
        text: qsTr("Reset Training")
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        visible: true

        onClicked:
        {
            cppController.setWebViewVisibility(true)

            cppBLEController.setIsInPlaystate( false )
            cppTrainingHandler.stop()
            uicontroller.reload();
            playButtons.state = "beginning"
            playButtons.newTrainingSignal();

        }
    }



    states:[
        State{
            name: "beginning"
            PropertyChanges{  target: playButton; enabled: true; highlighted: false; opacity:1.0}
            PropertyChanges{ target: pauseButton; enabled: false; highlighted: false; opacity:0.4; icon.color: "gray"}
            PropertyChanges{ target: stopButton; enabled: false; highlighted: false; opacity:0.4; icon.color: "gray"}
            PropertyChanges{ target: resetButton; enabled: false; highlighted: false; opacity:0.5}
        },
        State{
            name: "playclicked"
            PropertyChanges{  target: playButton; enabled: false; highlighted: true; opacity:0.2}
            PropertyChanges{ target: pauseButton; enabled: true; highlighted: false; opacity:1.0; icon.color: "yellow"}
            PropertyChanges{ target: stopButton; enabled: true; highlighted: false; opacity:1.0; icon.color: "red"}
            PropertyChanges{ target: resetButton; enabled: true; highlighted: false; opacity:1.0}
        },
        State{
            name: "pauseclicked"
            PropertyChanges{  target: playButton; enabled: true; highlighted: false; opacity:1.0}
            PropertyChanges{ target: pauseButton; enabled: false; highlighted: true; opacity:0.4; icon.color: "gray"}
            PropertyChanges{ target: stopButton; enabled: true; highlighted: false; opacity:1.0; icon.color: "red"}
            PropertyChanges{ target: resetButton; enabled: true; highlighted: false; opacity:1.0}
        }
    ]
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:8;anchors_width:100}D{i:9;anchors_width:640}
}
##^##*/
