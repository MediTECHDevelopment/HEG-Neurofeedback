import QtQuick 2.0
import QtQuick.Controls 2.4

//UIAnalyseSettings includes only the Layout-Settings (UILayoutButtonsPart). Training-equivalent is UITrainingSettings.

Item
{
    function colorTableheaderTexts()
    {
        var color = "gray"
        var highlightedColor = "black"

        minMaxText.color = color
        thresholdText.color = color

        if(uicontroller.headerGroupButtonID == 0)
        {
            minMaxText.color = highlightedColor
        }
        if(uicontroller.headerGroupButtonID == 1)
        {
            thresholdText.color = highlightedColor
        }
    }


    Rectangle
    {
        width: parent.width*0.9
        height: parent.height*0.9
        anchors.centerIn: parent

        id: analysesettingsrec
        radius: 10
        border.width: 1
        border.color: "lightgray"

        Component.onCompleted:
        {
            colorTableheaderTexts()
        }

        Connections
        {
            target: uicontroller
            ignoreUnknownSignals: true
            onHeaderGroupButtonIDChanged:
            {
                colorTableheaderTexts()
            }
        }

        Text
        {
            id: analyseSettingsheaderText
            text: qsTr("Analyse settings")
            anchors.top: parent.top
            anchors.topMargin: 10
            font.pointSize: 20
            font.bold: true
            anchors.left: parent.left
            anchors.leftMargin: 10
        }
        UILayoutButtonsPart
        {
            id: layoutbuttons
            height: 70
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: analyseSettingsheaderText.bottom
            anchors.topMargin: 10
        }

        Rectangle
        {
            //difficulty-buttons for point-calculation
            id: pointCalcDiffButtons
            height: 70
            color: "#00ffffff"
            radius: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: tableHeaderButtons.bottom
            anchors.topMargin: 10
            border.color: "#d3d3d3"
            border.width: 1
            clip: true
            visible: false

            Text
            {
                id: diffText
                text: qsTr("Difficulty:")
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
            }
            Column
            {
                id: column
                anchors.right: parent.right
                anchors.rightMargin: 0
                clip: false
                anchors.leftMargin: 0
                anchors.left: parent.left
                anchors.top: diffText.bottom
                anchors.topMargin: 6
                spacing: 6

                //the ID is negative cause the backend was negative. Could be changed (BOTH!), if wanted
                RadioButton
                {
                    id: calcDiff1
                    text: "1"
                    scale: 1
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    checked: uicontroller.calcDiffButtonID === -2
                    //exclusiveGroup: clacDiffGroup
                    onClicked: uicontroller.calcDiffButtonID = -2
                }
                RadioButton
                {
                    id: calcDiff2
                    y: 23
                    text: "2"
                    visible: true
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    checked: uicontroller.calcDiffButtonID === -3
                    //exclusiveGroup: clacDiffGroup
                    onClicked: uicontroller.calcDiffButtonID = -3
                }
                RadioButton
                {
                    id: calcDiff10
                    text: "10"
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    checked: uicontroller.calcDiffButtonID === -4
                    //exclusiveGroup: clacDiffGroup
                    onClicked: uicontroller.calcDiffButtonID = -4
                }
            }
        }

        Rectangle
        {
            id: tableHeaderButtons
            height: 70
            color: "#00ffffff"
            radius: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: layoutbuttons.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            border.width: 1
            visible: true
            border.color: "#d3d3d3"
            clip: true
            Text
            {
                id: headerButtonText
                width: 100
                text: qsTr("Headergroups:")
                font.bold: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: parent.top
                anchors.topMargin: 0
            }


            Text
            {
                id: minMaxText
                width: 110
                height: 30
                text: qsTr("Min, Max, Mean")
                anchors.verticalCenter: headerButtonText.verticalCenter
                clip: true
                anchors.left: headerButtonText.right
                anchors.leftMargin: 10
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        uicontroller.headerGroupButtonID = 0
                        cppMainHandler.changeTableHeader()
                    }
                }
            }

            Rectangle
            {
                id: rectangle
                width: 2
                color: "#000000"
                anchors.left: minMaxText.right
                anchors.leftMargin: 5
                anchors.bottom: minMaxText.bottom
                anchors.bottomMargin: 8
                anchors.top: minMaxText.top
                anchors.topMargin: 8
            }

            Text
            {
                id: thresholdText
                x: 9
                y: 0
                width: 110
                height: 30
                text: qsTr("Threshold")
                clip: true
                horizontalAlignment: Text.AlignHCenter
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: minMaxText.right
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: 5

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        uicontroller.headerGroupButtonID = 1
                        cppMainHandler.changeTableHeader()
                    }
                }
            }

        }

    }


}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:3;anchors_height:346}D{i:10;anchors_x:282}
D{i:13;anchors_height:30}
}
##^##*/
