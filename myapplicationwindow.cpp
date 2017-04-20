#include "myapplicationwindow.h"
#include <QStandardPaths>
#include <QDir>
#include <QSettings>
#include <QVariant>

myApplicationWindow::myApplicationWindow(QObject *parent) : QObject(parent)
{

}

myApplicationWindow::~myApplicationWindow()
{
    QSettings settings;
    settings.setValue("blurValue", QVariant(blurValue));
    settings.setValue("displayDuration", QVariant(displayDuration));
    settings.setValue("pictureDirectory", QVariant(pictureDirectory));
}

void myApplicationWindow::Init()
{
//    mainComponent = new QQmlComponent(&engine, "main.qml");
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    appWindow = engine.rootObjects().first();

    QSettings settings;
    QString pictureHomeDir = QStandardPaths::standardLocations(
                QStandardPaths::PicturesLocation).first();

    blurValue = settings.value("blurValue",50).toInt();
    displayDuration = settings.value("displayDuration", 10000).toInt();
    pictureDirectory = settings.value("pictureDirectory", pictureHomeDir).toString();

    QDir d(pictureDirectory);

    myImages = new imageFiles(this);
    myImages->setupImageProvider(&engine);
    myImages->readImageURLsFromDisk(d);
//    myImages->ReadURLs();
    engine.rootContext()->setContextProperty("myImages", myImages);
    appWindow->setProperty("showImageDuration", 4000);
    appWindow->setProperty("blurValue",99);
    appWindow->setProperty("pictureHome", pictureHomeDir);


    QVariant returnedValue;
    QVariant msg = "Initialize";
    QMetaObject::invokeMethod(appWindow, "setImageState",
            Q_RETURN_ARG(QVariant, returnedValue),
            Q_ARG(QVariant, msg));
}

