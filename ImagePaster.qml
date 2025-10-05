import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Dialogs
import Clipboard 1.0
import GFile 1.2
Window {
    id: window
    minimumWidth: 20
    minimumHeight: 20
    flags: {
        var r=Qt.FramelessWindowHint|Qt.Window|Qt.Tool
        r|=top?Qt.WindowStaysOnTopHint:null
        r|=ghost?Qt.WindowTransparentForInput:null
        return r
    }
    color: "#00000000"
    visible: false

    readonly property real sys_width: window.screen.width
    readonly property real sys_height: window.screen.height
    readonly property real dpr:window.screen.devicePixelRatio
    property int width_:100
    property int height_:100
    property int dragX: 0
    property int dragY: 0
    property bool dragging: false
    property int x0
    property int y0
    property bool ghost:false
    property int bw:3
    property int thisn:-99
    property string name:""
    property string path:"0"
    property bool lock:lock_set.checked
    property bool top:top_set.checked
    property int e:0

    function resize(){
        width=width_*win.scale
        height=height_*win.scale
    }

    GFile{
        id:file
    }

    DropArea {
        anchors.fill: parent
        onEntered: {
            drop_cover.visible=true
        }
        onExited: {
            drop_cover.visible=false
        }
        onDropped: (drop)=>{
                       drop_cover.visible=false
                       var s=String(drop.text)
                       if(image.source!=s)
                       {
                           image.last=image.source
                           image.source=s
                       }
                   }
    }
    Rectangle{
        z:200
        id:drop_cover
        anchors.fill: parent
        color: "#80808080"
        visible: false
        Text{
            anchors.centerIn: parent
            text:"松开鼠标以粘贴"
            font.pixelSize: 20
            color: $topic_color
        }
    }
    onThisnChanged: {
        if(path!="-1")
        {
            if(Clipboard.hasImage())
                image.source=Clipboard.saveImage()
            else
                image.source=Clipboard.pasteText()
            window.visible=true
            console.log("IP:has image")
        }
        else
            console.log("IP:no image")
    }
    onWidthChanged: {
        if(e==Qt.LeftEdge || e==Qt.RightEdge)
        {
            win.scale=width/width_
            resize()
        }
        if(width<20)
        {
            win.scale=1
            resize()
        }
    }
    onHeightChanged: {
        if(e==Qt.TopEdge || e==Qt.BottomEdge)
        {
            win.scale=height/height_
            resize()
        }
    }
    Window{
        id:scale_text_window
        visible: false
        flags: Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
        width: scale_text.width
        height: scale_text.height
        x:window.x
        y:window.y
        function show(){
            opacity_text_window.visible=false
            visible=true
            scale_text_timer.running=false
            scale_text_timer.running=true
        }
        Text{
            id:scale_text
            text: "大小:"+parseInt(win.scale*100)+"%"
        }
        Timer{
            id:scale_text_timer
            interval: 2000
            onTriggered: scale_text_window.visible=false
        }
    }
    Window{
        id:opacity_text_window
        visible: false
        flags: Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
        width: opacity_text.width
        height: opacity_text.height
        x:window.x
        y:window.y
        function show(){
            scale_text_window.visible=false
            visible=true
            opacity_text_timer.running=false
            opacity_text_timer.running=true
        }
        Text{
            id:opacity_text
            text: "透明度:"+parseInt(window.opacity*100)+"%"
        }
        Timer{
            id:opacity_text_timer
            interval: 2000
            onTriggered: opacity_text_window.visible=false
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        z:2
        cursorShape: {
            const p = Qt.point(mouseX, mouseY);
            const b = bw;
            if (p.x < b && p.y < b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y >= height - b) return Qt.SizeFDiagCursor;
            if (p.x >= width - b && p.y < b) return Qt.SizeBDiagCursor;
            if (p.x < b && p.y >= height - b) return Qt.SizeBDiagCursor;
            if (p.x < b || p.x >= width - b) return Qt.SizeHorCursor;
            if (p.y < b || p.y >= height - b) return Qt.SizeVerCursor;
        }
        acceptedButtons: Qt.LeftButton|Qt.RightButton

        onWheel:(wheel)=>{
                    if(!lock)
                    {
                        if($press_ctrl){
                            if(wheel.angleDelta.y>0)
                            {
                                if(window.opacity<=0.95)
                                window.opacity+=0.05
                                else
                                window.opacity=1
                            }
                            else if(wheel.angleDelta.y<0)
                            {
                                if(window.opacity>=0.1)
                                window.opacity-=0.05
                                else
                                window.opacity=0.01
                            }
                            opacity_text_window.show()
                        }
                        else{
                            if(wheel.angleDelta.y>0) win.scale+=0.05
                            else if(wheel.angleDelta.y<0)
                            {
                                if(window.width>100)  win.scale-=0.05
                                else win.scale=50/width_
                            }
                            resize()
                            scale_text_window.show()
                        }
                    }
                }
        onPressed: (mouse)=>{
                       if(!lock){
                           const p = mouse
                           const b = bw;
                           if (mouse.x < b) { e = Qt.LeftEdge }
                           if (mouse.x >= width - b) { e = Qt.RightEdge }
                           if (mouse.y < b) { e = Qt.TopEdge }
                           if (mouse.y >= height - b) { e = Qt.BottomEdge }
                           if(e==0)
                           {
                               dragX = mouseX
                               dragY = mouseY
                               dragging = true
                               x0=window.x
                               y0=window.y
                           }
                           else if(mouse.button!=Qt.RightButton)
                           window.startSystemResize(e);
                       }
                   }
        onReleased: (mouse)=>{
                        resize()
                        e=0
                        dragging = false
                        if(window.x==x0 && window.y==y0 && mouse.button==Qt.RightButton)
                        {
                            menu_.x=window.x+mouseX
                            menu_.y=window.y+mouseY
                            if(menu_.x+menu_.width>sys_width) menu_.x-=menu_.width
                            if(menu_.y+menu_.height>sys_height) menu_.y-=menu_.height
                            menu_.visible=true
                        }
                    }
        onPositionChanged: {
            if (dragging) {
                window.x += mouseX - dragX
                window.y += mouseY - dragY
            }
        }
    }
    Rectangle{
        id:win
        transformOrigin: Item.TopLeft
        color:"#00000000"
        scale: 1
        width: width_
        height: height_
        Image{
            property string last:"-1"
            id:image
            onSourceChanged: console.log("sc")
            onStatusChanged:
            {
                if(status==Image.Error)
                {
                    console.log("IP:error")
                    if(last=="-1")
                        pasterLoad.toText(thisn)
                    else
                        source=last
                }
                else if(status==Image.Ready)
                {
                    image.width=sourceSize.width*win.scale
                    image.height=image.width*sourceSize.height/sourceSize.width
                    console.log("IP:ok")
                    width/=dpr
                    height/=dpr
                    width_=image.width
                    height_=image.height
                    resize()
                    pasterLoad.addMenu(thisn)
                }
                else if(status==Image.Loading)
                    console.log("IP:ing")
                else if(status==Image.Null)
                    source=last
                else console.log(status)
            }
        }
    }
    Window{//右键菜单窗口
        id:menu_
        visible:false
        flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
        width: 112
        height:242
        color:"transparent"
        minimumWidth: 112
        onActiveFocusItemChanged: {//失去焦点时隐藏
            if(!activeFocusItem)
                visible=false
        }
        onVisibleChanged:
        {
            if(!visible)
            {
                width=minimumWidth
            }
        }
        Rectangle{//右键菜单窗口背景
            id:menu__back
            width: menu_.width
            height:menu_.height
            border.width: 1
            border.color: "#80808080"
            transformOrigin: Item.TopLeft
        }
        Text{
            x:1
            y:1
            width: 110
            height: 20
            text:"贴图-"+name
            font.pixelSize: 10
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Item{
            x:1
            y:top_set.height+1
            width: 110
            height: parent.height-2
            Cbutton{
                id:top_set
                type:1
                width: parent.width
                text: "置顶"
                checkable: true
                checked: true
                onClicked: menu_.visible=false
            }
            Cbutton{
                id:lock_set
                type:1
                y:top_set.height
                width: parent.width
                text: "锁定"
                checkable: true
                onClicked: menu_.visible=false
            }
            Cbutton{
                y:top_set.height*2
                type:1
                width: parent.width
                text:"复制图片路径"
                onClicked: {
                    Clipboard.copyText(image.source)
                    menu_.visible=false
                }
            }
            Cbutton{
                y:top_set.height*3
                type:1
                width: parent.width
                text:"复制"
                onClicked: {
                    var s=String(image.source)
                    if(s.substring(0,1)==".")
                    {
                        s=s.slice(s.indexOf("/")+1,s.length)
                        s=s.slice(s.indexOf("/")+1,s.length)
                        s=s.slice(0,s.indexOf("."))
                        Clipboard.copyImage(s,0)
                    }
                    else if(s.substring(0,1)=="f")
                        Clipboard.copyImage(s,1)
                    else if(s.substring(0,1)=="h")
                        Clipboard.copyImage(s,2)
                    menu_.visible=false
                }
            }
            Cbutton{
                y:top_set.height*4
                type:1
                width: parent.width
                text:"粘贴"
                onClicked: {
                    var s=String()
                    if(Clipboard.hasImage())
                        s=String(Clipboard.saveImage())
                    else
                        s=String(Clipboard.pasteText())
                    if(image.source!=s)
                    {
                        image.last=image.source
                        image.source=Clipboard.pasteText()
                        menu_.visible=false
                    }
                }
            }

            Cbutton{
                y:top_set.height*5
                type:1
                width: parent.width
                text:"命名"
                onClicked: {
                    inputDialog.open()
                }
                Dialog {
                    id: inputDialog
                    title: "请输入名称"
                    anchors.centerIn: parent
                    modal: true
                    standardButtons: Dialog.Ok | Dialog.Cancel

                    ColumnLayout {
                        anchors.fill: parent
                        spacing: 0
                        Label {
                            text: "请输入名称:"
                            Layout.alignment: Qt.AlignLeft
                        }

                        TextField {
                            id: textInput
                            Layout.fillWidth: true
                            placeholderText: ""
                            focus: true
                            onAccepted: {
                                if (textInput.text.length > 0) {
                                    inputDialog.accept()
                                }
                            }
                        }
                    }

                    onAccepted: {
                        menu_.visible=false
                        pasterLoad.rename(thisn,textInput.text)
                        name=textInput.text
                        textInput.text = ""
                    }

                    onRejected: {
                        textInput.text = ""
                    }
                }
            }
            Cbutton{
                y:top_set.height*6
                type:1
                id:save_bu
                width: parent.width
                text:"图片另存为"
                onClicked: {
                    var s=String(image.source)
                    if(s.substring(0,1)==".")
                    {
                        s=s.slice(s.indexOf("/")+1,s.length)
                        s=s.slice(s.indexOf("/")+1,s.length)
                        s=s.slice(0,s.indexOf("."))
                        Clipboard.saveAs(s)
                    }
                    else if(s.substring(0,1)=="f")
                        Clipboard.saveAs(s,1)
                    else if(s.substring(0,1)=="h")
                        Clipboard.saveAs(s,2)
                    menu_.visible=false
                }
            }
            Cbutton{
                y:top_set.height*7
                type:1
                width: parent.width
                text:"显示为文字"
                onClicked: {
                    menu_.visible=false
                    Clipboard.copyText(image.source)
                    pasterLoad.toText(thisn)
                }
            }
            Cbutton{
                y:top_set.height*8
                type:1
                width: parent.width
                text: "隐藏"
                onClicked: {
                    pasterLoad.setV(thisn)
                    menu_.visible=false
                    window.visible=false
                }
            }
            Cbutton{
                y:top_set.height*9
                type:1
                width: parent.width
                text: "幽灵模式"
                onClicked: {
                    menu_.visible=false
                    ghost=true
                }
            }
            Cbutton{
                y:top_set.height*10
                type:1
                width: parent.width
                text: "关闭"
                onClicked: {
                    menu_.visible=false
                    pasterLoad.exit(thisn)
                }
            }
        }
    }
}
