import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.12
import QtQuick.Extras 1.4


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
            config_button.source = "settings_dark.png"

        } else if (theme === "Light") {
            backgroundColor = "#FFFFFF"
            textOnBackground = "#000000"
            config_button.source = "settings.png"
        }
        window.color = backgroundColor
    }

    color: background
    width: 800
    height: 600
    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width
    visible: true
    title: qsTr("Site-blocker")
    property string primaryServer: '0.0.0.0'
    property string secondaryServer: '0.0.0.0'


    signal button_signal()
    signal setServer(string server)
    signal setInterface(string nic)
    signal init_signal()
    signal dns_signal()
    signal close_signal()
    
    onClosing: close_signal()
    Image {
        id: config_button
        source: "settings.png"
        width: 32
        height: 32
        x: (parent.width - width - 6)
        y: (parent.height - height - 6)
        MouseArea { anchors.fill: parent; onClicked: popup.open() }
    }

    Column {
        id: column
        anchors.centerIn: parent
        spacing: 16
        padding: 5

        /*ToggleButton {
            radius: 200
            anchors.horizontalCenter: parent.horizontalCenter;
            id: start;
            width: radius;
            height: radius;
            text: qsTr("Start/Stop");
            font.pixelSize: 24;
            antialiasing: true;
            font.family: "Segoe UI";
            highlighted: true;
            flat: false;
            onClicked: button_signal()
        }*/
        ToggleButton {
            id: start;
            onClicked: button_signal()
            width: 200
            height: 200
            text: qsTr("Start/Stop");
            antialiasing: true;
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
        onTriggered: init_signal()
        }
    
    Timer {
        interval: 10; running: true; repeat: true
        onTriggered: dns_signal()
    }


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
                            name: qsTr("Light")
                        }
                        ListElement {
                            name: qsTr("Dark")
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
                        text: qsTr("DNS server")
                        y: (parent.height - serverChooser.height - height) / 2
                        color: textOnBackground
                    }
                    ListModel {
                        id: serversList

                        function addItem(serverName) {
                            serversList.append( { "name": serverName } )
                            //console.log(serverName)
                        }
                    }
                    ComboBox {
                        id: serverChooser
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: 0
                        anchors.bottomMargin: 0
                        currentIndex: 0
                        model: serversList
                        width: parent.width
                        onCurrentTextChanged: setServer(currentText)
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
                        id: interfaceLabel
                        text: qsTr("Network interface")
                        y: (parent.height - serverChooser.height - height) / 2
                        color: textOnBackground
                    }
                    ListModel {
                        id: interfacesList

                        function addItem(interfaceName) {
                            interfacesList.append( { "name": interfaceName } )
                            //console.log(interfaceName)
                        }
                    }
                    ComboBox {
                        id: interfaceChooser
                        anchors.right: parent.right
                        anchors.bottom: parent.bottom
                        anchors.rightMargin: 0
                        anchors.bottomMargin: 0
                        currentIndex: 0
                        model: interfacesList
                        width: parent.width
                        onCurrentTextChanged: setInterface(currentText)
                    }
                }
            }
        }
    }


    Connections {
        target: program

        onStartSignal: {
            RoundButton.text = qsTr("Stop")
        }
        
        onAddServersItem: {
            serversList.addItem(name)
        }

        onAddInterfacesItem: {
            interfacesList.addItem(name)
        }
    }


}