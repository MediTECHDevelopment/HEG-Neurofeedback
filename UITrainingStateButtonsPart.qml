import QtQuick 2.0
import QtQuick.Controls 2.4

//UITrainingStateButtonsPart allows to select the trainingstate (concentration or relaxation)

Rectangle
{
    id: rectangle
    height: 35
    radius: 10
    border.width: 1
    border.color: "lightgray"

    Component.onCompleted:
    {
        colorStateTexts()
    }

    Text
    {
        id: headerTrainingStatesSettings
        text: qsTr("Training State:")
        anchors.top: parent.top
        anchors.topMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        font.bold: true
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        anchors.left: parent.left
        anchors.leftMargin: 10
    }

    Connections
    {
        target: uicontroller
        ignoreUnknownSignals: true
        onIsconcentrationChanged:
        {
            colorStateTexts()
        }
    }

    function colorStateTexts()
    {
        var color = "gray"
        var highlightedColor = "black"

        concentrationTextSettings.color = color
        relaxationTextSettings.color = color

        if(uicontroller.isconcentration)
        {
            concentrationTextSettings.color = highlightedColor
        }
        else
        {
            relaxationTextSettings.color = highlightedColor
        }
    }


    Text
    {
        id: concentrationTextSettings
        y: 30
        width: 120
        height: 35
        text: qsTr("Concentration")
        anchors.left: headerTrainingStatesSettings.right
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                uicontroller.isconcentration = true
            }
        }
    }

    Rectangle
    {
        width: 2
        color: "#000000"
        anchors.left: concentrationTextSettings.right
        anchors.leftMargin: 0
        anchors.bottom: concentrationTextSettings.bottom
        anchors.bottomMargin: 8
        anchors.top: concentrationTextSettings.top
        anchors.topMargin: 8
    }

    Text
    {
        id: relaxationTextSettings
        width: 120
        text: qsTr("Relaxation")
        anchors.bottom: concentrationTextSettings.bottom
        anchors.bottomMargin: 0
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.left: concentrationTextSettings.right
        anchors.leftMargin: 0
        anchors.top: concentrationTextSettings.top
        anchors.topMargin: 0

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                uicontroller.isconcentration = false
            }
        }
    }




}


