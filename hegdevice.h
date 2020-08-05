#ifndef HEGDEVICE_H
#define HEGDEVICE_H

#include <QObject>

class HEGDevice : public QObject
{
    Q_OBJECT
public:
    explicit HEGDevice(QObject *parent = nullptr);

    int m_sampleNumber = 0;

    bool m_isActive = false;

    void createSample(unsigned int byteValueIR,unsigned int byteValueRED);

    void resetHEGDevice();

    double analogToDigital(uint analogValue);

signals:
    void newDatafromDevice(int, double, double);

public slots:
    void startDeviceHandler(bool isActive);


};

#endif // HEGDEVICE_H
