#include "QDebug"
#include "logicthreshold.h"
#include "controller.h"

AdaptiveThreshold::AdaptiveThreshold(Controller *controller)
{
    _pController        = controller;
}

AdaptiveThreshold::~AdaptiveThreshold()
{
}

/**
 * @brief Threshold::ThresholdAdaptionHandler controls all the Adaption Thresholdmethods
 */
void AdaptiveThreshold::ThresholdAdaptionHandler(double YValue)
{
    double oldThreshold = _pController->getThreshold();
    if(_pController->adaptiveThresholdIsActive)
    {
        //Check if it is under or over the Threshold
        if(YValue < (oldThreshold - (oldThreshold * (_pController->adapPercentage) / 100)))
        {
            _pController->setThresholdValue(YValue + (YValue*(_pController->adapPercentage) / 100));
        }
        else if(YValue > (oldThreshold + (oldThreshold * (_pController->adapPercentage) / 100)))
        {
            _pController->setThresholdValue(YValue - (YValue*(_pController->adapPercentage) / 100));
        }
    }
}
