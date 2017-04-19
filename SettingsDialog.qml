import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2


Item {
    id: dialogComponent
    anchors.fill: parent
    // Add a simple animation to fade in the popup
    // let the opacity go from 0 to 1 in 400ms
    PropertyAnimation { target: dialogComponent; property: "opacity";
        duration: 400; from: 0; to: 1;
        easing.type: Easing.InOutQuad ; running: true }

    property string pictreFolderHome: ""
    property int newBlurValue: appWindow.blurValue
    property int newDurationValue: appWindow.showImageDuration / 1000

    function acceptNewValues() {
        appWindow.changeSettings(newBlurValue,newDurationValue,pictreFolderHome)
        dialogComponent.destroy()
    }

    // This rectange is the a overlay to partially show the parent through it
    // and clicking outside of the 'dialog' popup will do 'nothing'
    Rectangle {
        anchors.fill: parent
        id: overlay
        color: "#000000"
        opacity: 0.6
        // add a mouse area so that clicks outside
        // the dialog window will not do anything
        MouseArea {
            anchors.fill: parent
        }
    }

    // This rectangle is the actual popup
    FileDialog {
        id: fileDialog
        title: "Please choose the parent folder for pictures"
        selectFolder: true
        folder: shortcuts.pictures
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrls)
            Qt.quit()
        }
        onRejected: {
            console.log("Canceled")
            Qt.quit()
        }
    }
    Rectangle {
        id: dialogWindow
        width: 320
        height: 200
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#ffffff"
            }

            GradientStop {
                position: 0.003
                color: "#1ff3cf"
            }

            GradientStop {
                position: 1
                color: "#4c4c4c"
            }

        }
        anchors.centerIn: parent

        Text {
            id: text1
            x: 28
            y: 41
            width: 114
            height: 19
            text: qsTr("Background Blur Value:")
            font.pointSize: 12
        }

        Button {
            id: btnAccept
            x: 28
            y: 155
            text: qsTr("Accept")
            isDefault: true
            onClicked: {
                dialogComponent.destroy()
            }
        }

        Button {
            id: btnCancel
            x: 215
            y: 155
            text: qsTr("Cancel")
            onClicked: {
                dialogComponent.destroy()
            }
        }

        Button {
            id: btnFolderChooser
            x: 28
            y: 106
            width: 262
            height: 43
            text: qsTr("Choose Base Picture Folder")
        }

        Text {
            id: text2
            x: 28
            y: 72
            text: qsTr("Image Display Duration:")
            font.pixelSize: 12
        }

        SpinBox {
            id: blurValueSpinner
            x: 210
            y: 40
            width: 80
            height: 20
            maximumValue: 300
        }

        SpinBox {
            id: durationValueSpinner
            x: 210
            y: 75
            width: 80
            height: 20
        }

    }
}

//Item {
//    id: settingsDialog
//    width: 580
//    height: 400
////    SystemPalette { id: palette }
////    clip: true

//    PropertyAnimation { target: settingsDialog; property: "opacity";
//                                  duration: 400; from: 0; to: 1;
//                                  easing.type: Easing.InOutQuad ; running: true }
//    FileDialog {
//        id: dlgImageFolder
//        folder: appWindow.pictureHome
//        width: 500
//        height: 300
//    }

////    Dialog {
////        id: helloDialog
////        modality: dialogModal.checked ? Qt.WindowModal : Qt.NonModal
////        title: customizeTitle.checked ? windowTitleField.text : "Hello"
////        onButtonClicked: console.log("clicked button " + clickedButton)
////        onAccepted: lastChosen.text = "Accepted " +
////            (clickedButton == StandardButton.Ok ? "(OK)" : (clickedButton == StandardButton.Retry ? "(Retry)" : "(Ignore)"))
////        onRejected: lastChosen.text = "Rejected " +
////            (clickedButton == StandardButton.Close ? "(Close)" : (clickedButton == StandardButton.Abort ? "(Abort)" : "(Cancel)"))
////        onHelp: lastChosen.text = "Yelped for help!"
////        onYes: lastChosen.text = (clickedButton == StandardButton.Yes ? "Yeessss!!" : "Yes, now and always")
////        onNo: lastChosen.text = (clickedButton == StandardButton.No ? "Oh No." : "No, no, a thousand times no!")
////        onApply: lastChosen.text = "Apply"
////        onReset: lastChosen.text = "Reset"

////        Label {
////            text: "Hello world!"
////        }
////    }

//    Rectangle {
//        height: 40
//        width: 100
//        radius: 10
//        anchors.centerIn: parent
//        anchors.bottom: parent.bottom
//        MouseArea {
//            anchors.fill: parent
//            onClicked: settingsDialog.destroy()
//        }
//    }

//}
