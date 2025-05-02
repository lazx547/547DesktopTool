import QtQuick

Rectangle {
    width: 323-le/2
    height: 30
    property double le:0
    property int num
    property int type
    property int _text
    border.color: "#80808080"
    border.width: 1
    Text {
        text:"标识:"+_text
        font.pixelSize: 20
    }
    Cbutton{
        width: 60
        height: 28
        x:100
        text: "显示"
        onClicked: {
            $ModuleErs[type].objs[num].visible=true
        }
    }
    Cbutton{
        width: 60
        height: 28
        x:160
        text: "隐藏"
        onClicked: {
            $ModuleErs[type].objs[num].visible=false
        }
    }
    Cbutton{
        width: 60
        height: 28
        x:220
        text: "关闭"
        onClicked: {
            $ModuleErs[type].del(num)
        }
    }
}
