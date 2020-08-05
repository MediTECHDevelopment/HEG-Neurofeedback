#ifndef DATAHANDLER_H
#define DATAHANDLER_H

#include <QString>
#include <QFileDialog>
#include <QDataStream>
#include <QTextStream>
#include <QMessageBox>
#include <QDebug>
#include <QThread>
#include <QVariant>

#include "classclient.h"
#include "classmeasurement.h"
class Statistics;
class Data;
class Controller;

/*
 * The DataHandler class is managing everything with saving and loading MeasurementData
 */
class DataHandler : public QObject
{
    Q_OBJECT
public:
    explicit DataHandler(Controller *controller =0, Statistics *Results_pointer=0);
    bool writeData(QString *savefilePath, Client currentClient, Data *Data_pointer);
    bool readData(QString *,Data *Data_pointer);


public slots:
    bool saveData(Client currentClient, Data *Data_pointer);
    void loadData(Client currentClient, Data *Data_pointer);
    void saveAsCSV(Client exportClient, Measurement exportMeasurement, QString fileUrl);


private:
    Controller      *_pController;
    Data            *_pData;
    Statistics      *_pResults;

    //saveData:
    QString          _saveFilename ;

signals:
   void forwardingToDatabase();
   void updateDatabasedialog(Client);
   void setNotepadNotes(QVariant notes);
};
#endif // DATAHANDLER_H
