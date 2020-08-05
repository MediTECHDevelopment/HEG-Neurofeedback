#include "handlertraining.h"

#include "classmeasurement.h"
#include "controller.h"
#include "classdata.h"
#include "logicthreshold.h"
#include "hegsimulator.h"
#include "classtimehandler.h"
#include "logicvirtualhegsample.h"
#include <QVector3D>

#include <QtDebug>


HandlerTraining::HandlerTraining(Measurement *measurementpointer, Controller *controllerpointer, Data *datapointer, AdaptiveThreshold *thresholdpointer,HEGDevice* hegDevice)
{
    _pMeasurement = measurementpointer;
    _pController = controllerpointer;
    _pData = datapointer;
    _pThreshold = thresholdpointer;

    //_pHEGDevice = new HEGSimulator();

    //_pSimulatorThread = new QThread();

    _pTimeHandler = new TimeHandler();

    //_pHEGDevice->moveToThread(_pSimulatorThread);
    m_hegDevice = hegDevice;

    _pUITimer = new QTimer();
    _mLastX = 0;

    //connect simulator/ Thread!
    connect(m_hegDevice, SIGNAL(newDatafromDevice(int, double, double)), this, SLOT(newData(int, double, double)));
    connect(this, SIGNAL(TimerState(bool)), m_hegDevice, SLOT(startDeviceHandler(bool)), Qt::QueuedConnection);
    connect(this, SIGNAL(stopHEGDevice(bool)), m_hegDevice, SLOT(startDeviceHandler(bool)), Qt::QueuedConnection);
    //connect(this, SIGNAL(stopHEGDevice(bool)), _pHEGDevice, SLOT(deleteLater()));
    //connect(_pHEGDevice, SIGNAL (readyToKill()), _pSimulatorThread, SLOT (quit()));

    connect(_pUITimer, SIGNAL(timeout()), this, SLOT(timeoutHandlingUITimer()));
    connect(_pController, SIGNAL(concentrationChange(bool)), this, SLOT(saveChangedGoal(bool)));
}

HandlerTraining::~HandlerTraining()
{
    //_pHEGDevice muss be deleted AFTER _pSimulatorThread!!! Otherwise there will be an ASSERT...
    delete _pTimeHandler;
    //delete _pSimulatorThread;
    //delete _pHEGDevice;
    delete _pUITimer;

    delete m_lastRatioValues;
}

/**
 * @brief HandlerTraining::start is called when the start Button was clicked
 */
void HandlerTraining::start()
{
    _pUITimer->start(100);      //every 100ms the datavector is given to the ui, but ever second value is visualized! (buffer-use)
    if(_pController->pausedMeasurement != true)
    {
        //Saving descriptive properties
        _pMeasurement->setDate(QDate::currentDate());
        _pMeasurement->setTime(_pTimeHandler->getMeasurementStartTime());
        _pController->realtimePlotting  = true;
        _pController->measurementIsActive = true;

        _pController->showMessageInStatusBarLeft(tr("Measurement started"), 2000);

        //_pSimulatorThread->start();
        m_hegDevice->startDeviceHandler(true);
    }
    //connect at the beginning
    emit TimerState(true);

    _pTimeHandler->getNewStartTime();
    _pController->pausedMeasurement = false;

    _mplaystate = true;
}


/**
 * @brief HandlerTraining::pause is called when the button paused is clicked
 */
void HandlerTraining::pause()
{
    _pUITimer->stop();
    //connect at the beginning
    emit TimerState(false);
    _pTimeHandler->addMeasurementMSDuration();
    _pController->pausedMeasurement = true;
    _mplaystate = false;

}
/**
 * @brief HandlerTraining::stop is called when the Button stopped is clicked
 */
void HandlerTraining::stop()
{
    _pUITimer->stop();
    if(_pController->pausedMeasurement!=true)
    {
        _pTimeHandler->addMeasurementMSDuration();
    }
    //connect at the beginning
    emit TimerState(false);
    m_hegDevice->resetHEGDevice();

    //Used to save the total Duration
    _pMeasurement->setDuration(_pTimeHandler->getMeasurementDuration());
    _pController->totalDurationTime = _pTimeHandler->getMeasurementDuration();

    //To save the last states of these Values SHOULD BE DATA AS WELL, data.appendState like that
    saveChangedGoal(_pController->getConcentrationState());

    _pData->setMeasurement(*_pMeasurement);

    _pController->measurementisSaved = false;
    _pController->measurementIsActive = false;

    _mplaystate = false;
    _mLastX = 0;
    _mlineGraphDataBufferX.clear();
    _mlineGraphDataBufferYData.clear();
    _mlineGraphDataBufferYThreshold.clear();
    _pTimeHandler->resetMeasurementMSDuration();
}

void HandlerTraining::stopSaveQuestion()
{
    _pController->showMessageInStatusBarRight(tr("Measurement stopped: ")+_pData->getMeasurement().getDuration().toString("hh:mm:ss"));
    _pController->showMessageInStatusBarLeft(tr("Data succesfully loaded"), 2000);

    //Ask the user once if he wants to save or not
    //Connections in UIAnalyseView
    emit showStopSaveDecisionBox(tr("Measurement finished"),tr("Do you want to save your measurement?"));
}

void HandlerTraining::stopSaveDecision(int decision)
{
    //call in UIAnalyseView!
    switch (decision)
    {
    case 1:
        //connections in UIAnalyseView
        emit showDatabase();
        break;
    case 2:
        _pController->measurementisSaved = true;
        break;
    }
    _pController->pausedMeasurement = false;
}

/**
 * @brief HandlerTraining::saveChangedGoal method which saves the change and the x value
 * @param concentrationChange
 */
void HandlerTraining::saveChangedGoal(bool concentrationChange)
{
    if(_pController->measurementIsActive==true)
    {
        _pData->appendState(concentrationChange,_pData->getRaw()->getRawDataVector().last().getX());
    }
}


void HandlerTraining::choosenVideoFile(QString videopath)
{
    //call in UIVideoCtrlPart
    _pController->videoPath = videopath;
}


void HandlerTraining::newData(int xValue, double HEGRedData, double HEGIRedData)
{
    double ratio = virtualHEG::toVirtualSample(HEGRedData,HEGIRedData);

    m_lastRatioValues->push_back(ratio);

    if(m_lastRatioValues->size() > _pController->samplesPerSecond * 5) //durchschnitt von 5 sekunden
    {
        m_lastRatioValues->removeFirst();
    }

    double values = 0.0;
    for(int i=0;i<m_lastRatioValues->size();i++)
    {
        values += m_lastRatioValues->at(i);
    }
    double meanRatio = values / m_lastRatioValues->size();

    //qInfo("MeanRatio: " + QString::number( meanRatio ).toUtf8() );


    //At first calculate the Threshold
    if(_pController->adaptiveThresholdIsActive == true)
    {
        _pThreshold->ThresholdAdaptionHandler(meanRatio);
    }


    _pData->getRaw()->appendRawDataVector(xValue,meanRatio,_pController->getThreshold(),_pController->getConcentrationState(),_pController->getDifficulty());


    int calculatedTime = _pData->getRaw()->getRawDataVector().size() * _pController->hertzMultiplicator;
    int elapsedTime = _pTimeHandler->getElapsedTime();

    int lostTime = elapsedTime - calculatedTime;

    if(lostTime > 0)
    {
        int lostSamples = lostTime / _pController->hertzMultiplicator;

        for(int newSample = 1 ;newSample < lostSamples+1; newSample++)
        {
            m_hegDevice->m_sampleNumber += 1;

            qInfo( "extraSample " + QString::number( m_hegDevice->m_sampleNumber ).toUtf8() );

            _pData->getRaw()->appendRawDataVector(m_hegDevice->m_sampleNumber,meanRatio,_pController->getThreshold(),_pController->getConcentrationState(),_pController->getDifficulty());
        }

        qInfo(QString::number( lostSamples ).toUtf8() );
    }
}


HEGDevice* HandlerTraining::getHEGPointer()
{
    return m_hegDevice;
}


void HandlerTraining::getActualDuration(bool pause)
{
    _pController->showMessageInStatusBarRight(_pTimeHandler->elapsedtimeAsString(pause));
}

void HandlerTraining::timeoutHandlingUITimer()
{
    if (_mplaystate)
    {
        int actualX = _pData->getRaw()->getRawDataVector().size();
        int getShift=0;

        for (int ixArrays = _mLastX; ixArrays < actualX; ixArrays += 2)
        {
            _mlineGraphDataBufferX.append(_pData->getRaw()->getRawDataVector().at(ixArrays).getX()*_pController->hertzMultiplicator);
            _mlineGraphDataBufferYData.append(_pData->getRaw()->getRawDataVector().at(ixArrays).getY());
            _mlineGraphDataBufferYThreshold.append(_pData->getRaw()->getRawDataVector().at(ixArrays).getThreshold());

            if ( ixArrays+2 >= actualX)
            {
                getShift = actualX-ixArrays;
            }
        }

        getActualDuration(_pController->pausedMeasurement);

        emit timeoutSignalUITimerDrawRest(_mlineGraphDataBufferX, _mlineGraphDataBufferYData, _mlineGraphDataBufferYThreshold);

        _mLastX = actualX-getShift;
        while(_mlineGraphDataBufferX.size() != 0)
        {
            _mlineGraphDataBufferX.removeLast();
            _mlineGraphDataBufferYData.removeLast();
            _mlineGraphDataBufferYThreshold.removeLast();
        }
    }
}

