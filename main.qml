import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Window 2.2

ApplicationWindow {
    id: appWindow
    objectName: "appWindow"
    visible: true
    width: 640
    height: 480
    property int showImageDuration: 5000    // 5 seconds (5000 milliseconds)
    property bool movingForward: true


//    visibility: "FullScreen"

    function toggleFullScreen() {
        console.log("****VISIBILITY IS:",appWindow.visibility)
        if(appWindow.visibility===5)
            appWindow.visibility="Windowed"
        else
            appWindow.visibility="FullScreen"
    }

    function getImage() {
        return myImages.nextImage()
    }

    function loadNextImage() {
        if(movingForward) {
            mainWindow.nextImage = myImages.nextImage()
            console.log("Next Image")
        }
        else {
            mainWindow.nextImage = myImages.previousImage()
            movingForward = true
            console.log("****LOADING PREVIOUS IMAGE***")
        }
    }

    function imageTimerStart() {
        imageTimer.start()
        console.log("starting image timeer")
    }

    // trying to make a simultaneous cross-fade between old and new backgrounds
    function setImageState(imgState) {
        mainWindow.state = imgState
        console.log("main.qml function setting mainWindow state to:", imgState)
        if(imgState === "fadeIn") {
//            mainWindow.currentImage = mainWindow.nextImage
            loadNextImage()

        } else if(imgState === "showNewImage") {
            mainWindow.oldImage = mainWindow.currentImage
            console.log(mainWindow.state)
            //            imageTimer.start()

        } else if(imgState === "hideOldImage") {
            console.log(mainWindow.state)
            imageTimer.stop()

        } else if(imgState === "fadeOut") { // swap
            mainWindow.currentImage = mainWindow.nextImage
            console.log(mainWindow.state)

        } else {
            console.log(mainWindow.state)
            console.error("UNDEFINED STATE")

        }
    }
    /// original function when we were allowing a period of black between backgrounds
//    function setImageState(imgState) {
//        mainWindow.state = imgState
//        console.log("main.qml function setting mainWindow state to:", imgState)
//        if(imgState === "fadeIn") {
//            mainWindow.currentImage = mainWindow.nextImage
//            loadNextImage()

//        } else if(imgState === "showNewImage") {
//            console.log(mainWindow.state)
//            //            imageTimer.start()

//        } else if(imgState === "hideOldImage") {
//            console.log(mainWindow.state)
//            imageTimer.stop()

//        } else if(imgState === "fadeOut") {
//            console.log(mainWindow.state)

//        } else {
//            console.log(mainWindow.state)
//            console.error("UNDEFINED STATE")

//        }
//    }

    function goToImage(direction) {
        imageTimer.stop()
        if(direction === "next") {
            movingForward = true
        } else {
            movingForward = false
        }
        appWindow.setImageState("fadeIn")
    }

    Timer {
        id: imageTimer
        interval: showImageDuration
        running: false
        onTriggered: setImageState("hideOldImage")
    }

    MainPage {
        id: mainWindow
        property string currentImage: appWindow.getImage()
        property string nextImage: ""
        property string oldImage: ""
        property bool isFirstImage: true
        anchors.fill: parent
    }

    MouseArea {
        anchors.fill: parent
        onDoubleClicked: appWindow.toggleFullScreen()
        onClicked: {
            if(mouseX < Screen.width / 4) {     // we clicked on the left so we want to back up
                goToImage("previous")
            } else if(mouseX > 3*Screen.width / 4){
                goToImage("next")
            }
        }
    }
    Keys.onLeftPressed: console.log("Left key pressed")
    Keys.onRightPressed: console.log("Right key pressed")
}
