import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.0

Rectangle {
    id: imagePage
    objectName: "imagePage"
    color: "black"

    function changeState(newState) {
        // console.log("Current State:", state)
        // console.log("New State:", newState)
        imagePage.state = newState
    }

    Timer {
        id: startOffTimer
        interval: 1000
        running: false
        onTriggered: {
            // console.log("startoffTimer stopping")
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
//        onOpacityChanged: // console.log("NEW IMAGE BLUR OPACITY CHANGED TO:", newBackgroundBlur.opacity, "state is:", imagePage.state)
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
        horizontalOffset: appWindow.shadowOffset
        verticalOffset: appWindow.shadowOffset
        radius: 8.0
        anchors.fill: foregroundImage
        samples: 17
        transparentBorder: true
        color: "#80000000"
        source: foregroundImage
        opacity: 0
    }

    Image {
        id: foregroundImage
        anchors.fill: parent
        anchors.rightMargin: 10 + appWindow.shadowOffset
        anchors.leftMargin: 10 + appWindow.shadowOffset
        anchors.bottomMargin: 10 + appWindow.shadowOffset
        anchors.topMargin: 10 + appWindow.shadowOffset
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
                    // console.log("InitializeScript")
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
        },
        State {
            name: "ImageDisplay"
            PropertyChanges {
                target: newBackgroundImage
                source: mainWindow.currentImage
            }
            PropertyChanges {
                target: oldBackgroundImage
                source: mainWindow.oldImage
            }
            PropertyChanges {
                target: imageTimer
                running: true
            }
            PropertyChanges {
                target: newBackgroundBlur
                opacity: 0
            }
            PropertyChanges {
                target: oldBackgroundBlur
                opacity: 1
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
                name: "ImageDisplayScript"
                script: {
                    // console.log("ImageDisplayScript")
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
        },
        State {
            name: "ImageInterrupt"
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
            StateChangeScript {
                name: "ImageInterruptScript"
                script: {
                    mainWindow.oldImage = mainWindow.currentImage
                }
            }
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
            ParallelAnimation {
                NumberAnimation {
                    target: newBackgroundBlur
                    property: "opacity"
                    duration: appWindow.backgroundTransitionDuration/2
                    easing.type: Easing.InQuad
                }
                NumberAnimation {
                    target: oldBackgroundBlur
                    property: "opacity"
                    duration: appWindow.backgroundTransitionDuration/2
                    easing.type: Easing.InQuad
                }
                NumberAnimation {
                    target: foregroundImage
                    property: "opacity"
                    duration: appWindow.backgroundTransitionDuration/2
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: imageDropShadow
                    property: "opacity"
                    duration: appWindow.backgroundTransitionDuration/2
                    easing.type: Easing.InOutQuad
                }
            }

            onRunningChanged: {
                if((state=="ImageOut") && (!running)) {
                    mainWindow.currentImage = mainWindow.nextImage
                    changeState("ImageIn")
                }
            }
        },
        Transition {
            from: "*"
            to: "ImageIn"
            ParallelAnimation {
                NumberAnimation {
                    target: newBackgroundBlur
                    property: "opacity"
                    to: 1
                    duration: appWindow.backgroundTransitionDuration/2
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    target: oldBackgroundBlur
                    property: "opacity"
                    to: 0
                    duration: appWindow.backgroundTransitionDuration/2
                    easing.type: Easing.OutQuad
                }
                NumberAnimation {
                    target: foregroundImage
                    property: "opacity"
                    duration: appWindow.backgroundTransitionDuration/2
                    easing.type: Easing.InOutQuad
                }
                NumberAnimation {
                    target: imageDropShadow
                    property: "opacity"
                    duration: appWindow.backgroundTransitionDuration/2
                    easing.type: Easing.InOutQuad
                }
            }

            onRunningChanged: {
                if((state=="ImageIn") && (!running)) {
                    // console.log("ImageChangeScript")
                    mainWindow.oldImage = mainWindow.currentImage
                    changeState("ImageDisplay")
                }
            }
        },
        Transition {
            from: "*"
            to: "ImageDisplay"
            ScriptAction{
                scriptName: "ImageDisplayScript"
            }
        },
        Transition {
            from: "*"
            to: "ImageReset"
            onRunningChanged: {
                // console.log("ImageResetScript")
                changeState("ImageOut")
            }
        },
        Transition {
            from: "*"
            to: "ImageInterrupt"

            NumberAnimation {
                targets: [newBackgroundBlur, oldBackgroundBlur, foregroundImage, imageDropShadow]
                properties: "opacity"
                duration: 100
            }

            onRunningChanged:  {
                // console.log("ImageInterruptScript")
                changeState("ImageOut")
            }
        }
    ]

}
