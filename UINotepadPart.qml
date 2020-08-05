import QtQuick 2.0
import QtQuick.Controls 2.1

//UINotepadPart provides a simple Notepad without further functions. Text could be displayed and written in.

Item {

    Text{
        id: notepadtxt
        text: qsTr("Notepad")
    }

    Rectangle
    {
        border.width: 1
        border.color: "grey"
        width: parent.width
        height: parent.height * 0.3
        anchors.top: notepadtxt.bottom
        anchors.topMargin: width * 0.025
        anchors.horizontalCenter: parent.horizontalCenter


        Flickable {
            id: flickable
            flickableDirection: Flickable.VerticalFlick
            anchors.fill: parent

            TextArea.flickable: TextArea {
                id: notetext
                text: uicontroller.notetextNotes
                wrapMode: TextArea.Wrap
                placeholderText: qsTr("Notes")

                leftPadding: 5
                rightPadding: 5
                topPadding: 5
                bottomPadding: 5
                onFocusChanged: {
                    uicontroller.notetextNotes = notetext.text;
                }
            }
            ScrollBar.vertical: ScrollBar {}
        }
    }
}
