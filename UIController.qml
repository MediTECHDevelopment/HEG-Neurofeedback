import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.2

//The uicontroller holds variables, which are needed in several other components, too. It musst be initialised in main.qml to be accessible for every other component!

Item
{
    Connections
    {
        target: cppController
        ignoreUnknownSignals: true          //otherwise: QML Connections: Cannot assign to non-existent property "..." Should be assigned for every Connections, but could be hard for debugging...
        onDisplayStatustextLeft:
        {
            statetextleft = statusMessage;
            statetexttimer.interval = messageDuration;
            statetexttimer.start();
        }
        onDisplayStatustextRight:
        {
            statetextright = statusMessage
        }
        onDisplayStatustextClientLabel:
        {
            clientLabel = statusMessage
        }
        onSetNewThreshold:
        {
            threshold = newThreshold
        }
        onSetNewVidFile:
        {
            videosource = newVidPath
        }
    }

    Connections
    {
        target: cppDatabaseHandler
        ignoreUnknownSignals: true
        onLoadButtonDecisionBox:
        {
            loadButtonDialog.text = message;
            loadButtonDialog.visible = true;
        }
        onLoadAction:
        {
            if(runtime)
            {
                runtime = false
                mainloader.sourceComponent = mainanalyse
            }
            drawOfflineData++;
            databasestatus = false;
        }
    }

    Connections
    {
        target: mainwindow
        ignoreUnknownSignals: true
        //axis musst be adapted on every width-change!
        onWidthChanged:
        {
            if(!runtime)
            {
                adaptAxis();
            }
        }
    }

    Connections
    {
        target: cppTrainingHandler
        ignoreUnknownSignals: true
        onTimeoutSignalUITimerDrawRest:
        {
            //sended with ~10Hz, contains the data since the last signal as a List
            adaptAxis();
            getLineData(xData, yData, yThreshold)
        }
    }

    Connections
    {
        target: cppDataHandler
        ignoreUnknownSignals: true
        onSetNotepadNotes:
        {
            //to set the notes after runtimechange or measurementloading
            notetextNotes = notes
        }
    }

    Connections
    {
        target: cppMainHandler
        onSendOfflineData:
        {
            clearLines = true;

            //allocate the datalists
            totalXVector = xData
            totalYDataVector = yData
            totalYThresholdVector = yThreshold
            totalStateVector = offStates

            measurmentDateString = measDate
            measurmentDurationString = measDuration
            measurmentTimeString = measTime

            totalMS = xData[xData.length-1]
            trendselect = xData[xData.length-1]/1000

            //call after the allocations and settings, otherwise settings for drawing may be false/uncompleted
            getOffLineData(xData, yData, yThreshold, 0, totalXVector.length)
            firstRuntimeSettings = false
        }
    }

    //get highlightcolors depending on the os
    SystemPalette
    {
        id: colorPalette
        colorGroup: SystemPalette.Active
    }
    property color highlightColor: colorPalette.highlight;

    //called for online-data, every datapoint, which is passed to QML is drawn
    property int ixList;
    function getLineData(xList, yDataList, yThresholdList)
    {
        //print("listsize " + xList.length)
        for (ixList = 0; ixList < xList.length; ixList++)
        {
            //print("ms: " + currentMS)
            //print("ix " + ixList)
            currentMS = xList[ixList]
            appendAtYData = yDataList[ixList]
            appendAtYThreshold = yThresholdList[ixList]
            recalculateDataThresholdDiff(yDataList[ixList],yThresholdList[ixList], isconcentration)
        }
    }

    //called for offline-data (after stop or load) on every change on the linegraph-part, which should be displayed (on trendselect changed, on slider changed etc)
    //not every datapoint musst be drawn, compress depending on the windowwidth
    function getOffLineData(xList, yDataList, yThresholdList, startIndex, stopIndex)
    {
        //calculating the step length for the for-loop
        var compressWidth = Math.ceil((stopIndex-startIndex)/(mainwindow.width * 0.5))
        var iList, iPartList, min, max, minIndex, maxIndex

        //set startpoints for max-/min-calculation
        appendAtYData = yDataList[startIndex]
        appendAtYThreshold = yThresholdList[startIndex]
        currentMS = xList[startIndex]

        //get through data int stepwidth
        for(iList = startIndex; iList < stopIndex; iList += compressWidth)
        {
            if(yDataList[iList] >= 0)
            {
                min = yDataList[iList]
                max = yDataList[iList]
            }
            else
            {
                min = 0
                max = 0
            }

            minIndex = iList
            maxIndex = iList


            //get through the datapoints between the steps to find min/max
            for(iPartList = 0; iPartList < compressWidth; iPartList++)
            {
                if(min > yDataList[iList+iPartList] && yDataList[iList+iPartList] >= 0)
                {
                    min = yDataList[iList+iPartList]
                    minIndex = iList+iPartList
                }
                if(max < yDataList[iList+iPartList])
                {
                    max = yDataList[iList+iPartList]
                    maxIndex = iList+iPartList
                }
            }

            //append min/max, depending on there order
            if(minIndex < maxIndex)
            {
                appendAtYData = yDataList[minIndex]
                appendAtYThreshold = yThresholdList[minIndex]
                currentMS = xList[minIndex]

                appendAtYData = yDataList[maxIndex]
                appendAtYThreshold = yThresholdList[maxIndex]
                currentMS = xList[maxIndex]
            }
            else if(minIndex !== maxIndex)
            {
                appendAtYData = yDataList[maxIndex]
                appendAtYThreshold = yThresholdList[maxIndex]
                currentMS = xList[maxIndex]

                appendAtYData = yDataList[minIndex]
                appendAtYThreshold = yThresholdList[minIndex]
                currentMS = xList[minIndex]
            }
            else //if min == max, draw just one point
            {
                appendAtYData = yDataList[maxIndex]
                appendAtYThreshold = yThresholdList[maxIndex]
                currentMS = xList[maxIndex]
            }

            isconcentration = totalStateVector[maxIndex]
        }
    }

    //realtimeplotting or not
    property bool runtime: true
    property bool firstRuntimeSettings: false
    onRuntimeChanged:
    {
        console.log("runtime changed")
        totalMS = maxmillisec
        maxmillisec = totalMS //welcher ist richtig?
        maxmillisec = totalMS/1000 //welcher ist richtig?
        minmillisec = 0
        movingMin = 0.0

        trendselect = currentMS/1000
        clearLines = true;
    }

    property int drawOfflineData: 0
    property int clearAnalyseModel: 0
    onDrawOfflineDataChanged:
    {
        vidOrAnalyse = qsTr("Analystable")      //in the online-mode, the text musst be video, offline it is analysetable...

        clearAnalyseModel++ // just needed to call a "on changed"

        cppMainHandler.getOfflineData()
        cppMainHandler.fillAnalyseTable()
    }

    //called on "new Training". Don't reset everything, some of the layoutsettings ie should be maintain even in a new training
    function reload()
    {
        //reset musst be the first action (save questions etc)!
        cppMainHandler.reset();

        measurmentTimeString = ""
        measurmentDateString = ""
        measurmentDurationString = ""

        runtime = true

        playFirstClicked = true;

        notetextNotes = ""

        thresholdisadaptive = true

        vidOrAnalyse = qsTr("Video")
        resetVid();

        firstselect = true
        secondselect = false
        thirdselect = false
        forthselect = false
        trendselect = 11
        trendselectInMS = 11000
        usertrendtext = "10"

        statetextleft = ""
        statetextright = qsTr("elapsed time")

        tickcount = 10
        maxmillisec = trendselectInMS
        minmillisec = 0
        currentMS = 0
        appendAtYData = 50
        appendAtYThreshold = 10
        clearLines = true;

        sliderNeeded = false
        sliderValue = 0.0

        varYMin = 0
        varYMax = 200

        barGraphColor = "transparent"
        thresholdGraphColor = "transparent"

        totalXVector = []
        totalYDataVector = []
        totalYThresholdVector = []
        totalStateVector = []

        mainloader.sourceComponent = maintraining
    }

    //WebViewURL
    property string webViewURL: "" //cppController.getLastUsedURL()
    property bool webViewControllsMenuOpen: false
    property int webViewHeight: 1
    property int webViewWidth: 1

    Connections
    {
        target: cppController
        ignoreUnknownSignals: true
        onLoadNewURL:
        {
            print("new url : " +newURL)
            webViewURL = newURL
        }
    }

    //Devices
    property bool isConnectedToDevice: true

    //Main Menu
    property bool clientsActive: true
    property bool settingsActive: false
    property bool selectFeedbackActive: false
    property bool startTrainingActive: false
    property bool resultActive: false
    property bool showResult: false
    property bool addedResultToActiveClient: false
    property bool deletedLastResult: false
    property bool analyseMode: false

    //Submenu
    property bool showSettingsButton: false
    property bool showBackToMenuButton: true
    property bool showBackToResultsButton: false
    property bool showResultFinishButton: false
    property bool showSelectionPart: false



    //analysetable !!no reload!!
    property int calcDiffButtonID: -2
    onCalcDiffButtonIDChanged:
    {
        cppController.setCalcDiffID(calcDiffButtonID);
        clearAnalyseModel++
        cppMainHandler.fillAnalyseTable();
    }

    property int headerGroupButtonID: 0
    property int headerCount: 13
    onHeaderGroupButtonIDChanged:
    {

    }

    //sideData RELOAD!!
    property string measurmentTimeString: ""
    property string measurmentDateString: ""
    property string measurmentDurationString: ""

    //Layoutstates !!no reload!!
    property string laststate: "viewall"
    property bool timetimerruns: false

    property bool barstate: true
    property bool linestate: true
    property bool vidstate: true
    property int layoutid: 1
    property string vidOrAnalyse: qsTr("Video")     //RELOAD!!

    //Trainingstate  !!no reload!!
    property bool isconcentration: true
    onIsconcentrationChanged:
    {
        cppController.setConcentrationState(isconcentration)
    }

    //Threshhold
    property bool thresholdisadaptive: true         //Reload
    property int threshold: 100 //das muss alles noch angepasst werden!
    onThresholdisadaptiveChanged:
    {
        cppController.changeAdaptiveThresh(thresholdisadaptive)
    }
    onThresholdChanged:
    {
        cppController.setThresholdValue(threshold)
    }

    //Difficulty  !!no reload!!
    property int difficultyid: 1
    onDifficultyidChanged:
    {
        cppController.setDifficulty(difficultyid)
    }

    //Notes RELOAD!
    property string notetextNotes: ""
    onNotetextNotesChanged:
    {
        cppController.setNotes(notetextNotes);
    }

    //TrendSelect-Stuff RELOAD!
    property bool firstselect: true
    property bool secondselect: false
    property bool thirdselect: false
    property bool forthselect: false
    property bool totalselect: false
    property int trendselect: 11
    property int trendselectInMS: 11000
    property string usertrendtext: "10"
    property int stepwidth: 1      //"timer" for appending new axisLabel
    onTrendselectChanged:
    {
        trendselectInMS= trendselect * 1000

        //set stuff vor x-Axis-Ticks
        if(trendselect<=10)
        {
            tickcount = trendselect+1;
            stepwidth = 1
        }
        else if(trendselect<=25)
        {
            tickcount = Math.floor(trendselect/2)+1;
            stepwidth = 2
        }
        else
        {
            tickcount = 7;
            stepwidth = Math.round(trendselect / 6)
        }

        //check for slider-stuff
        if (!runtime)
        {
            sliderValue = 0.0
            if (trendselectInMS < totalMS && !totalselect)
            {
                sliderNeeded = true;
            }
            else
            {
                sliderNeeded = false;
            }

            if (sliderNeeded && !totalselect) //sliderNeeded & totalselect both true should never happen!
            {
                maxmillisec = trendselectInMS
                movingMax = trendselect

                minmillisec = 0
                movingMin = 0.0          
            }
            else
            {
                maxmillisec = trendselectInMS
                movingMax = trendselect

                minmillisec = 0
                movingMin = 0.0
            }

            //draw new linegraph-part, if needed
            if(!totalselect)
            {
                clearLines = true
                if(trendselect*100 > totalXVector.length)
                {
                    getOffLineData(totalXVector, totalYDataVector, totalYThresholdVector, 0, totalXVector.length)
                }
                else
                {
                    getOffLineData(totalXVector, totalYDataVector, totalYThresholdVector, 0, trendselect*100)
                }
            }
            //drwa new totalselect for the linegraph
            else if(!firstRuntimeSettings)
            {
                clearLines = true
                getOffLineData(totalXVector, totalYDataVector, totalYThresholdVector, 0, totalXVector.length)
            }

        }
        adaptAxis();
    }
    onTotalselectChanged:
    {
        if(totalselect)
        {
            maxmillisec = totalMS
            minmillisec = 0
            trendselect = totalMS / 1000
        }
    }

    //PlayButton-Stuff RELOAD!
    property bool playstate: false
    property bool pausestate: false
    property bool playFirstClicked: true

    onPlayFirstClickedChanged:
    {
        thresholdGraphColor = "black"

        varYMin = 79
        varYMax = 80
    }

    //Videoselect-Stuff !!no reload!!
    property string videosource: ""
    property bool mutestate: true
    property bool playVideo: false
    function resetVid()
    {
        //sets the video back to 00:00 when new Training is clicked
        var resetVidSource = videosource
        videosource = ""
        videosource = resetVidSource
    }

    //sidepanel   !!no reload!!
    property int currentsideindex: 0

    //mainstack   !!no reload!!
    property bool databasestatus: false
    property bool settingsstatus: false
    property bool deviceListStatus: false
    property bool mainMenuStatus: true
    property bool barGraphStatus:false
    property bool playButtonsStatus: false
    property bool selectionButtonsStatus: false
    property bool infoPageStatus: false
    property bool agrementPageStatus: false

    //statusbar
    property string statetextleft: ""
    property string statetextright: qsTr("elapsed time")
    property string clientLabel: ""
    Timer
    {
        //Text in the statusbar left is displayed just for a specified time!
        id: statetexttimer;
        repeat: false
        onTriggered:
        {
            statetextleft = "";
        }
    }

    property var totalXVector
    property var totalYDataVector
    property var totalYThresholdVector
    property var totalStateVector

    //linegraph RELOAD!
    property bool clearLines: false
    property int tickcount: 10
    property int maxmillisec: trendselectInMS
    property int minmillisec: 0
    property int currentMS : 0
    property int totalMS: 0
    property string thresholdColor: "black"
    property real movingMin: 0.0
    property real movingMax: 0.0

    property int appendAtYData: 50
    property int appendAtYThreshold: 10

    property var datalineClicked: 0
    property int datalineIndex: 0
    onDatalineClickedChanged:
    {
        //set the Bargraph for the clicked point
        datalineIndex =  datalineClicked / 10

        appendAtYData = totalYDataVector[datalineIndex]
        appendAtYThreshold = totalYThresholdVector[datalineIndex]
        recalculateDataThresholdDiff(appendAtYData, appendAtYThreshold, totalStateVector[datalineIndex])
        thresholdGraphColor = "black"
    }

    property int sliderMovingMin
    property int sliderMovingMax
    onSliderMovingMinChanged:
    {
        if(sliderNeeded)
        {
            //draw linegraph-part new on every slider-movement
            sliderMovingMax = Math.round(sliderMovingMin + (trendselect * 100))
            getOffLineData(totalXVector, totalYDataVector, totalYThresholdVector, sliderMovingMin, sliderMovingMax)
        }
    }

    //claculate the playstate for the video and the color for the bargraph, depending on data- and thresholdvalue an the current concentrationstate
    function recalculateDataThresholdDiff(yDataValue,yTresholdValue, trainstate)
    {
        if (trainstate)
        {
            if ( yDataValue < yTresholdValue)
            {
                if(runtime)
                    playVideo = false;
                if ( yDataValue < yTresholdValue * 0.8)
                {
                    barGraphColor = "red";
                }
                else
                {
                    barGraphColor = "yellow";
                }
            }
            else
            {
                if(runtime)
                    playVideo = true;
                barGraphColor = "limegreen";
            }
        }
        else
        {

            if ( yDataValue> yTresholdValue)
            {
                if(runtime)
                    playVideo = false;
                if ( yDataValue > yTresholdValue * 1.2)
                {
                    barGraphColor = "red";
                }
                else
                {
                    barGraphColor = "yellow";
                }
            }
            else
            {
                if(runtime)
                    playVideo = true;
                barGraphColor = "limegreen";
            }
        }
    }

    property bool labelpos: true //still needed???

    property bool sliderNeeded: false
    property real sliderValue: 0.0

    //y-axis RELOAD!
    property int varYMin: 0
    property int varYMax: 200

    //bargraph RELOAD!
    property string barGraphColor: "transparent"
    property string thresholdGraphColor: "transparent"

    //adapts the axis on several events. X-Axis is just adapted at realtimeplotting, but not for offline-drawing.
    function adaptAxis()
    {
        /// adapt X-axis
        if(runtime)
        {
            if (currentMS >= trendselectInMS)
            {
                maxmillisec = currentMS
                movingMax = currentMS/1000
            }
            else
            {
                maxmillisec = trendselectInMS
                movingMax = trendselect
            }

            if (maxmillisec >= trendselectInMS)
            {
                minmillisec = maxmillisec - trendselectInMS
                movingMin = movingMax - trendselect
            }
            else
            {
                minmillisec = 0
                movingMin = 0.0
            }
        }

        /// adapt Y-axis

        if ((varYMax - 5) < appendAtYData)
        {
            varYMax = Math.ceil(appendAtYData + 5)
        }

        if ((varYMin + (varYMin * 0.1)) > appendAtYData)
        {
            varYMin = Math.ceil(appendAtYData - 5)
            if(varYMin < 0)
            {
                varYMin = 0
            }
        }
    }

    function layoutchange(barstate, linestate, vidstate)
    {
        //every layout has a specific ID, which must be calculated
        if (barstate && linestate && vidstate)
        {
            return 1;
        }
        else if (linestate && vidstate)
        {
            return 2;
        }
        else if (barstate && linestate)
        {
            return 3;
        }
        else if (barstate && vidstate)
        {
            return 4;
        }
        else if (barstate)
        {
            return 5;
        }
        else if (linestate)
        {
            return 6;
        }
        else if (vidstate)
        {
            return 7;
        }
        else
        {
            return 8;
        }
    }

    MessageDialog
    {
        id: loadButtonDialog
        title: qsTr("Discard unsaved changes?")
        text: ""
        visible: false
        standardButtons: StandardButton.Yes | StandardButton.No

        onYes: cppDatabaseHandler.loadButtonDecision(1);
        onNo: cppDatabaseHandler.loadButtonDecision(2);
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
