#include "classanalysis.h"

Analysis::Analysis()
{

}
/**
* @brief Statistics::setTrainingSplit is implemented to write the Statistic object later, when it should be load instead of recalculate with the values
*/
void Analysis::setTrainingSplit(QTime start, QTime stop, QString newState, quint16 newPercentTrue, quint16 newPercentTransit, quint16 newPercentFalse, double newMin, double newMax, double newMean, double newRange, quint16 newPoints, QString newDifficulty, double ThresholdMax, double ThresholdMin)
{
   startTime       = start;
   stopTime        = stop;
   state           = newState;
   percentCorrect  = newPercentTrue;
   percentTransit  = newPercentTransit;
   percentFalse    = newPercentFalse;
   min             = newMin;
   max             = newMax;
   mean            = newMean;
   range           = newRange;
   points          = newPoints;
   difficulty      = newDifficulty;
   thresholdMax    = ThresholdMax;
   thresholdMin    = ThresholdMin;
}
/**
* @brief Statistics::toLine enfast the Usage while saving a Statistic object
* @returns a QString to save
*/
const QString Analysis::toLine() const
{
   QString line (startTime.toString("hh:mm:ss") + "_" + stopTime.toString("hh:mm:ss") + "_" + state + "_" + QString::number(percentCorrect) + "_" + QString::number(percentTransit) + "_" + QString::number(percentFalse) + "_" + QString::number(min) + "_" + QString::number(max) + "_" + QString::number(mean) + "_" + QString::number(range) + "_" + QString::number(points) + "_" + difficulty + "_" + QString::number(thresholdMax) + "_" + QString::number(thresholdMin));
   return line;
}
//SETTER
void Analysis::setTrainingSplitBasics(QTime newStartTime, QTime newStopTime, QString newState)
{
   startTime   = newStartTime;
   stopTime    = newStopTime;
   state       = newState;
}
void Analysis::setTrainingSplitPercentages(quint16 percenttrue, quint16 percenttransit, quint16 percentfalse)
{
   percentCorrect  = percenttrue;
   percentTransit  = percenttransit;
   percentFalse    = percentfalse;
}
void Analysis::setTrainingSplitExtreme(double newmin, double newmax, double newmean, double newrange)
{
   min     = newmin;
   max     = newmax;
   mean    = newmean;
   range   = newrange;
}
void Analysis::setTrainingSplitPointsDifficulty(quint16 newpoints, QString newdifficulty)
{
   points      = newpoints;
   difficulty  = newdifficulty;
}
void Analysis::setTrainingSplitThreshold(double ThresholdMax, double ThresholdMin)
{
   thresholdMax = ThresholdMax;
   thresholdMin = ThresholdMin;
}
QTime Analysis::getStartTime()
{
   return startTime;
}
QTime Analysis::getStopTime()
{
   return stopTime;
}

QString Analysis::getState()
{
   return state;
}
quint16 Analysis::getPercentageCorrect()
{
   return percentCorrect;
}
quint16 Analysis::getPercentageTransit()
{
   return percentTransit;
}
quint16 Analysis::getPercentageFalse()
{
   return percentFalse;
}
double Analysis::getMin()
{
   return min;
}
double Analysis::getMax()
{
   return max;
}
double Analysis::getMean()
{
   return mean;
}
double Analysis::getRange()
{
   return range;
}
quint16 Analysis::getPoints()
{
   return points;
}
QString Analysis::getDifficulty()
{
   return difficulty;
}
double Analysis::getThresholdMax()
{
   return thresholdMax;
}
double Analysis::getThresholdMin()
{
   return thresholdMin;
}
