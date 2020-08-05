import QtQuick 2.0
import QtQuick.Controls 2.4

//UIMainButtonsPart includes the four Buttons in the upper right corner, which are always accessible

Item
{
    id: mainButtons
    height: 140


    Column
    {
        id: column
        height: 140
        spacing: 5

        Button
        {
            id: finishButton
            width: mainButtons.width
            height: 35
            text: qsTr("Back")
            visible: uicontroller.showBackToMenuButton

            onClicked:
            {
                cppDatabaseHandler.closeDatabase();

                cppController.setWebViewVisibility(false)

                uicontroller.settingsstatus = false
                uicontroller.deviceListStatus = false
                uicontroller.databasestatus = false


                uicontroller.barstate = true
                uicontroller.layoutid = uicontroller.layoutchange(uicontroller.barstate, uicontroller.linestate, uicontroller.vidstate)

                uicontroller.showSettingsButton = false

                uicontroller.mainMenuStatus = true

            }
        }

        Button
        {
            id: resultFinishButton
            width: mainButtons.width
            height: 35
            text: qsTr("Menu")
            visible: uicontroller.showResultFinishButton

            onClicked:
            {
                uicontroller.deletedLastResult = false
                uicontroller.addedResultToActiveClient = true

                uicontroller.showSettingsButton = false
                uicontroller.showBackToMenuButton = true
                uicontroller.showResultFinishButton = false
                uicontroller.showSelectionPart = false

                uicontroller.reload();

                cppController.setWebViewVisibility(false)

                uicontroller.barstate = true
                uicontroller.layoutid = uicontroller.layoutchange(uicontroller.barstate, uicontroller.linestate, uicontroller.vidstate)

                uicontroller.mainMenuStatus = true
            }
        }

        Button
        {
            id: resultSettingsBackButton
            width: mainButtons.width
            height: 35
            text: qsTr("Back")
            visible: uicontroller.showBackToResultsButton

            onClicked:
            {
                uicontroller.settingsstatus = false
                uicontroller.showSettingsButton = true
                uicontroller.showResultFinishButton = true
                uicontroller.showBackToResultsButton = false
                uicontroller.showSelectionPart = true
            }
        }

        Button
        {
            id: settigsButton
            width: mainButtons.width
            height: 35
            text: qsTr("Settings")
            visible: uicontroller.showSettingsButton

            onClicked:
            {
                uicontroller.settingsstatus = true
                uicontroller.showSettingsButton = false
                uicontroller.showResultFinishButton = false
                uicontroller.showBackToResultsButton = true
                uicontroller.showSelectionPart = false


            }
        }

        Row
        {
            width: mainButtons.width
            spacing: mainButtons.width * 0.0125
            visible: uicontroller.showSelectionPart

            Button
            {

                id: leftButton
                width: (mainButtons.width * 0.5) - (mainButtons.width * 0.0125)
                height: 40
                icon.name: "left"
                icon.source: "/icons/left.png"
                onClicked:
                {
                    if (uicontroller.currentsideindex == 0)
                    {
                        uicontroller.currentsideindex = 2
                    }
                    else
                    {
                        uicontroller.currentsideindex--
                    }
                }
            }

            Button
            {
                id: rightButton
                width: (mainButtons.width * 0.5) - (mainButtons.width * 0.0125)
                height: 40
                icon.name: "right"
                icon.source: "/icons/right.png"
                onClicked: {
                    if (uicontroller.currentsideindex == 2)
                    {
                        uicontroller.currentsideindex = 0
                    }
                    else
                    {
                        uicontroller.currentsideindex++
                    }
                }
            }
        }

    }


}




