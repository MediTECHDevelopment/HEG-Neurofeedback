#include <QDebug>

#include "classstats.h"
#include "controller.h"
#include "classtimehandler.h"

//state included in data

Statistics::Statistics(Data *Datapointer,Controller *Controllerpointer)
{
    _pData = Datapointer;
    _pController = Controllerpointer;
}
void Statistics::createStatistics(int difficulty)
{
    reset();

    QTime relativeStartTime;
    int startValues = 0;
     _mStateStarts.append(0);
    relativeStartTime.setHMS(0,0,0,0);
    //Alle Wechsel des Trainingsziels
    if(_pData->getStates()->size()>0)
    {
        //for each State-Part
        for(int iRow = 0; iRow<_pData->getStates()->size();iRow++)
        {
            State tempState     = _pData->getStates()->at(iRow);
            int stoppedXValue   = tempState.getTimestamp();
            _mStateStarts.append(stoppedXValue);
            QString state       = tempState.getConcentration();

            QTime relativeStopTime = TimeHandler::elapsedToTime(stoppedXValue*_pController->hertzMultiplicator);

            newStatistics.setTrainingSplitBasics(relativeStartTime,relativeStopTime,state);

            percentageCalculation(startValues,stoppedXValue,state);
            minMaxMeanRange(startValues,stoppedXValue,state);
            pointCalculation(startValues,stoppedXValue,state,difficulty);
            ThresholdExtrema(startValues,stoppedXValue,state);

            if(state == "concentration")
            {
                concentrationDuration += stoppedXValue*_pController->hertzMultiplicator - startValues * _pController->hertzMultiplicator;
                concentrationValues += stoppedXValue - startValues;
                concentrationCount++;
            }
            else if( state == "relaxation")
            {
                relaxationDuration += stoppedXValue*_pController->hertzMultiplicator - startValues * _pController->hertzMultiplicator;
                relaxationValues += stoppedXValue - startValues;
                relaxationCount++;
            }

            //prepare the statistics object
            relativeStartTime = relativeStopTime;
            startValues = stoppedXValue;

            //save the statistics object to save it in the file later on
            Staterow.append(newStatistics);
        }
        summedStatistics();
    }
}
void Statistics::summedStatistics()
{
    //summed concentration-Parts
    if(concentrationCount != 0)
    {
        concentrationTrue /= concentrationCount;
        concentrationFalse = 100 - concentrationTrue;
        concentrationMean  = concentrationYValueSum / concentrationValues;
        concentrationRange = concentrationMax - concentrationMin;
    }

    QTime startValue;
    startValue.setHMS(0,0,0,0);
    newStatistics.setTrainingSplit(startValue, TimeHandler::elapsedToTime(concentrationDuration), "concentration", concentrationTrue, concentrationBetween, concentrationFalse, concentrationMin, concentrationMax, concentrationMean, concentrationRange, concentrationPoints, /*DifficultyToString(concentrationDifficulty)*/ "...", concentrationThresholdMax, concentrationThresholdMin);
    Staterow.append(newStatistics);

    //summed relaxation-Parts
    if(relaxationCount != 0)
    {
        relaxationTrue /= relaxationCount;
        relaxationFalse = 100 - relaxationTrue;
        relaxationMean  = relaxationYValueSum / relaxationValues;
        relaxationRange = relaxationMax - relaxationMin;
    }

    //relax-stats created after total, cause an correction of the relax-Duration

    if(relaxationCount+concentrationCount != 0)
    {
        totalDuration    = relaxationDuration + concentrationDuration;
        relaxationDuration = round(totalDuration/1000)*1000 - round(concentrationDuration/1000)*1000;
        totalTrue        = (relaxationTrue + concentrationTrue) / (relaxationCount + concentrationCount);
        totalBetween     = (relaxationBetween + concentrationBetween) / (relaxationCount + concentrationCount);
        totalFalse       = 100-totalTrue;
        if(relaxationMin<concentrationMin)
        {totalMin = relaxationMin;}
        else
        {totalMin = concentrationMin;}

        if(relaxationMax>concentrationMax)
        {totalMax = relaxationMax;}
        else
        {totalMax = concentrationMax;}

        totalMean         = (relaxationYValueSum+concentrationYValueSum) / (relaxationValues+concentrationValues);
        totalRange        = totalMax-totalMin;
        totalPoints       = relaxationPoints+concentrationPoints;

        totalDifficulty = DifficultyToString(relaxationDifficulty+concentrationDifficulty);

        if(relaxationThresholdMax<concentrationThresholdMax)
        {totalThresholdMax = concentrationThresholdMax;}
        else
        {totalThresholdMax = relaxationThresholdMax;}

        if(relaxationThresholdMin>concentrationThresholdMin)
        {totalThresholdMin = concentrationThresholdMin;}
        else
        {totalThresholdMin = relaxationThresholdMin;}
    }

    newStatistics.setTrainingSplit(startValue,TimeHandler::elapsedToTime(relaxationDuration),"relaxation",relaxationTrue,relaxationBetween,relaxationFalse,relaxationMin,relaxationMax,relaxationMean,relaxationRange,relaxationPoints,/*DifficultyToString(relaxationDifficulty)*/ "...",relaxationThresholdMax,relaxationThresholdMin);
    Staterow.append(newStatistics);

    newStatistics.setTrainingSplit(startValue,TimeHandler::elapsedToTime(totalDuration),"total",totalTrue,totalBetween,totalFalse,totalMin,totalMax,totalMean,totalRange,totalPoints,/*totalDifficulty*/ "...",totalThresholdMax,totalThresholdMin);
    Staterow.append(newStatistics);

}
void Statistics::percentageCalculation(int startTime, int stopTime, QString state)
{
    int percentabove = timeAboveThreshold(startTime,stopTime);
    int percentBetween = timeBetweenThreshold(startTime,stopTime,state);
    percentabove*=100;
    percentBetween*=100;
    percentabove /= (stopTime)-(startTime);
    percentBetween /= (stopTime)-(startTime);
    if(state == "concentration")
    {
        concentrationTrue += percentabove;
        concentrationBetween += percentBetween;
        newStatistics.setTrainingSplitPercentages(percentabove,percentBetween,100-percentabove);
    }
    else
    {
        relaxationTrue += 100-percentabove;
        relaxationBetween += percentBetween;
        newStatistics.setTrainingSplitPercentages(100-percentabove,percentBetween,percentabove);
    }
}
void Statistics::minMaxMeanRange(int startTime, int stopTime, QString state)
{
    double minYValue = _pData->getRaw()->getRawDataVector().at(startTime).getY();
    double maxYValue = _pData->getRaw()->getRawDataVector().at(startTime).getY();

    double sumAll = 0;

    for(int iRange = startTime;iRange<stopTime;iRange++)
    {
        if(state == "concentration")
        {
            concentrationYValueSum+=_pData->getRaw()->getRawDataVector().at(iRange).getY();
        }
        else if(state == "relaxation")
        {
            relaxationYValueSum+=_pData->getRaw()->getRawDataVector().at(iRange).getY();
        }

        sumAll+=_pData->getRaw()->getRawDataVector().at(iRange).getY();
        if(minYValue>_pData->getRaw()->getRawDataVector().at(iRange).getY())
        {
            minYValue=_pData->getRaw()->getRawDataVector().at(iRange).getY();

        }
        if(maxYValue<_pData->getRaw()->getRawDataVector().at(iRange).getY())
        {
            maxYValue=_pData->getRaw()->getRawDataVector().at(iRange).getY();
        }
    }
    if(state == "concentration")
    {
        if(concentrationMin> minYValue)
        {concentrationMin = minYValue;}
        if(concentrationMax < maxYValue)
        {concentrationMax = maxYValue;}
    }
    else if(state == "relaxation")
    {
        if(relaxationMin > minYValue)
        {relaxationMin = minYValue;}
        if(relaxationMax < maxYValue)
        {relaxationMax = maxYValue;}
    }
    newStatistics.setTrainingSplitExtreme(minYValue,maxYValue,sumAll/(stopTime-startTime),maxYValue-minYValue);
}

void Statistics::pointCalculation(int startTime, int stopTime, QString state, int difficulty)
{
    int totalPoints = 0;
    int correctValues = 0;
    int difficultySeconds = 0;
    switch (difficulty)
    {
    case -2: difficultySeconds = 1; break;
    case -3: difficultySeconds = 2; break;
    case -4: difficultySeconds = 10; break;
    default: difficultySeconds = 0; break;
    }

    int addPoints  = 0;
    if (difficultySeconds == 10)
    {
        addPoints = 17;
    }
    else if(difficultySeconds == 2)
    {
        addPoints = 2;
    }
    else
    {
        addPoints = 1;
    }

    if(stopTime <= _pData->getRaw()->getRawDataVector().size())
    {
        for(int iRange = startTime ; iRange<stopTime;iRange++)
        {
            if(_pData->getRaw()->getRawDataVector().at(iRange).getY()>_pData->getRaw()->getRawDataVector().at(iRange).getThreshold())
            {
                correctValues++;
                if(correctValues >= _pData->getSamplesPerSecond() * difficultySeconds)
                {
                    totalPoints += addPoints;
                    correctValues = 0;
                }
            }
            else
            {
                correctValues = 0;
            }
        }
    }

    if(state == "concentration")
    {
        concentrationPoints+=totalPoints;
        concentrationDifficulty.append(_pData->getRaw()->getRawDataVector().at(stopTime-1).getDifficulty());
    }
    else if(state == "relaxation")
    {
        relaxationPoints+=totalPoints;
        relaxationDifficulty.append(_pData->getRaw()->getRawDataVector().at(stopTime-1).getDifficulty());

    }
    newStatistics.setTrainingSplitPointsDifficulty(totalPoints,DifficultyToString(_pData->getRaw()->getRawDataVector().at(stopTime-1).getDifficulty()));
}
int Statistics::timeAboveThreshold(int minValue, int maxValue)
{
    int timeabove = 0;
    if(maxValue<=_pData->getRaw()->getRawDataVector().size())
    {
        for(int iRange = minValue;iRange<maxValue;iRange++)
        {
            if(_pData->getRaw()->getRawDataVector().at(iRange).getY()>_pData->getRaw()->getRawDataVector().at(iRange).getThreshold())
            {
                timeabove++;
            }
        }
    }
    return timeabove;
}

int Statistics::timeBetweenThreshold(int minValue, int maxValue, QString state)
{
    int timeBetween = 0;
    if(maxValue<=_pData->getRaw()->getRawDataVector().size())
    {
        for(int iRange = minValue;iRange<maxValue;iRange++)
        {
            double actualYValue = _pData->getRaw()->getRawDataVector().at(iRange).getY();
            double Range = _pData->getRaw()->getRawDataVector().at(iRange).getThreshold()*((_pController->difficultyToAdapThreshold(_pData->getRaw()->getRawDataVector().at(iRange).getDifficulty())*_pController->ThresholdTransitPercent)/1000);
            if(state == "concentration")
            {
                if(actualYValue<_pData->getRaw()->getRawDataVector().at(iRange).getThreshold() && actualYValue > _pData->getRaw()->getRawDataVector().at(iRange).getThreshold()-Range)
                { timeBetween++;}
            }
            else
            {
                if(actualYValue>_pData->getRaw()->getRawDataVector().at(iRange).getThreshold() && actualYValue < _pData->getRaw()->getRawDataVector().at(iRange).getThreshold()+Range)
                { timeBetween++; }
            }
        }

    }
    return timeBetween;
}
QString Statistics::DifficultyToString(QVector<int> difficulty)
{
    QString DifficultyString;
    bool comma = false;
    if(difficulty.contains(1))
    {
        DifficultyString.append("Super Easy");
        comma = true;
    }
    if(difficulty.contains(2))
    {
        if(comma == true)
        {
            DifficultyString.append(", ");
        }
        DifficultyString.append("Easy");
        comma = true;
    }
    if(difficulty.contains(3))
    {
        if(comma == true)
        {
            DifficultyString.append(", ");
        }
        DifficultyString.append("Medium");
        comma = true;
    }
    if(difficulty.contains(4))
    {
        if(comma == true)
        {
            DifficultyString.append(", ");
        }
        DifficultyString.append("Advanced");
        comma = true;
    }
    if(difficulty.contains(5))
    {
        if(comma == true)
        {
            DifficultyString.append(", ");
        }
        DifficultyString.append("Hard");
    }
   return DifficultyString;
}
QString Statistics::DifficultyToString(int difficulty)
{
    QString DifficultyString;
    if(difficulty==1)
    {
        DifficultyString.append("Super Easy");
    }
    if(difficulty==2)
    {
        DifficultyString.append("Easy");
    }
    if(difficulty==3)
    {
        DifficultyString.append("Medium");
    }
    if(difficulty==4)
    {
        DifficultyString.append("Advanced");
    }
    if(difficulty==5)
    {

        DifficultyString.append("Hard");
    }
   return DifficultyString;
}
void Statistics::ThresholdExtrema(int startTime, int stopTime, QString state)
{
    //Safety Reason
    quint32 ThresholdMax = 0;
    quint32 ThresholdMin = 9999;
    quint32 tempThreshold;
    if(stopTime<=_pData->getRaw()->getRawDataVector().size())
    {
        for (int iRange = startTime;iRange<stopTime;iRange++)
        {
            tempThreshold = _pData->getRaw()->getRawDataVector().at(iRange).getThreshold();
            if(tempThreshold<ThresholdMin)
            {
                ThresholdMin = tempThreshold;
            }
            else if(tempThreshold>ThresholdMax)
            {
                ThresholdMax = tempThreshold;
            }
        }
    }

    if(state == "concentration")
    {
        if(concentrationThresholdMin> ThresholdMin)
        {concentrationThresholdMin = ThresholdMin;}
        if(concentrationThresholdMax < ThresholdMax)
        {concentrationThresholdMax = ThresholdMax;}
    }
    else if(state == "relaxation")
    {
        if(relaxationThresholdMin> ThresholdMin)
        {relaxationThresholdMin = ThresholdMin;}
        if(relaxationThresholdMax < ThresholdMax)
        {relaxationThresholdMax = ThresholdMax;}
    }

    newStatistics.setTrainingSplitThreshold(ThresholdMax,ThresholdMin);

}
void Statistics::reset()
{
    Staterow.clear();
    _mStateStarts.clear();

    concentrationDuration = 0;
    concentrationValues = 0;
    concentrationYValueSum = 0;
    concentrationCount = 0;
    concentrationTrue = 0;
    concentrationBetween = 0;
    concentrationFalse = 0;
    concentrationMin = 9999;//500;
    concentrationMax = 0;
    concentrationMean = 0;
    concentrationRange = 0;
    concentrationPoints = 0;
    concentrationDifficulty.clear();
    concentrationThresholdMax = 0;
    concentrationThresholdMin = 9999;//500;

    relaxationDuration = 0;
    relaxationValues = 0;
    relaxationYValueSum = 0;
    relaxationCount = 0;
    relaxationTrue = 0;
    relaxationBetween = 0;
    relaxationFalse = 0;
    relaxationMin = 9999;
    relaxationMax = 0;
    relaxationMean = 0;
    relaxationRange = 0;
    relaxationPoints = 0;
    relaxationDifficulty.clear();
    relaxationThresholdMax = 0;
    relaxationThresholdMin = 9999;

    totalDuration = 0;
    totalValues = 0;
    totalYValueSum = 0;
    totalCount = 0;
    totalTrue = 0;
    totalBetween = 0;
    totalFalse = 0;
    totalMin = 9999;
    totalMax = 0;
    totalMean = 0;
    totalRange = 0;
    totalPoints = 0;
    totalDifficulty = "";
    totalThresholdMax = 0;
    totalThresholdMin = 9999;
}
