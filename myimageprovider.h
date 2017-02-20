#ifndef MYIMAGEPROVIDER_H
#define MYIMAGEPROVIDER_H

#include <QQuickImageProvider>
#include <QObject>
#include <QQuickItem>
#include <QImage>
#include <QPixmap>


class MyImageProvider : public QQuickImageProvider
{
public:
    MyImageProvider(ImageType type, Flags flags = Flags());
    ~MyImageProvider();

    QImage requestImage(
            const QString &id, QSize *size, const QSize &requestedSize);
    QPixmap requestPixmap(
            const QString &id, QSize *size, const QSize &requestedSize);
};

#endif // MYIMAGEPROVIDER_H
