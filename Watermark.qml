import QtQuick


Window{
    flags: Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint|Qt.WindowTransparentForInput
    color: "#00000000"
    id:root
    visible:false
    x:root.screen.width*0.805
    y:root.screen.height*0.85
    width:text_.width
    height: text.height+text_.height
    opacity: 0.9
    property bool type:false
    function reset(i,t){
        visible=i
        type=t
    }

    Text{
        id:text
        color:"#8f8f8f"
        font.pixelSize: 25
        text:type?"激活 Windows":"Windows 已激活"
    }
    Text{
        y:text.height
        id:text_
        color:"#8f8f8f"
        font.pixelSize: 20
        text:type?"转到\"设置\"以激活 Windows":"转到\"设置\"以取消激活 Windows"
    }
}

