import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    id: appWindow
    objectName: "appWindow"
    visible: true
    width: 640
    height: 480
    property int showImageDuration: 5000    // 5 seconds (5000 milliseconds)
    //    visibility: "FullScreen"

    function getImage() {
        return myImages.nextImage()
    }

    function loadNextImage() {
        mainWindow.nextImage = myImages.nextImage()
    }

    Timer {
        id: imageTimer
        interval: showImageDuration
        running: false
        onTriggered: setImageState("hideOldImage")
    }

    function setImageState(imgState) {
        mainWindow.state = imgState
        if(imgState === "fadeIn") {
            console.log(mainWindow.state)
            mainWindow.currentImage = mainWindow.nextImage
            loadNextImage()
        } else if(imgState === "showNewImage") {
            console.log(mainWindow.state)
            imageTimer.start()
        } else if(imgState === "hideOldImage") {
            console.log(mainWindow.state)
            imageTimer.stop()
        } else if(imgState === "fadeOut") {
            console.log(mainWindow.state)
        } else {
            console.log(mainWindow.state)
            console.error("UNDEFINED STATE")
        }
    }

    MainPage {
        id: mainWindow
        property string currentImage: ""
        property string nextImage: appWindow.getImage()
        anchors.fill: parent
    }

    MouseArea {
        anchors.fill: parent
    }

}
