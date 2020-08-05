import QtQuick 2.0

//UIStatusBar provides three texts at the bottom of the window to display several texts. They are set through the UIController

Item {
    id: element

    Text {
        text: uicontroller.statetextleft
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: parent.left
    }

    Text {
        id: elapsedtext
        text: uicontroller.statetextright
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: clientLabel.left
        anchors.rightMargin: 5

    }
    Text {
        id: clientLabel
        text: uicontroller.clientLabel
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
    }


}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:1;anchors_height:200;anchors_width:200;anchors_x:57;anchors_y:78}
}
##^##*/
