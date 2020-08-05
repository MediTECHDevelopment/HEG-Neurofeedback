import QtQuick 2.0
import QtMultimedia 5.9

//UIVideoPart provides the Video, which could be shown during the measurement

Rectangle
{
    border.color: "grey"
    border.width: 1

    Video
    {
        id: video
        anchors.fill: parent
        visible: true
        source: uicontroller.videosource
        focus: true
        autoPlay: false
        muted: uicontroller.mutestate

        onPlaying: pathtext.color = "transparent"

        Connections{
            target: uicontroller
            onPlayVideoChanged:
            {
/*
                if (uicontroller.playstate && uicontroller.playVideo)
                {
                    print("zuul video play")
                    video.play();
                    video.visible = true;
                }
                else
                {
                    print("zuul video stop")
                    video.pause();
                }*/
            }
            onVideosourceChanged:
            {
                //pathtext.color = "black"
                //pathtext.text = getVidText()
            }
        }
    }

    function getVidText()
    {
        var text = qsTr("no Videofile selected")
        if(uicontroller.videosource !== 0)
        {
            vidPath = uicontroller.videosource
            splittedtVidPath = vidPath.split("///")
            text = qsTr("Selected Videofile: \n") + splittedtVidPath[splittedtVidPath.length - 1]
            print("video: " + text)
        }

        return text
    }

    property string vidPath
    property var splittedtVidPath
    Text {
        id: pathtext
        anchors.centerIn: parent
        color: "black"

        Component.onCompleted: {
            pathtext.text = getVidText()
        }
    }
}

//Konrads Sachen

//MouseArea {
//    anchors.fill: parent
////        onClicked: {
////            video.play()
////        }
//}

//Connections{
//    target: myclassData

//    onQmlplay: {
//        if(video.playbackState != 1)
//        {video.play()}
//    }
//    onQmlpause: {
//        if(video.playbackState != 2)
//        {video.pause()}
//    }
//    onQmlstop:{
//        if(video.playbackState != 0)
//        {video.stop()}
//    }

//}

//focus: true
////     Keys.onSpacePressed: video.playbackState == MediaPlayer.PlayingState ? video.pause() : video.play()
////     Keys.onLeftPressed: video.seek(video.position - 5000)
////     Keys.onRightPressed: video.seek(video.position + 5000)
//}
