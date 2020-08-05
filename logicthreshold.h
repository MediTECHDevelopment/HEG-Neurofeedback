#ifndef THRESHOLD_H
#define THRESHOLD_H

#include <QObject>
#include <QTimer>
class Controller;

/*
 * The adaptiveThreshold class is calculating and setting the adaptive Threshold.
 */
class AdaptiveThreshold : public QObject
{
    Q_OBJECT
public:
    explicit AdaptiveThreshold(Controller *controller);
    ~AdaptiveThreshold();
    void ThresholdAdaptionHandler(double YValue);
private:
    Controller              *_pController;
};

#endif // THRESHOLD_H
