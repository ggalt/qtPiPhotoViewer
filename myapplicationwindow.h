#ifndef MYAPPLICATIONWINDOW_H
#define MYAPPLICATIONWINDOW_H

#include <QObject>
#include <QQmlApplicationEngine>
#include <QQmlComponent>
#include <QQmlContext>
#include <QDebug>
#include <QString>
#include <QVariant>

#include "imagefiles.h"

class myApplicationWindow : public QObject
{
    Q_OBJECT
public:
    explicit myApplicationWindow(QObject *parent = 0);

    void Init(void);

signals:

public slots:

private:
    QQmlApplicationEngine engine;
    QQmlComponent *mainComponent;
    QObject* appWindow;

    imageFiles *myImages;
};

#endif // MYAPPLICATIONWINDOW_H
