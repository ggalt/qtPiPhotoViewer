import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    id: appWindow
    objectName: "mainPage"
    visible: true
    width: 640
    height: 480
    property int counter: 0

    property string applicationPath: ""

    function switchImages() {
        counter++
        if(counter%2===0){
            console.log("image1")
            console.log(applicationPath)
            mainPage.state = "image1"
        } else {
            console.log("Image2")
            console.log(applicationPath)
            mainPage.state = "image2"
        }

    }

    Timer {
        id: photoTimer
        interval: 5000
        running: true
        repeat: true
        onTriggered: appWindow.switchImages()
    }

    MainPage {
        id: mainPage
//        property string image1Source: "/home/ggalt/Pictures/Nikon/2016/Snowzilla/DSC_0216.JPG"
//        property string image2Source: "/home/ggalt/Pictures/Nikon/2015/Hawii and California/DSC_0918.JPG"
        property string image1Source: "/images/DSC06069.JPG"
        property string image2Source: "/images/DSC06092.JPG"
        anchors.fill: parent
    }
}
