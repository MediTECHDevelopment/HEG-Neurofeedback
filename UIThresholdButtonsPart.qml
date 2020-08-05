import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Extras 1.4

//UIThresholdButtonsPart is Part of the trainingsettings an allows to set a specific treshold, or make it adaptive

Rectangle
{
    id: threshrec
    height: 70
    radius: 10
    border.width: 1
    border.color: "lightgray"
    Text
    {
        id: thresholdHeadeText
        text: qsTr("Threshold:")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        font.bold: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
    }

    function getradiostatus()
    {
        if (!uicontroller.thresholdisadaptive)
        {
            return "black"
        }
        else
        {
            return "grey"
        }
    }


    TextField
    {
        id: treshtxt
        x: 61
        y: 28
        width: 100
        height: 30
        anchors.left: thresholdHeadeText.right
        text: uicontroller.threshold
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: 10

        color: getradiostatus()
        readOnly: uicontroller.thresholdisadaptive
        validator: IntValidator{ bottom: 0 }
        onFocusChanged: {
            if (treshtxt.text == "")
            {
                treshtxt.text = "1"
            }
            uicontroller.threshold = parseInt(treshtxt.text);
        }
    }

    CheckBox
    {
        y: 21
        height: 30
        text: qsTr("adaptive")
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: treshtxt.right
        anchors.leftMargin: 10
        checked: uicontroller.thresholdisadaptive
        onClicked:
        {
            uicontroller.thresholdisadaptive = !uicontroller.thresholdisadaptive
        }
    }


}


/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
