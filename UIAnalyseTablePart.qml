import QtQuick 2.0
import QtQuick.Controls 2.4

//UIAnalyseTablePart contains the statistics of the loaded measurement. the are generatet in the c++-Backend, stored in a ListModel and predented with a tableview

Rectangle
{
    id: rectangle
    width: 538
    height: 317
    color: "#ffffff"
    clip: true
    border.color: "grey"
    border.width: 1

    Connections
    {
        target: cppMainHandler
        //in the function void MainHandler::fillAnalyseTable() these signals are emitted. msStart is needed to get the startpoint at the x-axis (click on the line in the analysetable should move the linegraph to the startpoint of that section)
        // order is needed to separate the section-rows from the summed-rows
        onAddStateRow:
        {
            analyseModel.append({"start": partstart, "msStart": msPartStart, "stop": partstop,"stateTest": partstate, "correct": corrPer, "transit": transPer, "proFalse": falsePer,
                                    "min": min, "max": max, "mean": mean, "range": range, "difficulty": diff, "threshMax": threshMax, "threshMin": threshMin, "points": partPoints})
        }
        onAddTotalRow:
        {
            analyseModel.append({"start": totalstart, "stop": totalstop,"stateTest": totalstate, "correct": corrPer, "transit": transPer, "proFalse": falsePer,
                                    "min": min, "max": max, "mean": mean, "range": range, "difficulty": diff, "threshMax": threshMax, "threshMin": threshMin, "points": totalPoints, "order": order})
            uicontroller.varYMax = max + 5

            if(min - 5 < 0)
            {
                uicontroller.varYMin = 0
            }
            else
            {
                uicontroller.varYMin = min - 5
            }

        }
        onTableHeaderChanged:
        {
            switchVisibleHeader(uicontroller.headerGroupButtonID)
        }
    }

    Rectangle
    {
        id: tableBox
        color: "#ffffff"
        border.width: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0


        ListView
        {
            id: valueTable
            x: 0
            y: 21
            spacing: 0
            orientation: ListView.Vertical
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: headerRow.bottom
            anchors.topMargin: 0
            model: analyseModel
            delegate: Item
            {
                id: element
                objectName: "itemDelegate"
                x: 0
                width: valueTable.width
                height: 30

                Row
                {
                    id: valueRow
                    objectName: "rowTest"
                    y: 0
                    height: 30
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    clip: true
                    spacing: 0

                    Rectangle
                    {
                        id: valueStartBox
                        objectName: "valueStartBox"
                        width: valueRow.width / uicontroller.headerCount
                        color: "#ffffff"
                        border.width: 1
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        clip: true

                        Text
                        {
                            id: valueStart
                            text: start
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.leftMargin: 2
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                        }

                        Rectangle
                        {
                            id: valueBorderRightStart
                            width: 1
                            color: "#808080"
                            anchors.right: parent.right
                            anchors.rightMargin: 0
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                        }
                    }

                    Rectangle
                    {
                        id: valueStopBox
                        objectName: "valueStopBox"
                        width: valueRow.width / uicontroller.headerCount
                        color: "#ffffff"
                        border.width: 1
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        clip: true

                        Text
                        {
                            id: valueStop
                            text:  stop
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.leftMargin: 2
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                        }

                        Rectangle {
                            id: valueBorderRightStop
                            x: -6
                            y: -8
                            width: 1
                            color: "#808080"
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.bottomMargin: 0
                            anchors.rightMargin: 0
                        }
                    }

                    Rectangle
                    {
                        id: valueStateBox
                        objectName: "valueStateBox"
                        width: valueRow.width / uicontroller.headerCount
                        color: "#ffffff"
                        border.width: 1
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        clip: true

                        Text
                        {
                            id: valueState
                            text: stateTest
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.leftMargin: 2
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                        }

                        Rectangle
                        {
                            id: valueBorderRightState
                            x: 9
                            y: -3
                            width: 1
                            color: "#808080"
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.bottomMargin: 0
                            anchors.rightMargin: 0
                        }
                    }

                    Rectangle
                    {
                        id: valuePerCorrectBox
                        objectName: "valuePerCorrectBox"
                        width: valueRow.width / uicontroller.headerCount
                        color: "#ffffff"
                        border.width: 1
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        clip: true

                        Text
                        {
                            id: valuePerCorrect
                            text: correct
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.leftMargin: 2
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                        }

                        Rectangle {
                            id: valueBorderRightCorrect
                            x: -5
                            y: 2
                            width: 1
                            color: "#808080"
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.bottomMargin: 0
                            anchors.rightMargin: 0
                        }
                    }

                    Rectangle
                    {
                        id: valuePerTransitBox
                        objectName: "valuePerTransitBox"
                        width: valueRow.width / uicontroller.headerCount
                        color: "#ffffff"
                        border.width: 1
                        visible: false
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        clip: true

                        Text
                        {
                            id: valuePerTransit
                            text: transit
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.leftMargin: 2
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                        }

                        Rectangle {
                            id: valueBorderRightTransit
                            x: -7
                            y: -4
                            width: 1
                            color: "#808080"
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.bottomMargin: 0
                            anchors.rightMargin: 0
                        }
                    }

                    Rectangle
                    {
                        id: valuePerFalseBox
                        objectName: "valuePerFalseBox"
                        width: valueRow.width / uicontroller.headerCount
                        color: "#ffffff"
                        border.width: 1
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        clip: true

                        Text
                        {
                            id: valuePerFalse
                            text: proFalse
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.leftMargin: 2
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                        }

                        Rectangle {
                            id: valueBorderRightFalse
                            x: 7
                            y: 5
                            width: 1
                            color: "#808080"
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.bottomMargin: 0
                            anchors.rightMargin: 0
                        }
                    }

                    Rectangle
                    {
                        id: valueMinBox
                        objectName: "valueMinBox"
                        width: valueRow.width / uicontroller.headerCount
                        color: "#ffffff"
                        border.width: 1
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        clip: true

                        Text
                        {
                            id: valueMin
                            text: min
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.leftMargin: 2
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                        }

                        Rectangle {
                            id: valueBorderRightMin
                            x: 6
                            y: 9
                            width: 1
                            color: "#808080"
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.bottomMargin: 0
                            anchors.rightMargin: 0
                        }
                    }

                    Rectangle
                    {
                        id: valueMaxBox
                        objectName: "valueMaxBox"
                        width: valueRow.width / uicontroller.headerCount
                        color: "#ffffff"
                        border.width: 1
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        clip: true

                        Text
                        {
                            id: valueMax
                            text: max
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.leftMargin: 2
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                        }

                        Rectangle {
                            id: valueBorderRightMax
                            x: 7
                            y: 2
                            width: 1
                            color: "#808080"
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.bottomMargin: 0
                            anchors.rightMargin: 0
                        }
                    }

                    Rectangle
                    {
                        id: valueMeanBox
                        objectName: "valueMeanBox"
                        width: valueRow.width / uicontroller.headerCount
                        color: "#ffffff"
                        border.width: 1
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        clip: true

                        Text
                        {
                            id: valueMean
                            text: mean
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.leftMargin: 2
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                        }

                        Rectangle {
                            id: valueBorderRightMean
                            x: -3
                            y: 2
                            width: 1
                            color: "#808080"
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.bottomMargin: 0
                            anchors.rightMargin: 0
                        }
                    }

                    Rectangle
                    {
                        id: valueRangeBox
                        objectName: "valueRangeBox"
                        width: valueRow.width / uicontroller.headerCount
                        color: "#ffffff"
                        border.width: 1
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        clip: true

                        Text
                        {
                            id: valueRange
                            text: range
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.leftMargin: 2
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                        }

                        Rectangle {
                            id: valueBorderRightRange
                            x: 4
                            y: 4
                            width: 1
                            color: "#808080"
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.bottomMargin: 0
                            anchors.rightMargin: 0
                        }
                    }

                    Rectangle
                    {
                        id: valueDifficultyBox
                        objectName: "valueDifficultyBox"
                        width: valueRow.width / uicontroller.headerCount
                        color: "#ffffff"
                        border.width: 1
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        clip: true

                        Text
                        {
                            id: valueDifficulty
                            text: difficulty
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.leftMargin: 2
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignLeft
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                        }

                        Rectangle {
                            id: valueBorderRightDifficulty
                            x: -7
                            y: -3
                            width: 1
                            color: "#808080"
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.bottomMargin: 0
                            anchors.rightMargin: 0
                        }
                    }

                    Rectangle
                    {
                        id: valueThreshMaxBox
                        objectName: "valueThreshMaxBox"
                        width: valueRow.width / uicontroller.headerCount
                        color: "#ffffff"
                        border.width: 1
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        clip: true

                        Text
                        {
                            id: valueThreshMax
                            text: threshMax
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.leftMargin: 2
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                        }

                        Rectangle {
                            id: valueBorderRightThresholdMax
                            x: 3
                            y: 4
                            width: 1
                            color: "#808080"
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.bottomMargin: 0
                            anchors.rightMargin: 0
                        }
                    }

                    Rectangle
                    {
                        id: valueThreshMinBox
                        objectName: "valueThreshMinBox"
                        width: valueRow.width / uicontroller.headerCount
                        color: "#ffffff"
                        border.width: 1
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        clip: true

                        Text
                        {
                            id: valueThreshMin
                            text: threshMin
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.leftMargin: 2
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                        }

                        Rectangle {
                            id: valueBorderRightThresholdMin
                            x: 6
                            y: 0
                            width: 1
                            color: "#808080"
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.bottomMargin: 0
                            anchors.rightMargin: 0
                        }
                    }

                    Rectangle
                    {
                        id: valuePointsBox
                        objectName: "valuePointsBox"
                        width: valueRow.width / uicontroller.headerCount
                        color: "#ffffff"
                        border.width: 1
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 0
                        anchors.top: parent.top
                        anchors.topMargin: 0
                        clip: true

                        Text
                        {
                            id: valuePoints
                            text: points
                            anchors.right: parent.right
                            anchors.rightMargin: 5
                            anchors.left: parent.left
                            anchors.leftMargin: 2
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignRight
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                        }

                        Rectangle
                        {
                            id: valueBorderRightPoints
                            x: 9
                            y: -8
                            width: 1
                            color: "#808080"
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.bottomMargin: 0
                            anchors.rightMargin: 0
                        }
                    }
                }

            }
        }
        Row {
            id: headerRow
            x: 2
            y: 5
            height: 30
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 6
            clip: true
            spacing: 0

            Rectangle
            {
                id: headerStartBox
                width: headerRow.width / uicontroller.headerCount
                color: "#ffffff"
                border.width: 1
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                clip: true

                Text
                {
                    id: headerStart
                    text: qsTr("start")
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                }

                Rectangle {
                    id: rectangle1
                    width: 1
                    color: "#808080"
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                }
            }

            Rectangle
            {
                id: headerStopBox
                width: headerRow.width / uicontroller.headerCount
                color: "#ffffff"
                border.width: 1
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                clip: true

                Text
                {
                    id: headerStop
                    text:  qsTr("stop")
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                }

                Rectangle {
                    id: rectangle2
                    x: -6
                    y: -8
                    width: 1
                    color: "#808080"
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: 0
                    anchors.rightMargin: 0
                }
            }

            Rectangle
            {
                id: headerStateBox
                width: headerRow.width / uicontroller.headerCount
                color: "#ffffff"
                border.width: 1
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                clip: true

                Text
                {
                    id: headerState
                    text: qsTr("state")
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                }

                Rectangle
                {
                    id: rectangle3
                    x: 9
                    y: -3
                    width: 1
                    color: "#808080"
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: 0
                    anchors.rightMargin: 0
                }
            }

            Rectangle
            {
                id: headerPerCorrectBox
                width: headerRow.width / uicontroller.headerCount
                color: "#ffffff"
                border.width: 1
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                clip: true

                Text
                {
                    id: headerPerCorrect
                    text: qsTr("% correct")
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                }

                Rectangle {
                    id: rectangle4
                    x: -5
                    y: 2
                    width: 1
                    color: "#808080"
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: 0
                    anchors.rightMargin: 0
                }
            }

            Rectangle
            {
                id: headerPerTransitBox
                width: headerRow.width / uicontroller.headerCount
                color: "#ffffff"
                border.width: 1
                visible: false
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                clip: true

                Text
                {
                    id: headerPerTransit
                    text: qsTr("% transit")
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                }

                Rectangle {
                    id: rectangle5
                    x: -7
                    y: -4
                    width: 1
                    color: "#808080"
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: 0
                    anchors.rightMargin: 0
                }
            }

            Rectangle
            {
                id: headerPerFalseBox
                width: headerRow.width / uicontroller.headerCount
                color: "#ffffff"
                border.width: 1
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                clip: true

                Text
                {
                    id: headerPerFalse
                    text: qsTr("% false")
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                }

                Rectangle {
                    id: rectangle6
                    x: 7
                    y: 5
                    width: 1
                    color: "#808080"
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: 0
                    anchors.rightMargin: 0
                }
            }

            Rectangle
            {
                id: headerMinBox
                width: headerRow.width / uicontroller.headerCount
                color: "#ffffff"
                border.width: 1
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                clip: true

                Text
                {
                    id: headerMin
                    text: qsTr("min")
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                }

                Rectangle {
                    id: rectangle7
                    x: 6
                    y: 9
                    width: 1
                    color: "#808080"
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: 0
                    anchors.rightMargin: 0
                }
            }

            Rectangle
            {
                id: headerMaxBox
                width: headerRow.width / uicontroller.headerCount
                color: "#ffffff"
                border.width: 1
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                clip: true

                Text
                {
                    id: headerMax
                    text: qsTr("max")
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                }

                Rectangle {
                    id: rectangle8
                    x: 7
                    y: 2
                    width: 1
                    color: "#808080"
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: 0
                    anchors.rightMargin: 0
                }
            }

            Rectangle
            {
                id: headerMeanBox
                width: headerRow.width / uicontroller.headerCount
                color: "#ffffff"
                border.width: 1
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                clip: true

                Text
                {
                    id: headerMean
                    text: qsTr("mean")
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                }

                Rectangle {
                    id: rectangle9
                    x: -3
                    y: 2
                    width: 1
                    color: "#808080"
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: 0
                    anchors.rightMargin: 0
                }
            }

            Rectangle
            {
                id: headerRangeBox
                width: headerRow.width / uicontroller.headerCount
                color: "#ffffff"
                border.width: 1
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                clip: true

                Text
                {
                    id: headerRange
                    text: qsTr("range")
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                }

                Rectangle {
                    id: rectangle10
                    x: 4
                    y: 4
                    width: 1
                    color: "#808080"
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: 0
                    anchors.rightMargin: 0
                }
            }

            Rectangle
            {
                id: headerDifficultyBox
                width: headerRow.width / uicontroller.headerCount
                color: "#ffffff"
                border.width: 1
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                clip: true

                Text
                {
                    id: headerDifficulty
                    text: qsTr("difficulty")
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                }

                Rectangle {
                    id: rectangle11
                    x: -7
                    y: -3
                    width: 1
                    color: "#808080"
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: 0
                    anchors.rightMargin: 0
                }
            }

            Rectangle
            {
                id: headerThreshMaxBox
                width: headerRow.width / uicontroller.headerCount
                color: "#ffffff"
                border.width: 1
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                clip: true

                Text
                {
                    id: headerThreshMax
                    text: qsTr("threshold Max")
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                }

                Rectangle {
                    id: rectangle12
                    x: 3
                    y: 4
                    width: 1
                    color: "#808080"
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: 0
                    anchors.rightMargin: 0
                }
            }

            Rectangle
            {
                id: headerThreshMinBox
                width: headerRow.width / uicontroller.headerCount
                color: "#ffffff"
                border.width: 1
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                clip: true

                Text
                {
                    id: headerThreshMin
                    text: qsTr("threshold min")
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                }

                Rectangle {
                    id: rectangle13
                    x: 6
                    y: 0
                    width: 1
                    color: "#808080"
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: 0
                    anchors.rightMargin: 0
                }
            }

            Rectangle
            {
                id: headerPointsBox
                width: headerRow.width / uicontroller.headerCount
                color: "#ffffff"
                border.width: 1
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0
                clip: true

                Text
                {
                    id: headerPoints
                    text: qsTr("points")
                    anchors.right: parent.right
                    anchors.rightMargin: 0
                    anchors.left: parent.left
                    anchors.leftMargin: 2
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0
                }

                Rectangle
                {
                    id: rectangle14
                    x: 9
                    y: -8
                    width: 1
                    color: "#808080"
                    anchors.top: parent.top
                    anchors.topMargin: 0
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.bottomMargin: 0
                    anchors.rightMargin: 0
                }
            }
        }
    }


    function switchVisibleHeader(headerGroup)
    {

        for(var delegates in valueTable.contentItem.children)
        {
            for(var rows in valueTable.contentItem.children[delegates].children)
            {
                if(valueTable.contentItem.children[delegates].children[rows].objectName === "rowTest")
                {
                    for(var boxes in valueTable.contentItem.children[delegates].children[rows].children)
                    {

                        if(valueTable.contentItem.children[delegates].children[rows].children[boxes].objectName !== "valuePerTransitBox")
                        {
                            valueTable.contentItem.children[delegates].children[rows].children[boxes].visible = true
                        }
                    }

                }
            }
        }

        headerMinBox.visible = true
        headerMaxBox.visible = true
        headerMeanBox.visible = true

        headerThreshMaxBox.visible = true
        headerThreshMinBox.visible = true

        uicontroller.headerCount = 13

        if(headerGroup === 0)
        {
            uicontroller.headerCount = 11
            headerThreshMaxBox.visible = false
            headerThreshMinBox.visible = false

            for(var delegates2 in valueTable.contentItem.children)
            {
                for(var rows2 in valueTable.contentItem.children[delegates2].children)
                {
                    if(valueTable.contentItem.children[delegates2].children[rows2].objectName === "rowTest")
                    {
                        for(var boxes2 in valueTable.contentItem.children[delegates2].children[rows2].children)
                        {
                            if(valueTable.contentItem.children[delegates2].children[rows2].children[boxes2].objectName === "valueThreshMaxBox" ||
                                   valueTable.contentItem.children[delegates2].children[rows2].children[boxes2].objectName === "valueThreshMinBox" )
                            {
                                valueTable.contentItem.children[delegates2].children[rows2].children[boxes2].visible = false
                            }
                        }

                    }
                }
            }
        }
        if(headerGroup === 1)
        {
            uicontroller.headerCount = 10
            headerMinBox.visible = false
            headerMaxBox.visible = false
            headerMeanBox.visible = false

            for(var delegates3 in valueTable.contentItem.children)
            {
                for(var rows3 in valueTable.contentItem.children[delegates3].children)
                {
                    if(valueTable.contentItem.children[delegates3].children[rows3].objectName === "rowTest")
                    {
                        for(var boxes3 in valueTable.contentItem.children[delegates3].children[rows3].children)
                        {
                            if(valueTable.contentItem.children[delegates3].children[rows3].children[boxes3].objectName === "valueMinBox" ||
                                    valueTable.contentItem.children[delegates3].children[rows3].children[boxes3].objectName === "valueMaxBox" ||
                                    valueTable.contentItem.children[delegates3].children[rows3].children[boxes3].objectName === "valueMeanBox")
                            {
                                valueTable.contentItem.children[delegates3].children[rows3].children[boxes3].visible = false
                            }
                        }

                    }
                }
            }
        }

        headerStartBox.width = headerRow.width / uicontroller.headerCount
        headerStopBox.width = headerRow.width / uicontroller.headerCount
        headerStateBox.width = headerRow.width / uicontroller.headerCount
        headerPerCorrectBox.width = headerRow.width / uicontroller.headerCount
        headerPerFalseBox.width = headerRow.width / uicontroller.headerCount
        headerMinBox.width = headerRow.width / uicontroller.headerCount
        headerMaxBox.width = headerRow.width / uicontroller.headerCount
        headerMeanBox.width = headerRow.width / uicontroller.headerCount
        headerRangeBox.width = headerRow.width / uicontroller.headerCount
        headerDifficultyBox.width = headerRow.width / uicontroller.headerCount
        headerThreshMaxBox.width = headerRow.width / uicontroller.headerCount
        headerThreshMinBox.width = headerRow.width / uicontroller.headerCount
        headerPointsBox.width = headerRow.width / uicontroller.headerCount

        for(var delegates4 in valueTable.contentItem.children)
        {
            for(var rows4 in valueTable.contentItem.children[delegates4].children)
            {
                if(valueTable.contentItem.children[delegates4].children[rows4].objectName === "rowTest")
                {
                    for(var boxes4 in valueTable.contentItem.children[delegates4].children[rows4].children)
                    {
                        valueTable.contentItem.children[delegates4].children[rows4].children[boxes4].width =  headerRow.width / uicontroller.headerCount
                    }
                }
            }
        }

    }

    Connections
    {
        target: uicontroller
        onClearAnalyseModelChanged:
        {
            analyseModel.clear()
        }
    }

    ListModel
    {
        id: analyseModel
    }

    /*
    Component
    {
        //separates the single-sections from the summed-sections
        id: sectionHeading
        Rectangle
        {
            width: parent.width
            height: childrenRect.height
            color: "black"
            Text { }    //musst be created, even without content...
        }

    }*/








}



/*##^##
Designer {
    D{i:4;anchors_height:30}D{i:6;anchors_height:200}D{i:9;anchors_height:200}D{i:13;anchors_height:285.3}
D{i:14;anchors_x:0}D{i:12;anchors_height:200}D{i:17;anchors_height:285.3}D{i:15;anchors_height:200}
D{i:19;anchors_x:0}D{i:18;anchors_height:200}D{i:21;anchors_height:200}D{i:24;anchors_height:200}
D{i:27;anchors_height:200}D{i:32;anchors_height:288;anchors_width:467;anchors_x:0;anchors_y:29}
D{i:30;anchors_height:200}D{i:33;anchors_height:200}D{i:37;anchors_x:0}D{i:36;anchors_height:285.3}
D{i:39;anchors_height:200}D{i:42;anchors_height:200}D{i:46;anchors_height:288;anchors_width:467;anchors_x:0;anchors_y:317}
D{i:45;anchors_height:200}D{i:5;anchors_width:33.5;anchors_x:0}D{i:3;anchors_width:467;anchors_x:0;anchors_y:0}
D{i:50;anchors_height:285.3}D{i:51;anchors_x:0}D{i:60;anchors_height:315;anchors_width:465;anchors_x:8}
D{i:2;anchors_height:200;anchors_width:200;anchors_x:473;anchors_y:163}
}
##^##*/
