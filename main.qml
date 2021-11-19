import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.12
import QtQuick.Controls.Universal 2.12

Window {
    width: 800
    height: 600
    visible: true
    title: qsTr("Site-blocker")
    Universal.theme: Universal.Light
    Universal.accent: Universal.Cobalt
    Component.onCompleted: getDNS();
    property string primaryServer: '0.0.0.0'
    property string secondaryServer: '0.0.0.0'

    Column {
        id: column
        anchors.centerIn: parent
        spacing: 16
        padding: 5
        RoundButton { property int size: 160; anchors.horizontalCenter: parent.horizontalCenter; id:start; width: size; height: size; text: "Start"; font.pixelSize: 24; antialiasing: true; font.family: qsTr("Segoe UI"); clip: false; highlighted: true; flat: false; radius: 250 }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            Text { id: primaryPlaceholder; text: "Current primary DNS: " }
            Text { id: primaryDNS; text: primaryServer}
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            Text { id: secondaryPlaceholder; text: "Current secondary DNS: " }
            Text { id: secondaryDNS; text: secondaryServer }
        }
        
    }
    Popup {
        id: popup
        width: parent.width - 40
        height: parent.height - 40
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutsideParent
        Column {
            CheckBox { text: qsTr("E-mail") }
            CheckBox { text: qsTr("Calendar") }
            CheckBox { text: qsTr("Contacts") }
        }
    }

    Button {
        id: config_button
        text: "Config"
        width: 40
        height: 40
        x: (parent.width - width - 5)
        y: (parent.height - height - 5)
        onClicked: popup.open()
    }
}


