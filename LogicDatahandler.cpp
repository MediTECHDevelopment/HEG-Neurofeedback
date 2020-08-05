#include "logicdatahandler.h"

#include "controller.h"
#include "classstats.h"

//raw data is included through data
//sample is included through raw data
//data is included through stats

DataHandler::DataHandler(Controller *controller_pointer, Statistics *Results_pointer)
{
    _pController        = controller_pointer;
    _pResults           = Results_pointer;
}
/**
 * @brief DataHandler::saveData is the method where the save operation is prepared
 * @param currentClient is the client under which the measurement should be saved
 */
bool DataHandler::saveData(Client currentClient, Data *Data_pointer)
{
    _pController->currentClientID = currentClient.getID();
    //If the user did not choose a client he need to choose one. direct link to open database
    if (currentClient.setClientPath().isEmpty())
    {
        emit _pController->showMessageInQml(tr("Please choose a Client"), tr("You did not choose any Client in the Database. \n\n If you want to save a measurement, please select a Client in your Database"));
        emit forwardingToDatabase();
        return false;
    }

    //Creating / checking the  Directory where the measurement get saved
    QString _saveFilename = _pController->savepath+currentClient.setClientPath();
    QDir dir(_saveFilename);


    if(dir.mkpath(_saveFilename)==false)
    {
        emit _pController->showMessageInQml(tr("Problem creating the Directory"), tr("Error, unable to create the clients saving directory!"));
        return false;
    }

    _saveFilename.append("/"+Data_pointer->getMeasurement().setMeasurementPath());


    if (writeData(&_saveFilename, currentClient, Data_pointer) == false)
    {
        emit _pController->showMessageInQml(tr("Unable to open file"), tr("Error, more Information in your Logfile"));
        return false;
    }
    else
    {
        _pController->measurementisSaved=true;
        emit _pController->showMessageInStatusBarLeft(tr("Data Saved"), 2000);
        emit updateDatabasedialog(currentClient);
    }
    return true;
}
/**
 * @brief DataHandler::saveData is the method where the data is saved to the filepath depending on the client
 * @param savefilename is the savefilepath
 * @param currentClient is the client who performed the training.
 * @return
 */
bool DataHandler::writeData(QString *savefilePath, Client currentClient, Data *Data_pointer)
{
    QFile file(*savefilePath);

    if (!file.open(QIODevice::WriteOnly)) {
        emit _pController->showMessageInQml(tr("Problem saving the Measurement"), tr("Error,")+file.errorString());
        return false;
    }

    QDataStream outputText(&file);
    outputText<<QString("[Metadata]");
    outputText<<QString("Samplerate=\t")+QString(QString::number(Data_pointer->getSamplesPerSecond()));
    outputText<<QString("ClientID=\t")+QString(QString::number(currentClient.getID()));
    outputText<<QString("MeasurementDate=\t")+QString(Data_pointer->getMeasurement().getDate().toString("yyyy.MM.dd"));
    outputText<<QString("MeasurementTime=\t")+QString(Data_pointer->getMeasurement().getTime().toString("hh:mm:ss:zzz"));
    outputText<<QString("TotalDuration  =\t")+QString(Data_pointer->getMeasurement().getDuration().toString("hh:mm:ss:zzz"));

    outputText<<QString("[ConcentrationStates]");
    outputText<<Data_pointer->getStates()->size();
    for(int iConcStateVector=0;iConcStateVector<Data_pointer->getStates()->size();iConcStateVector++)
    {
        outputText<<QString("Statechange=\t")+QString(Data_pointer->getStates()->operator [](iConcStateVector).toString());
    }
    outputText<<QString("[Notes]");
    outputText<<QString(_pController->getNotes());

    outputText<<QString("[Statistics]");
    outputText<<QString("startTime_stopTime_State_percentCorrect_percentTransit_percentFalse_min_max_mean_range_points_Difficulty 1:super easy - 5:super hard _ThresholdMax_ThresholdMin");
    outputText<<_pResults->Staterow.size();
    for(int iTrainingSplitsVector=0;iTrainingSplitsVector<_pResults->Staterow.size();iTrainingSplitsVector++)
    {
        outputText<<QString(_pResults->Staterow.at(iTrainingSplitsVector).toLine());
    }
    outputText<<QString("[Samples]");

    outputText<<QString("XValue\tYValue\tThreshold\tisConcentration\tDifficulty");
    outputText<<Data_pointer->getRaw()->getRawDataVector().size();
    for(int iSamples=0;iSamples<Data_pointer->getRaw()->getRawDataVector().size();iSamples++)
    {
        outputText<<Data_pointer->getRaw()->getRawDataVector().at(iSamples).getX()<<Data_pointer->getRaw()->getRawDataVector().at(iSamples).getY()<<Data_pointer->getRaw()->getRawDataVector().at(iSamples).getThreshold()<<Data_pointer->getRaw()->getRawDataVector().at(iSamples).isConcentration()<<Data_pointer->getRaw()->getRawDataVector().at(iSamples).getDifficulty();
    }

    file.close();

    return true;
}
/**
 * @brief DataHandler::loadDataHandler prepares the loadData event
 * emitted from Database client, measurement, load click

 * @param currentClient
 * @param currentMeasurement
 */
void DataHandler::loadData(Client currentClient, Data *Data_pointer)
{
    QString _openFilename = _pController->savepath+currentClient.setClientPath()+"/"+Data_pointer->getMeasurement().setMeasurementPath();

    if(_openFilename.isEmpty())
        return;
    else
    {
        if(readData(&_openFilename, Data_pointer) == false)     //functioncall & If!
        {
            emit _pController->showMessageInQml(tr("Unable to open file"), tr("Error, take a look in the LogFile"));
        }
        else
        {
            emit _pController->showMessageInStatusBarLeft(tr("Data succesfully loaded"), 2000);
        }
    }
}
/**
 * @brief DataHandler::readData is laoding the asked file and emiting the RawVector to sampleprocessing to set it as raw globaly
 * @param loadfilename, Data_pointer
 * @return
 */

bool DataHandler::readData(QString *loadfilename, Data *Data_pointer)
{
    QFile file(*loadfilename);
    if(!file.open(QIODevice::ReadOnly))
    {
        emit _pController->showMessageInQml(tr("Problem loading the Measurement"), tr("Error,")+file.errorString());
        return false;
    }
    QString line;
    QDataStream input(&file);

    input >>line;   //Metadata
    if(line == "[Metadata]")
    {
        QStringList prelineSub;

        input >>line;   //Samplerate
        prelineSub = line.split('=');
        if(prelineSub.first() == "Samplerate")
        {
            QString samplesPerSecond = prelineSub.last().mid(1,prelineSub.last().size());
            Data_pointer->setSamplesPerSecond(samplesPerSecond.toInt());
        }

        input>>line;
        prelineSub = line.split('=');
        if(prelineSub.first() == "ClientID")
        {
            QString clientID = prelineSub.last().mid(1,prelineSub.last().size());
            _pController->currentClientID = clientID.toInt();
        }
        input>>line;
        prelineSub = line.split('=');
        if(prelineSub.first() == "MeasurementDate")
        {
            Data_pointer->getMeasurement().setDate(QDate::fromString(prelineSub.last().mid(1,prelineSub.last().size()),"yyyy.MM.dd"));
        }

        input>>line;
        prelineSub = line.split('=');
        if(prelineSub.first() == "MeasurementTime")
        {
            Data_pointer->getMeasurement().setTime(QTime::fromString(prelineSub.last().mid(1,prelineSub.last().size()),"hh:mm:ss:zzz"));
        }

        input>>line;
        prelineSub = line.split('=');
        if(prelineSub.first() == "TotalDuration  ")
        {
            Data_pointer->getMeasurement().setDuration(QTime::fromString(prelineSub.last().mid(1,prelineSub.last().size()),"hh:mm:ss:zzz"));
        }
    }

    input>>line; //[ConcentrationStates]
    if(line == "[ConcentrationStates]")
    {
        int size;
        input >>size;

        for(int i=0; i<size;i++)
        {
            input >>line;
            QStringList prelineSub = line.split('=');

            QString tempString = prelineSub.last().mid(1,prelineSub.last().size());
            QStringList postlineSub = tempString.split("_");

            bool tempState;
            if(postlineSub.first() == "concentration")
            {
                tempState = true;
            }
            else
            {
                tempState = false;
            }

            Data_pointer->appendState(tempState,postlineSub.last().toInt());
        }
    }

    input>>line; //[Notes]
    if(line == "[Notes]")
    {
        input>>line;
        emit setNotepadNotes(line);;
    }

    input>>line; //[Statistics]
    if(line == "[Statistics]")
    {
        int size;
        input>>line;    //Description
        input>>size;
        for(int i=0;i<size;i++)
        {
            input>>line;
        }
        //Not neccessary now
        //pay attention one line is description
    }

    input >>line;   //[Samples]
    input >>line;  // Line with the description


    RawData newRaw;
    int XData;
    double YData,Threshold;
    bool Concentration;
    int Difficulty;

    int size;
    input >>size;
    for(int i=0;i<size;i++)
    {
        input>>XData>>YData>>Threshold>>Concentration>>Difficulty;
        newRaw.appendRawDataVector(XData,YData,Threshold,Concentration,Difficulty);
    }
    file.close();
    Data_pointer->setRawData(newRaw);
    return true;
}
/**
 * @brief DataHandler::saveAsCSV loads the required data out of the savefile and converts it into csv
 * @param exportClient is the client where the measurement is saved
 * @param exportMeasurement is the measurement which should be exported
 * saveAsCVS is opening the required File and simultanously writting the values in CSV format to the saveCSVFilename
 */
void DataHandler::saveAsCSV(Client exportClient, Measurement exportMeasurement, QString fileUrl)
{
    QString filePath = fileUrl.split("///").last().trimmed();
    QString fileName = exportClient.showClientString() + " " + exportMeasurement.setMeasurementPath().split(".").first() + ".csv";
    //QFile CSVSaveFile(filePath);
    QFile CSVSaveFile;
    QDir::setCurrent(filePath);
    CSVSaveFile.setFileName(fileName);

    if(CSVSaveFile.open(QIODevice::WriteOnly |QIODevice::Truncate))
    {
        QTextStream CSVSaveStream(&CSVSaveFile);

        CSVSaveStream  <<"[Metadata]"<<endl;

        QString _openFilename = _pController->savepath+exportClient.setClientPath()+"/"+exportMeasurement.setMeasurementPath();

        if(_openFilename.isEmpty())
        {
            return;
        }

        bool MetadataIsActive           = false;
        bool ConcentrationStateIsActive = false;
        bool NotesIsActive              = false;
        bool StatisticsIsActive         = false;

        QFile loadFile(_openFilename);
        if(!loadFile.open(QIODevice::ReadOnly | QIODevice::Text))
        {
            emit _pController->showMessageInQml(tr("Problem saving as CSV"), tr("Error,")+loadFile.errorString());
            return;
        }
        QString line;
        QDataStream loadStream(&loadFile);

        loadStream >> line;
        while(line  != "[Samples]")
        {
            if(line == "[Metadata]")
            {
                ConcentrationStateIsActive  = false;
                NotesIsActive               = false;
                StatisticsIsActive          = false;

                MetadataIsActive            = true;
            }

            if(line == "[ConcentrationStates]")
            {
                MetadataIsActive            = false;
                NotesIsActive               = false;
                StatisticsIsActive          = false;

                ConcentrationStateIsActive  = true;
                CSVSaveStream <<"[ConcentrationStates]"<<endl;
            }
            if(line == "[Notes]")
            {
                ConcentrationStateIsActive  = false;
                MetadataIsActive            = false;
                StatisticsIsActive          = false;

                NotesIsActive               = true;
                CSVSaveStream  <<"[Notes]"<<endl;
            }
            if(line =="[Statistics]")
            {
                ConcentrationStateIsActive  = false;
                MetadataIsActive            = false;
                NotesIsActive               = false;

                StatisticsIsActive          = true;
                CSVSaveStream  <<"[Statistics]"<<endl;
            }

            if(MetadataIsActive)
            {
                QStringList prelineSub;

                loadStream >> line;
                prelineSub= line.split('=');
                if(prelineSub.first() == "Samplerate")
                {
                    CSVSaveStream<<"Samplerate="<<";"<<prelineSub.last().trimmed()<<endl;
                }

                loadStream >> line;
                prelineSub = line.split('=');
                if(prelineSub.first() == "ClientID")
                {
                    CSVSaveStream<<"Client="<<";"<< exportClient.showClientString()<<endl;
                }

                loadStream >> line;
                prelineSub = line.split('=');
                if(prelineSub.first() == "MeasurementDate")
                {
                    CSVSaveStream<<"MeasurementDate="        <<";"<< prelineSub.last().trimmed()<<endl;
                }

                loadStream >> line;
                prelineSub = line.split('=');
                if(prelineSub.first() == "MeasurementTime")
                {
                    CSVSaveStream<<"MeasurementTime="        <<";"<< prelineSub.last().trimmed()<<endl;
                }

                loadStream >> line;
                prelineSub = line.split('=');
                if(prelineSub.first() == "TotalDuration  ")
                {
                    CSVSaveStream<<"TotalDuration  ="        <<";"<< prelineSub.last().trimmed()<<endl;
                }
            }
            if(ConcentrationStateIsActive)
            {
                int size;
                loadStream >>size;

                for(int i=0; i<size;i++)
                {
                    loadStream >> line;
                    CSVSaveStream<<"Statechange=;"<<line.split('=').last().replace("_",";")<<endl;
                }
            }
            if(NotesIsActive)
            {
                loadStream >> line;
                CSVSaveStream<< line.trimmed()<<endl;
                //statt trimmed() geht auch simplified
            }
            if(StatisticsIsActive)
            {
                int size;
                loadStream >> line;
                loadStream >> size;
                for(int i=0;i<size;i++)
                {
                    loadStream >> line;
                    CSVSaveStream<< line.replace("_",";")<<endl;
                }
            }
            loadStream >> line;
        }
        loadStream>>line;

        CSVSaveStream<<"[Samples]"<<endl;
        CSVSaveStream<<line.replace('\t',';')<<endl;  // Line with the description

        double XData,YData,Threshold;
        bool Concentration;
        int Difficulty;

        int size;
        loadStream >>size;
        for(int i=0;i<size;i++)
        {
            loadStream>>XData>>YData>>Threshold>>Concentration>>Difficulty;
            QString temp = QString::number(XData)+";"+QString::number(YData)+";"+QString::number(Threshold)+";"+QString::number(Concentration)+";"+QString::number(Difficulty);
            CSVSaveStream<<temp.replace('.',',')<<endl;
        }

        loadFile.close();
        CSVSaveFile.close();

        _pController->showMessageInQml(tr("Succesfully saved as .csv"), tr("File saved as: \n") + fileName + tr("\nat \n") + filePath);
    }
}
