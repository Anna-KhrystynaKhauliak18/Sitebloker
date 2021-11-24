import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.12

Window {
    property string backgroundColor: "#FFFFFF"
    property string primary: "#6200EE"
    property string textOnPrimary: "#FFFFFF"

    id: window

    function setTheme(theme) {

        if (theme === "Dark") {
            backgroundColor = "#121212"

        } else if (theme === "Light") {
            backgroundColor = "#FFFFFF"
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

    Column {
        id: column
        anchors.centerIn: parent
        spacing: 16
        padding: 5
        RoundButton {
            property int size: 160;
            palette.button: "salmon"
            anchors.horizontalCenter: parent.horizontalCenter;
            id:start;
            width: size;
            height: size;
            text: "Start";
            font.pixelSize: 24;
            layer.smooth: true
            layer.mipmap: true
            antialiasing: true;
            font.family: qsTr("Segoe UI");
            clip: false;
            highlighted: true;
            flat: false;
            radius: 250 }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            Text { id: primaryPlaceholder; text: "Current primary DNS: " }
            Text { id: primaryDNS; text: primaryServer }
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            Text { id: secondaryPlaceholder; text: "Current secondary DNS: " }
            Text { id: secondaryDNS; text: secondaryServer }
            
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
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        
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


