#ifndef MYAPPLICATIONWINDOW_H
#define MYAPPLICATIONWINDOW_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQmlContext>
#include <QDebug>
#include <QString>
#include <QStringList>
#include <QDir>
#include <QUrl>
#include <QVariant>

#include "myimageprovider.h"

class myApplicationWindow : public QObject
{
    Q_OBJECT
public:
    explicit myApplicationWindow(QObject *parent = 0);

    void Init(void);
    void ReadImageURLs(void);

signals:

public slots:
    void NextImage(void);

private:
    QQmlApplicationEngine engine;
    QQmlComponent *mainComponent;
    MyImageProvider *imageProvider;
    QObject* appWindow;

    QStringList photoUrlList;
    int imageCount;
    int imagePointer;
    QDir topDir;
};

#endif // MYAPPLICATIONWINDOW_H
