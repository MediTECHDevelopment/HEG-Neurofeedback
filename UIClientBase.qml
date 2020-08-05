import QtQuick 2.0
import QtQuick.Dialogs 1.2
import QtQuick.Controls 2.4

//UIClientBase is needed to create a new Client or edit an old one.

Item
{
    id: element
    Connections
    {
        target: cppDatabaseHandler
        ignoreUnknownSignals: true
        onShowEditClientBase:
        {     //show old clientdata
            prenamefield.text = prename;
            surnamefield.text = surname;
            daySelection.editText = dayOfBirth;
            monthSelection.editText = monthOfBirth;
            yearSelection.editText = yearOfBirth;
            genderBox.currentIndex = gender == qsTr("Female") ? 0 : 1;
            if(threshold != 0)
                thresholdSpin.value = threshold;
            if(videofile != "")
                vidfile.text = videofile;
        }
    }

    //the birthday is selected for each component separate an musst be put together on confirm
    property string dateString
    function getDayOfBirthString(day, month, year)
    {
        dateString = year.toString();

        if(month<10)
            dateString += "0" + month.toString()
        else
            dateString += month.toString()

        if(day<10)
            dateString += "0" + day.toString();
        else
            dateString += day.toString();

        return dateString;
    }

    //the selectable year should start with the current and goes down to currentyear - 150 to ensure selectable birthdays for everyone
    property date currentYear
    currentYear: new Date()
    property int ixYear: currentYear.getFullYear()
    onCurrentYearChanged:
    {
        while( ixYear > currentYear.getFullYear() - 150)
        {
            yearmodel.append({"year": ixYear})
            ixYear--;
        }
    }

    //for the ComboBox a model is needed...

    ListModel
    {
        id: yearmodel
    }

    property string vidPath
    property var splittedtVidPath
    FileDialog
    {
        id: videoDialog
        title: qsTr("Please choose a videofile")
        folder: shortcuts.home
        onAccepted:
        {
            vidPath = videoDialog.fileUrl
            splittedtVidPath = vidPath.split("///")
            vidfile.text = splittedtVidPath[splittedtVidPath.length - 1]    //just show the path, not the url
        }
        onRejected:
        {
            console.log("Canceled")
        }
    }

    ScrollView
    {
        id: scrollView
        contentHeight: 870
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0

        Row
        {
            id: endClientBaseButtons
            x: 192
            y: 519
            anchors.topMargin: 30
            spacing: 5
            anchors.top: thresholdSpin.bottom
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.3
            Button
            {
                text: qsTr("Close");
                onClicked:
                {
                    cppDatabaseHandler.setNewClientBool(false);
                    databaseStack.pop()
                }
            }
            Button
            {
                text: qsTr("Accept");
                onClicked:
                {
                    cppDatabaseHandler.acceptClientChange(prenamefield.text, surnamefield.text, getDayOfBirthString(daySelection.contentItem.text, monthSelection.contentItem.text, yearSelection.contentItem.text), genderBox.textAt(genderBox.currentIndex), thresholdSpin.value, videoDialog.fileUrl);
                    databaseStack.pop()
                }
            }
        }

        Text
        {
            id: vidfile
            x: 192
            y: 491
            text: qsTr("no video set");
            visible: false
            anchors.top: vidButton.bottom
            anchors.topMargin: prenameText.height * 0.5
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.3
        }

        Button
        {
            id: vidButton
            x: 192
            y: 444
            text: qsTr("Open Video")
            visible: false
            anchors.top: videoFileText.bottom
            anchors.topMargin: prenameText.height * 0.5
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.3
            onClicked: {
                videoDialog.open()
            }
        }

        Text
        {
            id: videoFileText
            x: 192
            y: 425
            text: qsTr("Video File");
            visible: false
            anchors.top: thresholdSpin.bottom
            anchors.topMargin: prenameText.height
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.3
        }

        SpinBox
        {
            id: thresholdSpin
            x: 192
            y: 372
            editable: true
            from: 0
            to: 999
            value: 100
            validator: IntValidator { bottom: 0; top: 999}
            anchors.top: thresholdText.bottom
            anchors.topMargin: prenameText.height * 0.5
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.3
        }

        Text
        {
            id: thresholdText
            x: 192
            y: 352
            text: qsTr("Threshold");
            anchors.top: genderBox.bottom
            anchors.topMargin: prenameText.height
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.3
        }

        ComboBox
        {
            id: genderBox
            x: 192
            y: 299
            anchors.top: genderText.bottom
            anchors.topMargin: prenameText.height
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.3
            model: ListModel
            {
                ListElement {text: qsTr("Female")}
                ListElement {text: qsTr("Male")}
            }
        }

        Text
        {
            id: genderText
            x: 192
            y: 273
            text: qsTr("Gender");
            anchors.top: dateRow.bottom
            anchors.topMargin: prenameText.height
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.3
        }

        Row
        {
            id: dateRow
            x: 192
            anchors.top: dayOfBirthText.bottom
            anchors.topMargin: 6
            spacing: 3
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.3

            ComboBox {
                id: daySelection
                model: [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31]
                editable: false
                onEditTextChanged: currentIndex = editText - 1
            }

            ComboBox {
                id: monthSelection
                model: [1,2,3,4,5,6,7,8,9,10,11,12]
                editable: false
                onEditTextChanged: currentIndex = editText - 1
            }

            ComboBox {
                id: yearSelection
                model: yearmodel
                editable: false
                onEditTextChanged: currentIndex = find(editText, Qt.MatchExactly)
            }
        }

        Text {
            id: dayOfBirthText
            x: 192
            text: qsTr("day of birth");
            anchors.top: surnamefield.bottom
            anchors.topMargin: 13
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.3
        }

        TextField {
            id: surnamefield
            x: 192
            anchors.top: surnameText.bottom
            anchors.topMargin: 7
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.3
        }

        Text {
            id: surnameText
            x: 192
            text: qsTr("Surname");
            anchors.top: prenamefield.bottom
            anchors.topMargin: 13
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.3
        }

        TextField {
            id: prenamefield
            x: 192
            anchors.top: prenameText.bottom
            anchors.topMargin: 6
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.3
        }

        Text {
            id: prenameText
            x: 192
            text: qsTr("Prename")
            anchors.top: clientbaseTitle.bottom
            anchors.topMargin: 22
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.3
        }

        Text {
            id: clientbaseTitle
            x: 192
            text: qsTr("Clientdatabase")
            anchors.top: parent.top
            anchors.topMargin: 10
            font.pixelSize: 20
            anchors.left: parent.left
            anchors.leftMargin: parent.width * 0.3
        }













    }

}


/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:19;anchors_y:220}D{i:23;anchors_y:201}
D{i:24;anchors_y:148}D{i:25;anchors_y:128}D{i:26;anchors_y:75}D{i:27;anchors_y:56}
D{i:28;anchors_y:6}D{i:4;anchors_height:480;anchors_width:640;anchors_x:0;anchors_y:0}
}
##^##*/
