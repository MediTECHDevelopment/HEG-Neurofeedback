#include "controller.h"
#include <QDebug>
#include <QStandardPaths>

#include <QSettings>
#include <QUrl>



Controller::Controller()
{
    firstSettings();
    savepath = QStandardPaths::writableLocation( QStandardPaths::AppLocalDataLocation )+"/HEGData/";
    //savepath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation)+"/HEGData/";



}

Controller::~Controller()
{
}

/**
 * @brief Controller::firstSettings is describing the global Values at the start
 */
void Controller::firstSettings()
{
    samplesPerSecond = 30;  // 30; höhere samplerate führt zu performance problemen im chart;
    hertzMultiplicator = (1000/samplesPerSecond);
    //Determined from user input in Settings
    threshold = 100;

    difficulty = 1;
    adapPercentage = 5;

    //Settings Check Box
    adaptiveThresholdIsActive   = true;

    //Determined from the Users Current Choices in the MainWindow
    //Save States
    measurementisSaved          = true;
    notesAreSaved               = true;
    //Measurement State
    isConcentration             = true;
    //Layout States
    pausedMeasurement           = false;
    measurementIsActive         = false;
    realtimePlotting            = true;

    _mcalcDiffID = -2;
}

void Controller::resetAll()
{
    firstSettings();
}

//--------------------------------------------------------------------------------------//
//METADATA VIDEOPATH sets the VideoPath to save it later and emits it that the _videoPlayer can set the VideoPath as new Media
void Controller::setVideoPath(QString newVideoPath)
{
    videoPath = newVideoPath;
    emit setNewVidFile(videoPath);
}

void Controller::setCalcDiffID(int ButtonID)
{
    _mcalcDiffID = ButtonID;
}

int Controller::getCalcDiffID()
{
    return _mcalcDiffID;
}
void Controller::setNotes(QString notes)
{
    _mNotes = notes;
    notesAreSaved = false;
}

QString Controller::getNotes()
{
    return _mNotes;
}
//------------------------------------------------------------------------------------------//
//THRESHOLD
void Controller::setThresholdValue(double newThresholdValue)
{
    threshold = newThresholdValue;
    emit setNewThreshold(threshold);
}
double Controller::getThreshold() const
{
    return threshold;
}

void Controller::changeAdaptiveThresh(bool threshStatus)
{
    adaptiveThresholdIsActive = threshStatus;
}

//Important for the Drawing of the BarGraph. It controls the colors.
bool Controller::getConcentrationState() const
{
    return isConcentration;
}
/**
 * @brief Controller::setConcentrationState can be replaced with an algorithm who finds these CHanges in the raw data
 * @param vConcentration
*/
void Controller::setConcentrationState(bool vConcentration)
{
    if(isConcentration!=vConcentration)
    {
        //emits the OLD State
        emit concentrationChange(isConcentration);
        isConcentration = vConcentration;
        //setDifficulty if the difficulty should just change once a state is changed
    }
}
/**
 * @brief Controller::setDifficulty is emittet when the user changed the difficulty, new is that it should just change if the state changes
 * @param Difficulty
 */
void Controller::setDifficulty(int Difficulty)
{
    difficulty = quint8(Difficulty);

    if(difficulty == 1)
    {   //very easy
        adapPercentage = 5;
    }
    else if(difficulty == 2)
    {
        adapPercentage = 4;
    }
    else if(difficulty == 3)
    {
        adapPercentage = 3;
    }
    else if(difficulty == 4)
    {
        adapPercentage = 2;
    }
    else if(difficulty == 5)
    {   //very hard
        adapPercentage = 1;
    }
}
quint8 Controller::getDifficulty()
{
    return difficulty;
}

/**
 * @brief Controller::difficultyToAdapThreshold is used for the dataanalysis
 * @param Difficulty
 * @return
 */
int Controller::difficultyToAdapThreshold(int Difficulty)
{
    if(Difficulty == 1)
    {
        return 5;
    }
    else if(Difficulty == 2)
    {
        return 4;
    }
    else if(Difficulty == 3)
    {
        return 3;
    }
    else if(Difficulty == 4)
    {
        return 2;
    }
    else if(Difficulty == 5)
    {
        return 1;
    }
    //should not be reached...
    return 0;
}

/**
 * @brief Controller::showMessageInQml emits a signal to QML to show a Messagebox with the given title and message
 * @param messageTitle, message
 */
void Controller::showMessageInQml(QString messageTitle, QString message)
{
    emit displayMessages(messageTitle, message);
}

/**
 * @brief Controller::showMessageInStatusBarLeft emits a signal to show the given message für messageDuration milliseconds long at the statusbar-left-text
 * @param statusmessage, messageDuration
 */
void Controller::showMessageInStatusBarLeft(QString statusMessage, int messageDuration)
{
    emit displayStatustextLeft(statusMessage, messageDuration);
}

/**
 * @brief Controller::showMessageInStatusBarRight emits a signal to show the given message in the statusbar-right-text. the text is shown until it is changed
 * @param messageTitle, message
 */
void Controller::showMessageInStatusBarRight(QString statusMessage)
{
    emit displayStatustextRight(statusMessage);
}

/**
 * @brief Controller::showMessageInQml emits a signal to QML to prepend the Clientlabel to the statusbar-right-text, when a client is activated
 * @param messageTitle, message
 */
void Controller::showMessageInStatusBarClientLabel(QString statusMessage)
{
    emit displayStatustextClientLabel(statusMessage);
}

void Controller::setWebViewVisibility(bool visible)
{
    emit webViewVisibilityChanged(visible);
}

void Controller::setWebViewMenueOpen(bool open)
{
    emit webViewVisibilityChanged(!open);
    emit webViewMenuVisibilityChanged(open);
}

void Controller::setURLButtonEnabled(bool enabled)
{
    emit urlButtonEnabled(enabled);
}

QString Controller::getLastUsedURL()
{
    qInfo("getURL: " + m_lastUsedURL.toUtf8()  );
    return m_lastUsedURL;
}

void Controller::setLastUsedURL(QString newURl)
{
    QSettings appSettings("MediTECH","HEG");

    QString settingsKey = m_activeClientIdentfier+"lastUsedURL";
    qInfo("loadSetting: " + settingsKey.toUtf8());
    qInfo("newURL: " + newURl.toUtf8() );
    appSettings.setValue(settingsKey, newURl);

    m_lastUsedURL = newURl;
}

void Controller::setFavoriteURL(QString newURl , int position)
{
    QSettings appSettings("MediTECH","HEG");

    appSettings.setValue(QString::number(position), newURl);

    qInfo("Added To Favorites in CPP ......");

}

void Controller::loadFavoriteList()
{

      QSettings appSettings("MediTECH","HEG");

      for (int index= 0 ; index < 5 ; index++)
      {
         QString urlAtPosition = appSettings.value(QString::number(index)).toString();
         qInfo("saved URL at : " + QString::number(index).toUtf8() + " is: " +  urlAtPosition.toUtf8());

         if (urlAtPosition != "" && urlAtPosition != NULL)
         {
             emit showFavorites(urlAtPosition);
         }
      }

}

QString Controller::getFavoriteAtPosition(int position)
{
      QSettings appSettings("MediTECH","HEG");
      return appSettings.value(QString::number(position)).toString();
}

void Controller::clearFavoriteListView()
{
    emit clearFavoritesList();
}

void Controller::removeFavoriteAtPosition(int position)
{
     qInfo("Position to Delete " + QString::number(position).toUtf8() );

     QSettings appSettings("MediTECH","HEG");
     appSettings.setValue(QString::number(position), "");

}

QString Controller::getURLFromInput(QString input)
{
    QUrl url = QUrl::fromUserInput(input);
    return url.toString();
}

bool Controller::isNormalHttp(QString url)
{
    qInfo( "isNormal?" );


    if (url.startsWith("http") || url.startsWith("https"))
    {
        qInfo( "true" );
        return true;
    }

    qInfo( "false" );
    return false;
}

QString Controller::filterWebContentURL(QString url)
{
   if (url.startsWith("http") || url.startsWith("https"))
   {
       return url;
   }

   if (url.startsWith("intent"))
   {
       QStringList urlParts = url.split(";");

       for(int stringPart = 0;stringPart<urlParts.size();stringPart++)
       {
           if( urlParts[stringPart].startsWith("S.browser_fallback_url") )
           {
               QString fallbackURL = urlParts[stringPart].replace("S.browser_fallback_url=","");

               fallbackURL = unescapeURL(fallbackURL);

               return fallbackURL;
           }
       }
    }

    return ""; //"https://www.google.de";
}

QString Controller::unescapeURL(QString url)
{
    QString unescapedString = url.replace("%3A",":").replace("%2F","/").replace("%3F","?").replace("%3D","=");
    return unescapedString;
}

void Controller::emitLoadNewURL(QString newURL)
{
    emit loadNewURL(newURL);
}

int Controller::getNumberOfResultsOfActiveClient()
{
    return m_numberOfResultsOfActiveClient;
}










