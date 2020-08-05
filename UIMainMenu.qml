import QtQuick 2.0
import QtQuick.Controls 2.4

Item
{

    Component.onCompleted:
    {
        print("main menu loaded")
        updateButtonActivationStatus()

        cppDatabaseHandler.reactivateLastActiveClient()

        checkForTrainingActive()

        checkForResultActive()


    }

    Connections
    {
        target: uicontroller
        ignoreUnknownSignals: true
        onMainMenuStatusChanged:
        {
            if(uicontroller.mainMenuStatus)
            {
                print("to the main menu")
                checkForTrainingActive()
            }
            mainMenuURL1Text.text = cppController.getFavoriteAtPosition(0)
            mainMenuURL2Text.text = cppController.getFavoriteAtPosition(1)
        }

        onClientsActiveChanged:
        {
           uicontroller.deletedLastResult = false
           updateButtonActivationStatus()
        }

        onAddedResultToActiveClientChanged:
        {
            uicontroller.deletedLastResult = false
            checkForResultActive()
        }

        onAnalyseModeChanged:
        {
            checkForTrainingActive()
        }
    }


    function checkForTrainingActive()
    {
        var savedURL = cppController.getLastUsedURL()
        print("savedURL: " + savedURL)
        if( savedURL != "https://www.google.de/" && uicontroller.settingsActive && !uicontroller.analyseMode)
        {
            uicontroller.startTrainingActive = true
        }
        else
        {
            uicontroller.startTrainingActive = false
        }

        updateButtonActivationStatus()
    }

    function checkForResultActive()
    {
        var resultNumber = cppController.getNumberOfResultsOfActiveClient();
        if ( ( (resultNumber > 0 && uicontroller.clientsActive) || uicontroller.addedResultToActiveClient ) && uicontroller.settingsActive && !uicontroller.deletedLastResult )
        {
            uicontroller.resultActive = true
        }
        else
        {
            uicontroller.resultActive = false
        }

        updateButtonActivationStatus()
    }

    Connections
    {
        target: cppDatabaseHandler
        ignoreUnknownSignals: true
        onUpdateActiveClientStatus:
        {
            uicontroller.addedResultToActiveClient = false

            uicontroller.settingsActive = hasActiveClient
            uicontroller.selectFeedbackActive = hasActiveClient
            updateButtonActivationStatus()

            if(!hasActiveClient)
            {
                mainMenuClientNameText.color = "red"
                mainMenuClientNameText.text = qsTr("No client active")
            }
            else
            {
                cppDatabaseHandler.closeDatabase();
                uicontroller.databasestatus = false
                uicontroller.mainMenuStatus = true
            }

        }
        onActiveClientChanged:
        {
            uicontroller.addedResultToActiveClient = false

            mainMenuClientNameText.color = "black"
            mainMenuClientNameText.text = prename + " " + surname

            checkForTrainingActive()

            checkForResultActive()
        }

    }

    function updateButtonActivationStatus()
    {
        var visibiltyScale = 0.2

        settingsPageButton.opacity = visibiltyScale
        uIDifficultyButtonsPart.visible = false
        uITrainingStateButtonsPart.visible = false
        mainMenuClientNameText.visible = false

        feedbackPageButton.opacity = visibiltyScale
        trainingPageButton.opacity = visibiltyScale
        resultPageButton.opacity = visibiltyScale
        clientPageButton.opacity = visibiltyScale

        if(uicontroller.clientsActive)
        {
           clientPageButton.opacity = 1
           mainMenuClientNameText.visible = true
        }

        if(uicontroller.settingsActive)
        {
            settingsPageButton.opacity = 1
            uIDifficultyButtonsPart.visible = true
            uITrainingStateButtonsPart.visible = true
        }
        if(uicontroller.selectFeedbackActive)
        {
            feedbackPageButton.opacity = 1
        }
        if(uicontroller.startTrainingActive && uicontroller.isConnectedToDevice)
        {
            trainingPageButton.opacity = 1
        }
        if(uicontroller.resultActive)
        {
            resultPageButton.opacity = 1
        }
    }

    Rectangle
    {
        width: parent.width
        height: parent.height
        anchors.centerIn: parent

        id: mainmenurec
        radius: 10
        border.width: 1
        border.color: "lightgray"
        visible: uicontroller.mainMenuStatus


        Image
        {
            id: titleImage
            height: 50
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.right: infoPageButton.left
            anchors.rightMargin: 0
            anchors.left: parent.left
            anchors.leftMargin: 0
            fillMode: Image.PreserveAspectFit
            source: "/icons/HEG-APP-Schriftzug.png"
        }


        Image
        {
            id: clientPageButton
            anchors.top : titleImage.bottom
            anchors.left: parent.left
            width: parent.width * 0.40
            height: width * 0.25
            anchors.topMargin: 0
            anchors.leftMargin: parent.width * 0.01
            source: "/icons/Users.jpg"

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    uicontroller.databasestatus = true;
                    cppDatabaseHandler.showDatabase(false);

                    uicontroller.playButtonsStatus = false

                    uicontroller.mainMenuStatus = false
                    uicontroller.showResult = false
                }
            }

            Text
            {
                text: qsTr("select User")
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top : parent.top
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: parent.width * 0.22
                anchors.rightMargin: parent.width * 0.1
                font.pointSize: 20
                font.bold: true
            }

        }


        Image
        {
            id: settingsPageButton
            anchors.top : clientPageButton.bottom
            anchors.left: parent.left
            width: parent.width * 0.40
            height: width * 0.25
            anchors.topMargin: 5
            anchors.leftMargin: parent.width * 0.01
            source: "/icons/Settings.jpg"

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    if(uicontroller.settingsActive)
                    {
                        uicontroller.settingsstatus = true

                        uicontroller.playButtonsStatus = false

                        uicontroller.mainMenuStatus = false
                    }
                }
            }

            Text
            {
                text: qsTr("Settings")
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top : parent.top
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: parent.width * 0.22
                anchors.rightMargin: parent.width * 0.1
                font.pointSize: 20
                font.bold: true
            }

        }


        Image
        {
            id: feedbackPageButton
            anchors.top : settingsPageButton.bottom
            anchors.left: parent.left
            width: parent.width * 0.40
            height: width * 0.25
            anchors.topMargin: 5
            anchors.leftMargin: parent.width * 0.01
            source: "/icons/Feedback.jpg"

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    if(uicontroller.selectFeedbackActive)
                    {
                        cppController.setWebViewVisibility(true)

                        uicontroller.playButtonsStatus = false

                        uicontroller.mainMenuStatus = false

                        cppController.clearFavoriteListView();
                        cppController.loadFavoriteList();

                        uicontroller.barstate = false

                        //favoritelistView

                    }
                }
            }

            Text
            {
                text: qsTr("select Feedback")
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top : parent.top
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: parent.width * 0.22
                anchors.rightMargin: parent.width * 0.1
                font.pointSize: 20
                font.bold: true
            }

        }



        UIDifficultyButtonsPart
        {
            id: uIDifficultyButtonsPart
            height: 32
            anchors.verticalCenterOffset: -16
            anchors.verticalCenter: settingsPageButton.verticalCenter
            anchors.left: settingsPageButton.right
        }

        UITrainingStateButtonsPart
        {
            id: uITrainingStateButtonsPart
            height: 32
            anchors.left: settingsPageButton.right
            anchors.top: uIDifficultyButtonsPart.bottom
            anchors.topMargin: 0
        }

        Image
        {
            id: trainingPageButton
            anchors.top : feedbackPageButton.bottom
            anchors.left: parent.left
            width: parent.width * 0.40
            height: width * 0.25
            anchors.topMargin: 5
            anchors.leftMargin: parent.width * 0.01
            source: "/icons/Start_Menu.jpg"

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    if(uicontroller.startTrainingActive && uicontroller.isConnectedToDevice)
                    {
                        cppController.setWebViewVisibility(true)

                        uicontroller.playButtonsStatus = true

                        uicontroller.mainMenuStatus = false

                        uicontroller.showBackToMenuButton = false
                        uicontroller.showSelectionPart = true

                    }
                }
            }

            Text
            {
                text: qsTr("start Training")
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top : parent.top
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: parent.width * 0.22
                anchors.rightMargin: parent.width * 0.1
                font.pointSize: 20
                font.bold: true
            }

        }


        Image
        {
            id: resultPageButton
            anchors.top : trainingPageButton.bottom
            anchors.left: parent.left
            width: parent.width * 0.40
            height: width * 0.25
            anchors.topMargin: 5
            anchors.leftMargin: parent.width * 0.01
            source: "/icons/Result.jpg"

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    if(uicontroller.resultActive)
                    {
                        uicontroller.databasestatus = true;
                        cppDatabaseHandler.showDatabase(false);

                        uicontroller.playButtonsStatus = false

                        uicontroller.mainMenuStatus = false

                        uicontroller.showResult = true
                    }
                }
            }

            Text
            {
                text: qsTr("Result")
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.top : parent.top
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                anchors.leftMargin: parent.width * 0.22
                anchors.rightMargin: parent.width * 0.1
                font.pointSize: 20
                font.bold: true
            }

        }

        Image
        {
            id: infoPageButton
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.topMargin: 10
            width: 50
            height: 50
            source: "/icons/Info-Button.png"

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    uicontroller.infoPageStatus = true
                }
            }


        }

        Text
        {
            id: mainMenuClientNameText
            y: 90
            height: 30
            color: "#e21d1d"
            text: qsTr("No Client Active")
            font.bold: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            anchors.verticalCenter: clientPageButton.verticalCenter
            anchors.left: clientPageButton.right
            anchors.leftMargin: 10
        }


        Rectangle
        {
            id: devicelistMenuButtonBox
            x: 582
            y: 422
            width: 50
            height: 50
            color: "#ffffff"
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10

            Image
            {
                id: deviceLisatMenuButtonImage
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source: "/icons/Connection.png"

                MouseArea
                {
                    anchors.fill: parent
                    onClicked:
                    {
                        uicontroller.deviceListStatus = true
                        uicontroller.mainMenuStatus = false
                    }
                }
            }
        }

        Rectangle
           {
               id:mainmenuURLs
               anchors.left: feedbackPageButton.right
               anchors.top: feedbackPageButton.top
               anchors.leftMargin: 10
               height: feedbackPageButton.height


               Text
               {
                   id: mainMenuURL1Text
                   text: qsTr(cppController.getFavoriteAtPosition(0))
                   font.bold: true
                   anchors.top: parent.top
                   anchors.topMargin: parent.height * 0.2


                   MouseArea
                   {
                       anchors.fill: parent
                       onClicked:
                       {
                           uicontroller.webViewURL = mainMenuURL1Text.text
                           mainMenuURL1Text.color = "blue"
                       }
                   }



               }

               Text
               {
                   id: mainMenuURL2Text
                   text: qsTr(cppController.getFavoriteAtPosition(1))
                   font.bold: true
                   anchors.top: mainMenuURL1Text.bottom
                   anchors.topMargin: parent.height * 0.2

                   MouseArea
                   {
                       anchors.fill: parent
                       onClicked:
                       {
                           uicontroller.webViewURL = mainMenuURL2Text.text
                            mainMenuURL2Text.color = "blue"
                       }
                   }

               }
           }

    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
