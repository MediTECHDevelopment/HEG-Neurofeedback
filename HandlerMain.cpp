#include "handlermain.h"
#include "controller.h"
#include "classdata.h"
#include "logicdatahandler.h"
#include "handlerdatabase.h"
#include "handlertraining.h"
#include "classstats.h"
#include "hegsimulator.h"

MainHandler::MainHandler(Controller *controllerpointer, DataHandler *dataHandlerPointer, Data *dataPointer, HandlerDatabase *databasePointer, HandlerTraining *traininghandlerpointer, Statistics *resultsPointer)
{
    _pController = controllerpointer;
    _pDataHandler = dataHandlerPointer;
    _pData = dataPointer;
    _pDatabase = databasePointer;
    _pTrainingHandler = traininghandlerpointer;
    _pResults = resultsPointer;

    _pData->setSamplesPerSecond( _pController->samplesPerSecond );
}
MainHandler::~MainHandler()
{
}

/**
 * @brief MainHandler::reset is used to set a new measurement or before loading other datas(load)
 */
//called in UIcontroller - reload()
void MainHandler::reset()
{
    //necessary if "stop" wasn't clicked
    if(_pController->measurementIsActive==true)
    {
        _pTrainingHandler->TimerState(false);       //have to be called befors reset!
        _pTrainingHandler->getHEGPointer()->resetHEGDevice();
    }

    if(_pController->notesAreSaved==false)
    {
        //slot in main.qml
        emit resetDecisionBox(tr("You did not save your Notes"), tr("Do you want save your Notes?\n\n"));

        return;
    }

    _pData->reset(_pController->samplesPerSecond);
    _pData->getRaw()->reset();
    _pController->resetAll();

    _pController->changeWindowTitle(tr("MediTECH HEG Standalone"));
    _pController->showMessageInStatusBarLeft(tr("reset succesfull"), 2000);
}

void MainHandler::resetSaveNotes(int decision)
{
    //called in main.qml
    switch (decision)
    {
    case 1:

        _pDataHandler->saveData(_pDatabase->getClient(_pController->currentClientID),_pData);
        break;

    case 2:
        _pController->notesAreSaved = true;
        break;
    }

    _pData->reset(_pController->samplesPerSecond);
    _pController->resetAll();

    _pController->showMessageInStatusBarLeft(tr("reset succesfull"), 2000);
}

int MainHandler::close()
{
    if(_pController->measurementIsActive==true)
    {
        _pTrainingHandler->TimerState(false);       //have to be called befors reset!
        _pTrainingHandler->getHEGPointer()->resetHEGDevice();
    }
    //Warning if the notepad is filled but not saved
    if(_pController->notesAreSaved == false && _pController->measurementisSaved == true)
    {
        //Slot in main.qml
        emit showCloseDecisionBox(tr("You did not save your Notes"), tr("Do you want save your Notes?\n"));
        return 1;
    }
    //close accepted in QML
    return 0;
}

void MainHandler::saveNotes()
{
    //called in main.qml
    _pDataHandler->saveData(_pDatabase->getClient(_pController->currentClientID),_pData);  //simultanes Abfragen und Speichern
    _pController->notesAreSaved = true;
}

/**
 * @brief MainHandler::loadEvent is the method which is displaying the data from the choosen client and choosen measurement callback from database
 * @param currentClient
 * @param measurement
 */
void MainHandler::loadEvent()
{
    reset();
}

void MainHandler::getOfflineData()
{
    QList<QVariant> offlineDataX;
    QList<QVariant> offlineDataY;
    QList<QVariant> offlineThresholdY;
    QList<QVariant> offlineState;
    QString measurementTime = _pData->getMeasurement().getTime().toString("hh:mm:ss");
    QString measurementDate = _pData->getMeasurement().getDate().toString("yyyy-MM-dd");
    QString measurementDuration = _pData->getMeasurement().getDuration().toString("hh") + "h "+ _pData->getMeasurement().getDuration().toString("mm") + "m " + _pData->getMeasurement().getDuration().toString("ss") + "s ";

    for (int ixAllData = 0; ixAllData < _pData->getRaw()->getRawDataVector().size(); ixAllData++)
    {
        offlineDataX.append(_pData->getRaw()->getRawDataVector().at(ixAllData).getX() * _pController->hertzMultiplicator);
        offlineDataY.append(_pData->getRaw()->getRawDataVector().at(ixAllData).getY());
        offlineThresholdY.append(_pData->getRaw()->getRawDataVector().at(ixAllData).getThreshold());
        offlineState.append(_pData->getRaw()->getRawDataVector().at(ixAllData).isConcentration());
    }

    //Connections in UIController
    emit sendOfflineData(offlineDataX, offlineDataY, offlineThresholdY, offlineState, measurementTime, measurementDate, measurementDuration);

}

void MainHandler::fillAnalyseTable()
{
    _pResults->createStatistics(_pController->getCalcDiffID());
    int listElementCount = _pResults->Staterow.size();

    for(int ixStateRow = 0; ixStateRow < listElementCount; ixStateRow++)
    {
        int partStartMS = 0;
        if(ixStateRow < listElementCount - 3)
        {
            partStartMS = _pResults->_mStateStarts[ixStateRow]* _pController->hertzMultiplicator;
        }
        QString partstart = _pResults->Staterow.operator [](ixStateRow).getStartTime().toString("mm:ss");
        QString partend = _pResults->Staterow.operator [](ixStateRow).getStopTime().toString("mm:ss");
        QString partstate = _pResults->Staterow.operator [](ixStateRow).getState();

        if(partstate.toUtf8() == "concentration")
        {
           partstate = "/\\";

           if(ixStateRow >= listElementCount -3)
           {
               partstate = "total /\\";
           }
        }
        else if(partstate.toUtf8() == "relaxation")
        {
           partstate = "\\/";

           if(ixStateRow >= listElementCount -3)
           {
               partstate = "total \\/";
           }
        }


        quint16 corrPer = _pResults->Staterow.operator [](ixStateRow).getPercentageCorrect();
        quint16 transPer = _pResults->Staterow.operator [](ixStateRow).getPercentageTransit();
        quint16 falsePer = _pResults->Staterow.operator [](ixStateRow).getPercentageFalse();
        QString min = QString::number(_pResults->Staterow.operator [](ixStateRow).getMin(),'f',1);
        QString max = QString::number(_pResults->Staterow.operator [](ixStateRow).getMax(),'f',1);
        QString mean = QString::number(_pResults->Staterow.operator [](ixStateRow).getMean(),'f',1);
        QString range = QString::number(_pResults->Staterow.operator [](ixStateRow).getRange(),'f',1);
        QString diff = _pResults->Staterow.operator [](ixStateRow).getDifficulty();
        QString threshMax = QString::number(_pResults->Staterow.operator [](ixStateRow).getThresholdMax(),'f',1);
        QString threshMin = QString::number(_pResults->Staterow.operator [](ixStateRow).getThresholdMin(),'f',1);
        QString points = QString::number(_pResults->Staterow.operator [](ixStateRow).getPoints());

        if(ixStateRow < listElementCount -3)
        {
            //Connections in UIAnalyseTablePart
            emit addStateRow(partstart, partStartMS, partend, partstate, corrPer, transPer, falsePer, min, max, mean, range, diff, threshMax, threshMin, points);
        }
        else if(ixStateRow < listElementCount -1)
        {
            //Connections in UIAnalyseTablePart
            emit addTotalRow(partstart, partend, partstate, corrPer, transPer, falsePer, min, max, mean, range, diff, threshMax, threshMin, points, "middle");
        }
        else
        {
            //Connections in UIAnalyseTablePart
            emit addTotalRow(partstart, partend, partstate, corrPer, transPer, falsePer, min, max, mean, range, diff, threshMax, threshMin, points, "bottom");
        }
    }
}

void MainHandler::changeTableHeader()
{
    emit tableHeaderChanged();
}
