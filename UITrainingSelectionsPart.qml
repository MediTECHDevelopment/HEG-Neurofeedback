import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11

//UITrainingSelectionsPart equivalent to UIAnalyseSelectionsPart

Item {
    clip: true

    StackLayout
    {
        id: trainingsidestack
        anchors.fill: parent
        currentIndex: uicontroller.currentsideindex
        UIPlayButtonPart { }
        UINotepadPart { }
        UITrendSelectPart { }
    }

    PageIndicator
    {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        count: trainingsidestack.count
        currentIndex: trainingsidestack.currentIndex
    }
}
