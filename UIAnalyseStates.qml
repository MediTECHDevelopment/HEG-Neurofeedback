import QtQuick 2.0
import QtQuick.Controls 2.4

//UIAnalyseStates implements the 8 possible layout-configurations, the state is taken over from UITrainingStates
Item {
    id: analysestates
    state: uicontroller.laststate

    Connections
    {
        target: uicontroller
        ignoreUnknownSignals: true
        onLayoutidChanged:
        {
            evaluateanalyselayout(uicontroller.layoutid)
        }
    }

    function evaluateanalyselayout (replaceid)
    {
        //every constellation has it's own id, which is used for UITrainingStates and UIAnalyseStates!
        switch (replaceid)
        {
        case 1:
            uicontroller.laststate = "viewall"
            break
        case 2:
            uicontroller.laststate = "viewlinevid"
            break
        case 3:
            uicontroller.laststate = "viewbarline"
            break
        case 4:
            uicontroller.laststate = "viewbarvid"
            break
        case 5:
            uicontroller.laststate = "viewbar"
            break
        case 6:
            uicontroller.laststate = "viewline"
            break
        case 7:
            uicontroller.laststate = "viewvid"
            break
        case 8:
            break
        }
    }

    // In den States die Anchor nicht ändern, sonst müssen die in allen anderen States auf die richtigen Werte zurückgesetzt werden!!
    UIBarGraphPart
    {
        id: analysebar
        visible: uicontroller.barstate
        anchors.left: analysestates.left
        anchors.top: analysestates.top
    }

    UIAnalyseTablePart
    {
        id: analysevid
        scale: 1
        visible: uicontroller.vidstate
        anchors.top: analysestates.top
        anchors.right: analysestates.right
    }

    UILineGraphPart
    {
        id: analyseline
        visible: uicontroller.linestate
        anchors.left: analysestates.left
        anchors.bottom: analysestates.bottom
    }

    states: [

        State {
            name: "viewall"
            PropertyChanges {target: analysebar; width: analysestates.width * 0.15; height: analysestates.height * 0.66}
            PropertyChanges {target: analysevid; width:analysestates.width * 0.84; height: analysestates.height * 0.66}
            PropertyChanges {target: analyseline; width: analysestates.width; height: analysestates.height * 0.33}
        },
        State {
            name: "viewbar"
            PropertyChanges {target: analysebar; width: analysestates.width * 0.15; height: analysestates.height * 0.66}
        },
        State {
            name: "viewbarline"
            PropertyChanges {target: analysebar; width: analysestates.width * 0.15; height: analysestates.height * 0.66}
            PropertyChanges {target: analyseline; width: analysestates.width; height: analysestates.height * 0.33}
        },
        State {
            name: "viewbarvid"
            PropertyChanges {target: analysebar; width: analysestates.width * 0.15; height: analysestates.height * 0.99}
            PropertyChanges {target: analysevid; width: analysestates.width * 0.84; height: analysestates.height * 0.99}
        },
        State {
            name: "viewline"
            PropertyChanges {target: analyseline; width: analysestates.width; height: analysestates.height * 0.33}
        },
        State {
            name: "viewlinevid"
            PropertyChanges {target: analysevid; width: analysestates.width; height: analysestates.height * 0.66}
            PropertyChanges {target: analyseline; width: analysestates.width; height: analysestates.height * 0.33}
        },
        State {
            name: "viewvid"
            PropertyChanges {target: analysevid; width: analysestates.width; height: analysestates.height * 0.99}
        }
    ]
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
