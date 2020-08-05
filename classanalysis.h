#ifndef STATISTICS_H
#define STATISTICS_H

#include <QTime>

/*
 * The Analysis class evaluates one State of the Measurement. The whole Data is saved in class Stats.
 */
class Analysis
{
public:
    Analysis();
    void setTrainingSplit(QTime,QTime,QString,quint16,quint16,quint16,double,double,double,double,quint16,QString,double,double);
    void setTrainingSplitExtreme(double newmin, double newmax, double newmean, double newrange);
    void setTrainingSplitPercentages(quint16 percenttrue, quint16 percenttransit, quint16 percentfalse);
    void setTrainingSplitBasics(QTime newStartTime, QTime newStopTime, QString newState);
    void setTrainingSplitPointsDifficulty(quint16 newpoints, QString newdifficulty);
    void setTrainingSplitThreshold(double ThresholdMax, double ThresholdMin);
    const QString toLine() const;


    QTime getStartTime();
    QTime getStopTime();
    QString getState();
    quint16 getPercentageCorrect();
    quint16 getPercentageTransit();
    quint16 getPercentageFalse();
    double getMin();
    double getMax();
    double getMean();
    double getRange();
    quint16 getPoints();
    QString getDifficulty();
    double getThresholdMax();
    double getThresholdMin();

private:
    QTime startTime;
    QTime stopTime;
    QString state;
    quint16 percentCorrect;
    quint16 percentTransit;
    quint16 percentFalse;
    double min;
    double max;
    double mean;
    double range;
    quint16 points;
    QString difficulty;
    double thresholdMax;
    double thresholdMin;
};

#endif // STATISTICS_H
