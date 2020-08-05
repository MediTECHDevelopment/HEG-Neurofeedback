import QtQuick 2.0
import QtQuick.Controls 2.4

//UIChooseClientPart provides the left selection-panel from the database. It contains a ListModel with all Clients and a listview, representing them

Rectangle
{
    border.width: 1
    border.color: "grey"

    Connections {
        target: cppDatabaseHandler
        ignoreUnknownSignals: true
        onClearClients:
        {
            clientModel.clear();
        }
        onShowClients:
        {
            clientModel.append({"Prename": prename, "Surname": surname});
        }
        onSetHighlightedClientRow:
        {
            listView.currentIndex = activeRow
        }
    }

    Rectangle
    {
        anchors.fill: parent
        border.width: 1
        border.color: "grey"

        //Listview und Krams :)
        ListModel
        {
            id: clientModel
        }

        ListView {
            id: listView
            anchors.fill: parent
            model: clientModel
            delegate: Component {
                Item
                {
                    width: parent.width
                    height: 30
                    Row
                    {
                        spacing: 7
                        Text { text: Prename}
                        Text { text: Surname}
                    }
                    MouseArea
                    {
                        anchors.fill: parent
                        onClicked:
                        {
                            listView.currentIndex = index
                            cppDatabaseHandler.singleClickClients()
                        }
                    }
                }
            }

            highlight: Rectangle {
                color: uicontroller.highlightColor
            }

            focus: true
            onCurrentIndexChanged: {
                cppDatabaseHandler.setSelectedClientRow(currentIndex);
            }
        }

    }

}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
