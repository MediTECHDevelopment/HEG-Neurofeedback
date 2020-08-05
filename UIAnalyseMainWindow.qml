import QtQuick 2.0

//UIAnalyseMainWindow is made up with the analyse-specific parts. The Basic-Strukture is similar to the UITrainingMainWindow. It is loaded on runtime-changed (stop Training or load Measurement)

Item
{
    id: element

    UIAnalyseView
    {
        id: mainview
        anchors.bottom: statusbar.top
        anchors.bottomMargin: 0
        anchors.right: analyserightMenueBox.left
        anchors.rightMargin: 8
        anchors.top: parent.top
        anchors.topMargin: 0

        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.012
    }

    UIStatusBar
    {
        id: statusbar
        height: 24
        anchors.left: mainview.left
        anchors.leftMargin: 0
        anchors.right: mainview.right
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
    }

    Rectangle
    {
        id: analyserightMenueBox
        x: 514
        width: 150
        color: "#ffffff"
        border.color: "#d3d3d3"
        border.width: 1
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        UIMainButtonsPart
        {
            id: mainbuttons
            y: 7
            height: 140
            anchors.left: parent.left
            anchors.leftMargin: 5
            clip: false
            anchors.rightMargin: 5
            anchors.topMargin: 5

            anchors.top: parent.top
            anchors.right: parent.right

        }

        UIAnalyseSelectionsPart
        {
            id: selectionspart
            y: 154
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.rightMargin: 5
            anchors.topMargin: 7
            anchors.top: mainbuttons.bottom
            anchors.right: parent.right
            visible: uicontroller.showSelectionPart
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:1;anchors_height:456}D{i:3;anchors_height:279}
D{i:4;anchors_height:24}
}
##^##*/
