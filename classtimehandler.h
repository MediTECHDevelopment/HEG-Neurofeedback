#ifndef MEASUREMENTTIMEHANDLER_H
#define MEASUREMENTTIMEHANDLER_H

#include <QObject>
#include <QTime>
#include <QDate>

/*
 *  The TimeHandler provides several timing-functions, used to calculate the duration and get the starttime of the measurment
 */

class TimeHandler : public QObject
{
    Q_OBJECT
public:
    explicit TimeHandler(QObject *parent = nullptr);
    int getElapsedMS(QTime startTime);
    static QTime elapsedToTime(int elapsedMS);
    QTime getMeasurementStartTime();
    int getMeasurementMSDuration();
    QTime getMeasurementDuration();
    void resetMeasurementMSDuration();
    QString elapsedtimeAsString(bool pause);
    int getElapsedTime();
    void getNewStartTime();
    void addMeasurementMSDuration();
    void reset();
private:
    QTime _measurementStartTime;
    int _measurmentMSDuration;
    QTime _lastStartTime;
    QString _elapsedTimeAsString;

signals:

public slots:   
};

#endif // MEASUREMENTTIMEHANDLER_H
