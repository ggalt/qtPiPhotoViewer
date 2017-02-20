#include "myimageprovider.h"

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
    QImage initImage(id);
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
