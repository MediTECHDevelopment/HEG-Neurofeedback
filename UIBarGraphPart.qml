import QtQuick 2.0
import QtCharts 2.3

//UIBarGraphPart provides the bargraph for the Training- and Analyseview.

Rectangle
{
    id: barrec
    border.color: "grey"
    border.width: 1


    ChartView
    {
        id: bargraph
        anchors.fill: parent
        antialiasing: true
        legend.visible: false

        UIYAxis_Coord
        {
            id: barYaxis
            labelsFont: Qt.font({pointSize: 9})
        }


        ValueAxis
        {
            id: barXaxis
            labelsVisible: false
            gridVisible: false
            //color: "transparent"
            color: "white"
        }


        //represents the current Datapoint
        BarSeries
        {
            barWidth: parent.width
            id: mySeries
            axisY: barYaxis
            axisX: barXaxis

            BarSet
            {
                id: data1
                values: [uicontroller.appendAtYData]
                color: uicontroller.barGraphColor
            }                  
        }


        //represents the current Thresholdpoint
        BarSeries
        {
            barWidth: parent.width
            axisY: barYaxis
            axisX: barXaxis

            BarSet
            {
                color: "transparent"    //don't change this color! If another color for the threshold is wnated, change the thresholdGraphColor in the uicontroller!
                borderColor: uicontroller.thresholdGraphColor
                borderWidth: 2
                values: [uicontroller.appendAtYThreshold]
            }
        }

        //to hide the lower border of the ThresholdGraph
        BarSeries
        {
            barWidth: parent.width
            axisY: barYaxis
            axisX: barXaxis
            BarSet
            {
                color: uicontroller.barGraphColor
                borderColor: uicontroller.barGraphColor
                values: [1]
            }
        }
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
