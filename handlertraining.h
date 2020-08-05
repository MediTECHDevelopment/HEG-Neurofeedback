#ifndef HANDLERTRAINING_H
#define HANDLERTRAINING_H

#include <QDebug>
#include <QVariant>
#include <QThread>
#include <QList>
#include <QTimer>       //inherits from QObject

#include "hegdevice.h"

class Measurement;
class Controller;
class Data;
class AdaptiveThreshold;
class HEGSimulator;
class TimeHandler;
class HEGThread;

/*
 *  The TrainingHandler holds all functions needed for the realtime-Plotting. This includes the data processing and sending it to QML, but also the Button-Backend for the playbuttons
 *  and setters for Threshold and Video
 */

class HandlerTraining : public QObject
{
    Q_OBJECT

public:
    HandlerTraining(Measurement *measurementpointer, Controller *controllerpointer, Data *datapointer, AdaptiveThreshold *thresholdpointer,HEGDevice* hegDevice);
    ~HandlerTraining();
    TimeHandler *_pTimeHandler;
    Q_INVOKABLE void stopSaveDecision(int decision);
    Q_INVOKABLE void stopSaveQuestion();
    Q_INVOKABLE void start();
    Q_INVOKABLE void pause();
    Q_INVOKABLE void stop();
    Q_INVOKABLE void choosenVideoFile(QString videopath);
    Q_INVOKABLE void newData(int xValue, double HEGRedData, double HEGIRedData);
    Q_INVOKABLE void getActualDuration(bool pause);

    HEGDevice *getHEGPointer();
    int test();
    //     Q_INVOKABLE void stopHEGThread();
    void killThread();
private:
    Measurement *_pMeasurement;
    Controller *_pController;
    Data *_pData;
    AdaptiveThreshold *_pThreshold;
    //HEGSimulator *_pHEGDevice;
    HEGDevice* m_hegDevice;

    //QThread *_pSimulatorThread;

    //HEGThread *_pHEGDeviceThread;
    QTimer *_pUITimer;
    QList<QVariant> _mlineGraphDataBufferX;
    QList<QVariant> _mlineGraphDataBufferYData;
    QList<QVariant> _mlineGraphDataBufferYThreshold;
    bool _mplaystate;
    int _mLastX;

    QList<double>* m_lastRatioValues = new QList<double>;

public slots:
    void saveChangedGoal(bool concentrationChange);
private slots:
    void timeoutHandlingUITimer();

signals:
    void showDatabase();
    void showStopSaveDecisionBox(QVariant messageTitle, QVariant message);
//    void startHEGHandler();
//    void resetHEGHandlerSignal();
//    void pauseHEGHandler();
    //void timeoutSignalUITimerDrawLineGraph(QVariant xValue, QVariant yDataValue, QVariant yThresholdValue);
    void timeoutSignalUITimerDrawRest(QList<QVariant> xData, QList<QVariant> yData, QList<QVariant> yThreshold);
    void TimerState(bool);
    void stopHEGDevice(bool);
};

#endif // HANDLERTRAINING_H
