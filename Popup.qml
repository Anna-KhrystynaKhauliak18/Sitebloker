import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    width: 1920
    height: 1080
    Column {
        
        Row {
            id: row
            x: 640
            y: 360
            width: 200
            height: 400
            
            Switch {
                id: switch1
                width: parent.width
                text: qsTr("Dark mode")
            }
         Row {
             width: 200
             height: 400


             ComboBox {
                 model: listModel
             }

             ListModel {
                 id: listModel
                 width: parent.width
                 Component.onCompleted: {
                             for (var i = 0; i < 24; i++) {
                                 append(createListElement());
                             }
                         }
             }
         }

        }
    }

}
