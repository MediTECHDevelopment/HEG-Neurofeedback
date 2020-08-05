import QtQuick 2.0

//UITrainingMainWindow equivalent to UIAnalyseMainWindow

Item
{
    id: element

    UITrainingView
    {
        id: mainview
        anchors.right: trainingMenueRightBox.left
        anchors.rightMargin: 8
        anchors.bottom: statusbar.top
        anchors.bottomMargin: 0

        anchors.top: parent.top
        anchors.topMargin: parent.width * 0.012
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.012
    }

    UIStatusBar
    {
        id: statusbar
        width: 505
        height: parent.height * 0.05
        anchors.right: mainview.right
        anchors.rightMargin: 0
        anchors.left: mainview.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
    }

    Rectangle
    {
        id: trainingMenueRightBox
        x: 519
        width: 150
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
            y: 8
            height: parent.height * 0.25
            visible: true
            anchors.topMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.rightMargin: 5

            anchors.top: parent.top
            anchors.right: parent.right

        }

        UITrainingSelectionsPart
        {
            id: selectionspart
            x: 0
            y: 128
            anchors.topMargin: 7
            anchors.rightMargin: 5
            anchors.left: parent.left
            anchors.leftMargin: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5

            anchors.top: mainbuttons.bottom
            anchors.right: parent.right
            visible: uicontroller.showSelectionPart
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:1;anchors_height:456;anchors_width:505.6}
D{i:2;anchors_width:634}D{i:4;anchors_width:18.700000000000003;anchors_x:"-6"}D{i:5;anchors_height:319.20000000000005;anchors_width:108.80000000000001}
D{i:3;anchors_height:200;anchors_y:234}
}
##^##*/
