#include <QGuiApplication>
//#include <QQmlApplicationEngine>
//#include <QQmlContext>
//#include <QDebug>
#include "myapplicationwindow.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QCoreApplication::setOrganizationName("GeorgeGalt");
    QCoreApplication::setOrganizationDomain("georgegalt.com");
    QCoreApplication::setApplicationName("qtPiPhotoViewer");

    QGuiApplication app(argc, argv);

    myApplicationWindow win;
    win.Init();

    return app.exec();
}
