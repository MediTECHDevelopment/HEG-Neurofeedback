#include "classtimehandler.h"
#include <QDebug>

TimeHandler::TimeHandler(QObject *parent) : QObject(parent)
{
    _measurmentMSDuration = 0;
}

void TimeHandler::reset()
{
    resetMeasurementMSDuration();
    _elapsedTimeAsString = "00:00:00";
}

void TimeHandler::resetMeasurementMSDuration()
{
    _measurmentMSDuration = 0;
}

QTime TimeHandler::getMeasurementStartTime()
{
    _measurementStartTime.start();
    return _measurementStartTime;
}

void TimeHandler::addMeasurementMSDuration()
{
    int elapsedMS = _lastStartTime.elapsed();
    _measurmentMSDuration += elapsedMS;
}

int TimeHandler::getMeasurementMSDuration()
{
    return _measurmentMSDuration;
}

QTime TimeHandler::getMeasurementDuration()
{
    QTime measurementDuration = elapsedToTime(_measurmentMSDuration);
    return measurementDuration;
}

void TimeHandler::getNewStartTime()
{
    _lastStartTime.start();
}

/**
* @brief TimeHandler::elapsedToTime calculates the elapsed Time from the milliseconds (i.e. returned by elapsed())
* @returns elapsed milliseconds as QTime (hours, minutes, seconds, milliseconds)
*/
QTime TimeHandler::elapsedToTime(int elapsedMS)
{
    int elapsedHours, elapsedMinutes, elapsedSeconds;
    int elapsedMilliseconds = elapsedMS;
    QTime elapsedTime;

    elapsedSeconds = elapsedMilliseconds / 1000;
    elapsedMilliseconds %= 1000;

    elapsedMinutes = elapsedSeconds / 60;
    elapsedSeconds %= 60;

    elapsedHours = elapsedMinutes / 60;
    elapsedMinutes %= 60;

    elapsedTime.setHMS(elapsedHours, elapsedMinutes, elapsedSeconds, elapsedMilliseconds);
    return (elapsedTime);
}

/**
* @brief TimeHandler::elapsedtimeAsString is necassary for the stopwatch in the statusbar (right)
* @returns elapsde Time as QString in format ("HH:mm:ss")
*/
QString TimeHandler::elapsedtimeAsString(bool pause)
{
    if (!pause)
    {
        int elapsed = _lastStartTime.elapsed();
        elapsed += _measurmentMSDuration;
        QTime time = elapsedToTime(elapsed);
        _elapsedTimeAsString = time.toString("HH:mm:ss");
    }
    return _elapsedTimeAsString;
}

int TimeHandler::getElapsedTime()
{
    int elapsed = _lastStartTime.elapsed();
    elapsed += _measurmentMSDuration;

    return elapsed;
}

