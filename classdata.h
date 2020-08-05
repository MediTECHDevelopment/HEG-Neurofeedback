#ifndef CLASSDATA_H
#define CLASSDATA_H

#include <QObject>
#include <QString>

#include <classrawdata.h>
#include <classmeasurement.h>
#include <classstate.h>


/*
 * Data is the class which includes all the important data of the actual measurement.
 */

class Data
{
public:
    Data();
    ~Data();
    void setData(RawData Raw,int SamplesPerSecond, Measurement Measure);
    void setRawData(RawData);
    void setSamplesPerSecond(int);
    void setMeasurement(Measurement Measure);

    RawData*            getRaw();
    int                 getSamplesPerSecond();
    Measurement         getMeasurement();
    QVector<State>*     getStates();
    void                appendState(bool _State, int _Timestamp);

    void reset(int SamplesPerSecond);
private:
    RawData             _vRaw;
    int                 _vSamplesPerSecond;
    Measurement         _vMeasurement;
    QVector<State>      _StateChanges;
};

#endif // CLASSDATA_H
