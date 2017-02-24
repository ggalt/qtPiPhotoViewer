#include "imagefiles.h"

imageFiles::imageFiles(QObject *parent) : QObject(parent)
{
    imagePointer = 0;
}

imageFiles::~imageFiles()
{

}

QString imageFiles::nextImage()
{
    if( imagePointer == 0) {
        imagesShown.insert(0,rand()%imageCount);
    } else {
        imagePointer--;
    }

    QString imageURL = "image://myImageProvider/"+photoUrlList.at(
                imagesShown.at(imagePointer));
    qDebug() << imageURL;
    return imageURL;
}

QString imageFiles::previousImage()
{
    imagePointer++;
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

    //// Main
    photoUrlList.append("/home/ggalt/Pictures/2006-Summer/IMG_0430.JPG");
    photoUrlList.append("/home/ggalt/Pictures/2006-Summer/IMG_0431.JPG");
    photoUrlList.append("'/home/ggalt/Pictures/2015/Hawaii and California/DSC_0611.JPG'");
    photoUrlList.append("/home/ggalt/Pictures/OldPhotos/DSC_0688.JPG");

//    photoUrlList.append("/home/ggalt/Pictures/2013_07_Hawaii/G0010093ww.JPG");
//    photoUrlList.append("/home/ggalt/Pictures/2013_07_Hawaii/G0010093.JPG");
//    photoUrlList.append("/home/ggalt/Pictures/2013_07_Hawaii/GOPR0116.JPG");
//    photoUrlList.append("/home/ggalt/Pictures/2013_07_Hawaii/GOPR0137.JPG");
//    photoUrlList.append("/home/ggalt/Pictures/2013_07_Hawaii/GOPR0170.JPG");

#else
    photoUrlList.append("C:/Users/ggalt66/Pictures/Desktop Images/DSC_0682");
    photoUrlList.append("C:/Users/ggalt66/Pictures/Desktop Images/DSC_0759");
    photoUrlList.append("C:/Users/ggalt66/Pictures/Desktop Images/DSC_1656");
    photoUrlList.append("C:/Users/ggalt66/Pictures/Desktop Images/DSC_0738");
    imageCount = photoUrlList.size();
#endif

}

void imageFiles::setupImageProvider(QQmlEngine *eng)
{
    imageProvider = new MyImageProvider(QQmlImageProviderBase::Image);
    eng->addImageProvider("myImageProvider", imageProvider);
}
