import QtQuick
import Qt5Compat.GraphicalEffects

Window{
    flags: Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint|Qt.WindowTransparentForInput
    color: "#00000000"
    id:root
    visible:false
    x:root.screen.width*0.805
    y:root.screen.height*0.85
    width:text_.width
    height: text.height+text_.height
    opacity: 0.5
    property bool type:false
    function reset(i,t){
        visible=i
        type=t
    }

    DropShadow {
        anchors.fill: text
        horizontalOffset: 1
        verticalOffset: 1
        radius: 2.0
        samples: 17
        color: "#30000000"
        source: text
    }

    DropShadow {
        anchors.fill: text_
        horizontalOffset: 1
        verticalOffset: 1
        radius: 2.0
        samples: 17
        color: "#30000000"
        source: text_
    }

    Text{
        z:2
        id:text
        color:"#FFFFFF"
        font.pixelSize: 26
        text:type?"激活  Windows":"Windows 已激活"
    }
    Text{
        y:text.height
        id:text_
        color:"#FFFFFF"
        font.pixelSize: 20
        text:type?"转到“设置”以激活 Windows。":"转到“设置”以取消激活 Windows。"
    }
    Timer{
        interval: 100
        onTriggered: root.raise()
        running: root.visible
        repeat: true
    }
}

