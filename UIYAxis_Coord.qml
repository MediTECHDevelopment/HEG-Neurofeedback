import QtQuick 2.0
import QtCharts 2.3

//UIYAxis_Coord is the y-Axis, used for the line- and bargraph. it is separated, to ensure, that it shows the same values for every version

ValueAxis
{
    min: uicontroller.varYMin
    max: uicontroller.varYMax
    gridVisible: false
    color: "black"
}

