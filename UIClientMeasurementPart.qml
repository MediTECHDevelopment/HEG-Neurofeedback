import QtQuick 2.8
import QtQuick.Controls 2.1

//UIClientMeasurementPart provides the right selectionpanel in the Database, to choose a measurement from a selected Client, which can be loaded oder deleted.

Item
{
    id: element
    Connections {
        target: chooseclientpart
        ignoreUnknownSignals: true
        onCurrentIndexChanged: {
            //as append is used for the ListModel, the Model musst always be cleared, if na new singleclick is detected
            measurementModel.clear();
        }
    }

    Connections
    {
        target: cppDatabaseHandler
        ignoreUnknownSignals: true
        onAppendClientMeasurement:
        {
            measurementModel.append({"Measurement": newMeasurement})
        }
        onClearMeasurements: {
            measurementModel.clear();
        }
        onExportButtonActive: {
            //the only database-button, which is not in UIDatabaseManagePart through Layoutstuff (it is easier to have three rectangles, not two and a weird thing creeping around at the ground)
            //exportCSVButton.enabled = exportActive;
        }
    }

    Rectangle
    {
        id: rectangle
        width: parent.width
        height: 450
        anchors.bottom: exportCSVButton.top
        anchors.bottomMargin: 2
        anchors.top: parent.top
        anchors.topMargin: 0
        border.width: 1
        border.color: "grey"


        ListModel {
            id: measurementModel
        }

        Component
        {
            id: measurementHeader
            Rectangle
            {
                width: parent.width*0.99
                height: 30
                color: "transparent"

                Row
                {
                    spacing: 5
                    Text { text: qsTr(" Date")}
                    Text { text: "    | "}
                    Text { text: qsTr(" Time")}
                    Text { text: " | "}
                    Text { text: qsTr("Duration")}
                }
            }
        }

        ListView {
            id: listView
            anchors.fill: parent
            model: measurementModel
            delegate: Component {
                Item {
                    width: parent.width
                    height: 30
                    Row
                    {
                        spacing: 9
                        Text
                        {
                            text: Measurement
                            verticalAlignment: Text.AlignBottom
                        }
                    }
                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            listView.currentIndex = index
                            cppDatabaseHandler.singleClickMeasurement()
                            cppDatabaseHandler.setSelectedMeasurementRow(listView.currentIndex)
                        }
                    }
                }


            }
            focus: true
            highlight: Rectangle
            {
                color: uicontroller.highlightColor
            }
            header: measurementHeader
            headerPositioning: ListView.OverlayHeader
            onCurrentIndexChanged:
            {
                cppDatabaseHandler.setSelectedMeasurementRow(currentIndex);
            }
        }


    }

    Button
    {
        id: exportCSVButton
        width: parent.width
        height: 40
        enabled: true
        text: qsTr("export to CSV")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 3
        onClicked: {
            cppDatabaseHandler.exportToCSV();
        }
    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
