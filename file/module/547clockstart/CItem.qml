import QtQuick

Rectangle {
    width: 400-le
    height: 30
    property double le:0
    property int num
    property int type
    property int _text
    border.color: "#80808080"
    border.width: 1
    Text {
        x:10
        y:1
        text:"标识:"+_text
        font.pixelSize: 20
    }
    Cbutton{
        width: 60
        height: 28
        x:100
        y:1
        text: "显示"
        onClicked: {
        }
    }
    Cbutton{
        width: 60
        height: 28
        x:160
        y:1
        text: "隐藏"
        onClicked: {
        }
    }
    Cbutton{
        width: 60
        height: 28
        x:220
        y:1
        text: "关闭"
        onClicked: {
        }
    }
}
