import QtQuick 2.0
import QtQuick.Controls 2.4

//UIClientDataSidePart manages the measurement-informations, displayed in the sidepanel in the Aalyseview in exchange for the Playbuttons in the trainingview. The new-training-button in every view needed!

Item {
    id:sidedata
    signal newTrainingSignal2();

    Column {
        spacing: firstText.height
        Column {
            Text {
                id: firstText
                text: qsTr("Time:")
            }

            Text {
                text: "     " + uicontroller.measurmentTimeString
            }
        }
        Column {
            Text {
                text: qsTr("Date:")
            }
            Text {
                text: "     " + uicontroller.measurmentDateString
            }
        }
        Column {
            Text {
                text: qsTr("Duration:")
            }
            Text {
                text: "     " + uicontroller.measurmentDurationString
            }
        }
    }

 /*   Button
    {
        width: sidedata.width
        height: 40
        anchors.bottom: sidedata.bottom
        anchors.bottomMargin: sidedata.height * 0.05
        text: qsTr("New Training")

        onClicked:
        {
            uicontroller.barstate = true
            uicontroller.layoutid = uicontroller.layoutchange(uicontroller.barstate, uicontroller.linestate, uicontroller.vidstate)

            cppTrainingHandler.stop()

            uicontroller.reload();
            sidedata.state = "beginning"
            console.log("reload");
            sidedata.newTrainingSignal2();

            cppController.setWebViewVisibility(true)
        }
    }*/

}
