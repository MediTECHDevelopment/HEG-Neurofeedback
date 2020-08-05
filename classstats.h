#ifndef CLASSSTATS_H
#define CLASSSTATS_H

#include <QTime>
#include <QVector>
#include <QtMath>

#include "classanalysis.h"
#include "classdata.h"
class Controller;
class Timehandler;

/*
 * Statistics is saving all the analysed States in an Array
 */

class Statistics
{
public:
    Statistics(Data *Datapointer, Controller *Controllerpointer);
    void createStatistics(int difficulty);
    QVector<Analysis> Staterow;
    QList<int> _mStateStarts;

private:
    void percentageCalculation(int,int,QString);
    void minMaxMeanRange(int,int,QString);
    void pointCalculation(int,int,QString,int difficulty);
    void ThresholdExtrema(int,int,QString);
    int  timeBetweenThreshold(int,int,QString);
    int  timeAboveThreshold(int,int);
    void summedStatistics();
    void reset();
    QString DifficultyToString(QVector<int> difficulty);
    QString DifficultyToString(int difficulty);

    Data *_pData;
    Controller *_pController;
    Timehandler *_pTimehandler;
    Analysis newStatistics;

    quint32 concentrationDuration;
    quint32 concentrationValues;
    double concentrationYValueSum;
    quint32 concentrationCount;
    quint8 concentrationTrue;
    quint8 concentrationBetween;
    quint8 concentrationFalse;
    double concentrationMin;
    double concentrationMax;
    double concentrationMean;
    double concentrationRange;
    quint16 concentrationPoints;
    QVector<int> concentrationDifficulty;
    quint32 concentrationThresholdMax;
    quint32 concentrationThresholdMin;

    quint32 relaxationDuration;
    quint32 relaxationValues;
    double relaxationYValueSum;
    quint32 relaxationCount;
    quint8 relaxationTrue;
    quint8 relaxationBetween;
    quint8 relaxationFalse;
    double relaxationMin;
    double relaxationMax;
    double relaxationMean;
    double relaxationRange;
    quint16 relaxationPoints;
    QVector<int> relaxationDifficulty;
    quint32 relaxationThresholdMax;
    quint32 relaxationThresholdMin;

    quint32 totalDuration;
    quint32 totalValues;
    double totalYValueSum;
    quint32 totalCount;
    quint8 totalTrue;
    quint8 totalBetween;
    quint8 totalFalse;
    double totalMin;
    double totalMax;
    double totalMean;
    double totalRange;
    quint16 totalPoints;
    QString totalDifficulty;
    quint32 totalThresholdMax;
    quint32 totalThresholdMin;
};

#endif // CLASSSTATS_H
