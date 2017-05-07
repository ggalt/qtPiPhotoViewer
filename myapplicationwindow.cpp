#include "myapplicationwindow.h"
#include <QStandardPaths>
#include <QDir>
#include <QSettings>
#include <QVariant>
#include <QQuickView>

#define DISPLAY_DURATION    10 * 1000
#define TRANSITION_DURATION 4 * 1000
#define BLUR_VALUE          99

myApplicationWindow::myApplicationWindow(QObject *parent) : QObject(parent)
{

}

myApplicationWindow::~myApplicationWindow()
{
    QSettings settings;
    settings.setValue("blurValue", QVariant(blurValue));
    settings.setValue("displayDuration", QVariant(displayDuration));
    settings.setValue("pictureDirectory", QVariant(pictureDirectory));
    settings.setValue("transitionDuration", QVariant(transitionDuration));
}

void myApplicationWindow::Init()
{
//    mainComponent = new QQmlComponent(&engine, "main.qml");
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    appWindow = engine.rootObjects().first();

    QSettings settings;
    QString pictureHomeDir = QStandardPaths::standardLocations(
                QStandardPaths::PicturesLocation).first();

    blurValue = settings.value("blurValue",BLUR_VALUE).toInt();
    displayDuration = settings.value("displayDuration", DISPLAY_DURATION).toInt();
    transitionDuration = settings.value("transitionDuration", TRANSITION_DURATION).toInt();
    pictureDirectory = settings.value("pictureDirectory", pictureHomeDir).toString();
//    QQuickView *v = new QQuickView(&engine,0);
//    v->setScreen();

    QDir d(pictureDirectory);

    myImages = new imageFiles(this);
    myImages->setupImageProvider(&engine);
    myImages->readImageURLsFromDisk(d);
//    myImages->ReadURLs();
    engine.rootContext()->setContextProperty("myImages", myImages);
    appWindow->setProperty("showImageDuration", displayDuration);
    appWindow->setProperty("transitionDuration", transitionDuration);
    appWindow->setProperty("blurValue",blurValue);
    appWindow->setProperty("pictureHome", pictureHomeDir);


    QVariant returnedValue;
    QVariant msg = "Initialize";
    QMetaObject::invokeMethod(appWindow, "setImageState",
            Q_RETURN_ARG(QVariant, returnedValue),
            Q_ARG(QVariant, msg));
}

