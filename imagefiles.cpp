#include <QDirIterator>
#include <QDebug>
#include <QDateTime>

#include "imagefiles.h"

imageFiles::imageFiles(QObject *parent) : QObject(parent)
{
    imagePointer = 0;

//    qsrand(QDateTime::currentMSecsSinceEpoch());
    qsrand(5);
}

imageFiles::~imageFiles()
{

}

QString imageFiles::nextImage()
{
    if( imagePointer == 0) {
        int randNum = qrand();
        qDebug() << "Random number:" << randNum;
        imagesShown.insert(0, randNum % imageCount);
    } else {
        imagePointer--;
        if(imagePointer < 0)
            imagePointer = 0;
    }

    QString imageURL = "image://myImageProvider/"+photoUrlList.at(
                imagesShown.at(imagePointer));
    qDebug() << imageURL << imagesShown;
    return imageURL;
}

QString imageFiles::previousImage()
{
    imagePointer++;
    if(imagePointer >= imagesShown.size())
        imagePointer = imagesShown.size()-1;

    QString imageURL = "image://myImageProvider/"+photoUrlList.at(
                imagesShown.at(imagePointer));
    qDebug() << imageURL;
    return imageURL;
}

void imageFiles::ReadURLs()
{
    photoUrlList.clear();
#ifdef Q_OS_LINUX
    //// Lenovo
    //    photoUrlList.append("/home/ggalt/Pictures/2014-summer/DSC_3264.jpg");
    //    photoUrlList.append("/home/ggalt/Pictures/2014-summer/DSC_3325.jpg");
    //    photoUrlList.append("/home/ggalt/Pictures/2014-summer/P1000417.JPG");
    //    photoUrlList.append("/home/ggalt/Pictures/2014-summer/P1000504.JPG");
    readImageURLsFromDisk(QDir("/home/ggalt/Pictures/"));

    //// Main
//    photoUrlList.append("/home/ggalt/Pictures/2006-Summer/IMG_0430.JPG");
//    photoUrlList.append("/home/ggalt/Pictures/2006-Summer/IMG_0431.JPG");
//    photoUrlList.append("'/home/ggalt/Pictures/2015/Hawaii and California/DSC_0611.JPG'");
//    photoUrlList.append("/home/ggalt/Pictures/OldPhotos/DSC_0688.JPG");
//    readImageURLsFromDisk(QDir("/home/ggalt/Pictures/"));

    //    photoUrlList.append("/home/ggalt/Pictures/2013_07_Hawaii/G0010093ww.JPG");
    //    photoUrlList.append("/home/ggalt/Pictures/2013_07_Hawaii/G0010093.JPG");
    //    photoUrlList.append("/home/ggalt/Pictures/2013_07_Hawaii/GOPR0116.JPG");
    //    photoUrlList.append("/home/ggalt/Pictures/2013_07_Hawaii/GOPR0137.JPG");
    //    photoUrlList.append("/home/ggalt/Pictures/2013_07_Hawaii/GOPR0170.JPG");

#else
    // Windows laptop
//    photoUrlList.append("C:/Users/ggalt66/Pictures/Desktop Images/DSC_0682");
//    photoUrlList.append("C:/Users/ggalt66/Pictures/Desktop Images/DSC_0759");
//    photoUrlList.append("C:/Users/ggalt66/Pictures/Desktop Images/DSC_1656");
//    photoUrlList.append("C:/Users/ggalt66/Pictures/Desktop Images/DSC_0738");
    readImageURLsFromDisk(QDir("C:/Users/ggalt66/Pictures/"));
    // Windows Desktop
//    readImageURLsFromDisk(QDir("C:/Users/George Galt/Pictures"));
#endif
    imageCount = photoUrlList.size();

}

void imageFiles::setupImageProvider(QQmlEngine *eng)
{
    imageProvider = new MyImageProvider(QQmlImageProviderBase::Image);
    eng->addImageProvider("myImageProvider", imageProvider);
}

void imageFiles::readImageURLsFromDisk(QDir d)
{
    photoUrlList.clear();
    QDirIterator it(d, QDirIterator::Subdirectories);
    while (it.hasNext()) {
        if( it.fileInfo().isFile() ) {
            QString entry = it.fileInfo().absoluteFilePath();
            if( entry.contains(".JPG") || entry.contains(".jpg")) {
                photoUrlList.append(entry);
            }
        }
        it.next();
    }
    imageCount = photoUrlList.count();
    qDebug() << imageCount << photoUrlList.at(0);
}
