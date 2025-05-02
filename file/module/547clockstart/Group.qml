import QtQuick

Rectangle {
    property var per
    property string name
    property int num
    property var objs:[]
    property var obj_items:[]
    property double le
    property bool active:false
    property color colorBg:active?"#DDDDDD":"#FFFFFF"
    color: colorBg
    width: 200-le
    height: 30
    border.color: "#808080"
    border.width: 1
    Text {
        text: name
        font.pixelSize: 15
        y:5
        x:1
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            per.reActive()
            active=true
            per.items[num].visible=true
        }
    }
}
