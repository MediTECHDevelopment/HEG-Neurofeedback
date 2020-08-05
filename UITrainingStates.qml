import QtQuick 2.0
import QtQuick.Controls 2.4

import QtWebView 1.1

//UITrainingStates equivalent to UIAnalyseStates

Item
{
    id: trainingstates
    state: uicontroller.laststate

    Connections
    {
        target: uicontroller
        ignoreUnknownSignals: true
        onLayoutidChanged:
        {
            evaluatetraininglayout(uicontroller.layoutid)
        }
        onWebViewURLChanged:
        {
            feedbackWebView.url = uicontroller.webViewURL
        }
    }

    Connections
    {
        target: cppController
        ignoreUnknownSignals:  true
        onWebViewVisibilityChanged:
        {
            setWebviewVisible(visible)
        }
        onWebViewMenuVisibilityChanged:
        {
            uicontroller.webViewControllsMenuOpen = visible
            webviewControlls.visible = visible
        }
    }

    function evaluatetraininglayout (replaceid)
    {
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
        id: trainingbar
        width: trainingstates.width * 0.15
        height: trainingstates.height * 0.66
        visible: uicontroller.barstate
        border.color: "#d3d3d3"
        anchors.left: trainingstates.left
        anchors.top: trainingstates.top
    }


    function setWebviewVisible(visible)
    {
        if(visible === true)
        {
            feedbackWebView.width = trainingvid.width - 2
            feedbackWebView.height = trainingvid.height - 2
        }
        else
        {
            feedbackWebView.width = 1
            feedbackWebView.height = 1
        }
    }

    function openWebviewControllsMenu(open)
    {
        uicontroller.webViewControllsMenuOpen = open
        webviewControlls.visible = open
        setWebviewVisible(!open)
    }

    function checkForHttpHttps(currentURL)
    {
        if( !cppController.isNormalHttp(currentURL) )
        {
            print("curl: " + currentURL)
            var newURL = cppController.filterWebContentURL(currentURL)
            print("nurl: " + newURL)

            if(newURL != "")
            {
                feedbackWebView.url = newURL
            }
        }
    }



    Rectangle
    {
        id: trainingvid
        width: trainingstates.width * 0.84
        height: trainingstates.height * 0.66
        border.color: "#d3d3d3"
        border.width: 1
        visible: uicontroller.vidstate
        anchors.top: trainingstates.top
        anchors.right: trainingstates.right

        WebView
        {

            id: feedbackWebView
            //anchors.fill: parent
            visible: true
            url: uicontroller.webViewURL
            width:  uicontroller.webViewWidth//trainingvid.width - 2
            height: uicontroller.webViewHeight//trainingvid.height - 2
            anchors.top: trainingvid.top
            anchors.right: trainingvid.right
            anchors.rightMargin: 1
            anchors.topMargin: 1

            Connections
            {
                target: feedbackWebView
                ignoreUnknownSignals: true

                onLoadingChanged:
                {
                    var currentURL = loadRequest.url
                    if (loadRequest.status === WebView.LoadStartedStatus)
                    {
                        print("Load start: " + loadRequest.url)
                    }
                    else if (loadRequest.status === WebView.LoadSucceededStatus)
                    {
                        print("Load succeeded: " + loadRequest.url)

                        if(!uicontroller.mainMenuStatus)
                        {
                            print("saved url")
                            cppController.setLastUsedURL( feedbackWebView.url )
                        }
                        urlTextField.text = feedbackWebView.url

                        checkForHttpHttps(currentURL)
                    }
                    else if (loadRequest.status === WebView.LoadFailedStatus)
                    {
                        print("Load failed: " + loadRequest.url + ". Error code: " + loadRequest.errorString)

                        checkForHttpHttps(currentURL)
                    }
                }
            }

            Connections
            {
                target: uicontroller
                ignoreUnknownSignals: true
                onPlayVideoChanged:
                {
                    uicontroller.runtime
                    if ( uicontroller.playVideo )
                    {
                        uicontroller.webViewWidth = trainingvid.width - 2
                        uicontroller.webViewHeight = trainingvid.height - 2

                        //print("zuul video play")
                        setWebviewVisible(true)
                    }
                    else
                    {
                        //print("zuul video stop")
                        setWebviewVisible(false)
                    }
                }
            }
        }

        Rectangle
        {
            id: webviewControlls
            color: "#ffffff"
            visible: false
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0

            Rectangle
            {
                id: urlRectangle
                height: 50
                color: "#ffffff"
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.top: parent.top
                anchors.topMargin: 5
                border.color: "#d3d3d3"
                border.width: 1

                TextField
                {
                    id: urlTextField
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 5
                    anchors.right: urlButton.left
                    anchors.rightMargin: 5
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    clip: true
                    placeholderText: qsTr("https://www.youtube.de")
                }

                Button
                {
                    id: urlButton
                    x: 243
                    width: 50
                    text: qsTr("Go")
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 5
                    anchors.top: parent.top
                    anchors.topMargin: 5
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    onClicked:
                    {
                        var urlString = cppController.getURLFromInput(urlTextField.text)
                        openURL(urlString)
                    }
                }
            }

            Grid
            {
                id: urlButtonGrid
                spacing: 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.top: urlRectangle.bottom
                anchors.topMargin: 5

                Button
                {
                    id: youtubeButton
                    text: qsTr("YouTube")
                    onClicked:
                    {
                        openURL("https://www.youtube.de")
                    }
                }

                Button
                {
                    id: netflixButton
                    text: qsTr("Netflix")
                    onClicked:
                    {
                        openURL("https://www.netflix.com")
                    }
                }

                Button
                {
                    id: googleButton
                    text: qsTr("Google")
                    onClicked:
                    {
                        openURL("https://www.google.de")
                    }
                }
            }
        }

        /*
        UIVideoPart
        {
            id: trainingvidPlayer
            visible: uicontroller.vidstate
            anchors.fill: parent
        }*/
    }

    function openURL(url)
    {
        uicontroller.webViewURL = url
        openWebviewControllsMenu(false)
    }


    UILineGraphPart
    {
        id: trainingline
        width: trainingstates.width
        height: trainingstates.height * 0.33
        border.color: "#d3d3d3"
        visible: uicontroller.playButtonsStatus
        anchors.left: trainingstates.left
        anchors.bottom: trainingstates.bottom
    }


    UIVideoControllersPart
    {
        id: webviewcontroller
        width: trainingstates.width
        visible: !uicontroller.playButtonsStatus
        height: trainingstates.height * 0.33
        anchors.left: trainingstates.left
        anchors.bottom: trainingstates.bottom
    }



    states: [

        State {
            name: "viewall"
            PropertyChanges {target: trainingbar; width: trainingstates.width * 0.15; height: trainingstates.height * 0.66}
            PropertyChanges {target: trainingvid; width: trainingstates.width * 0.84; height: trainingstates.height * 0.66}
            PropertyChanges {target: trainingline; width: trainingstates.width; height: trainingstates.height * 0.33}
            PropertyChanges {target: webviewcontroller; width: trainingstates.width; height: trainingstates.height * 0.33}
        },
        State {
            name: "viewbar"
            PropertyChanges {target: trainingbar; width: trainingstates.width * 0.15; height: trainingstates.height * 0.66}
        },
        State {
            name: "viewbarline"
            PropertyChanges {target: trainingbar; width: trainingstates.width * 0.15; height: trainingstates.height * 0.66}
            PropertyChanges {target: trainingline; width: trainingstates.width; height: trainingstates.height * 0.33}
        },
        State {
            name: "viewbarvid"
            PropertyChanges {target: trainingbar; width: trainingstates.width * 0.15; height: trainingstates.height * 0.99}
            PropertyChanges {target: trainingvid; width: trainingstates.width * 0.84; height: trainingstates.height * 0.99}
        },
        State {
            name: "viewline"
            PropertyChanges {target: trainingline; width: trainingstates.width; height: trainingstates.height * 0.33}
             PropertyChanges {target: webviewcontroller; width: trainingstates.width; height: trainingstates.height * 0.33}
        },
        State {
            name: "viewlinevid"
            PropertyChanges {target: trainingvid; width: trainingstates.width; height: trainingstates.height * 0.66}
            PropertyChanges {target: trainingline; width: trainingstates.width; height: trainingstates.height * 0.33}
            PropertyChanges {target: webviewcontroller; width: trainingstates.width; height: trainingstates.height * 0.33}
        },
        State {
            name: "viewvid"
            PropertyChanges {target: trainingvid; width: trainingstates.width; height: trainingstates.height * 0.99}
        }

    ]
}




/*

qml: Load start: intent://www.netflix.com/title/80201866#Intent;scheme=https;package=com.netflix.mediaclient;S.browser_fallback_url=https%3A//www.netflix.com/title/80201866%3FpreventIntent%3Dtrue;end
D HEG 2   : qml: Load failed: intent://www.netflix.com/title/80201866#Intent;scheme=https;package=com.netflix.mediaclient;S.browser_fallback_url=https%3A//www.netflix.com/title/80201866%3FpreventIntent%3Dtrue;end. Error code: net::ERR_UNKNOWN_URL_SCHEME
I HEG 2   : isNormal?
I HEG 2   : intent://www.netflix.com/title/80201866#Intent;scheme=https;package=com.netflix.mediaclient;S.browser_fallback_url=https-122420901378419657747156560567869210083283265785034271659719903659156885764961851847460519936.000000//www.netflix.com/title/802018660.000000preventIntent%3Dtrue;end
I HEG 2   : intent
I HEG 2   : intent://www.netflix.com/title/80201866#Intent;scheme=https;package=com.netflix.mediaclient;S.browser_fallback_url=https-122420901378419657747156560567869210083283265785034271659719903659156885764961851847460519936.000000//www.netflix.com/title/80201866-4794930677994601067395437678690278008257126665778024714184005164629005270312224335907812994757149714960217500670585420352801751600766008641266573170173276424547119582284400384672272750739456.000000preventIntent%3Dtrue;end
I HEG 2   : stringpart
I HEG 2   : intent://www.netflix.com/title/80201866#Intent
I HEG 2   : stringpart
I HEG 2   : scheme=https
I HEG 2   : stringpart
I HEG 2   : package=com.netflix.mediaclient
I HEG 2   : stringpart
I HEG 2   : S.browser_fallback_url=https-122420901378419657747156560567869210083283265785034271659719903659156885764961851847460519936.000000//www.netflix.com/title/80201866-4794926838576302854272469486125116540584830728650964427933011880183956452622927399048615311377161311575781662530034210788877220328959144609901011444277064644785644892067267589432430966079488.000000preventIntent%3Dtrue
I HEG 2   : fallback
I HEG 2   : intent://www.netflix.com/title/80201866#Intent;scheme=https;package=com.netflix.mediaclient;S.browser_fallback_url=https-122420901378419657747156560567869210083283265785034271659719903659156885764961851847460519936.000000//www.netflix.com/title/80201866-4794926838576302854272469486125116540584830728650964427933011880183956452622927399048615311377161311575781662530034210788877220328959144609901011444277064644785644892067267589432430966079488.000000preventIntent%3Dtrue;end
D HEG 2   : qml: Load start: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : qml: Load succeeded: intent://www.netflix.com/title/80201866#Intent;scheme=https;package=com.netflix.mediaclient;S.browser_fallback_url=https%3A//www.netflix.com/title/80201866%3FpreventIntent%3Dtrue;end
W qtMainLoopThrea: type=1400 audit(0.0:71188): avc: denied { read } for name="boot_id" dev="proc" ino=4518188 scontext=u:r:untrusted_app:s0:c512,c768 tcontext=u:object_r:proc:s0 tclass=file permissive=0
D HEG 2   : qml: Load succeeded: intent://www.netflix.com/title/80201866#Intent;scheme=https;package=com.netflix.mediaclient;S.browser_fallback_url=https%3A//www.netflix.com/title/80201866%3FpreventIntent%3Dtrue;end
D HEG 2   : qml: Load start: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : qml: Load failed: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true. Error code: net::ERR_UNKNOWN_URL_SCHEME
I HEG 2   : isNormal?
I HEG 2   : qrc:/https://www.netflix.com/title/80201866-122420901378419657747156560567869210083283265785034271659719903659156885764961851847460519936.000000preventIntent=true
D HEG 2   : qml: Load start: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : qml: Load succeeded: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : qml: Load succeeded: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : qml: Load start: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : qml: Load failed: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true. Error code: net::ERR_UNKNOWN_URL_SCHEME
I HEG 2   : isNormal?
I HEG 2   : qrc:/https://www.netflix.com/title/80201866-122420901378419657747156560567869210083283265785034271659719903659156885764961851847460519936.000000preventIntent=true
D HEG 2   : qml: Load start: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : Found new device: "" ( "2B:F5:8F:A8:B5:9F" )
D HEG 2   : qml: Load start: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : qml: Load failed: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true. Error code: net::ERR_UNKNOWN_URL_SCHEME
I HEG 2   : isNormal?
I HEG 2   : qrc:/https://www.netflix.com/title/80201866-122420901378419657747156560567869210083283265785034271659719903659156885764961851847460519936.000000preventIntent=true
D HEG 2   : qml: Load start: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : qml: Load succeeded: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : qml: Load succeeded: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : qml: Load start: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : qml: Load failed: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true. Error code: net::ERR_UNKNOWN_URL_SCHEME
I HEG 2   : isNormal?
I HEG 2   : qrc:/https://www.netflix.com/title/80201866-122420901378419657747156560567869210083283265785034271659719903659156885764961851847460519936.000000preventIntent=true
D HEG 2   : qml: Load start: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : qml: Load succeeded: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : qml: Load start: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : qml: Load failed: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true. Error code: net::ERR_UNKNOWN_URL_SCHEME
I HEG 2   : isNormal?
I HEG 2   : qrc:/https://www.netflix.com/title/80201866-122420901378419657747156560567869210083283265785034271659719903659156885764961851847460519936.000000preventIntent=true
D HEG 2   : qml: Load start: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : qml: Load start: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : qml: Load failed: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true. Error code: net::ERR_UNKNOWN_URL_SCHEME
I HEG 2   : isNormal?
I HEG 2   : qrc:/https://www.netflix.com/title/80201866-122420901378419657747156560567869210083283265785034271659719903659156885764961851847460519936.000000preventIntent=true
D HEG 2   : qml: Load start: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : Found new device: "" ( "0B:6B:47:62:73:3C" )
D HEG 2   : qml: Load start: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : qml: Load failed: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true. Error code: net::ERR_UNKNOWN_URL_SCHEME
I HEG 2   : isNormal?
I HEG 2   : qrc:/https://www.netflix.com/title/80201866-122420901378419657747156560567869210083283265785034271659719903659156885764961851847460519936.000000preventIntent=true
D HEG 2   : qml: Load start: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : qml: Load succeeded: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true
D HEG 2   : qml: Load succeeded: qrc:/https://www.netflix.com/title/80201866%3FpreventIntent=true

  */

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
