import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    id: appWindow
    objectName: "appWindow"
    visible: true
    width: 640
    height: 480
    property int counter: 0

    property string applicationPath: ""

    signal imageStateSwitched()

    function switchImages() {
        counter++
        if(counter%2===0){
            console.log("image1")
            mainWindow.state = "image1State"
        } else {
            console.log("Image2")
            mainWindow.state = "image2State"
        }
        console.log("state switched to:",mainWindow.state)

        appWindow.imageStateSwitched()
    }

    function loadNextImage(imageSource) {
        if(counter%2===0) {
            mainWindow.image2Source = imageSource
        } else {
            mainWindow.image1Source = imageSource
        }
        console.log("image source loaded", imageSource)
    }

    Timer {
        id: photoTimer
        interval: 5000
        running: true
        repeat: true
        onTriggered: appWindow.switchImages()
    }

    MainPage {
        id: mainWindow
//        property string image1Source: "/home/ggalt/Pictures/Nikon/2016/Snowzilla/DSC_0216.JPG"
//        property string image2Source: "/home/ggalt/Pictures/Nikon/2015/Hawii and California/DSC_0918.JPG"
        property string image1Source: ""
        property string image2Source: ""
        property string imagedirectsource: "file://C:/Users/ggalt66/Pictures/Maui 2016_15-Aug-16/DSC_5683 (3).jpg"
        anchors.fill: parent
    }
}
