#include "myapplicationwindow.h"
#include <QStandardPaths>
#include <QDir>

myApplicationWindow::myApplicationWindow(QObject *parent) : QObject(parent)
{

}

void myApplicationWindow::Init()
{
//    mainComponent = new QQmlComponent(&engine, "main.qml");
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    appWindow = engine.rootObjects().first();

    QString pictureHomeDir = QStandardPaths::standardLocations(
                QStandardPaths::PicturesLocation).first();

    myImages = new imageFiles(this);
    myImages->setupImageProvider(&engine);
    myImages->ReadURLs();
    engine.rootContext()->setContextProperty("myImages", myImages);
    appWindow->setProperty("showImageDuration", 2000);
    appWindow->setProperty("blurValue",50);
    appWindow->setProperty("pictureHome", pictureHomeDir);


    QVariant returnedValue;
    QVariant msg = "blackOut";
    QMetaObject::invokeMethod(appWindow, "setImageState",
            Q_RETURN_ARG(QVariant, returnedValue),
            Q_ARG(QVariant, msg));
}

