#ifndef HEGSIMULATOR_H
#define HEGSIMULATOR_H

#include <QDialog>
#include <QTimer>
/**
 * @brief The HEGSimulator class is the Simulator of the Sensor and will be deleted/toggled if there is a sensor
 */
class HEGSimulator : public QObject
{
   Q_OBJECT

private:
    QTimer  *_timer;

    int     _samplerate;
    double   _HEGRedData;
    double   _HEGIRedData;
    int     _iTrianglefunction;
    int     _iiTrianglefunction;
    int _xData;

public:
    HEGSimulator();
    ~HEGSimulator();
    void    setHEGSamplerate(int samplerate);
    int     getHEGSamplerate() const;
    bool    timerisRunning() const;

signals:
    void     newDatafromDevice(int, double, double);
    //void     newDatafromSimulator(int, double, double);
    void readyToKill();

private slots:
    void    createSample();

public slots:
    //void    startDeviceHandler();
    void    startDeviceHandler(bool isActive);
    void    resetHEGSimulator();
    //void    pauseDeviceHandler();

};

#endif // HEGSIMULATOR_H
