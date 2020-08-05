import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11

//UIDifficultyButtonsPart is one part of the trainingsettings and includes five radiobuttons for the difficulty of the tresholdadaption

Rectangle
{
    id: diffrec
    height: 35
    radius: 10
    border.width: 1
    border.color: "lightgray"

    Component.onCompleted:
    {
        colorTexts()
    }


    Text
    {
        id: difficultyHeader
        text: qsTr("Difficulty:")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 10
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        anchors.top: parent.top
        anchors.topMargin: 0
    }

    Connections
    {
        target: uicontroller
        ignoreUnknownSignals: true
        onDifficultyidChanged:
        {
            colorTexts()
        }
    }

    function colorTexts()
    {
        var color = "gray"
        var highlightedColor = "black"

        settingsDifficultyTextSuperEasy.color = color
        settingsDifficultyTextEasy.color = color
        settingsDifficultyTextIntermediate.color = color
        settingsDifficultyTextHard.color = color
        settingsDifficultyTextSuperHard.color = color

        if(uicontroller.difficultyid == 1)
        {
            settingsDifficultyTextSuperEasy.color = highlightedColor
        }
        if(uicontroller.difficultyid == 2)
        {
            settingsDifficultyTextEasy.color = highlightedColor
        }
        if(uicontroller.difficultyid == 3)
        {
            settingsDifficultyTextIntermediate.color = highlightedColor
        }
        if(uicontroller.difficultyid == 4)
        {
            settingsDifficultyTextHard.color = highlightedColor
        }
        if(uicontroller.difficultyid == 5)
        {
            settingsDifficultyTextSuperHard.color = highlightedColor
        }
    }

    Text
    {
        id: settingsDifficultyTextSuperEasy
        width: 90
        height: 35
        text: qsTr("Super Easy")
        anchors.left: difficultyHeader.right
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                uicontroller.difficultyid = 1
            }
        }
    }

    Rectangle {
        width: 2
        color: "#000000"
        anchors.left: settingsDifficultyTextSuperEasy.right
        anchors.leftMargin: 0
        anchors.bottom: settingsDifficultyTextSuperEasy.bottom
        anchors.bottomMargin: 8
        anchors.top: settingsDifficultyTextSuperEasy.top
        anchors.topMargin: 8
    }

    Text
    {
        id: settingsDifficultyTextEasy
        width: 90
        height: 36
        text: qsTr("Easy")
        anchors.left: settingsDifficultyTextSuperEasy.right
        anchors.leftMargin: 0
        anchors.top: settingsDifficultyTextSuperEasy.top
        anchors.topMargin: 0
        horizontalAlignment: Text.AlignHCenter
        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                uicontroller.difficultyid = 2
            }
        }
        verticalAlignment: Text.AlignVCenter
    }


    Rectangle {
        x: 0
        y: 9
        width: 2
        color: "#000000"
        anchors.topMargin: 8
        anchors.top: settingsDifficultyTextSuperEasy.top
        anchors.left: settingsDifficultyTextEasy.right
        anchors.bottomMargin: 8
        anchors.leftMargin: 0
        anchors.bottom: settingsDifficultyTextSuperEasy.bottom
    }

    Text {
        id: settingsDifficultyTextIntermediate
        width: 90
        height: 36
        text: qsTr("Intermediate")
        anchors.left: settingsDifficultyTextEasy.right
        anchors.leftMargin: 5
        anchors.top: settingsDifficultyTextSuperEasy.top
        anchors.topMargin: 0
        horizontalAlignment: Text.AlignHCenter
        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                uicontroller.difficultyid = 3
            }
        }
        verticalAlignment: Text.AlignVCenter
    }



    Rectangle {
        x: 4
        y: -9
        width: 2
        color: "#000000"
        anchors.topMargin: 8
        anchors.top: settingsDifficultyTextSuperEasy.top
        anchors.left: settingsDifficultyTextIntermediate.right
        anchors.bottomMargin: 8
        anchors.leftMargin: 0
        anchors.bottom: settingsDifficultyTextSuperEasy.bottom
    }

    Text
    {
        id: settingsDifficultyTextHard
        width: 90
        height: 36
        text: qsTr("Hard")
        anchors.left: settingsDifficultyTextIntermediate.right
        anchors.leftMargin: 5
        anchors.top: settingsDifficultyTextSuperEasy.top
        anchors.topMargin: 0
        horizontalAlignment: Text.AlignHCenter
        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                uicontroller.difficultyid = 4
            }
        }
        verticalAlignment: Text.AlignVCenter
    }





    Rectangle {
        x: 8
        y: -9
        width: 2
        color: "#000000"
        anchors.topMargin: 8
        anchors.top: settingsDifficultyTextSuperEasy.top
        anchors.left: settingsDifficultyTextHard.right
        anchors.bottomMargin: 8
        anchors.leftMargin: 0
        anchors.bottom: settingsDifficultyTextSuperEasy.bottom
    }

    Text
    {
        id: settingsDifficultyTextSuperHard
        width: 90
        height: 36
        text: qsTr("Super Hard")
        anchors.left: settingsDifficultyTextHard.right
        anchors.leftMargin: 5
        anchors.top: settingsDifficultyTextSuperEasy.top
        anchors.topMargin: 0
        horizontalAlignment: Text.AlignHCenter
        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                uicontroller.difficultyid = 5
            }
        }
        verticalAlignment: Text.AlignVCenter
    }





}


