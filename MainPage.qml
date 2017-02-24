import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

Item {
    id: imagePage
    objectName: "imagePage"

//    onStateChanged: myStageChange()

    Timer {
        id: startOffTimer
        interval: 1000
        running: false
        onTriggered: {
            console.log("startoffTimer stopping")
            startOffTimer.stop()
            appWindow.setImageState("fadeIn")
        }
    }

    Image {
        id: backgroundImage
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        source: currentImage
        autoTransform: true
        opacity: 0
    }

    FastBlur {
        id: backgroundBlur
        anchors.fill: backgroundImage
        source: backgroundImage
        radius: 50
        opacity: 0
    }

    DropShadow {
        id: imageDropShadow
        horizontalOffset: 3
        verticalOffset: 3
        radius: 8.0
        anchors.fill: foregroundImage
        samples: 17
        color: "#80000000"
        source: foregroundImage
    }

    Image {
        id: foregroundImage
        anchors.fill: parent
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        anchors.topMargin: 10
        fillMode: Image.PreserveAspectFit
        opacity: 0
        source: currentImage
        autoTransform: true
    }

    states: [
        State {
            name: "blackOut"
            PropertyChanges {
                target: startOffTimer
                running: true
            }
        },
        State {
            name: "fadeIn"
            PropertyChanges {
                target: backgroundBlur
                opacity: 1
            }
        },
        State {
            name: "showNewImage"
            PropertyChanges {
                target: foregroundImage
                opacity: 1
            }
        },
        State {
            name: "hideOldImage"
            PropertyChanges {
                target: foregroundImage
                opacity: 0
            }
        },
        State {
            name: "fadeOut"
            PropertyChanges {
                target: backgroundBlur
                opacity: 0
            }
        }
    ]

    transitions: [
        Transition {
            from: ""
            to: "fadeIn"

            SequentialAnimation {
                NumberAnimation {
                    id: fadeInAnimation
                    target: backgroundBlur
                    property: "opacity"
                    duration: 200
                    easing.type: Easing.InOutQuad
                }
                ScriptAction {
                    script: appWindow.setImageState("showNewImage")
                }
            }

        },
        Transition {
            from: ""
            to: "showNewImage"

            NumberAnimation {
                id: showNewImageAnimation
                target: foregroundImage
                property: "opacity"
                duration: 1000
                easing.type: Easing.InOutQuad
            }
        },
        Transition {
            from: ""
            to: "hideOldImage"

            SequentialAnimation {
                NumberAnimation {
                    id: hideOldImageAnimation
                    target: foregroundImage
                    property: "opacity"
                    duration: 1000
                    easing.type: Easing.InOutQuad
                }
                ScriptAction{
                    script: appWindow.setImageState("fadeOut")
                }
            }
        },
        Transition {
            from: ""
            to: "fadeOut"
            onRunningChanged: {
                if(!fadeOutAnimation.running) {
                    appWindow.setImageState("fadeIn")
                }
            }

            NumberAnimation {
                id: fadeOutAnimation
                target: backgroundBlur
                property: "opacity"
                duration: 200
                easing.type: Easing.InOutQuad
//                onStopped: appWindow.setImageState("fadeIn")
            }
        }
    ]
}
