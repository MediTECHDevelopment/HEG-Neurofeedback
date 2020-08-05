#ifndef VIRTUALHEG_H
#define VIRTUALHEG_H

#include <QList>

/*
 * The virtualHEG class is converting the  Signals to the HEG Ratio
 */
class virtualHEG
{
public:
    virtualHEG();
    ~virtualHEG();
    static double toVirtualSample(const double HEGRed, const double HEGiRed);
private:
    //static members to adjust the Samples
    static double _mVoltMin;
    static double _mVoltMax;
    static double _virtualMin;
    static double _virtualMax;
    static double _multiplier;
};

#endif // VIRTUALHEG_H
