#include "logicvirtualhegsample.h"
#include <QDebug>

/**
 * @brief virtualHEG:: static Members can also be set as const
 */
double virtualHEG::_mVoltMin    = -0.85;
double virtualHEG::_mVoltMax    = 0.85;
double virtualHEG::_virtualMin  = 0;
double virtualHEG::_virtualMax  = 2;
double virtualHEG::_multiplier  = 50;//200;

virtualHEG::virtualHEG()
{
}

virtualHEG::~virtualHEG()
{
}
/**
 * @brief virtualHEG::toVirtualSample is a static method which creates the HEG Ratio between the IRed and Red Value
 * @param HEGRed
 * @param HEGiRed
 * @returns the HEG Ratio
 */
double virtualHEG::toVirtualSample(const double HEGRed, const double HEGiRed)
{
    /*
    double virtualHEGRed = (HEGRed - _mVoltMin) * (_virtualMax-_virtualMin)/(-_mVoltMin+_mVoltMax);
    double virtualHEGiRed = (HEGiRed - _mVoltMin) * (_virtualMax-_virtualMin)/(-_mVoltMin+_mVoltMax);
    */

    double virtualHEGRed = HEGRed / 0.85  ;// / 0.85;
    double virtualHEGiRed = HEGiRed / 0.85 ;// / 0.85;

    if(virtualHEGiRed == 0.0)
    {
        virtualHEGiRed = 0.0001;
    }

    double ratio = ((virtualHEGRed/virtualHEGiRed)*_multiplier);



    //qInfo("IR:" + QString::number(virtualHEGiRed).toUtf8() + " RED:" + QString::number(virtualHEGRed).toUtf8() + " Ratio:" + QString::number(ratio).toUtf8() );

    return ratio;
}
