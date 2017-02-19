import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

Item {
    id: imagePage
    objectName: "imagePage"
//    state: image1
//    property string image1Source: "../../../Pictures/ggalt/2010/SaintCroixMayTripUnderwater/PICT0082.JPG"
//    property string image2Source: "../../../Pictures/ggalt/2010/HawaiiUnderwater/PICT0050.JPG"



    Image {
        id: image3
        anchors.fill: parent
//        source: "/home/ggalt/Pictures/Nikon/2016/Snowzilla/DSC_0216.JPG"
//        source: "../../../Pictures/ggalt/2010/SaintCroixMayTripUnderwater/PICT0082.JPG"
        source: image1Source
        opacity: 0
        fillMode: Image.PreserveAspectCrop
    }







    states: [
        State {
            name: "image1"

            PropertyChanges {
                target: image1
                opacity: 1
            }

            PropertyChanges {
                target: image3
                fillMode: Image.PreserveAspectCrop
                opacity: 1
            }

        },
        State {
            name: "image2"

            PropertyChanges {
                target: image2
                fillMode: Image.PreserveAspectFit
                opacity: 1
            }
        }
    ]



    Image {
        id: image4
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
//        source: "/home/ggalt/Pictures/Nikon/2015/Hawii and California/DSC_0918.JPG"
        source: image2Source
    }

    FastBlur {
        anchors.fill: image3
        source: image3
        radius: 50

    }



    DropShadow {
        id: dropShadow1
        horizontalOffset: 3
        verticalOffset: 3
        radius: 8.0
        anchors.fill: image1
        samples: 17
        color: "#80000000"
        source: image1
    }



    Image {
        id: image1
        anchors.fill: parent
        source: image1Source
//        source: "../../../Pictures/ggalt/2010/SaintCroixMayTripUnderwater/PICT0082.JPG"
//        source: "/home/ggalt/Pictures/Nikon/2016/Snowzilla/DSC_0216.JPG"
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        fillMode: Image.PreserveAspectFit
        opacity: 0
    }

    Image {
        id: image2
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        fillMode: Image.PreserveAspectFit
        anchors.fill: parent
//        source: "/home/ggalt/Pictures/Nikon/2015/Hawii and California/DSC_0918.JPG"
        source: image2Source
        opacity: 0
    }

}
