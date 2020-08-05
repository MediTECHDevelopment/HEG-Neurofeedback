import QtQuick 2.0
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.3

Item {

    function clearFavoritesList()
    {
      for (var index= 0 ; index <favoritelistView.count ; index++ )
      {
          urlmodel.remove(index);
      }
    }

    Rectangle
    {
        Connections
        {
            target: cppController
            ignoreUnknownSignals: true
            onShowFavorites:
            {

                urlmodel.append({"urlString" : url})
            }

            onClearFavoritesList:
            {
                clearFavoritesList();
                console.log("removing Favorites in QML....................... ")
            }
        }

        id: webviewControlls
        color: "#ffffff"
        visible: true
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
            visible: true
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
                visible: true
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.right: parent.right
                anchors.rightMargin: 5
                onClicked:
                {
                    var urlString = cppController.getURLFromInput(urlTextField.text)
                    uicontroller.webViewURL = urlString
                }
            }

            Button
            {
                id: favotiteButton
                visible: true
                width: 50
                icon.name: "Favorite"
                icon.source: "/icons/Star.png"
                icon.height: height * 0.7
                icon.width: width * 0.7
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.right: urlButton.left
                anchors.rightMargin: 5

                onClicked:
                {
                     console.log("count =  " + favoritelistView.count)
                     cppController.setFavoriteURL( cppController.getLastUsedURL() , favoritelistView.count)
                     urlmodel.append({ "urlString":  uicontroller.webViewURL})

                }
            }
        }



        Grid
        {
            id: urlButtonGrid
            visible: true
            spacing: 5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
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
                    uicontroller.webViewURL = "https://www.youtube.de"
                    urlTextField.text = "https://www.youtube.de"
                }
            }


            Button
            {
                id: googleButton
                text: qsTr("Google")
                visible: true
                onClicked:
                {
                    uicontroller.webViewURL = "https://www.google.de"
                    urlTextField.text = "https://www.google.de"
                }
            }


        }


          ListView
          {
              id: favoritelistView
              anchors.right: parent.right
              anchors.top: urlRectangle.bottom
              anchors.bottom: parent.bottom
              anchors.topMargin: 5
              anchors.bottomMargin: 5
              width: parent.width * 0.3
              model: urlmodel


              delegate: SwipeDelegate
              {
                  id: swipeDelegate
                  width: parent.width
                  height: 40

                  swipe.right: Label
                  {
                     id: deleteLabel
                     text: qsTr("Delete")
                     color: "white"
                     verticalAlignment: Label.AlignVCenter
                     padding: 12
                     height: parent.height
                     anchors.right: parent.right

                     MouseArea
                     {
                         anchors.fill: parent

                         onClicked:
                         {
                              console.log("index =  " +index)
                              cppController.removeFavoriteAtPosition(index);
                              urlmodel.remove(index);
                         }
                     }

                     background: Rectangle
                     {
                         color: deleteLabel.SwipeDelegate.pressed ? Qt.darker("tomato", 1.1) : "tomato"
                     }
                 }

                  Rectangle
                  {
                       width: parent.width

                      Text
                      {
                          width: parent.width * 0.80
                          anchors.left: parent.left
                          height: 45
                          verticalAlignment: Text.AlignVCenter
                          text: urlString

                          MouseArea
                          {
                              anchors.fill: parent

                              onClicked:
                              {
                                    console.log("open URL from Favorites List  " + cppController.getFavoriteAtPosition(index))
                                   uicontroller.webViewURL = cppController.getFavoriteAtPosition(index)

                              }
                          }
                      }

                  }


              }

              ListModel
              {
                  id: urlmodel

              }

          }



    }


}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
