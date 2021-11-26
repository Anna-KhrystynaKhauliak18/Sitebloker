import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.12


Window {
    property string backgroundColor: "#FFFFFF"
    property string primary: "#6200EE"
    property string textOnPrimary: "#FFFFFF"
    property string textOnBackground: "#000000"
    id: window
    function setTheme(theme) {

        if (theme === "Dark") {
            backgroundColor = "#121212"
            textOnBackground = "#FFFFFF"

        } else if (theme === "Light") {
            backgroundColor = "#FFFFFF"
            textOnBackground = "#000000"
        }
        window.color = backgroundColor
    }

    color: background
    width: 800
    height: 600
    visible: true
    title: qsTr("Site-blocker")
    property string primaryServer: '0.0.0.0'
    property string secondaryServer: '0.0.0.0'

    signal button_signal()

    Column {
        id: column
        anchors.centerIn: parent
        spacing: 16
        padding: 5
        RoundButton {
            radius: 200
            anchors.horizontalCenter: parent.horizontalCenter;
            id: start;
            width: radius;
            height: radius;
            text: "Start";
            font.pixelSize: 24;
            antialiasing: true;
            font.family: qsTr("Segoe UI");
            highlighted: true;
            flat: false;
            onClicked: button_signal()
            }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            Text { id: primaryPlaceholder; text: "Current primary DNS: "; color: textOnBackground }
            Text { id: primaryDNS; text: primaryServer; color: textOnBackground }
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            Text { id: secondaryPlaceholder; text: "Current secondary DNS: "; color: textOnBackground }
            Text { id: secondaryDNS; text: secondaryServer; color: textOnBackground }
            
        }
        
    }
    Popup {
        background: Rectangle {
            color: backgroundColor
        }

        id: popup
        width: parent.width - 40
        height: parent.height - 40
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal: true
        focus: true
        closePolicy: Popup.CloseOnPressOutsideParent | Popup.CloseOnEscape
        
            Column {
                Row {
                id: row
                x: parent.x + 5
                y: parent.y + 5
                width: 200
                height: 400
                
                ListModel {
                    id: themes

                    ListElement { name: "Light" }
                    ListElement { name: "Dark" }
                }

                ComboBox {
                    model: themes
                    onCurrentTextChanged: { setTheme(currentText) }
                }
            }
        }
    }

    Button {
        id: config_button
        text: "Config"
        width: 80
        height: 40
        x: (parent.width - width - 5)
        y: (parent.height - height - 5)
        onClicked: popup.open()
    }
}


