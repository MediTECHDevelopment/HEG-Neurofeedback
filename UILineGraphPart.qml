import QtQuick 2.0
import QtCharts 2.3
import QtQuick.Controls 2.4

//UILineGraphPart provides the on- and offlinegraph

Rectangle
{
    id: linerec

    property int movingTimer: 0
    property string appendString
    property string removeString
    Connections
    {
        target: uicontroller
        ignoreUnknownSignals: true
        onCurrentMSChanged:
        {
            //independent of the mode (on- or offline), a change of currentMS triggers the adherence of a new point to the linegraph
            appendXY();

            if(uicontroller.runtime)
            {
                //print(Math.round(uicontroller.currentMS)  + "  -.- " + uicontroller.stepwidth)
                //in onlinemode, the xAxis-ticks are calculated in this function, offline there is another one below
                if(Math.round(uicontroller.currentMS / 1000) % (uicontroller.stepwidth) == 0)   //stepwidth between ticks
                {
                    var labelPoint = 15 // half samplerate
                    //print("moving Timer: " + movingTimer + " lp " + labelPoint)
                    movingTimer++
                    if(movingTimer === labelPoint )       //if stepwidth 1 -> called after 5 "onCurrentMSChanged"; if stepwidth 2 -> called after 10 "onCurrentMSChanged"; ...
                    {
                        //get new string
                        if(Math.round(uicontroller.currentMS / 1000) < 10)
                        {
                            appendString = "00:0" + Math.round(uicontroller.currentMS / 1000)
                        }
                        else if(Math.round(uicontroller.currentMS / 1000) < 60)
                        {
                            appendString = "00:" + Math.round(uicontroller.currentMS / 1000)
                        }
                        else if (Math.round(uicontroller.currentMS / 1000) < 600)
                        {
                            if(Math.round(uicontroller.currentMS / 1000) % 60 < 10)
                                appendString = "0" + Math.floor(Math.round(uicontroller.currentMS / 1000)/60) + ":0" + Math.round(uicontroller.currentMS / 1000) % 60, Math.round(uicontroller.currentMS / 1000)
                            else
                                appendString = "0" + Math.floor(Math.round(uicontroller.currentMS / 1000)/60) + ":" + Math.round(uicontroller.currentMS / 1000)%60, Math.round(uicontroller.currentMS / 1000)
                        }
                        else if (Math.round(uicontroller.currentMS / 1000) < 3600)
                        {
                            if(Math.round(uicontroller.currentMS / 1000) % 60 < 10)
                                appendString = Math.floor(Math.round(uicontroller.currentMS / 1000)/60) + ":0" + Math.round(uicontroller.currentMS / 1000)%60, Math.round(uicontroller.currentMS / 1000)
                            else
                                appendString = Math.floor(Math.round(uicontroller.currentMS / 1000)/60) + ":" + Math.round(uicontroller.currentMS / 1000)%60, Math.round(uicontroller.currentMS / 1000)
                        }
                        else
                        {
                            //if measurement longer than an hour
                            var hours = Math.floor(Math.round(uicontroller.currentMS / 1000)/3600)
                            var hoursstring
                            var minutes = Math.floor((Math.round(uicontroller.currentMS / 1000) % 3600)/60)
                            var minutestring
                            var seconds = minutes/60
                            var secondsstring

                            if(hours > 10)
                                hoursstring = hours
                            else
                                hoursstring = "0"+hours

                            if (minutes > 10)
                                minutestring = minutes
                            else
                                minutestring = "0" + minutes

                            if(seconds > 10)
                                secondsstring = seconds
                            else
                                secondsstring = "0" +seconds

                            appendString = hoursstring + ":" + minutestring + ":" + secondsstring
                        }

                        //reduce performance-problems
                        removeString = xTrend10.categoriesLabels[0]

                        if(xTrend10.categoriesLabels.length > uicontroller.tickcount)
                        {
                            xTrend10.remove(removeString)
                        }
                        xTrend10.append(appendString, Math.round(uicontroller.currentMS / 1000))

                        getMovingAxisPoints(uicontroller.currentMS)
                        movingTimer = 0
                    }
                }
            }
        }
        onTrendselectChanged:
        {
            lineGraphSlider.value = 0.0
            resetTickCount(uicontroller.currentMS, uicontroller.stepwidth)
        }
        onClearLinesChanged:
        {
            if(uicontroller.clearLines)
            {
                dataline.clear();
                thresholdline.clear();
                xAxisLine.clear();
                stateChangeLine.clear();
                uicontroller.clearLines = false;
            }
        }

        onSliderValueChanged:
        {
            lineGraphSlider.value = uicontroller.sliderValue
        }

        onIsconcentrationChanged:
        {
            //draws a vertical line for every statechange
            stateChangeLine.append(uicontroller.currentMS/1000, -5)
            stateChangeLine.append(uicontroller.currentMS/1000, uicontroller.varYMax)
            stateChangeLine.append(uicontroller.currentMS/1000, -5)
        }
    }

    function appendXY()
    {
        //append and, if needed, remove points to the data- and tresholdline
        dataline.append( uicontroller.currentMS, uicontroller.appendAtYData)
        thresholdline.append( uicontroller.currentMS, uicontroller.appendAtYThreshold)

        if(uicontroller.runtime && uicontroller.currentMS/1000 > 120)
        {
            dataline.removePoints(0, 1);
            thresholdline.removePoints(0, 1)
        }
    }

    function getMovingAxisPoints(currMS)
    {
        //shift xAxisLine to get a moving Axis
        xAxisLine.append(Math.round(currMS / 1000), 0)

        if(uicontroller.runtime && uicontroller.currentMS > 2)
        {
            xAxisLine.removePoints(0,1)
        }
    }

    function resetTickCount(currMS, stepp)
    {
        //needed to reset the ticks on every trendselect changed
        if(uicontroller.runtime)
        {
            var labelArray = xTrend10.categoriesLabels
            while (labelArray.length !== 0)      //labelArray reduces itself while deleting the Labels, don't use for!
            {
                xTrend10.remove(labelArray[0]) //always asking for index 0 will return the (wanted) next value, couse the first one is deleted every loop
            }

            var newMin = 0
            if (uicontroller.trendselectInMS < currMS)
                newMin = (currMS/1000) - uicontroller.trendselect

            var newMax = uicontroller.trendselectInMS < currMS ? currMS/1000 : uicontroller.trendselect

            for (var ixSteps = 0; ixSteps<= newMax; ixSteps += stepp)
            {
                //calculation is the same as in the "onCurrentChanged
                if (ixSteps >= newMin)
                {
                    if(ixSteps < 10)
                        xTrend10.append("00:0" + ixSteps , ixSteps)
                    else if (ixSteps < 60)
                    {
                        xTrend10.append("00:" + ixSteps , ixSteps)
                    }
                    else if (ixSteps < 600)
                    {
                        if(ixSteps % 60 < 10)
                            xTrend10.append("0" + Math.floor(ixSteps/60) + ":0" + ixSteps % 60, ixSteps)
                        else
                            xTrend10.append("0" + Math.floor(ixSteps/60) + ":" + ixSteps%60, ixSteps)
                    }
                    else if (ixSteps < 3600)
                    {
                        if(ixSteps % 60 < 10)
                            xTrend10.append(Math.floor(ixSteps/60) + ":0" + ixSteps%60, ixSteps)
                        else
                            xTrend10.append(Math.floor(ixSteps/60) + ":" + ixSteps%60, ixSteps)
                    }
                    else
                    {
                        var hours = Math.floor(ixSteps/3600)
                        var hoursstring
                        var minutes = Math.floor((ixSteps % 3600)/60)
                        var minutestring
                        var seconds = minutes/60
                        var secondsstring

                        if(hours > 10)
                            hoursstring = hours
                        else
                            hoursstring = "0"+hours

                        if (minutes > 10)
                            minutestring = minutes
                        else
                            minutestring = "0" + minutes

                        if(seconds > 10)
                            secondsstring = seconds
                        else
                            secondsstring = "0" +seconds

                        xTrend10.append( hoursstring + ":" + minutestring + ":" + secondsstring)
                    }
                }
            }
        }
        else
        {
            offlineTicks(uicontroller.stepwidth)
        }
    }

    function offlineTicks(stepp) //called for offlineTicks-movement and trendchanges (including the first default-change to totaltrend)
    {
        var labelArray = xTrend10.categoriesLabels
        while (labelArray.length !== 0)      //labelArray reduces itself while deleting the Labels, don't use for!
        {
            xTrend10.remove(labelArray[0]) //always asking for index 0 will return the (wanted) next value, couse the first one is deleted every loop
        }

        //for (var ixSteps = 0; ixSteps <= (uicontroller.maxmillisec/1000) ; ixSteps += stepp)
        for (var ixSteps = 0; ixSteps <= uicontroller.movingMax ; ixSteps += stepp)
        {
            if(ixSteps >= uicontroller.movingMin)
            {
                if(ixSteps < 10)
                    xTrend10.append("00:0" + ixSteps , ixSteps)
                else if (ixSteps < 60)
                {
                    xTrend10.append("00:" + ixSteps , ixSteps)
                }
                else if (ixSteps < 600)
                {
                    if(ixSteps % 60 < 10)
                        xTrend10.append("0" + Math.floor(ixSteps/60) + ":0" + ixSteps % 60, ixSteps)
                    else
                        xTrend10.append("0" + Math.floor(ixSteps/60) + ":" + ixSteps%60, ixSteps)
                }
                else if (ixSteps < 3600)
                {
                    if(ixSteps % 60 < 10)
                        xTrend10.append(Math.floor(ixSteps/60) + ":0" + ixSteps%60, ixSteps)
                    else
                        xTrend10.append(Math.floor(ixSteps/60) + ":" + ixSteps%60, ixSteps)
                }
                else
                {
                    var hours = Math.floor(ixSteps/3600)
                    var hoursstring
                    var minutes = (ixSteps % 3600)/60
                    var minutestring
                    var seconds = minutes/60
                    var secondsstring

                    if(hours > 10)
                        hoursstring = hours
                    else
                        hoursstring = "0"+hours

                    if (minutes > 10)
                        minutestring = minutes
                    else
                        minutestring = "0" + minutes

                    if(seconds > 10)
                        secondsstring = seconds
                    else
                        secondsstring = "0" +seconds

                    xTrend10.append( hoursstring + ":" + minutestring + ":" + secondsstring)

                }
            }
        }
    }

    border.color: "grey"
    border.width: 1

    ChartView
    {
        id: linegraph
        anchors.fill: parent
        antialiasing: true
        legend.alignment: Qt.AlignLeft
        legend.font: Qt.font({pointSize: 11, bold:true})
        clip: true

        UIYAxis_Coord
        {
            id: lineYaxis1
            labelsFont: Qt.font({pointSize: 9})
        }

        UIYAxis_Coord
        {
            id: lineYaxis2
            labelsFont: Qt.font({pointSize: 9})
        }

        ValueAxis
        {
            //axis for data- and tresholdline, not visible but needed cause the scale bewtween the axes differs
            id: lineXaxistime
            gridVisible: false
            visible: false
            color: "transparent"
            tickCount: uicontroller.tickcount
            min: uicontroller.minmillisec
            max: uicontroller.maxmillisec
        }

        LineSeries
        {
            id: dataline
            name: qsTr("Data")
            axisY: lineYaxis1
            axisX: lineXaxistime
            width: 2
            color: "steelblue"
            onClicked:
            {
                if (!uicontroller.runtime)
                {
                    uicontroller.datalineClicked = point.x
                }
            }
        }

        LineSeries
        {
            id: thresholdline
            name: qsTr("Threshold")
            axisYRight: lineYaxis2
            axisX: lineXaxistime
            width: 1
            color: "black"
            style: Qt.DashDotDotLine
        }

        LineSeries  //needed for the moving axis, not visible!
        {
            //isn't drawn, just needed to get a moving axis. Could be deleted, if there is a better solution for a movin time-axis... basically that was the most curcial part from the whole program...
            id: xAxisLine
            axisY: lineYaxis1
            axisX: xTrend10
            visible: false
        }

        LineSeries
        {
            name: qsTr("state changes")
            id: stateChangeLine
            axisY: lineYaxis1
            axisX: xTrend10
            color: "darkred"
            style: Qt.DotLine
        }

        CategoryAxis
        {
            //"animated" with the halp of xAxisLine, every Tick is a completly new generated string!
            id: xTrend10
            min: uicontroller.movingMin
            max: uicontroller.movingMax
            gridVisible: false
            color: "black"
            labelsPosition: CategoryAxis.AxisLabelsPositionOnValue
            labelsFont: Qt.font({pointSize: 10})
            CategoryRange { label: "00:00"; endValue: 0 }
            CategoryRange { label: "00:01"; endValue: 1 }
            CategoryRange { label: "00:02"; endValue: 2 }
            CategoryRange { label: "00:03"; endValue: 3 }
            CategoryRange { label: "00:04"; endValue: 4 }
            CategoryRange { label: "00:05"; endValue: 5 }
            CategoryRange { label: "00:06"; endValue: 6 }
            CategoryRange { label: "00:07"; endValue: 7 }
            CategoryRange { label: "00:08"; endValue: 8 }
            CategoryRange { label: "00:09"; endValue: 9 }
            CategoryRange { label: "00:10"; endValue: 10 }
        }
    }

    //online not visible, offline not alwayse enabled!
    property real prevValue: 0.0
    Slider
    {
        id: lineGraphSlider
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.bottom: parent.bottom
        visible: !uicontroller.runtime
        enabled: uicontroller.sliderNeeded
        value: 0.0
        from: 0.0
        to: 1.0

        onValueChanged:
        {
            if(uicontroller.sliderNeeded)
            {
                uicontroller.clearLines = true

                uicontroller.sliderMovingMin = Math.round(position * (uicontroller.totalXVector.length - (uicontroller.trendselect * 100)))

                uicontroller.maxmillisec = parseInt( Math.round((uicontroller.totalMS - uicontroller.trendselectInMS) * position) + uicontroller.trendselectInMS)
                uicontroller.movingMax = (Math.round((uicontroller.totalMS - uicontroller.trendselectInMS) * position) + uicontroller.trendselectInMS) / 1000

                uicontroller.minmillisec = uicontroller.maxmillisec - uicontroller.trendselectInMS
                uicontroller.movingMin = (uicontroller.maxmillisec - uicontroller.trendselectInMS) / 1000

                offlineTicks(uicontroller.stepwidth)
            }
        }
    }
}
