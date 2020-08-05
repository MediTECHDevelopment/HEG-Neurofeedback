import QtQuick 2.0
import QtQuick.Controls 2.4

//UITrainingSettings provides all Settings needed for the onlinemode, including  layout-, difficulty and treshold-stuff

Item{
    Rectangle
    {
        width: parent.width*0.9
        height: parent.height*0.9
        anchors.centerIn: parent

        id: trainingsettingsrec
        radius: 10
        border.width: 1
        border.color: "lightgray"
        Text
        {
            id: settingsHeaderText
            text: qsTr("Training settings")
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 10
            anchors.topMargin: 10
            font.pointSize: 20
            font.bold: true
        }

        UIDifficultyButtonsPart
        {
            id: settingsDifficultyPart
            y: 50
            height: 70
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: settingsHeaderText.bottom
            anchors.topMargin: 10
        }

        UITrainingStateButtonsPart
        {
            id: settingsStatePart
            height: 70
            anchors.top: settingsDifficultyPart.bottom
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
        }

        UIThresholdButtonsPart
        {
            id: settingsThresholdPart
            y: 50
            height: 70
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: settingsStatePart.bottom
            anchors.topMargin: 10
        }

        UILayoutButtonsPart
        {
            id: layoutbuttons
            y: 50
            height: 70
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: settingsThresholdPart.bottom
            anchors.topMargin: 10
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:3;anchors_width:140;anchors_x:10}D{i:4;anchors_width:140;anchors_x:10;anchors_y:50}
D{i:5;anchors_width:140;anchors_x:10}D{i:6;anchors_width:140;anchors_x:10}
}
##^##*/
