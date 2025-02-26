QT += quick charts core gui qml quickcontrols2
QT += charts
QT += multimedia
QT += multimediawidgets
QT += bluetooth
QT += webview
CONFIG += c++11

TARGET = HEG_Neurofeedback_Smart_Brain_Training
TEMPLATE = app
# The following define makes your compiler emit warnings if you use
# any feature of Qt w hich as been marked deprecated (the exact warnings
# depend on your compiler). Please consult the documentation of the
# deprecated API in order to know  how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if you use deprecated APIs.
# In order to do  so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000   # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
    blecontroller.cpp \
    devicelistdata.cpp \
    hegdevice.cpp \
        main.cpp \
    HegSimulator.cpp \
    ClassData.cpp \
    ClassRawData.cpp \
    ClassState.cpp \
    ClassSample.cpp \
    LogicVirtualHegSample.cpp \
    ClassMeasurement.cpp \
    LogicThreshold.cpp \
    Controller.cpp \
    ClassTimehandler.cpp \
    ClassAnalysis.cpp \
    ClassClient.cpp \
    ClassStats.cpp \
    LogicDatahandler.cpp \
    HandlerTraining.cpp \
    HandlerMain.cpp \
    HandlerDatabase.cpp

RESOURCES += qml.qrc \
    ../HEG2_QML/icons.qrc \
    translations.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml

TRANSLATIONS = heggui_en.ts \
               heggui_de.ts \
               heggui_fr.ts \

HEADERS += \
    blecontroller.h \
    devicelistdata.h \
    hegdevice.h \
    hegsimulator.h \
    classdata.h \
    classrawdata.h \
    classstate.h \
    classsample.h \
    logicvirtualhegsample.h \
    classmeasurement.h \
    logicthreshold.h \
    controller.h \
    classtimehandler.h \
    classanalysis.h \
    classclient.h \
    classstats.h \
    logicdatahandler.h \
    handlertraining.h \
    handlermain.h \
    handlerdatabase.h

FORMS +=

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android



