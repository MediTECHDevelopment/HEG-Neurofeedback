#include <QDebug>
#include <hegsimulator.h>

HEGSimulator::HEGSimulator()
{
    _samplerate =   10;
    _HEGRedData      =   -0.1;
    _HEGIRedData      =   0.1;
    _iTrianglefunction = 1;
    _iiTrianglefunction = 2;
    _xData = 0;
    _timer      =   new QTimer(this);
     connect(_timer, SIGNAL(timeout()),this,SLOT(createSample()));
}

HEGSimulator::~HEGSimulator()
{
    delete _timer;
}

void HEGSimulator::startDeviceHandler(bool isActive)
{
    if(isActive==true)
    {
        _timer->start(_samplerate);
    }
    else if(isActive==false)
    {
        _timer->stop();
    }
}

void HEGSimulator::createSample()
{
    _xData++;
    if (_HEGRedData <= -0.85 || _HEGRedData >= -0.1)
    {
        _iTrianglefunction++;
    }
    if (_iTrianglefunction%2==0)
    {
        _HEGRedData-=0.01;
    }
    else
    {
        _HEGRedData+=0.01;
    }

    if (_HEGIRedData <= 0.1 || _HEGIRedData >= 0.85)
    {
        _iiTrianglefunction++;
    }
    if (_iiTrianglefunction%2==0)
    {
        _HEGIRedData-=0.01;
    }
    else
    {
        _HEGIRedData+=0.01;
    }
    emit newDatafromDevice(_xData, _HEGRedData, _HEGIRedData);
}


void HEGSimulator::setHEGSamplerate(int samplerate)
{
    _samplerate = samplerate;
}
int HEGSimulator::getHEGSamplerate() const
{
    return _samplerate;
}
bool HEGSimulator::timerisRunning() const
{
    return _timer->isActive();
}

void HEGSimulator::resetHEGSimulator()
{
    qDebug()<<"reset simulator";        //don't delete, otherwise there will be an exception... (timing-problems i guess)
    _iTrianglefunction=1;
    _iiTrianglefunction = 2;
    _HEGRedData      =   -0.1;
    _HEGIRedData      =   0.1;
    _xData = 0;

    emit readyToKill();
}
