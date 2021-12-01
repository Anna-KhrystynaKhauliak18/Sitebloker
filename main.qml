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
    signal setServer(string server)
    signal init_signal()

    Button {
        id: config_button
        text: qsTr("Config")
        width: 80
        height: 40
        x: (parent.width - width - 5)
        y: (parent.height - height - 5)
        onClicked: popup.open()
    }

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
            Text { id: primaryPlaceholder; text: qsTr("Current primary DNS: "); color: textOnBackground }
            Text { id: primaryDNS; text: primaryServer; color: textOnBackground }
        }
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            Text { id: secondaryPlaceholder; text: qsTr("Current secondary DNS: "); color: textOnBackground }
            Text { id: secondaryDNS; text: secondaryServer; color: textOnBackground } 
        }
    }
        
    Timer {
        interval: 10; running: true; repeat: false
        onTriggered: init_signal() }

    Popup {
        background: Rectangle { color: backgroundColor }

        id: popup
        width: parent.width - 40
        height: parent.height - 40
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        modal: true
        focus: true
        closePolicy: Popup.CloseOnPressOutsideParent | Popup.CloseOnEscape
        Row {
            id: mainRow
            Column {
                Column {
                    padding: 5
                    x: parent.x + 5
                    y: parent.y + 5
                    width: 200
                    height: 80

                    Text {
                        id: themeCaption
                        text: "Theme (restart not required)"
                        y: (parent.height - themeSelector.height - height) / 2
                        color: textOnBackground
                    }
                    ListModel {
                        id: themes

                        ListElement {
                            name: "Light"
                        }
                        ListElement {
                            name: "Dark"
                        }
                    }
                    ComboBox {
                        id: themeSelector
                        model: themes
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: 0
                        anchors.bottomMargin: 0
                        width: parent.width
                        onCurrentTextChanged: { setTheme(currentText) }
                    }
                }
                Column {
                    padding: 5
                    topPadding: 20
                    x: parent.x + 5
                    y: parent.y + 5
                    width: 200
                    height: 80
                    Text {
                        id: themeCaption1
                        text: "Select DNS server"
                        y: (parent.height - serverChooser.height - height) / 2
                        color: textOnBackground
                    }
                    ListModel {
                        id: serversList

                        function addItem(serverName) {
                            serversList.append( { "name": serverName } )
                            console.log(serverName)
                        }
                    }
                    ComboBox {
                        id: serverChooser
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: 0
                        anchors.bottomMargin: 0
                        model: serversList
                        width: parent.width
                        onCurrentTextChanged: setServer(currentText)
                    }
                }
            }
        }
    }


    Connections {
        target: program

        onStartSignal: {
            RoundButton.text = "Stop"
        }
        
        onAddListItem: {
            serversList.addItem(name)
        }
    }


}