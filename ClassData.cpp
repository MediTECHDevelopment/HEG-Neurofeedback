#include "classdata.h"

Data::Data()
{

}
Data::~Data()
{

}
void Data::setData(RawData Raw, int SamplesPerSecond, Measurement Measure)
{
    _vRaw = Raw;
    _vSamplesPerSecond = SamplesPerSecond;
    _vMeasurement = Measure;
}
void Data::setRawData(RawData Raw)
{
    _vRaw = Raw;
}
void Data::setMeasurement(Measurement Measure)
{
    _vMeasurement = Measure;
}
void Data::setSamplesPerSecond(int SamplesPerSecond)
{
    _vSamplesPerSecond = SamplesPerSecond;
}
RawData * Data::getRaw()
{
    return &_vRaw;
}
int Data::getSamplesPerSecond()
{
    return _vSamplesPerSecond;
}
Measurement Data::getMeasurement()
{
    return _vMeasurement;
}
void Data::appendState(bool _State, int _Timestamp)
{
    State tempState;
    tempState.setDifficulty(_State);
    tempState.setTimestamp(_Timestamp);
    _StateChanges.append(tempState);
}
QVector<State> * Data::getStates()
{
    return &_StateChanges;
}
void Data::reset(int SamplesPerSecond)
{
    _vRaw.reset();
    _vMeasurement.reset();
    _StateChanges.clear();
    _vSamplesPerSecond = SamplesPerSecond;
}
