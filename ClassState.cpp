#include "classstate.h"

State::State()
{

}
State::~State()
{

}
void State::setDifficulty(bool isConcentration)
{
    if (isConcentration == true)
    {
        _vIsConcentration = "concentration";
    }
    else
    {
        _vIsConcentration = "relaxation";
    }
}
void State::setTimestamp(int Timestamp)
{
    _vTimestamp = Timestamp;
}
QString State::getConcentration()
{
    return (_vIsConcentration);
}
int State::getTimestamp() const
{
    return (_vTimestamp);
}
QString State::toString()
{
    return(_vIsConcentration+"_"+ QString::number(_vTimestamp));
}
