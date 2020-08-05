import QtQuick 2.0
import QtQuick.Controls 2.4

//show database or clientbase?

Item {

    StackView {
        id: databaseStack
        initialItem: database
        anchors.fill: parent
    }

    Component {
        id: database
        UIDataBase {}
    }

    Component {
        id: clientbase
        UIClientBase {}
    }
}
