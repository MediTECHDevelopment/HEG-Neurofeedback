#ifndef STATE_H
#define STATE_H

#include <QString>

/*
 * The class State ist used to describe the users choice for concentration and relaxation. A State change is saved in the Data Class. the class is important to divide the States in the Results
 */

class State
{
public:
    State();
    ~State();
    void    setDifficulty(bool isConcentration);
    void    setTimestamp(int);
    QString getConcentration();
    int     getTimestamp() const;
    QString toString();

private:
    QString _vIsConcentration;
    int     _vTimestamp;
};

#endif // STATE_H
