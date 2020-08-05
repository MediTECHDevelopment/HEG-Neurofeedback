#include "QDebug"

#include "classrawdata.h"
#include "logicvirtualhegsample.h"

RawData::RawData()
{
}
RawData::~RawData()
{

}
/**
 * @brief samplePastProcessing::loadRawDataVector is called by an emit in load Data. It is setting the loaded Vector to the Raw Vector
 * @param loadedVector is the loaded Vector out of the file
 */
void RawData::setRawData(QVector<Sample> loadedVector)
{
    _vRawDataVector.clear();
    _vRawDataVector = loadedVector;
}

/**
 * @brief Raw::appendRawDataVector saves the sensor Data.
 * It is saving the Values, passed from the Sensor, as a Sample in a Vector.
 */
void RawData::appendRawDataVector(int XData, double HEGRatio, double Threshold, bool State, quint8 Difficulty)
{
    _vSample.setSample(XData,HEGRatio,Threshold,State,Difficulty);
    _vRawDataVector.append(_vSample);
}

QVector<Sample> RawData::getRawDataVector()
{
    return (_vRawDataVector);
}

void RawData::reset()
{
    _vRawDataVector.clear();
}

void RawData::compress(int compressfactor)
{
    double tempY = 0;
    double tempX = 0;
    double tempThreshold = 0;
    double tempState = 0;
    double tempDifficulty  = 0;
    QVector<Sample> compressedRaw;

    for(int iSamples=0; iSamples<_vRawDataVector.size()-compressfactor;iSamples+=compressfactor)
    {
        tempY = 0;
        tempX = 0;
        tempThreshold = 0;
        tempState = 0;
        tempDifficulty = 0;
        for(int iCompress=0; iCompress<compressfactor;iCompress++)
        {
            tempX += _vRawDataVector.at(iSamples+iCompress).getX();
            tempY += _vRawDataVector.at(iSamples+iCompress).getY();
            tempThreshold += _vRawDataVector.at(iSamples+iCompress).getThreshold();
            tempState += _vRawDataVector.at(iSamples+iCompress).isConcentration();
            tempDifficulty += _vRawDataVector.at(iSamples+iCompress).getDifficulty();
        }
        _vSample.setSample((tempX/compressfactor),(tempY/compressfactor),(tempThreshold/compressfactor),(tempState/compressfactor),(tempDifficulty/compressfactor));
        compressedRaw.append(_vSample);
    }
_vRawDataVector = compressedRaw;
}
