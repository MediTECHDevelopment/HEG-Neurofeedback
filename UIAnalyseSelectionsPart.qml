import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.11

//UIAnalyseSelectionsPart is the Stack for the Selection-/Information-Part at the right side. Other than the UITrainingSelectionsPart, no UIVideoCtrlPart is included and instead of the UIPlayButtonPart,
//the UIClientDataSidePart is used.

Item
{
    clip: true

    StackLayout
    {
        id: analysesidestack
        anchors.fill: parent
        currentIndex: uicontroller.currentsideindex
        UIClientDataSidePart { }
        UINotepadPart { }
        UITrendSelectPart { }
    }

    PageIndicator {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        count: analysesidestack.count
        currentIndex: analysesidestack.currentIndex
    }
}
