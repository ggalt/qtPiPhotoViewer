import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0

Item {
    id: root
    width: 580
    height: 400
    SystemPalette { id: palette }
    clip: true

    FileDialog {
        id: dlgImageFolder
        folder: appWindow.pictureHome
    }

    Dialog {
        id: helloDialog
        modality: dialogModal.checked ? Qt.WindowModal : Qt.NonModal
        title: customizeTitle.checked ? windowTitleField.text : "Hello"
        onButtonClicked: console.log("clicked button " + clickedButton)
        onAccepted: lastChosen.text = "Accepted " +
            (clickedButton == StandardButton.Ok ? "(OK)" : (clickedButton == StandardButton.Retry ? "(Retry)" : "(Ignore)"))
        onRejected: lastChosen.text = "Rejected " +
            (clickedButton == StandardButton.Close ? "(Close)" : (clickedButton == StandardButton.Abort ? "(Abort)" : "(Cancel)"))
        onHelp: lastChosen.text = "Yelped for help!"
        onYes: lastChosen.text = (clickedButton == StandardButton.Yes ? "Yeessss!!" : "Yes, now and always")
        onNo: lastChosen.text = (clickedButton == StandardButton.No ? "Oh No." : "No, no, a thousand times no!")
        onApply: lastChosen.text = "Apply"
        onReset: lastChosen.text = "Reset"

        Label {
            text: "Hello world!"
        }
    }

}
