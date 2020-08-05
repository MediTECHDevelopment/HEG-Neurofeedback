#include "classclient.h"
#include <QDebug>


Client::Client()
{
    _vID            = 0;
    _vPrename       = "default";
    _vSurname       = "default";
    _vDayOfBirth    .setDate(0000,00,00);
    _vGender        = "female";
}
void Client::setClient(int ID, QString pname,QString sname,QString dOfBirth,QString gender)
{
    _vID          = ID;
    _vPrename     = pname;
    _vSurname     = sname;
    _vDayOfBirth  = QDate::fromString(dOfBirth,"yyyyMMdd");
    _vGender      = gender;
}

const QString Client::setClientPath() const
{
    return (QString::number(_vID));
}

/**
 * Displays the Client in the status-Bar
 **/
const QString Client::showClientString() const
{
    return(QString::number(_vID) + " - "+ _vPrename + " " + _vSurname + " - " + _vDayOfBirth.toString("yyyy.MM.dd") + " - " + _vGender);
}

/**
 * Easiest method for the load Event
 * Method gets the line and converts it to the client attributes
**/
void Client::clientFromLine(QString line)
{
    QStringList prelineSub = line.split('=');
    if(prelineSub.first() == "clientID")
    {
        QString idString = prelineSub.last().trimmed();
        _vID =  idString.toInt();
    }
    else if(prelineSub.first() == "prename")
    {
        _vPrename = prelineSub.last().trimmed();
    }
    else if(prelineSub.first() == "surname")
    {
        _vSurname = prelineSub.last().trimmed();
    }
    else if(prelineSub.first() == "birthday")
    {
        _vDayOfBirth  = QDate::fromString(prelineSub.last().trimmed(),"yyyyMMdd");
    }
    else if(prelineSub.first() == "Gender")
    {
        _vGender = prelineSub.last().trimmed();
    }
}
/**
 * @brief Client::isValid checks if the properties are valid for a Client
 * @returns if its valid or not
 */
bool Client::isValid()
{
    if (_vID == 0 || _vPrename == "default" || _vSurname == "default" || _vDayOfBirth.toString("yyyyMMdd") == "00000000" || _vPrename == "" || _vSurname == "" )
    {
        return false;
    }
    else
    {
        return true;
    }
}

/**
 * GETTER
 */
const QString Client::getPrename() const
{
    return (_vPrename);
}
const QString Client::getSurname() const
{
    return (_vSurname);
}
const QString Client::getGender() const
{
    return (_vGender);
}
const QDate Client::getDayOfBirth() const
{
    return (_vDayOfBirth);
}
int Client::getID() const
{
    return (_vID);
}
