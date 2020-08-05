#ifndef CLIENT_H
#define CLIENT_H

#include <QString>
#include <QDate>

/*
 * The Client class is describing how a client is looking like.
 */
class Client
{
public:
    Client();
    void    setClient(int ID, QString pname, QString sname, QString dOfBirth, QString gender);
    void    clientFromLine(QString line);
    bool    isValid();

    const   QString setClientPath()     const;
    const   QString showClientString()  const;

    int     getID()                     const;
    const   QString getPrename()        const;
    const   QString getSurname()        const;
    const   QString getGender()         const;
    const   QDate   getDayOfBirth()     const;

private:
    int     _vID;
    QString _vPrename;
    QString _vSurname;
    QDate   _vDayOfBirth;
    QString _vGender;
};

#endif // CLIENT_H
