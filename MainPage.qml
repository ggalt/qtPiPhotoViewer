import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

Rectangle {
    id: imagePage
    objectName: "imagePage"
    color: "black"

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
        id: newBackgroundImage
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        source: currentImage
        autoTransform: true
        opacity: 0
    }

    FastBlur {
        id: newBackgroundBlur
        anchors.fill: newBackgroundImage
        source: newBackgroundImage
        radius: appWindow.blurValue
        opacity: 0
    }

    Image {
        id: oldBackgroundImage
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        source: oldImage
        autoTransform: true
        opacity: 0
    }

    FastBlur {
        id: oldBackgroundBlur
        anchors.fill: oldBackgroundImage
        source: oldBackgroundImage
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
        opacity: 0
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
                target: foregroundImage
                opacity: 0
            }
            PropertyChanges {
                target: newBackgroundBlur
                opacity: 1
            }
            PropertyChanges {
                target: oldBackgroundBlur
                opacity: 0
            }
        },
        State {
            name: "showNewImage"
            PropertyChanges {
                target: foregroundImage
                opacity: 1
            }
            PropertyChanges {
                target: newBackgroundBlur
                opacity: 1
            }
            PropertyChanges {
                target: oldBackgroundBlur
                opacity: 0
            }
        },
        State {
            name: "hideOldImage"
            PropertyChanges {
                target: foregroundImage
                opacity: 0
            }
            PropertyChanges {
                target: newBackgroundBlur
                opacity: 1
            }
            PropertyChanges {
                target: oldBackgroundBlur
                opacity: 0
            }
        },
        State {
            name: "fadeOut"
            PropertyChanges {
                target: foregroundImage
                opacity: 0
            }
            PropertyChanges {
                target: newBackgroundBlur
                opacity: 0
            }
            PropertyChanges {
                target: oldBackgroundBlur
                opacity: 0
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "fadeIn"

            SequentialAnimation {
//                ScriptAction {
//                    script: console.log("at transition fadeIn")
//                }

                NumberAnimation {
                    id: fadeInAnimation
                    target: newBackgroundBlur
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 600
                    easing.type: Easing.InOutQuad
                }
                ScriptAction {
                    script: appWindow.setImageState("showNewImage")
                }
            }

        },
        Transition {
            from: "*"
            to: "showNewImage"

            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation {
                        id: showNewImageAnimation
                        target: foregroundImage
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 1000
                        easing.type: Easing.InOutQuad
                    }

                    NumberAnimation {
                        target: imageDropShadow
                        property: "opacity"
                        duration: 1000
                        from: 0
                        to: 1
                        easing.type: Easing.InOutQuad
                    }
                }

                ScriptAction {
                    script: appWindow.imageTimerStart()
                }
            }
        },
        Transition {
            from: "*"
            to: "hideOldImage"

            SequentialAnimation {
                ParallelAnimation {
                    NumberAnimation {
                        id: hideOldImageAnimation
                        target: foregroundImage
                        property: "opacity"
                        from: 1
                        to: 0
                        duration: 1000
                        easing.type: Easing.InOutQuad
                    }

                    NumberAnimation {
                        target: imageDropShadow
                        property: "opacity"
                        duration: 1000
                        from: 1
                        to: 0
                        easing.type: Easing.InOutQuad
                    }
                }

                ScriptAction{
                    script: appWindow.setImageState("fadeOut")
                }
            }
        },
        Transition {
            from: "*"
            to: "fadeOut"

            SequentialAnimation {
                NumberAnimation {
                    id: fadeOutAnimation
                    target: newBackgroundBlur
                    property: "opacity"
                    duration: 600
                    easing.type: Easing.InOutQuad
                }
                ScriptAction {
                    script: appWindow.setImageState("fadeIn")
                }
            }
        }
    ]
}
