import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

Rectangle {
    id: imagePage
    objectName: "imagePage"
    color: "black"

    function changeState(newState) {
        console.log("New State:", newState)
        imagePage.state = newState
    }

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
                target: foregroundImage
                source: "qrc:/images/black.png"
            }
            PropertyChanges {
                target: foregroundImage
                opacity: 1
            }
            PropertyChanges {
                target: imageDropShadow
                opacity: 1
            }
            PropertyChanges {
                target: newBackgroundImage
                source: mainWindow.nextImage
            }
            PropertyChanges {
                target: newBackgroundBlur
                opacity: 0
            }
            PropertyChanges {
                target: oldBackgroundImage
                source: "qrc:/images/black.png"
            }
            PropertyChanges {
                target: oldBackgroundBlur
                opacity: 1
            }
            StateChangeScript {
                script: {
                    name: "InitializeScript"
                    console.log("InitializeScript")
                    appWindow.loadNextImage()
                    changeState("ImageOut")
                }
            }
        },

        State {
            name: "ImageOut"
            PropertyChanges {
                target: newBackgroundBlur
                opacity: appWindow.backgroundOpacity/2
            }
            PropertyChanges {
                target: oldBackgroundBlur
                opacity: appWindow.backgroundOpacity/2
            }
            PropertyChanges {
                target: foregroundImage
                opacity: 0
            }
            PropertyChanges {
                target: imageDropShadow
                opacity: 0
            }
            StateChangeScript {
                name: "ImageChangeScript"
                script: {
                    console.log("ImageChangeScript")
                    mainWindow.currentImage = mainWindow.nextImage
                    changeState("ImageIn")
                }
            }
        },

        State {
            name: "ImageIn"
            PropertyChanges {
                target: newBackgroundBlur
                opacity: 1
            }
            PropertyChanges {
                target: oldBackgroundBlur
                opacity: 0
            }
            PropertyChanges {
                target: foregroundImage
                opacity: 1
            }
            PropertyChanges {
                target: imageDropShadow
                opacity: 1
            }
            StateChangeScript {
                name: "ImageInScript"
                script: {
                    console.log("ImageChangeScript")
                    changeState("ImageDisplay")
                }
            }
        },
        State {
            name: "ImageDisplay"
            PropertyChanges {
                target: newBackgroundImage
                source: mainWindow.currentImage
            }
            PropertyChanges {
                target: imageTimer
                running: true
            }
            StateChangeScript {
                name: "ImageDisplayScript"
                script: {
                    console.log("ImageDisplayScript")
                    mainWindow.oldImage = mainWindow.currentImage
                    appWindow.loadNextImage()
                }
            }
        },
        State {
            name: "ImageReset"
            PropertyChanges {
                target: imageTimer
                running: false
            }
            PropertyChanges {
                target: oldBackgroundBlur
                opacity: 1
            }
            PropertyChanges {
                target: newBackgroundBlur
                opacity: 0
            }
            PropertyChanges {
                target: newBackgroundImage
                source: mainWindow.nextImage
            }
//            StateChangeScript {
//                name: "ImageResetScript"
//                script: {
//                    console.log("ImageResetScript")
//                    changeState("ImageOut")
//                }
//            }
        }
    ]

    transitions: [
        Transition {
            from: "*"
            to: "Initialize"
            ScriptAction {
                scriptName: "InitializeScript"
            }
        },
        Transition {
            from: "*"
            to: "ImageOut"
            SequentialAnimation {
                NumberAnimation {
                    targets: [newBackgroundBlur, oldBackgroundBlur, foregroundImage, imageDropShadow]
                    properties: "opacity"
                    duration: appWindow.backgroundTransitionDuration/2
                }
                ScriptAction {
                    scriptName: "ImageChangeScript"
                }
            }
        },
        Transition {
            from: "*"
            to: "ImageIn"
            SequentialAnimation {
                NumberAnimation {
                    targets: [newBackgroundBlur, oldBackgroundBlur, foregroundImage, imageDropShadow]
                    properties: "opacity"
                    duration: appWindow.backgroundTransitionDuration/2
                }
                ScriptAction {
                    scriptName: "ImageInScript"
                }
            }
        },
        Transition {
            from: "*"
            to: "ImageDisplay"
            ScriptAction{
                scriptName: "ImageDisplayScript"
            }
        }
//        Transition {
//            from: "*"
//            to: "ImageReset"
//            SequentialAnimation {
//                ScriptAction {
//                    scriptName: "ImageResetScript"
//                }
//            }
//        }
    ]

    onStateChanged: {
        console.log("=======================Current state is:", state)
        if(state==="ImageReset") {
            console.log("Changing state only after state change is done")
            changeState("ImageOut")
        }
    }

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
