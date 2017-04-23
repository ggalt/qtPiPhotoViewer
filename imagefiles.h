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
#define IMAGE_BUF_SIZE 1024

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
    void readImageURLsFromDisk(QDir d);

signals:

public slots:
private:
    MyImageProvider *imageProvider;

    QStringList photoUrlList;
    int imageCount;
    int imagePointer;
    QList<int> imagesShown;
    quint32 newImagesShown[IMAGE_BUF_SIZE];
    int newImagePointer;
    QDir topDir;
};

#endif // IMAGEFILES_H
