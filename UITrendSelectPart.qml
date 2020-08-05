import QtQuick 2.0
import QtQuick.Controls 2.4

//UITrendSelectPart includes four to five RadioButtons, one of them withe a textfield for free int-input to choose the time section, which should be displayed with the linegraph

Item {

    Column
    {
        spacing: width * 0.025

        Text
        {
            id: trendtxt
            text: qsTr("Trend")
        }

        RadioButton
        {
            checked: uicontroller.firstselect
            onClicked:
            {
                uicontroller.firstselect = true
                uicontroller.secondselect = false
                uicontroller.thirdselect = false
                uicontroller.forthselect = false
                uicontroller.totalselect = false
                uicontroller.trendselect = parseInt(vartrend.text)
            }
            TextField
            {
                id: vartrend
                anchors.left: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 50
                height: 30
                text: uicontroller.usertrendtext
                enabled: uicontroller.firstselect

                validator: IntValidator{ bottom: 0 ; top: 120}

                onTextChanged: {
                    if (vartrend.text == "")
                    {
                        uicontroller.trendselect = 1
                    }
                    else
                    {
                        uicontroller.trendselect = parseInt(vartrend.text)
                    }
                }

                onFocusChanged: {
                    if (vartrend.text == "")
                    {
                        vartrend.text = "1"
                    }
                    uicontroller.usertrendtext = vartrend.text
                }
            }
            Text
            {
                anchors.left: vartrend.right
                anchors.leftMargin: 2
                anchors.verticalCenter: parent.verticalCenter
                text: "s"
            }
        }
        RadioButton
        {
            checked: uicontroller.secondselect
            text: "30s"
            onClicked:
            {
                uicontroller.firstselect = false
                uicontroller.secondselect = true
                uicontroller.thirdselect = false
                uicontroller.forthselect = false
                uicontroller.totalselect = false
                uicontroller.trendselect = 30
            }
        }
        RadioButton
        {
            checked: uicontroller.thirdselect
            text: "60s"
            onClicked:
            {
                uicontroller.firstselect = false
                uicontroller.secondselect = false
                uicontroller.thirdselect = true
                uicontroller.forthselect = false
                uicontroller.totalselect = false
                uicontroller.trendselect = 60
            }
        }
        RadioButton
        {
            checked: uicontroller.forthselect
            text: "120s"
            onClicked:
            {
                uicontroller.firstselect = false
                uicontroller.secondselect = false
                uicontroller.thirdselect = false
                uicontroller.forthselect = true
                uicontroller.totalselect = false
                uicontroller.trendselect = 120
            }
        }
        RadioButton
        {
            visible: !uicontroller.runtime
            checked: uicontroller.totalselect
            text: qsTr("total trend")
            onClicked:
            {
                uicontroller.firstselect = false
                uicontroller.secondselect = false
                uicontroller.thirdselect = false
                uicontroller.forthselect = false
                uicontroller.totalselect = true
            }
        }
    }

}
