#include "myimageprovider.h"
#include <QImageReader>

MyImageProvider::MyImageProvider(QQmlImageProviderBase::ImageType type,
                                 QQmlImageProviderBase::Flags flags)
    : QQuickImageProvider(type,flags)
{

}

MyImageProvider::~MyImageProvider()
{

}

QImage MyImageProvider::requestImage(const QString &id,
                                     QSize *size, const QSize &requestedSize)
{
//    qDebug() << "image id ==" << id;
    QImageReader imgReader(id);
    imgReader.setAutoTransform(true);
    QImage initImage = imgReader.read();

    if(initImage.isNull()) {    // error in getting image
        qDebug() << "Image read error:" << imgReader.errorString();
        initImage = QImage(requestedSize,QImage::Format_ARGB32);
        initImage.fill(Qt::lightGray);
    }

    QImage retVal;

    if(requestedSize.isValid()) {
        retVal = initImage.scaled(requestedSize, Qt::KeepAspectRatio);
    } else {
        retVal = initImage;
    }
    *size = retVal.size();
    return retVal;
}

QPixmap MyImageProvider::requestPixmap(const QString &id,
                                       QSize *size, const QSize &requestedSize)
{
    QPixmap initImage(id);
    QPixmap retVal;

    if(requestedSize.isValid()) {
        retVal = initImage.scaled(requestedSize, Qt::KeepAspectRatio);
    } else {
        retVal = initImage;
    }
    *size = retVal.size();
    return retVal;
}
