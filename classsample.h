#ifndef SAMPLE_H
#define SAMPLE_H

#include <QString>

/*
 * The Sample class describes, how a sample looks like. The sample is saved in Raw Data.
 */

class Sample
{
public:
    Sample();
    void setSample(int xData, double yData);
    void setSample(int xData, double yData, double threshold, bool State, int difficulty);
    int getX() const;
    double getY() const;
    double getThreshold() const;
    bool   isConcentration() const;
    int  getDifficulty() const;

private:
   int _vXData;
   double _vYData;
   double _vThreshold;
   bool   _vIsConcentration;
   int  _vDifficulty;
};

#endif // SAMPLE_H
