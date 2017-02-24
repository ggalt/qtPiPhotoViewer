#ifndef IMAGEFILES_H
#define IMAGEFILES_H

#include <QObject>
#include <QStringList>
#include <QList>
#include <QString>
#include <QDir>
#include <QUrl>
#include <QVariant>
#include <QQmlEngine>

#include "myimageprovider.h"

class imageFiles : public QObject
{
    Q_OBJECT
public:
    explicit imageFiles(QObject *parent = 0);
    ~imageFiles(void);

    Q_INVOKABLE QString nextImage(void);
    Q_INVOKABLE QString previousImage(void);

    void ReadURLs(void);
    void setupImageProvider(QQmlEngine *eng);

signals:

public slots:
private:
    MyImageProvider *imageProvider;

    QStringList photoUrlList;
    int imageCount;
    int imagePointer;
    QList<int> imagesShown;
    QDir topDir;
};

#endif // IMAGEFILES_H
