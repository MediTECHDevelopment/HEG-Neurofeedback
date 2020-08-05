#ifndef MAINHANDLER_H
#define MAINHANDLER_H

#include <QObject>
#include <QDebug>
#include <QDataStream>
#include <QSettings>
#include <QQmlApplicationEngine>
#include <QString>

class Controller;
class DataHandler;
class Data;
class HandlerDatabase;
class HandlerTraining;
class Statistics;

/*
 *  the Main-Handler holds functions, which are necessary to display new and loaded Data. Furthermore it handles closing-events.
 */

class MainHandler : public QObject
{
    Q_OBJECT
public:
    MainHandler(Controller *controllerpointer, DataHandler *dataHandlerPointer, Data *dataPointer, HandlerDatabase *databasePointer, HandlerTraining *traininghandlerpointer, Statistics *resultsPointer);
    ~MainHandler();

    Controller         *_pController;
    DataHandler        *_pDataHandler;
    Data               *_pData;
    HandlerDatabase    *_pDatabase;
    Q_INVOKABLE void saveNotes();
    Q_INVOKABLE void resetSaveNotes(int decision);
    Q_INVOKABLE void reset();
    Q_INVOKABLE void getOfflineData();
    Q_INVOKABLE void fillAnalyseTable();
    Q_INVOKABLE void changeTableHeader();
private:
    //Part of the Simulator
    QThread         *_pSimulatorThread;
    HandlerTraining *_pTrainingHandler;
    Statistics *_pResults;


public slots:
    void loadEvent();
    int close();

signals:
    void showCloseDecisionBox(QVariant messageTitle, QVariant message);
    void resetDecisionBox(QVariant messageTitle, QVariant message);
    void sendOfflineData(QList<QVariant> xData, QList<QVariant> yData, QList<QVariant> yThreshold, QList<QVariant> offStates, QVariant measTime, QVariant measDate, QVariant measDuration);
    void addStateRow(QString partstart, int msPartStart, QString partstop, QString partstate, quint16 corrPer, quint16 transPer, quint16 falsePer, QString min, QString max, QString mean, QString range, QString diff, QString threshMax, QString threshMin, QString partPoints);
    void addTotalRow(QString totalstart, QString totalstop, QString totalstate, quint16 corrPer, quint16 transPer, quint16 falsePer, QString min, QString max, QString mean, QString range, QString diff, QString threshMax, QString threshMin, QString totalPoints, QString order);
    void tableHeaderChanged();
};

#endif // MAINHANDLER_H
