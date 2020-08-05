#include "classmeasurement.h"

Measurement::Measurement()
{
    _MeasurementDate.setDate(2000,01,01);
    _MeasurementTime.setHMS(00,00,00);
    _MeasurementDuration.setHMS(00,00,00,000);
}

void Measurement::setMeasurement(QDate MeasurementDate, QTime MeasurementTime, QTime MeasurementDuration)
{
    _MeasurementDate = MeasurementDate;
    _MeasurementTime = MeasurementTime;
    _MeasurementDuration = MeasurementDuration;
}

void Measurement::setDate(QDate MeasurementDate)
{
    _MeasurementDate = MeasurementDate;
}

QDate Measurement::getDate()
{
    return _MeasurementDate;
}

void Measurement::setTime(QTime MeasurementTime)
{
    _MeasurementTime = MeasurementTime;
}

QTime Measurement::getTime()
{
    return _MeasurementTime;
}

void Measurement::setDuration(QTime MeasurementDuration)
{
    _MeasurementDuration = MeasurementDuration;
}

QTime Measurement::getDuration()
{
    return _MeasurementDuration;
}

/**
 * @brief Measurement::stringToMeasurement is used in Dialog Database and converts the Path into a Measurement
 * @param line is the path which get converted into a Measurement
 */
void Measurement::stringToMeasurement(QString line)
{
    QStringList MeasurementStringSub = line.split('_');
    QStringList eraseEnding = MeasurementStringSub.last().split('.');

    _MeasurementDate            = QDate::fromString(MeasurementStringSub.first(),"yyyy-MM-dd");
    _MeasurementTime           = QTime::fromString(MeasurementStringSub.at(1),"hh-mm-ss");
    _MeasurementDuration       = QTime::fromString(eraseEnding.at(0),"hh'h'mm'm'ss's'");
}

/**
 * @brief Measurement::showString is showing the Measurement which was read by the stringToMeasurement method in the Dialog database
 * If the User is loading a measurement it uses this method to display the Client and the load measurement in the windowtitle
 * @returns a string which get displayed in the Measurement window
 */
const QString Measurement::showString() const
{
    return (_MeasurementDate.toString("yyyy-MM-dd") + " | " + _MeasurementTime.toString("hh:mm:ss")+" | " + _MeasurementDuration.toString("mm'm' ss's'"));
}

/**
 * @brief Measurement::setMeasurementPath is used to save a Measurement
 * @returns the Filepath of the measurement
 */
const QString Measurement::setMeasurementPath() const
{
    return (_MeasurementDate.toString("yyyy-MM-dd")+"_"+_MeasurementTime.toString("hh-mm-ss")+"_"+_MeasurementDuration.toString("hh'h'mm'm'ss's'")+".dat");
}

/**
 * @brief Measurement::isEmpty is testing the measurement before displaying it, if its valid or not
 * @returns true or false, just with false it is not empty, so it get displayed in the Dialog Database
 */
bool Measurement::isEmpty()
{
    if(_MeasurementDate.toString("yyyyMMdd") == "20000101" ||  _MeasurementTime.toString("hhmmss") == "000000" || _MeasurementDuration.toString("hhmmsszzz") == "000000000")
    {
        return (true);
    }
    return (false);
}
void Measurement::reset()
{
    _MeasurementDate.setDate(2000,01,01);
    _MeasurementTime.setHMS(00,00,00);
    _MeasurementDuration.setHMS(00,00,00,000);
}




