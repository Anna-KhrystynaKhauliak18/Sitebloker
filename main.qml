import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.12
import QtQuick.Controls.Universal 2.12

ApplicationWindow {
    property string primaryAddress: '0.0.0.0'
    property string secondryAddress: '0.0.0.0'
    width: 800
    height: 600
    visible: true
    title: qsTr("Site-blocker")
    Universal.theme: Universal.System
    Universal.accent: Universal.Cobalt
    Component.onCompleted: getDNS();

    Column {
        id: column
        anchors.centerIn: parent
        spacing: 16
        padding: 5
        RoundButton {anchors.horizontalCenter: parent.horizontalCenter; id:start; width: 80; height: 80; text: "Start"; clip: false; highlighted: true; flat: false; radius: 250 }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            Text { id: primaryPlaceholder; text: "Current primary DNS: " }
            Text { id: primaryDNS; text: "0.0.0.0"}
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            Text { id: secondaryPlaceholder; text: "Current secondary DNS: " }
            Text { id: secondaryDNS; text: "0.0.0.0" }
        }
    }

}
