#include "handlerdatabase.h"
#include "controller.h"
#include "classdata.h"

#include <QSettings>

HandlerDatabase::HandlerDatabase(Controller *controllerPointer, Data *datapointer, DataHandler *datahandlerPointer)
{
    _pClientVector  = new QVector<Client>;
    _pController = controllerPointer;
    _mClickedClientRow = 0;
    _mActiveClientRow = 0;

    _mClickedMeasurementRow = 0;
    _pData = datapointer;
    _pDataHandler = datahandlerPointer;

    connect(this, SIGNAL(saveAsCSVSignal(Client, Measurement, QString)), _pDataHandler, SLOT(saveAsCSV(Client, Measurement, QString)));
}
HandlerDatabase::~HandlerDatabase()
{
    delete _pClientVector;
}

void HandlerDatabase::reactivateLastActiveClient()
{
    //reactivate last active client----------------------
    findAndLoadClients();

    QSettings appSettings("MediTECH","HEG");
    if(_pClientVector->size() == 0)
    {
        appSettings.setValue("clickedClientRow", -1);
    }

    int clickedClientRow = appSettings.value("clickedClientRow").toInt();
    /*qInfo("------------------------");
    qInfo("active clicked");
    qInfo( QString::number(clickedClientRow).toUtf8() );
    qInfo("------------------------");*/

    if(clickedClientRow >=_pClientVector->size())
    {
        /*qInfo("---------------------------");
        qInfo("active client number to high");
        qInfo("---------------------------");*/
        clickedClientRow = -1;
        appSettings.setValue("clickedClientRow", -1);
    }

    if(clickedClientRow != -1)
    {
        _mClickedClientRow = clickedClientRow;
        acceptActivate();
    }

    //----------------------------------------------------
}

void HandlerDatabase::setNewClientBool(bool isNew)
{
    _mNewClient = isNew;
}

/**
 * @brief HandlerDatabase::setSelectedMeasurementRow sets _mClickedMeasurementRow
 * @param measurmentRow
 */
void HandlerDatabase::setSelectedMeasurementRow(int measurmentRow)
{
    //QML counts the listmodel-rows from 0!
    _mClickedMeasurementRow = measurmentRow;
}

/**
 * @brief HandlerDatabase::setSelectedClientRow sets __mClickedClientRow, NOT _mActiveClientRow!
 * @param clientRow
 */
void HandlerDatabase::setSelectedClientRow(int clientRow)
{
    //QML counts the listmodel-rows from 0!
    _mClickedClientRow = clientRow;
}

/**
 * @brief HandlerDatabase::getClient loads data and metainformation for the client with clientID
 * @param clientID
 * @return ClientVector of the Client with id clientID
 */
Client HandlerDatabase::getClient(int clientID)
{
    findAndLoadClients();
    for(int iClients = 0;iClients<_pClientVector->size();iClients++)
    {
        if(_pClientVector->at(iClients).getID() == clientID)
        {
            return _pClientVector->at(iClients);
        }
    }
    //Should never be reached
    Client Error;
    return Error;
}

/**
 * @brief HandlerDatabase::manageButtonsLayout manages the state of the databasebuttons
 * @param clientIsActive
 */
void HandlerDatabase::manageButtonsLayout(bool clientIsActive)
{
    if(clientIsActive == true)
    {
        emit newButtonActive(true);
        emit editButtonActive(true);
        emit deleteButtonActive(true);
        emit loadButtonActive(false);
        emit saveButtonActive(false);
        emit activateButtonActive(false);
        emit exportButtonActive(false);

        if(_pController->measurementIsActive == false && _pController->realtimePlotting == true && _pController->pausedMeasurement == false)
        {
            emit activateButtonActive(true);
        }

        //isSaved is changed after realtimeplotting is over, if you save it is saved as true
        if(_pController->measurementisSaved == false)
        {
            emit saveButtonActive(_pController->realtimePlotting);
        }
    }
    else if(clientIsActive == false) // Means Measurement is Active
    {
        emit newButtonActive(false);
        emit editButtonActive(false);
        emit saveButtonActive(false);
        emit activateButtonActive(false);

        if(_pController->measurementIsActive == false)
        {
            emit loadButtonActive(true);
            emit exportButtonActive(true);
        }
    }
}

/**
 * @brief HandlerDatabase::acceptClientChange: Depending on the bool for editing or creating a new Client the accept Button is updating the Client and its personal file or creating a new Directory and a new personal file
 */
void HandlerDatabase::acceptClientChange(QString prename, QString surname, QString dayOfBirth, QString gender, int threshold, QString videoPath)
{
    if(prename == "" || surname == "")
    {
        _pController->showMessageInQml(tr("Unable to set a new Client"),tr("Error, please fill in the details"));
    }
    else
    {
        int indexForActiveClientAfterSave = _mClickedClientRow;

        QDir directoryClientPath;
        QString source;

        qInfo("client vector size: " + QString::number( _pClientVector->size() ).toUtf8() );

        if(_mNewClient == true)
        {
            _mClient.setClient(findID(), prename, surname, dayOfBirth, gender);
            _pClientVector->append(_mClient);

            indexForActiveClientAfterSave = _pClientVector->size() - 1;
        }
        else
        {
            //Change from *_pCurrentRow to _mClickedClientRow
            _mClient.setClient(_pClientVector->at(_mClickedClientRow).getID(), prename, surname, dayOfBirth, gender);

            //Change from *_pCurrentRow to _mClickedClientRow
            _pClientVector->replace(_mClickedClientRow, _mClient);
        }

        _mClientVidPath = videoPath;
        _mClientThreshold = threshold;

        source = _pController->savepath + _mClient.setClientPath();
        directoryClientPath.setPath(source);
        if(directoryClientPath.mkpath(source)!=true)
        {
            _pController->showMessageInQml(tr("Unable to create the clients directory"),tr("Error, please contact the Support"));
            return;
        }
        source.append(".clientdat");
        createClientDatFile(source);

        //update Database is the emit which updates the Dialog Database Window
        findAndLoadClients();

        refocus(_pClientVector->at(_mClickedClientRow));

        _mNewClient = false;

        _mClickedClientRow = indexForActiveClientAfterSave;
        acceptActivate();
    }
}

/**
 * @brief HandlerDatabase::createClientDatFile creates a profileFile with the actual Client and the actual videoPath and Threshold
 * @param vClientPath is the clientPath, where the settings should be saved
 */
void HandlerDatabase::createClientDatFile(QString vClientPath)
{
    QFile file(vClientPath);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
    {
        _pController->showMessageInQml(tr("Problem saving the Client"), tr("Error,")+file.errorString());
        return;
    }
    QTextStream outputText(&file);
    outputText<<"clientID=\t"   <<_mClient.getID()<<endl;
    outputText<<"prename=\t"    <<_mClient.getPrename()<<endl;
    outputText<<"surname=\t"    <<_mClient.getSurname()<<endl;
    outputText<<"birthday=\t"   <<_mClient.getDayOfBirth().toString("yyyyMMdd")<<endl;
    outputText<<"Gender=\t"     <<_mClient.getGender()<<endl;
    outputText<<"[Settings]"    <<endl;

    outputText<<"VideoPath=\t"  <<_mClientVidPath<<endl;
    outputText<<"Threshold=\t"  <<_mClientThreshold<<endl;
    outputText<<"[End]"<<endl;

    file.close();
}
/**
 * @brief HandlerDatabase::findID is searching an ID for the new Client
 * @param newSlot is starting with 1. So thats the first possible ID
 * @return the free Client ID
 * IMPORTANT If I want the really last one, so If the user deleted the last, I need to Use the registry, like with QSettings in the MainWindow
 */
int HandlerDatabase::findID()
{
    int newSlot = 1;
    for(int clients = 0; clients<_pClientVector->size();clients++)
    {
        if ((_pClientVector->at(clients).getID() >= newSlot) == true)
        {
            newSlot = _pClientVector->at(clients).getID() + 1;
        }
    }
    return newSlot;
}

/**
 * @brief HandlerDatabase::showDatabase calls findAndLoadClients if the database is activated, otherwise calls closeDatabase
 * @param databaseIsActive
 */
void HandlerDatabase::showDatabase(bool databaseIsActive)
{
    if(databaseIsActive)
    {
        closeDatabase();
    }
    else
    {
        findAndLoadClients();
    }
}

/**
 * @brief HandlerDatabase::closeDatabase clears the Client-Vector
 */
void HandlerDatabase::closeDatabase()
{
    _pClientVector->clear();
}

/**
 * @brief HandlerDatabase::singleClickClients sets the maininformation in the database and calls manageButtonsLayout and loadFilesFromClient
 */
//called from QML (UIChooseClientPart)
void HandlerDatabase::singleClickClients()
{
    emit setClientMainInformation(_pClientVector->at(_mClickedClientRow).getPrename(), _pClientVector->at(_mClickedClientRow).getSurname(), _pClientVector->at(_mClickedClientRow).getDayOfBirth().toString("yyyy-MM-dd"), _pClientVector->at(_mClickedClientRow).getGender());
    manageButtonsLayout(true);

    //Is loading the TrainingFiles from the Client
    loadFilesFromClient(_pClientVector->at(_mClickedClientRow));

}

/**
 * @brief HandlerDatabase::singleClickMeasurement calls manageButtonsLayout
 */
//called from QML (UIClientMeasurementPart)
void HandlerDatabase::singleClickMeasurement()
{
    manageButtonsLayout(false);
}

/**
 * @brief HandlerDatabase::editButton get old client-information and send it to clientbase
 */
//called from QML (UIDatabaseManagePart)
void HandlerDatabase::editButton()
{
    _mNewClient = false;
    QString oldVidPath = "";
    int oldThreshold = 0;
    _mPreEditClient = _pClientVector->at(_mClickedClientRow);

    //Connections in main.qml
    emit _pController->changeWindowTitle("Edit "+_mPreEditClient.getPrename()+" "+ _mPreEditClient.getSurname());

    // Settings are not part of Client and musst be read from file!
    //Save the old Settings
    QString oldPath = _pController->savepath + _mPreEditClient.setClientPath()+".clientdat";
    QFile file(oldPath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        _pController->showMessageInQml(tr("Problem loading the Settings"), tr("Error,")+file.errorString());
        return;
    }
    QString line;
    QTextStream input (&file);
    int i = 0;
    while ( (line = input.readLine() ) != "[End]" && (line = input.readLine() ) != "")
    {
        i++;
        if(line.split("=").first().trimmed() == "VideoPath")
        {
            oldVidPath = line.split("=").last().split('/').last().split('.').first().trimmed();
        }
        if(line.split("=").first().trimmed() == "Threshold")
        {
            oldThreshold = line.split("=").last().trimmed().toInt();
        }
    }
    file.close();

    //Connections in UIClientBase
    emit showEditClientBase(_mPreEditClient.getPrename(), _mPreEditClient.getSurname(), _mPreEditClient.getDayOfBirth().toString("dd"),  _mPreEditClient.getDayOfBirth().toString("MM"), _mPreEditClient.getDayOfBirth().toString("yyyy"), _mPreEditClient.getGender(), oldThreshold, oldVidPath);

}

/**
 * @brief HandlerDatabase::deleteButton triggers decisionboxes to delete measurements and clients.
 */
void HandlerDatabase::deleteButton()
{
    //Deletes the Client and all it's measurements
    if(_mClickedMeasurementRow == -1 || _mMeasurementVector.size() == 0)
    {
        //a client can't be deleted, while he has measurements!
        //Normaly it automaticaly choose the first Client as selected, safety feature, but not necessary
        if(_mClickedClientRow == -1)
        {
            _pController->showMessageInQml(tr("Unable to delete Client"),tr("Error, please select a Client"));
        }
        else
        {
            //Connections in UIDataBase
            emit deleteButtonDecisionBox(tr("Confirm your delete"),
                                         tr("You requested to delete the client:\n\n") + _pClientVector->at(_mClickedClientRow).getPrename()+" "+_pClientVector->at(_mClickedClientRow).getSurname()+".\n\n"
                                         + tr("Do you really want to delete this client?"));
        }
    }
    //Deletes the Measurement
    else if(_mClickedMeasurementRow != -1 && _mMeasurementVector.size() > 0 )
    {
        //Connections in UIDataBase
        emit deleteButtonMeasurementDecisionBox(tr("Confirm your delete"),
                                                tr("You requested to delete the measurement:\n\n") + _mMeasurementVector.at(_mClickedMeasurementRow).showString() +".\n\n"
                                                + tr("Do you really want to delete this measurement?"));
    }
}

//called from the deleteClientDialog in UIDataBase
void HandlerDatabase::deleteClientDecision(int decision)
{
    switch (decision)
    {
    case 1: //yes
    {
        QSettings appSettings("MediTECH","HEG");
        int activeClientRow = appSettings.value("clickedClientRow").toInt();

        qInfo("delete");
        if(activeClientRow == _mClickedClientRow)
        {
            qInfo("deleted active");
            appSettings.setValue("clickedClientRow", -1);
            emit updateActiveClientStatus(false);
        }
        if(activeClientRow > _mClickedClientRow)
        {
            qInfo("deleted below active");
            activeClientRow =   activeClientRow - 1;
            appSettings.setValue("clickedClientRow",activeClientRow);
        }

        QString deleteClient = _pClientVector->at(_mClickedClientRow).setClientPath();
        QDir directoryPath;
        QString deleteClientPath = _pController->savepath+deleteClient;
        directoryPath.setPath(deleteClientPath);
        deleteClientPath.append(".clientdat");

        //removeRecursively means that everything get deleted which is under this directory
        if (directoryPath.removeRecursively()==false || directoryPath.remove(deleteClientPath)==false)
        {
            _pController->showMessageInQml(tr("Unable to delete the Client with all its files"),tr("Error, please read the logFile, a file is still in use and it is not deleted."));
        }
        _pClientVector->removeAt(_mClickedClientRow);

        _mMeasurementVector.clear();

        emit clearMeasurements();

        emit setClientMainInformation("", "", "", "");

        _mActiveClientRow = activeClientRow;

        updateClientView();

        /*if(_mActiveClientRow != -1)     //reset active_Client-Stuff
        {
            _mActiveClientRow = -1;
            _pController->setVideoPath("");
            _pController->setThresholdValue(100);
            _pController->showMessageInStatusBarClientLabel("");

            emit _pController->changeWindowTitle(tr("HEG"));
        }*/
        break;
    }
    case 2: //no
        break;
    }
}

//called from the deleteMeasurementDialog in UIDataBase
void HandlerDatabase::deleteMeasurementDecision(int decision)
{
    switch (decision)
    {
    case 1: //yes
    {
        QString deleteMeasurement = _mMeasurementVector.at(_mClickedMeasurementRow).setMeasurementPath();
        QString currentClient = _pClientVector->at(_mClickedClientRow).setClientPath();
        QDir filePath;
        filePath.setPath(_pController->savepath+currentClient+"/");
        if (filePath.remove(deleteMeasurement)==false)
        {
            _pController->showMessageInQml(tr("Unable to delete the Measurement"),tr("Error, please read the logFile, the file is not deleted."));
        }

        _mMeasurementVector.removeAt(_mClickedMeasurementRow);

        updateMeasurementList();
        break;
    }
    case 2: //no
        break;
    }
}

/**
 * loadCLients is searching for all files with the ending clientdat in the data directory
 * and pass the input of these files to the ClientVector.
 */
void HandlerDatabase::findAndLoadClients()
{
    _pClientVector->clear();

    QDir clientdatPath;
    QString clientsource (_pController->savepath);
    clientdatPath.setPath(clientsource);

    //Filter for the clientdat Files
    QStringList filters;
    filters << "*.clientdat";
    clientdatPath.setNameFilters(filters);

    //The QStringList shows all the Files with this ending
    QStringList clientdats = clientdatPath.entryList(QDir::Files | QDir::NoDotAndDotDot);
    for(int clients = 0;clients<clientdats.size();clients++)
    {
        QString _vClientPathString (clientdatPath.path()+ "/" + clientdats.at(clients));
        if(_vClientPathString.isEmpty())
        {return;}

        QFile file(_vClientPathString);
        if(!file.open(QIODevice::ReadOnly | QIODevice::Text))
        {
            _pController->showMessageInQml(tr("Problem loading a Client"), tr("Error, ")+file.errorString());
            return;
        }
        QString line;
        QTextStream input(&file);
        do
        {
            line = input.readLine();
            _mClient.clientFromLine(line);

        }while(line != "[Settings]" );

        file.close();
        if(_mClient.isValid() == false)
        {
            _pController->showMessageInQml(tr("Problem loading a Client"), tr("Error, some Values are default or empty"));
        }
        else
        {
            _pClientVector->append(_mClient);
        }
    }
    //This method is showing the QVector in the Database-UI


    updateClientView();
}

/**
 * Gets called from the load Clients method at the end, it loads the Clients from the QVector into the ListWidget
 */
void HandlerDatabase::updateClientView()
{
    //Connections in UIChooseClientPart

    emit clearClients();
    for(int iClients = 0; iClients < _pClientVector->size(); iClients++)
    {
        //Slot for the Signal in UIChooseClient, connected via Connections
        emit showClients(_pClientVector->at(iClients).getPrename(), _pClientVector->at(iClients).getSurname());
    }

    //Important, because a Client should be auto selected, makes it easier for the buttons.
    //Without it need to be checked everytime if ClientList is -1 means not selected or selected
    checkNoClientLayout();

    qInfo("client size: " + QString::number( _pClientVector->size() ).toUtf8() );

    if(_pClientVector->size()>0)
    {
        int clientToHighlight = _mActiveClientRow;

        if(clientToHighlight == -1)
        {
            clientToHighlight = 0;
        }

        if(clientToHighlight >= _pClientVector->size())
        {
            clientToHighlight = _pClientVector->size() -1;
        }

        //slot in UIChooseClientPart, connected via Connections
        //Connections in UIChooseClientPart
        emit setHighlightedClientRow(clientToHighlight);
        singleClickClients();
    }
}

/**
 * changed Client is set in ClientDialog, the new or edited user should be shown.
 */
void HandlerDatabase::refocus(Client changedClient)
{
    //Connections in UIClientDataMainPart
    emit setClientMainInformation(changedClient.getPrename(), changedClient.getSurname(), changedClient.getDayOfBirth().toString("yyyy-MM-dd"), changedClient.getGender());

    loadFilesFromClient(changedClient);

    // set highlighted Client to changed Client -> should be managed by QML!
}

/**
 * loadFilesfromClient is loading the files from the given client
 */
int HandlerDatabase::loadFilesFromClient(Client clientForFiles)
{
    _mMeasurementVector.clear();

    QDir directoryFilePath;
    QString source (_pController->savepath+clientForFiles.setClientPath()+"/");
    directoryFilePath.setPath(source);

    QStringList files = directoryFilePath.entryList(QDir::Files);

    for(int fileNr = 0; fileNr<files.size(); fileNr++)
    {
        _mMeasurement.stringToMeasurement(files.at(fileNr));
        _mMeasurementVector.append(_mMeasurement);
    }

    //updating UI-Measurement-List of the Client
    updateMeasurementList();
    return _mMeasurementVector.count();
}
/**
 * Gets called from the load FilesfromClient method at the end, it loads the Clients from the QVector into the ListWidget
 */
void HandlerDatabase::updateMeasurementList()
{
    //Connections in UIClientMeasurementPart
    emit clearMeasurements();
    for(int i=0;i<_mMeasurementVector.size();i++)
    {
        //Slot in UIClientMeasurementPart, connected via Connections
        emit appendClientMeasurement(_mMeasurementVector.at(i).showString());
    }

    if(_mMeasurementVector.size() <= 0)
    {
        emit lastMeasurementDeleted();
    }

}

/**
 * @brief HandlerDatabase::loadButton asks, if the user wants to safe the measurement while it is unsafed
 */
void HandlerDatabase::loadButton()
{
    // If the past Measurement is not saved, the programm asks the USer if he want to save it before loading another
    if(_pController->measurementisSaved == false)
    {
        //Connections in UIController
        emit loadButtonDecisionBox(tr("You did not save your Measurement \n") + tr("Do you really want to load a Measurement, without saving?\n"));
        return;     //Part 2 is called in loadButtonDecision, if needed!
    }
    loadButtonPart2();
    //Connections in UIController
    emit loadAction();
}

void HandlerDatabase::loadButtonDecision(int decision)
{
    switch (decision)
    {
    case 1: //yes
        _pController->measurementisSaved = true;
        break;
    case 2: //no
        return;
    }
    loadButtonPart2();
    //Connections in UIController
    emit loadAction();
}

void HandlerDatabase::loadButtonPart2()
{
    //-1 means no row is selected
    if(_mClickedMeasurementRow == -1 || _mClickedClientRow == -1)
    {
        _pController->showMessageInQml(tr("Please choose a Client and a Measurement"),tr("Error, please select a Client and a Measurement"));
        return;
    }

    _pData->getStates()->clear();

    _pData->setMeasurement(_mMeasurementVector.at(_mClickedMeasurementRow));
    _pDataHandler->loadData(_pClientVector->at(_mClickedClientRow),_pData);


    //Connections in main.qml
    emit _pController->changeWindowTitle(getClient(_pController->currentClientID).showClientString() + " | " + _pData->getMeasurement().showString());
}

void HandlerDatabase::saveButton()
{
    //if no row selected
    if(_mClickedClientRow == -1)
    {
        _pController->showMessageInQml(tr("Please choose a Client"),tr("Error, please select a Client"));
        return;
    }
    //Connections in UIDatabaseManagePart
    emit saveButtonDecisionBox(tr("You requested to save the measurement for client :\n\n") + _pClientVector->at(_mClickedClientRow).getPrename()+" "+_pClientVector->at(_mClickedClientRow).getSurname()+".\n\n" + tr("Do you also want to save your Video and last Threshold for this client?"));
}

void HandlerDatabase::saveButtonDecision(int decision)
{
    //want to save vidPath & threshold?
    switch (decision)
    {
    case 1: //no
    {
        _pDataHandler->saveData( _pClientVector->at(_mClickedClientRow),_pData);

        _pController->measurementisSaved = true;
        _pController->notesAreSaved = true;
        updateMeasurementList();
        break;
    }
    case 2:    //yes
    {
        _pDataHandler->saveData( _pClientVector->at(_mClickedClientRow),_pData);
        saveClientsSettings(_pClientVector->at(_mClickedClientRow));

        _pController->measurementisSaved = true;
        _pController->notesAreSaved = true;
        loadFilesFromClient(_pClientVector->at(_mClickedClientRow));
        break;
    }
    case 3:
        break;
    }
}

void HandlerDatabase::saveMeasurementForActiveClient()
{
    closeDatabase();
    findAndLoadClients();

    _pDataHandler->saveData( _pClientVector->at(_mActiveClientRow),_pData);
    saveClientsSettings(_pClientVector->at(_mActiveClientRow));

    _pController->measurementisSaved = true;
    _pController->notesAreSaved = true;
    loadFilesFromClient(_pClientVector->at(_mActiveClientRow));

    _pController->pausedMeasurement = false;

    closeDatabase();
}

/**
 * @brief HandlerDatabase::acceptActivate sets _mActiveClientRow and loads Video, Threshold etc vor the activated Client
 */
void HandlerDatabase::acceptActivate()
{
    if(_mClickedClientRow == -1)
    {
        _pController->showMessageInQml(tr("Please choose a Client"),tr("You did not select a Client"));
        return;
    }
    else
    {
        //what happens if I start a new measurement, it needs to set 0
        _mActiveClientRow = _mClickedClientRow;
        _pController->currentClientID = _pClientVector->at(_mClickedClientRow).getID();

        _pController->m_numberOfResultsOfActiveClient = loadFilesFromClient( _pClientVector->at(_mClickedClientRow) );

        _pController->m_activeClientIdentfier = _pClientVector->at(_mClickedClientRow).getPrename()+_pClientVector->at(_mClickedClientRow).getSurname();

        loadClientsSettings(_pClientVector->at(_mClickedClientRow));

        QSettings appSettings("MediTECH","HEG");
        appSettings.setValue("clickedClientRow", _mClickedClientRow);

        QString settingsKey = _pController->m_activeClientIdentfier+"lastUsedURL";
        QString lastURL = appSettings.value(settingsKey).toString();

        qInfo("db key: " + settingsKey.toUtf8());
        qInfo("db last url: " + lastURL.toUtf8());

        if(lastURL.toUtf8() != "")
        {
            qInfo("has url");
            _pController->setLastUsedURL(lastURL);
        }
        else
        {
            qInfo("current Last 1");
            _pController->setLastUsedURL("https://www.google.de/");
        }

        emit _pController->loadNewURL(_pController->getLastUsedURL());

        clientChanged(_pClientVector->at(_mClickedClientRow));
        closeDatabase();

        emit updateActiveClientStatus(true);
    }
}

/**
 * @brief MainWindow::clientChanged is called when the user has set a client as active
 * @param currentClient
 */
void HandlerDatabase::clientChanged(Client currentClient)
{
    _pController->showMessageInStatusBarClientLabel(currentClient.showClientString());

    //Connections in main.qml
    emit _pController->changeWindowTitle(tr("HEG Training ")+ currentClient.getPrename() + " " + currentClient.getSurname());
    emit activeClientChanged( currentClient.getPrename(),currentClient.getSurname() );
}

/**
* @brief databaseDialog::loadClientsSettings is used to load the old saved Client settings of the user
* @param client is used to get the path where the settings are saved
*/
void HandlerDatabase::loadClientsSettings(Client client)
{
    QDir clientdatPath;
    QString clientsource (_pController->savepath+client.setClientPath()+".clientdat");
    clientdatPath.setPath(clientsource);

    QFile file(clientsource);
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        _pController->showMessageInQml(tr("Problem loading the Settings"), tr("Error, ")+file.errorString());
        return;
    }
    QString line;
    QTextStream input(&file);
    do
        line = input.readLine();
    while(line!="[Settings]");
    do
    {
        line = input.readLine();
        /*if(line.split('=').first()=="VideoPath")
        {
            if(line.split('=').last().trimmed() != "")
            {
                _pController->setVideoPath(line.split('=').last().trimmed());
            }
            else
            {
                _pController->setVideoPath("");
                _pController->showMessageInQml(tr("VideoPath does not exist"), tr("Error, no Media is set or the last Video does not exist \n"));
            }
        }*/
        if(line.split('=').first()=="Threshold")
        {
            _pController->setThresholdValue(line.split('=').last().trimmed().toDouble());
        }
    }while(line != "[End]" && line != "");

    file.close();
}

/**
 * @brief databaseDialog::saveClientsSettings is used to save the client settings
 * @param client is used to generate the current client path
 */
void HandlerDatabase::saveClientsSettings(Client client)
{
    QDir clientdatPath;
    QString clientsource (_pController->savepath+client.setClientPath()+".clientdat");
    clientdatPath.setPath(clientsource);

    QFile file(clientsource);
    if(!file.open(QIODevice::ReadWrite | QIODevice::Text))
    {
        _pController->showMessageInQml(tr("Problem saving the Settings"), tr("Error, ")+file.errorString());
        return;
    }
    QTextStream outputText(&file);
    //don't forget the endlines!!!
    outputText<<"clientID=\t"<<client.getID()<<endl;
    outputText<<"prename=\t"<<client.getPrename()<<endl;
    outputText<<"surname=\t"<<client.getSurname()<<endl;
    outputText<<"birthday=\t"<<client.getDayOfBirth().toString("yyyyMMdd")<<endl;
    outputText<<"Gender=\t"<<client.getGender()<<endl;
    outputText<<"[Settings]"<<endl;
    outputText<<"VideoPath=\t"<<_pController->videoPath<<endl;
    outputText<<"Threshold=\t"<<_pController->getThreshold()<<endl;
    outputText<<"[End]"<<endl;
}

//called in UIClientMeasurementPart
void HandlerDatabase::exportToCSV()
{
    if(_mClickedClientRow == -1)
    {
        _pController->showMessageInQml(tr("Unable to export Measurement"), tr("Error, please select a Measurement"));
    }
    else
    {
        _mMeasurement = _mMeasurementVector.at(_mClickedMeasurementRow);
        //Connections in UIDataBase
        emit saveAsCSVDecision();
    }
}

//called in UIDataBase
void HandlerDatabase::getCSVFilename(QString fileUrl)
{
    //connect at the beginning
    emit saveAsCSVSignal(_pClientVector->at(_mClickedClientRow), _mMeasurement, fileUrl);
}

void HandlerDatabase::checkNoClientLayout()
{
    if(_pClientVector->size()==0)
    {
        //Everything disabled, if there is no Client in the Database
        //Slot in UIDataBaseManagePart, connected via Connections
        emit noClientLayout();
    }
}
