import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

Item {
    id: imagePage
    objectName: "imagePage"

    states: [
        State {
            name: "image1State"

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
            name: "image2State"

            PropertyChanges {
                target: image2
                fillMode: Image.PreserveAspectFit
                opacity: 1
            }
        }
    ]

    transitions: Transition {
        from: "image1State"
        to: "image2State"
        SequentialAnimation {
            NumberAnimation {
                easing.type: Easing.InCirc
                property: "width"
                duration: 200
                to: 0
                target: image1
            }

            NumberAnimation {
                target: image2
                property: "width"
                duration: 200
                from: 0
                easing.type: Easing.OutCirc
            }
        }
    }

    FastBlur {
        id: backgroundBlur
        anchors.fill: image3
        source: image3
        radius: 50
    }

    DropShadow {
        id: imageDropShadow
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
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        fillMode: Image.PreserveAspectFit
        opacity: 0
        source: image1Source
        autoTransform: true
    }

    Image {
        id: image2
        anchors.fill: parent
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        fillMode: Image.PreserveAspectFit
        opacity: 0
        source: image2Source
        autoTransform: true
    }

    Image {
        id: image3
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: image1Source
        autoTransform: true
    }

    Image {
        id: image4
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        opacity: 0
        source: image2Source
        autoTransform: true
    }

}
