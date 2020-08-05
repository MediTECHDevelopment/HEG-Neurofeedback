#ifndef PROGRAMM_H
#define PROGRAMM_H

#include <QVector>

#include "classsample.h"

/*
 * Raw Data ist the class which get the raw Data, processes it and saves it.
 */

class RawData
{
public:
    RawData();
    ~RawData();

    void compress(int compressfactor);
    QVector<Sample> getRawDataVector();
    void reset();
    void appendRawDataVector(int XData, double HEGRatio, double Threshold, bool State, quint8 Difficulty);
    void setRawData(QVector<Sample> loadedVector);


private:
    QVector<Sample>     _vRawDataVector;     //The _vRawDataVector is declared as a value, because if i pass a pointer, it gets changed everytime it is changed
    Sample              _vSample;
};

#endif // PROGRAMM_H
