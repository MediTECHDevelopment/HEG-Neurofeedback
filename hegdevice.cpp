#include "hegdevice.h"

HEGDevice::HEGDevice(QObject *parent) : QObject(parent)
{

}

void HEGDevice::createSample(unsigned int byteValueIR, unsigned int byteValueRED)
{    
    m_sampleNumber += 1;

    double valueIR = analogToDigital(byteValueIR);
    double valueRED = analogToDigital(byteValueRED);

    emit newDatafromDevice(m_sampleNumber, valueRED, valueIR);
}

double HEGDevice::analogToDigital(uint analogValue)
{
    return ( ((double)analogValue) * (5.0 / 1023.0) );
}

void HEGDevice::startDeviceHandler(bool isActive)
{
    m_isActive = isActive;
}

void HEGDevice::resetHEGDevice()
{
    m_isActive = false;
    m_sampleNumber = 0;
}
