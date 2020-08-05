#ifndef TIMEMANAGEMENT_H
#define TIMEMANAGEMENT_H

#include <QString>
#include <QDate>

/**
 * @brief The Measurement class saves all informations to distinguish between measurements.
 */
class Measurement
{
public:
    Measurement();
    void setMeasurement(QDate MeasurementDate, QTime MeasurementTime, QTime MeasurementDuration);
    void setDate(QDate MeasurementDate);
    QDate getDate();
    void setTime(QTime MeasurementTime);
    QTime getTime();
    void setDuration(QTime MeasurementDuration);
    QTime getDuration();

    void stringToMeasurement(QString line);
    const QString showString() const;
    const QString setMeasurementPath() const;
    bool isEmpty();
    void reset();
private:
    QDate _MeasurementDate;
    QTime _MeasurementTime;
    QTime _MeasurementDuration;
};

#endif // MEASUREMENT_H
