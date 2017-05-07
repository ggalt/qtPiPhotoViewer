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
    property int imageFadeDuration: 2000
    property int backgroundTransitionDuration: 3000
    property real backgroundOpacity: 0.75
    property int blurValue: 99
    property int shadowOffset: 4
    property string pictureHome: ""
    property bool movingForward: true

//    visibility: "FullScreen"

    function toggleFullScreen() {
        // console.log("****VISIBILITY IS:",appWindow.visibility)
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
            // console.log("Next Image")
        }
        else {
            mainWindow.nextImage = myImages.previousImage()
            movingForward = true
            // console.log("****LOADING PREVIOUS IMAGE***")
        }
    }

    function imageTimerStart() {
        imageTimer.start()
        // console.log("starting image timeer")
    }

    // trying to make a simultaneous cross-fade between old and new backgrounds

    function setImageState(imgState) {

        if(imgState==="Initialize") {
            mainWindow.state = imgState
            setImageState("ImageOut")
        }
        else if(imgState==="ImageOut") {
            loadNextImage()
            mainWindow.state = imgState
        }
        else if(imgState==="ImageSwitch") {
            mainWindow.state = imgState
            mainWindow.currentImage = mainWindow.nextImage
        }
        else if(imgState==="ImageIn") {
            mainWindow.state = imgState
        }
        else if(imgState==="ImageDisplay") {
            mainWindow.oldImage = mainWindow.currentImage
            mainWindow.state = imgState
        }
        else if(imgState==="ImageInterrupt") {
            loadNextImage()
            mainWindow.state = imgState
//            console.log("state is ImageInterrupt")
        }
        else {
             console.log("HELP!! Unknown image state:", imgState)
        }
    }

    function goToImage(direction) {
        imageTimer.stop()
        if(direction === "next") {
            movingForward = true
        } else {
            movingForward = false
        }
        console.log("Moving Forward:", movingForward, "timer is running?", imageTimer.running)
        appWindow.setImageState("ImageInterrupt")
    }

    function loadSettingsDialog() {
        Qt.createComponent("SettingsDialog.qml").createObject(appWindow,{})
    }

    function changeSettings(newBlurValue, newDurationValue, newURL) {
        // console.log("blur:",newBlurValue,"duration:",newDurationValue,"URL:",newURL)
        if(newBlurValue > 0)
            blurValue = newBlurValue
        if(newDurationValue > 0)
            showImageDuration = newDurationValue * 1000
        if(newURL!= "") {
            pictureHome = newURL
        }
    }

    Timer {
        id: imageTimer
        interval: showImageDuration
        running: false
        onTriggered: {
            // console.log("imageTimer triggered")
            mainWindow.state = "ImageReset"
        }
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
        onDoubleClicked: loadSettingsDialog() //launch settings dialog
        onPressAndHold: appWindow.toggleFullScreen()
        onClicked: {
            console.log("MOUSE CLICK", mouseX)
            console.log("Screen width:", parent.width)
            if(mouseX < parent.width / 4) {     // we clicked on the left so we want to back up
                goToImage("previous")
            } else if(mouseX > 3*parent.width / 4){
                goToImage("next")
            }
        }
    }
    Keys.onLeftPressed: goToImage("previous")
    Keys.onRightPressed: goToImage("next")
}
