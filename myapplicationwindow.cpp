#include "myapplicationwindow.h"

myApplicationWindow::myApplicationWindow(QObject *parent) : QObject(parent)
{

}

void myApplicationWindow::Init()
{
//    mainComponent = new QQmlComponent(&engine, "main.qml");
    qDebug() << 1;
    engine.load(QUrl(QLatin1String("qrc:/main.qml")));
    qDebug() << 2;
    appWindow = engine.rootObjects().first();
    qDebug() << 3;

//    if( mainComponent->status() != QQmlComponent::Ready ) {
//        qDebug() << mainComponent->errorString();
//        return;
//    }
    qDebug() << 4;

    imageProvider = new MyImageProvider(QQmlImageProviderBase::Image);
    qDebug() << 5;
    engine.addImageProvider("myImageProvider", imageProvider);

    qDebug() << 6;
    connect(appWindow, SIGNAL(imageStateSwitched()),
            this, SLOT(NextImage()));

    ReadImageURLs();
    qDebug() << photoUrlList;
    NextImage();
}

void myApplicationWindow::ReadImageURLs()
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

void myApplicationWindow::NextImage()
{
    QString imageURL = "image://myImageProvider/"+photoUrlList.at(rand()%imageCount);
    qDebug() << imageURL;
    QVariant msg = QVariant(imageURL);
    QVariant retVal;
    qDebug() << imageURL;
    QMetaObject::invokeMethod(appWindow, "loadNextImage",
            Q_RETURN_ARG(QVariant, retVal),
            Q_ARG(QVariant,msg));
}
