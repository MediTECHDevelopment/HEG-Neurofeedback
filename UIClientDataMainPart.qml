import QtQuick 2.0

//UIClientDataMainPart provides the basic-information for every clicked client in the database. It is resetted on ever singleclientclick

Item {
    Connections {
        target: cppDatabaseHandler
        ignoreUnknownSignals: true
        onSetClientMainInformation: {
            prenameText.text = prename;
            surnameText.text = surname;
            dayOfBirthText.text = dayOfBirth;
            genderText.text = gender;
        }
    }

    Column
    {
        spacing: prenameText.height * 0.3
        Text
        {
            text: qsTr("Prename")
            Text {
                id: prenameText
                anchors.left: parent.right
                anchors.leftMargin: 10
            }
        }
        Text
        {
            text: qsTr("Surname")
            Text {
                id: surnameText
                anchors.left: parent.right
                anchors.leftMargin: 10
            }
        }
        Text
        {
            text: qsTr("day of birth")
            Text {
                id: dayOfBirthText
                anchors.left: parent.right
                anchors.leftMargin: 10
            }
        }
        Text
        {
            text: qsTr("Gender")
            Text {
                id: genderText
                anchors.left: parent.right
                anchors.leftMargin: 10
            }
        }
    }
}


/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
