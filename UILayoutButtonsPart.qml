import QtQuick 2.11
import QtQuick.Controls 2.4

//UILayoutButtonsPart provides the selection for the layoutoptions

Item
{

    id: layoutrec
    height: 70

    Connections
    {
        target: uicontroller
        ignoreUnknownSignals: true
        onSettingsstatusChanged:
        {
            uicontroller.layoutid = uicontroller.layoutchange(uicontroller.barstate, uicontroller.linestate, uicontroller.vidstate)
        }
    }



    Rectangle
    {
        id: rectangle
        height: 70
        anchors.fill: parent
        border.width: 1
        border.color: "lightgray"
        radius: 10

        Text
        {
            id: layoutSettingText
            text: qsTr("Layout:")
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 10
        }

        CheckBox
        {
            id: radiobutton1
            height: 30
            text: qsTr("BarGraph")
            anchors.left: radiobutton3.right
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            visible: false
            checked: uicontroller.barstate

            onClicked: { uicontroller.barstate = !uicontroller.barstate }
        }

        CheckBox
        {
            id: radiobutton2
            height: 30
            text: qsTr("LineGraph")
            anchors.left: layoutSettingText.right
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            checked: uicontroller.linestate

            onClicked: { uicontroller.linestate = !uicontroller.linestate }
        }

        CheckBox
        {
            id: radiobutton3
            height: 30
            text: uicontroller.vidOrAnalyse
            anchors.left: radiobutton2.right
            anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            checked: uicontroller.vidstate

            onClicked: { uicontroller.vidstate = !uicontroller.vidstate }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
