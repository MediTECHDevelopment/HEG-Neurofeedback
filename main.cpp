#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtCharts>
#include <QQmlEngine>
#include <QQmlContext>
#include <QThread>
#include <QObject>
#include <QTranslator>

#include "hegsimulator.h"
#include "classdata.h"
#include "controller.h"
#include "classstats.h"
#include "logicthreshold.h"
#include "logicdatahandler.h"
#include "handlertraining.h"
#include "handlerdatabase.h"
#include "handlermain.h"

#include <QtQuick/qquickitem.h>
#include <QtQuick/qquickview.h>


#include "blecontroller.h"

#include "devicelistdata.h"
#include "hegdevice.h"

#include <QtWebView>

int main(int argc, char *argv[])
{
    QtWebView::initialize();

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);
    app.setOrganizationName("MediTECH");
    app.setOrganizationDomain("meditech.de");
    app.setApplicationName("HEG Neurofeedback Smart Brain Training");

   /* QTranslator qtTranslator;
    qtTranslator.load("qt_" + QLocale::system().name(), QLibraryInfo::location(QLibraryInfo::TranslationsPath));
    app.installTranslator(&qtTranslator);*/

    QTranslator hegguiTranslator;
    QString language =  QLocale::system().name();

     if (language == "de_DE")
     {
          qInfo("German");
         hegguiTranslator.load(":/heggui_de.qm");
     }
     else
     {
          qInfo("English" );
        hegguiTranslator.load(":/heggui_en.qm");
     }

    app.installTranslator(&hegguiTranslator);


    HEGDevice* hegDevice = new HEGDevice();

    QScopedPointer<Data> _pData(new Data());
    QScopedPointer<Measurement> _pMeasurement(new Measurement());
    QScopedPointer<Controller> _pController(new Controller());
    QScopedPointer<Statistics> _pResults(new Statistics(_pData.data(),_pController.data()));
    QScopedPointer<AdaptiveThreshold> _pAdaptiveThreshold(new AdaptiveThreshold(_pController.data()));
    QScopedPointer<DataHandler> _pDataHandler(new DataHandler(_pController.data(),_pResults.data()));

    QScopedPointer<HandlerTraining> _pTrainingHandler(new HandlerTraining(_pMeasurement.data(), _pController.data(), _pData.data(), _pAdaptiveThreshold.data(),hegDevice));
    QScopedPointer<HandlerDatabase> _pDatabaseHandler(new HandlerDatabase(_pController.data(), _pData.data(), _pDataHandler.data()));
    QScopedPointer<MainHandler> _pMainHandler(new MainHandler(_pController.data(), _pDataHandler.data(), _pData.data(), _pDatabaseHandler.data(),_pTrainingHandler.data(), _pResults.data()));


    QQmlApplicationEngine engine;

    QQmlContext* rootContext = engine.rootContext();
    //setContextProperties musst be declared before the load of the qml-engine!
    engine.rootContext()->setContextProperty("cppMainHandler", _pMainHandler.data());
    engine.rootContext()->setContextProperty("cppTrainingHandler", _pTrainingHandler.data());
    engine.rootContext()->setContextProperty("cppDatabaseHandler", _pDatabaseHandler.data());
    engine.rootContext()->setContextProperty("cppController", _pController.data());
    engine.rootContext()->setContextProperty("cppDataHandler", _pDataHandler.data());


    QList<DeviceListData *> dataList = {};
    rootContext->setContextProperty("deviceListModel",QVariant::fromValue(dataList));

    QScopedPointer<BLEController> _bleController(new BLEController(rootContext,hegDevice));
    engine.rootContext()->setContextProperty("cppBLEController", _bleController.data());


    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));


    _bleController->searchForBLE(true);


    if (engine.rootObjects().isEmpty())
        return -1;

    //engine.rootContext()->setContextProperty("cppSimulatorThread", _pSimulatorThread.data());


    return app.exec();
}



