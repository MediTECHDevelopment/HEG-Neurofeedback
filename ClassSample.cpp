#include "classsample.h"

Sample::Sample()
{
    //Default Values
    _vYData      =  0;
    _vYData      =  0;
    _vThreshold  =  1;
    _vDifficulty =  1;
}
void Sample::setSample(int xData, double yData)
{
    _vXData = xData;
    _vYData = yData;
}
void Sample::setSample(int xData, double yData, double threshold, bool state, int difficulty)
{
    _vXData             = xData;
    _vYData             = yData;
    _vThreshold         = threshold;
    _vIsConcentration   = state;
    _vDifficulty        = difficulty;
}

int Sample::getX() const
{
    return(_vXData);
}
double Sample::getY() const
{
    return(_vYData);
}
double Sample::getThreshold() const
{
    return(_vThreshold);
}
bool Sample::isConcentration() const
{
    return(_vIsConcentration);
}
int Sample::getDifficulty() const
{
    return(_vDifficulty);
}
