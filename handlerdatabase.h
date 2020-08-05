#ifndef HANDLERDATABASE_H
#define HANDLERDATABASE_H

#include <QObject>
#include <QVector>
#include <QVariant>
#include <QFile>

#include "logicdatahandler.h"
class Controller;
class Data;

/*
 *  Interface to the Database (UI), provides the backend for the Buttons and send the Data for the Client-/Measurmentmodels. It also includes the handling for the Clientbase
 */

class HandlerDatabase : public QObject
{
    Q_OBJECT

public:
    HandlerDatabase(Controller *controllerPointer, Data *datapointer, DataHandler *datahandlerPointer);
    ~HandlerDatabase();

    Q_INVOKABLE void saveMeasurementForActiveClient();
    Q_INVOKABLE void saveClientsSettings(Client client);
    Q_INVOKABLE void loadClientsSettings(Client client);
    Q_INVOKABLE void createClientDatFile(QString vClientPath);
    Q_INVOKABLE Client getClient(int clientID);
    Q_INVOKABLE void exportToCSV();
    Q_INVOKABLE void saveButton();
    Q_INVOKABLE void acceptActivate();
    Q_INVOKABLE void loadButton();
    Q_INVOKABLE void setSelectedMeasurementRow(int measurementRow);
    Q_INVOKABLE void setSelectedClientRow(int clientRow);
    Q_INVOKABLE void findAndLoadClients();
    Q_INVOKABLE void deleteButton();
    Q_INVOKABLE void editButton();
    Q_INVOKABLE void singleClickClients();
    Q_INVOKABLE void closeDatabase();
    Q_INVOKABLE void showDatabase(bool databaseIsActive);
    Q_INVOKABLE int findID();
    Q_INVOKABLE void acceptClientChange(QString prename, QString surname, QString dayOfBirth, QString gender, int threshold, QString videoPath);
    Q_INVOKABLE void saveButtonDecision(int decision);
    Q_INVOKABLE void loadButtonDecision(int decision);
    Q_INVOKABLE void deleteClientDecision(int decision);
    Q_INVOKABLE void deleteMeasurementDecision(int decision);
    Q_INVOKABLE void getCSVFilename(QString fileUrl);
    Q_INVOKABLE void setNewClientBool(bool isNew);
    Q_INVOKABLE void singleClickMeasurement();
    Q_INVOKABLE void reactivateLastActiveClient();
private:
    QVector<Client> *_pClientVector;
    Controller *_pController;
    Measurement _mMeasurement;
    QVector<Measurement> _mMeasurementVector;
    int _mActiveClientRow;
    int _mClickedClientRow;
    int _mClickedMeasurementRow;
    Client _mClient;
    Client _mPreEditClient;
    bool _mNewClient;
    QString _mClientVidPath;
    int _mClientThreshold;
    Data *_pData;
    DataHandler *_pDataHandler;
    QString _moldVidPath;
    int _moldThreshold;

    int loadFilesFromClient(Client clientForFiles);
    void updateMeasurementList();
    void clientChanged(Client currentClient);
    void loadButtonPart2();
    void updateClientView();
    void checkNoClientLayout();
    void manageButtonsLayout(bool clientIsActive);

private slots:
    void refocus(Client changedClient);

signals:
    void saveAsCSVSignal(Client,Measurement, QString);
    void showClients(QVariant prename, QVariant surname);
    void clearClients();
    void noClientLayout();
    void appendClientMeasurement(QVariant newMeasurement);
    void saveButtonDecisionBox(QVariant message);
    void loadButtonDecisionBox(QVariant message);
    void setClientMainInformation(QVariant prename, QVariant surname, QVariant dayOfBirth, QVariant gender);
    void setHighlightedClientRow(int activeRow);
    void deleteButtonDecisionBox(QVariant boxTitle, QVariant message);
    void deleteButtonMeasurementDecisionBox(QVariant boxTitle, QVariant message);
    void clearMeasurements();
    void showEditClientBase(QVariant prename, QVariant surname, QVariant dayOfBirth, QVariant monthOfBirth, QVariant yearOfBirth, QVariant gender, QVariant threshold, QVariant videofile);
    void saveAsCSVDecision();
    void newButtonActive(bool newActive);
    void editButtonActive(bool editActive);
    void deleteButtonActive(bool deleteActive);
    void loadButtonActive(bool loadActive);
    void saveButtonActive(bool saveActive);
    void activateButtonActive(bool activateActive);
    void exportButtonActive(bool exportActive);
    void loadAction();
    void updateActiveClientStatus(bool hasActiveClient);
    void activeClientChanged(QString prename,QString surname);
    void lastMeasurementDeleted();
};

#endif // HANDLERDATABASE_H
