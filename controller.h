#ifndef CONTROLLER_H
#define CONTROLLER_H

#include <QObject>
#include <QVector>
#include <QDate>
#include <QRectF>
#include <QPen>
#include <QVariant>

/*
 *  functions and variables, which are need in several classes
 */

class Controller : public QObject
{
    Q_OBJECT
public:
    Controller();
    ~Controller();



    int m_numberOfResultsOfActiveClient = 0;

    //STATES
    //Measurement States
    bool    measurementIsActive;        //If the Measurement is started or paused
    bool    pausedMeasurement;          //If the Measurement is paused, to handle the Buttons
    bool    realtimePlotting;           //It controlls the Views Training and Analyse

    //Save States
    bool    measurementisSaved;
    bool    notesAreSaved;

    //Settings States
    bool    adaptiveThresholdIsActive;

    //--------------------------------------------------------------------------------//

    //METADATA

    //Used to save data under the right filepath
    int currentClientID;

    //Saves the last played videoPath
    QString videoPath;

    //If device is always constant it can be const
    int samplesPerSecond;
    int hertzMultiplicator;
    //--------------------------------------------------------------------------------//

    //GETTER AND SETTER FOR PRIVATE VARIABLES
    //Metadata
    Q_INVOKABLE double getThreshold() const;
    Q_INVOKABLE bool getConcentrationState() const;

    //Adaptive Threshold and BarGraph Colour
    Q_INVOKABLE void setDifficulty(int Difficulty);
    quint8 getDifficulty();
    int adapPercentage;
    int difficultyToAdapThreshold(int Difficulty);
    //needed in stats
    const int ThresholdTransitPercent = 20; //80% opposite
    QString savepath;
    QTime totalDurationTime;


    QString m_activeClientIdentfier = "";
    QString unescapeURL(QString url);

    //Data *_pData;
    void showMessageInQml(QString messageTitle, QString messages);
    void showMessageInStatusBarLeft(QString statusMessage, int messageDuration);
    void showMessageInStatusBarRight(QString statusMessage);
    void showMessageInStatusBarClientLabel(QString statusMessage);
    Q_INVOKABLE void setNotes(QString notes);
    QString getNotes();
    Q_INVOKABLE void changeAdaptiveThresh(bool threshStatus);
    Q_INVOKABLE void setThresholdValue(double newThresholdValue);
    Q_INVOKABLE void setCalcDiffID(int ButtonID);
    int getCalcDiffID();


    Q_INVOKABLE void setWebViewVisibility(bool visible);
    Q_INVOKABLE void setWebViewMenueOpen(bool open);
    Q_INVOKABLE void setURLButtonEnabled(bool enabled);

    Q_INVOKABLE QString getLastUsedURL();
    Q_INVOKABLE void setLastUsedURL(QString newURL);
    Q_INVOKABLE void setFavoriteURL(QString newURl, int position);
    Q_INVOKABLE void loadFavoriteList();

    Q_INVOKABLE QString getURLFromInput(QString input);

    Q_INVOKABLE bool isNormalHttp(QString url);
    Q_INVOKABLE QString filterWebContentURL(QString url);
    Q_INVOKABLE void clearFavoriteListView();
    Q_INVOKABLE void removeFavoriteAtPosition(int position);

    Q_INVOKABLE int getNumberOfResultsOfActiveClient();
    Q_INVOKABLE QString getFavoriteAtPosition(int position);

    void emitLoadNewURL(QString newURL);

private:

    QString m_lastUsedURL = "https://www.google.de/";

    //threshold is controlling the Video and the displayed Threshold
    double  threshold;
    //isConcentration is holding the value for the current State of the measurement
    bool    isConcentration;
    //setted difficulty
    quint8 difficulty;
    QString _mNotes;
    void firstSettings();
    int _mcalcDiffID;

public slots:

    void setConcentrationState(bool vConcentration);
    void setVideoPath(QString newVideoPath);
    void resetAll();

signals:
    void concentrationChange(bool);
    void changeWindowTitle(QVariant newTitle);
    void displayMessages(QVariant messageTitle, QVariant message);
    void displayStatustextLeft(QVariant statusMessage, QVariant messageDuration);
    void displayStatustextRight(QVariant statusMessage);
    void displayStatustextClientLabel(QVariant statusMessage);
    void setNewThreshold(QVariant newThreshold);
    void setNewVidFile(QVariant newVidPath);

    void webViewVisibilityChanged(bool visible);
    void webViewMenuVisibilityChanged(bool visible);
    void urlButtonEnabled(bool enabled);
    void showFavorites(QString url);
    void clearFavoritesList();
    void loadNewURL(QString newURL);
};

#endif // CONTROLLER_H

