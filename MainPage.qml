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
        source: mainWindow.currentImage
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
        source: mainWindow.oldImage
        autoTransform: true
        opacity: 0
    }

    FastBlur {
        id: oldBackgroundBlur
        anchors.fill: oldBackgroundImage
        source: oldBackgroundImage
        radius: appWindow.blurValue
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
        source: mainWindow.currentImage
        autoTransform: true
    }

    states: [
        State {
            name: "Initialize"
            PropertyChanges {
                target: startOffTimer
                running: true
            }
            PropertyChanges {
                target: foregroundImage
                source: "qrc:/images/black.png"
            }
            PropertyChanges {
                target: newBackgroundImage
                source: "qrc:/images/black.png"
            }
            PropertyChanges {
                target: oldBackgroundImage
                source: "qrc:/images/black.png"
            }
        },

        State {
            name: "ImageOut"
            PropertyChanges {
                target: newBackgroundImage
                source: mainWindow.nextImage
            }
            PropertyChanges {
                target: foregroundImage
                source: mainWindow.oldImage
            }
        },

        // Image should be faded out and we should be mid-transition between backgrounds
        State {
            name: "ImageSwitch"
            PropertyChanges {
                target: foregroundImage
                source: mainWindow.currentImage
            }
        },
        State {
            name: "ImageIn"
            PropertyChanges {
                target: newBackgroundImage
                source: mainWindow.currentImage
            }
        },
        State {
            name: "ImageDisplay"
            PropertyChanges {
                target: imageTimer
                running: true
            }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "ImageOut"
            ScriptAction {
                script: appWindow.setImageState("ImageSwitch")
            }

        },
        Transition {
            from: "*"
            to: "ImageSwitch"
            SequentialAnimation {
                ParallelAnimation {

                    NumberAnimation {
                        target: newBackgroundBlur
                        property: "opacity"
                        duration: appWindow.backgroundTransitionDuration/2
                        from: 0
                        to: appWindow.backgroundOpacity /2
                        easing.type: Easing.InQuad
                    }


                    NumberAnimation {
                        target: oldBackgroundBlur
                        property: "opacity"
                        duration: appWindow.backgroundTransitionDuration/2
                        from: 1
                        to: appWindow.backgroundOpacity/2
                        easing.type: Easing.InQuad
                    }


                    NumberAnimation {
                        target: foregroundImage
                        property: "opacity"
                        duration: appWindow.backgroundTransitionDuration/2
                        from: 1
                        to: 0
                        easing.type: Easing.InOutQuad
                    }


                    NumberAnimation {
                        target: imageDropShadow
                        property: "opacity"
                        duration: appWindow.backgroundTransitionDuration/2
                        from: 1
                        to: 0
                        easing.type: Easing.InOutQuad
                    }
                }

                ScriptAction {
                    script: appWindow.setImageState("ImageIn")
                }
            }
        },
        Transition {
            from: "*"
            to: "ImageIn"
            SequentialAnimation {
                ParallelAnimation {

                    NumberAnimation {
                        target: newBackgroundBlur
                        property: "opacity"
                        duration: appWindow.backgroundTransitionDuration/2
                        from: appWindow.backgroundOpacity /2
                        to: 1
                        easing.type: Easing.OutQuad
                    }


                    NumberAnimation {
                        target: oldBackgroundBlur
                        property: "opacity"
                        duration: appWindow.backgroundTransitionDuration/2
                        from: appWindow.backgroundOpacity /2
                        to: 0
                        easing.type: Easing.OutQuad
                    }


                    NumberAnimation {
                        target: foregroundImage
                        property: "opacity"
                        duration: appWindow.backgroundTransitionDuration/2
                        from: 0
                        to: 1
                        easing.type: Easing.InOutQuad
                    }


                    NumberAnimation {
                        target: imageDropShadow
                        property: "opacity"
                        duration: appWindow.backgroundTransitionDuration/2
                        from: 0
                        to: 1
                        easing.type: Easing.InOutQuad
                    }
                }

                ScriptAction {
                    script: appWindow.setImageState("ImageDisplay")
                }
            }
        },
        Transition {
            from: "*"
            to: "ImageDisplay"

        }
    ]

}
////////////////////////////////////////////////////////////////////////////////////////////

//    states: [
//        State {
//            name: "blackOut"
//            PropertyChanges {
//                target: startOffTimer
//                running: true
//            }
//        },
//        State {
//            name: "fadeIn"
//            PropertyChanges {
//                target: foregroundImage
//                opacity: 0
//            }
//            PropertyChanges {
//                target: newBackgroundBlur
//                opacity: appWindow.backgroundOpacity
//            }
//            PropertyChanges {
//                target: oldBackgroundBlur
//                opacity: 0
//            }
//        },
//        State {
//            name: "showNewImage"
//            PropertyChanges {
//                target: foregroundImage
//                opacity: 1
//            }
//            PropertyChanges {
//                target: newBackgroundBlur
//                opacity: appWindow.backgroundOpacity
//            }
//            PropertyChanges {
//                target: oldBackgroundBlur
//                opacity: 0
//            }
//        },
//        State {
//            name: "hideOldImage"
//            PropertyChanges {
//                target: foregroundImage
//                opacity: 0
//            }
//            PropertyChanges {
//                target: newBackgroundBlur
//                opacity: 0
//            }
//            PropertyChanges {
//                target: oldBackgroundBlur
//                opacity: appWindow.backgroundOpacity
//            }
//        },
//        State {
//            name: "fadeOut"
//            PropertyChanges {
//                target: foregroundImage
//                opacity: 0
//            }
//            PropertyChanges {
//                target: newBackgroundBlur
//                opacity: 0
//            }
//            PropertyChanges {
//                target: oldBackgroundBlur
//                opacity: 0
//            }
//        }
//    ]

//    transitions: [
//        Transition {
//            from: "*"
//            to: "fadeIn"

//            SequentialAnimation {
//                ParallelAnimation {
//                    NumberAnimation {
//                        id: fadeInAnimation
//                        target: newBackgroundBlur
//                        property: "opacity"
//                        from: 0
////                        to: 1
//                        duration: appWindow.backgroundTransitionDuration
//                        easing.type: Easing.InQuad
//                    }

//                    NumberAnimation {
//                        id: fadeOutAnimation
//                        target: oldBackgroundBlur
//                        property: "opacity"
////                        from: 1
//                        to: 0
//                        duration: appWindow.backgroundTransitionDuration
//                        easing.type: Easing.OutQuad
//                    }

//                }

//                ScriptAction {
//                    script: appWindow.setImageState("showNewImage")
//                }
//            }

//        },
//        Transition {
//            from: "*"
//            to: "showNewImage"

//            SequentialAnimation {
//                ParallelAnimation {
//                    NumberAnimation {
//                        id: showNewImageAnimation
//                        target: foregroundImage
//                        property: "opacity"
//                        from: 0
//                        to: 1
//                        duration: appWindow.imageFadeDuration
//                        easing.type: Easing.OutQuad
//                    }

//                    NumberAnimation {
//                        target: imageDropShadow
//                        property: "opacity"
//                        duration: appWindow.imageFadeDuration
//                        from: 0
//                        to: 1
//                        easing.type: Easing.OutQuad
//                    }
//                }

//                ScriptAction {
//                    script: appWindow.imageTimerStart()
//                }
//            }
//        },
//        Transition {
//            from: "*"
//            to: "hideOldImage"

//            SequentialAnimation {
//                ParallelAnimation {
//                    NumberAnimation {
//                        id: hideOldImageAnimation
//                        target: foregroundImage
//                        property: "opacity"
//                        from: 1
//                        to: 0
//                        duration: appWindow.imageFadeDuration
//                        easing.type: Easing.InQuad
//                    }

//                    NumberAnimation {
//                        target: imageDropShadow
//                        property: "opacity"
//                        duration: appWindow.imageFadeDuration
//                        from: 1
//                        to: 0
//                        easing.type: Easing.InQuad
//                    }
//                }

//                ScriptAction{
//                    script: appWindow.setImageState("fadeIn")
//                }
//            }
//        }
////        },
////        Transition {
////            from: "*"
////            to: "fadeOut"

////            SequentialAnimation {
////                NumberAnimation {
////                    id: fadeOutAnimation
////                    target: newBackgroundBlur
////                    property: "opacity"
////                    duration: 600
////                    easing.type: Easing.InOutQuad
////                }
////                ScriptAction {
////                    script: appWindow.setImageState("fadeIn")
////                }
////            }
////        }
//    ]
