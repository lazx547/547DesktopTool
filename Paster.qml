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
    width: 640
    height: 480
    minimumWidth: 100
    minimumHeight: 50
    flags: {
        var r=Qt.FramelessWindowHint|Qt.Window|Qt.Tool
        r|=top?Qt.WindowStaysOnTopHint:null
        r|=ghost?Qt.WindowTransparentForInput:null
        return r
    }
    color: "#00000000"
    visible: false
    
    property real lastScaleW
    property real lastScaleH
    readonly property real sys_width: window.screen.width
    readonly property real sys_height: window.screen.height
    property int bw: border_size>3?border_size:3
    property int dragX: 0
    property int dragY: 0
    property bool dragging: false
    property int x0
    property int y0
    property bool ghost:false
    property int edgeThreshold: 5
    property font sfont
    property string name:""
    property int thisn:-1
    property string path:"./data.ini"
    property bool lock:lock_set.checked
    property bool top:top_set.checked
    property color topic_color:$topic_color
    property color font_color:"#2080f0"
    property color back_color
    property int border_width
    property color border_color
    property font font_:{
        pixelSize: 30
        family: "微软雅黑"
        bold: false
    }
    function read(){
        if(file.is("./data.ini"))
        {
            file.source=path
            var s=file.read(),r_,g_,b_,a_
            window.width=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)//,
            window.height=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)//,
            window_opacity.setValue(s.slice(0,s.indexOf(",")))
            s=s.slice(s.indexOf(",")+1,s.length)//,
            s=s.slice(s.indexOf(",")+1,s.length)//,
            r_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)//,
            g_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)//,
            b_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)//,
            a_=s.slice(0,s.indexOf(","))
            font_color_picker.setColor(r_,g_,b_,a_)
            s=s.slice(s.indexOf(",")+1,s.length)//,
            s=s.slice(s.indexOf(",")+1,s.length)//,
            r_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)//,
            g_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)//,
            b_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)//,
            a_=s.slice(0,s.indexOf(","))
            back_color_picker.setColor(r_,g_,b_,a_)
            s=s.slice(s.indexOf(",")+1,s.length)//,
            s=s.slice(s.indexOf(",")+1,s.length)//,
            r_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)//,
            g_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)//,
            b_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)//,
            a_=s.slice(0,s.indexOf(","))
            border_color_picker.setColor(r_,g_,b_,a_)
            s=s.slice(s.indexOf(",")+1,s.length)//,
            s=s.slice(s.indexOf(",")+1,s.length)//,
            border_size.setValue(s.slice(0,s.indexOf(",")))
            s=s.slice(s.indexOf(",")+1,s.length)//,
            s=s.slice(s.indexOf(",")+1,s.length)//,
            font_size.setValue(s.slice(0,s.indexOf(",")))
            s=s.slice(s.indexOf(",")+1,s.length)//,
            s=s.slice(s.indexOf(",")+1,s.length)//,
            font_bord.checked=s.slice(0,s.indexOf(","))=="true"?true:false
            s=s.slice(s.indexOf(",")+1,s.length)//,
            s=s.slice(s.indexOf(",")+1,s.length)//,
            font_center.checked=s.slice(0,s.indexOf(","))=="true"?true:false
            s=s.slice(s.indexOf(",")+1,s.length)//,
            s=s.slice(s.indexOf(",")+1,s.length)//,
            font_.family=s.slice(0,s.indexOf(","))
            console.log("P:readed")
        }
        else
        {
            sfont.family="微软雅黑"
        }
        text__.text=text_.text=Clipboard.pasteText()
        resize(text__.text)
    }
    function resize(s){
        metrics.text=""
        metrics.text=s
    }
    onPathChanged: {
        gfile.readA(path)
    }

    onThisnChanged: {
        if(path=="./data.ini")s()
    }
    function s(){
        text__.text=text_.text=Clipboard.pasteText()
        read()
        window.visible=true
    }
    onWidthChanged: {
        if(lastScaleW!=win.scale)
            lastScaleW=win.scale
        else
            win.width=window.width/win.scale
    }
    onHeightChanged: {
        if(lastScaleH!=win.scale)
            lastScaleH=win.scale
        else
            win.height=window.height/win.scale
    }

    function save(){
        var a=window.width+","
        a+=window.height+","
        a+=window_opacity.value+",fc:,"
        a+=font_color_picker.r.toString()+","+font_color_picker.g.toString()+","+font_color_picker.b.toString()+","+font_color_picker.a.toString()+",bc:,"
        a+=back_color_picker.r.toString()+","+back_color_picker.g.toString()+","+back_color_picker.b.toString()+","+back_color_picker.a.toString()+",bc:,"
        a+=border_color_picker.r.toString()+","+border_color_picker.g.toString()+","+border_color_picker.b.toString()+","+border_color_picker.a.toString()+",bs:,"
        a+=border_size.value.toString()+",fs:,"
        a+=font_size.value+",fb:,"
        a+=font_bord.checked+",fc:,"
        a+=font_center.seleted+",ff:,"
        a+=font_.family+","
        file.source="./data.ini"
        file.write(a)
    }
    GFile{
        id:gfile

        function readA(p){
            if(file.is(p))
            {
                file.source=p
                var s=file.read(),r_,g_,b_,a_
                window.width=Number(s.slice(0,s.indexOf(",")))
                s=s.slice(s.indexOf(",")+1,s.length)//,
                window.height=Number(s.slice(0,s.indexOf(",")))
                s=s.slice(s.indexOf(",")+1,s.length)//,
                window_opacity.setValue(Number(s.slice(0,s.indexOf(","))))
                s=s.slice(s.indexOf(",")+1,s.length)//,
                s=s.slice(s.indexOf(",")+1,s.length)//,
                r_=s.slice(0,s.indexOf(","))
                s=s.slice(s.indexOf(",")+1,s.length)//,
                g_=s.slice(0,s.indexOf(","))
                s=s.slice(s.indexOf(",")+1,s.length)//,
                b_=s.slice(0,s.indexOf(","))
                s=s.slice(s.indexOf(",")+1,s.length)//,
                a_=s.slice(0,s.indexOf(","))
                font_color_picker.setColor(r_,g_,b_,a_)
                s=s.slice(s.indexOf(",")+1,s.length)//,
                s=s.slice(s.indexOf(",")+1,s.length)//,
                r_=s.slice(0,s.indexOf(","))
                s=s.slice(s.indexOf(",")+1,s.length)//,
                g_=s.slice(0,s.indexOf(","))
                s=s.slice(s.indexOf(",")+1,s.length)//,
                b_=s.slice(0,s.indexOf(","))
                s=s.slice(s.indexOf(",")+1,s.length)//,
                a_=s.slice(0,s.indexOf(","))
                back_color_picker.setColor(r_,g_,b_,a_)
                s=s.slice(s.indexOf(",")+1,s.length)//,
                s=s.slice(s.indexOf(",")+1,s.length)//,
                r_=s.slice(0,s.indexOf(","))
                s=s.slice(s.indexOf(",")+1,s.length)//,
                g_=s.slice(0,s.indexOf(","))
                s=s.slice(s.indexOf(",")+1,s.length)//,
                b_=s.slice(0,s.indexOf(","))
                s=s.slice(s.indexOf(",")+1,s.length)//,
                a_=s.slice(0,s.indexOf(","))
                border_color_picker.setColor(r_,g_,b_,a_)
                s=s.slice(s.indexOf(",")+1,s.length)//,
                s=s.slice(s.indexOf(",")+1,s.length)//,
                border_size.setValue(s.slice(0,s.indexOf(",")))
                s=s.slice(s.indexOf(",")+1,s.length)//,
                s=s.slice(s.indexOf(",")+1,s.length)//,
                font_size.setValue(s.slice(0,s.indexOf(",")))
                s=s.slice(s.indexOf(",")+1,s.length)//,
                s=s.slice(s.indexOf(",")+1,s.length)//,
                font_bord.checked=s.slice(0,s.indexOf(","))=="true"?true:false
                s=s.slice(s.indexOf(",")+1,s.length)//,
                s=s.slice(s.indexOf(",")+1,s.length)//,
                font_center.checked=s.slice(0,s.indexOf(","))=="true"?true:false
                s=s.slice(s.indexOf(",")+1,s.length)//,
                s=s.slice(s.indexOf(",")+1,s.length)//,
                font_.family=s.slice(0,s.indexOf(","))
                s=s.slice(s.indexOf(",")+1,s.length)//,
                s=s.slice(s.indexOf(",")+1,s.length)//,
                text__.text=text_.text=s.slice(0,s.indexOf(","))
            }

        }

        function saveA(p){
            var a=window.width+","
            a+=window.height+","
            a+=window_opacity.value+",fc:,"
            a+=font_color_picker.r.toString()+","+font_color_picker.g.toString()+","+font_color_picker.b.toString()+","+font_color_picker.a.toString()+",bc:,"
            a+=back_color_picker.r.toString()+","+back_color_picker.g.toString()+","+back_color_picker.b.toString()+","+back_color_picker.a.toString()+",bc:,"
            a+=border_color_picker.r.toString()+","+border_color_picker.g.toString()+","+border_color_picker.b.toString()+","+border_color_picker.a.toString()+",bs:,"
            a+=border_size.value.toString()+",fs:,"
            a+=font_size.value+",fb:,"
            a+=font_bord.checked+",fc:,"
            a+=font_center.seleted+",ff:,"
            a+=font_.family+",te:,"
            a+=text_.text+","
            file.source=p
            file.write(a)
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

    Rectangle{
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
                           var a=drop.text
                           text__.text=text_.text=a
                           resize(a)
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
                color: topic_color
            }
        }

        Text {
            id: metrics
            font: font_
            visible: false
            onTextChanged: {
                var a=sys_width
                window.width=metrics.width+border_size.value*2+2*win.scale
                if(window.width>sys_width)
                {
                    window.width=a*win.scale
                    window.height=(text_.height+border_size.value*2)*win.scale
                }
                window.height=(metrics.height+border_size.value*2)*win.scale
            }
        }

        transformOrigin: Item.TopLeft
        id:win
        color:back_color
        border.color: border_color
        border.width: custom.visible?(border_width==0 ?3:border_width):border_width
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
                            if(wheel.angleDelta.y>0) win.scale+=0.05
                            else if(wheel.angleDelta.y<0)
                            {
                                if(window.width>100)  win.scale-=0.05
                                else win.scale=50/win.width
                            }
                            window.width=win.width*win.scale
                            window.height=win.height*win.scale
                            scale_text_window.show()
                        }
                    }
            onPressed: (mouse)=>{
                           if(!lock){
                               const p = mouse
                               const b = bw;
                               let e = 0;
                               if (mouse.x < b) { e = Qt.LeftEdge }
                               if (mouse.x >= width - b) { e |= Qt.RightEdge }
                               if (mouse.y < b) { e |= Qt.TopEdge }
                               if (mouse.y >= height - b) { e |= Qt.BottomEdge }
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
                            dragging = false
                            if(window.x==x0 && window.y==y0 && mouse.button==Qt.RightButton)
                            {
                                menu_.x=window.x+mouseX*win.scale
                                menu_.y=window.y+mouseY*win.scale
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

        TextArea{
            z:3
            x:border_width
            y:border_width
            width: win.width-2*border_width
            height: win.height-2*border_width
            visible: custom.visible
            id:text__
            color:font_color
            horizontalAlignment: Text.AlignHCenter
            font:font_
            wrapMode: Text.Wrap
            selectByMouse: true
            padding: 0
            leftPadding: 0
            rightPadding: 0
            clip: true
        }
        Item{
            x:border_width
            y:border_width
            width: win.width-2*border_width
            height: win.height-2*border_width
            Text{
                id:text_
                anchors.fill: parent
                color:font_color
                visible: !custom.visible
                horizontalAlignment: Text.AlignHCenter
                font:font_
                wrapMode: Text.Wrap
                clip: true
            }
        }
    }
    Window{//右键菜单窗口
        id:menu_
        visible:false
        flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
        width: 112
        height:302
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
                saves_button.seleted=false
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
            text:"文本-"+name+""
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
                id:saves_button
                y:top_set.height*2
                type:1
                width: parent.width
                text: "存档"
                onClicked: {
                    menu_.width= menu_.width==menu_.minimumWidth? menu_.minimumWidth+saves_window.width:menu_.minimumWidth
                    seleted=menu_.width==menu_.minimumWidth?false:true
                }
            }
            Cbutton{
                id:custom_button
                y:top_set.height*3
                type:1
                width: parent.width
                text: "编辑"
                checkable: true
                onClicked: {
                    if(!checked)
                    {
                        menu_.visible=false
                        custom.unChecked()
                        custom.visible=false
                    }
                    else
                    {
                        menu_.visible=false
                        custom.rePlace()
                        custom.visible=true
                    }
                    menu_.visible=false
                }
            }

            Cbutton{
                y:top_set.height*4
                type:1
                width: parent.width
                text:"复制"
                onClicked: {
                    Clipboard.copyText(text__.text)
                    menu_.visible=false
                }
            }
            Cbutton{
                y:top_set.height*5
                type:1
                width: parent.width
                text:"粘贴"
                onClicked: {
                    text__.text=text_.text=Clipboard.pasteText()
                    menu_.visible=false
                }
            }
            Cbutton{
                y:top_set.height*6
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
                y:top_set.height*7
                type:1
                width: parent.width
                text:"自动调整大小"
                onClicked: {
                    menu_.visible=false
                    resize(text__.text)
                }
            }
            Cbutton{
                FileDialog{
                    id:filed
                    fileMode: FileDialog.SaveFile
                    nameFilters: ["文本文档 (*.txt)"]
                    onAccepted: {
                        var s=String(selectedFile)
                        s=s.slice(8,s.length)
                        gfile.source=s
                        gfile.write(text_.text)
                    }
                }
                y:top_set.height*8
                type:1
                width: parent.width
                text:"保存为"
                onClicked: {
                    menu_.visible=false
                    filed.open()
                }
            }
            Cbutton{
                y:top_set.height*9
                type:1
                width: parent.width
                text:"转换为图片"
                onClicked: {
                    menu_.visible=false
                    win.grabToImage(function(result) {
                        pasterLoad.toImage(thisn,result.image)
                    });
                }
            }
            Cbutton{
                y:top_set.height*10
                type:1
                width: parent.width
                text:"保存为图片"
                onClicked: {
                    menu_.visible=false
                    win.grabToImage(function(result) {
                        console.log(result)
                        Clipboard.saveAs(result.image)
                    });
                }
            }
            Cbutton{
                y:top_set.height*11
                type:1
                width: parent.width
                text: "隐藏"
                onClicked: {
                    pasterLoad.setV(thisn)
                    menu_.visible=false
                }
            }
            Cbutton{
                y:top_set.height*12
                type:1
                width: parent.width
                text: "幽灵模式"
                onClicked: {
                    menu_.visible=false
                    ghost=true
                }
            }
            Cbutton{
                y:top_set.height*13
                type:1
                width: parent.width
                text: "关闭"
                onClicked: {
                    menu_.visible=false
                    save()
                    pasterLoad.exit(thisn)
                }
            }
        }
        Item {
            id: saves_window
            width: 143+saves_scoll.effectiveScrollBarWidth/2
            height: menu_.height
            x:112
            Rectangle{
                anchors.fill: parent
                border.width: 1
                border.color: "#80808080"
            }
            Rectangle{
                x:1
                y:1
                TextArea{
                    id:save_text
                    x:1
                    y:1
                    width: 80
                    height: 20
                    color: "black"
                    padding:2
                    font.pixelSize: 13
                    background:Rectangle{
                        anchors.fill: parent
                        border.width: 1
                        border.color: "#80808080"
                    }
                    onTextChanged: {
                        if(text.length>5)
                            text=text.slice(0,5)
                        if(text=="") save_new.enabled=false
                        else{
                            var a=false
                            for(var i=0;i<saves.sis.length;i++)
                                if(saves.sis[i].num==text)
                                {
                                    save_new.enabled=false
                                    a=true
                                    break
                                }
                            if(!a)
                                save_new.enabled=true
                        }
                    }
                }
                Cbutton{
                    x:80
                    y:1
                    width: 60
                    height: 20
                    text:"保存"
                    id:save_new
                    enabled: false
                    onClicked: {
                        enabled=false
                        gfile.source="./file/saves/"+save_text.text+".txt"
                        gfile.saveA(gfile.source)
                        var Csaves=Qt.createComponent("./CSaveItem.qml"),im
                        saves.sis.push(im=Csaves.createObject(saves))
                        im.file=gfile
                        im.par=saves
                        im.n=saves.sis.length
                        im.num=save_text.text
                        im.y=(im.n-1)*20
                        im.parent=saves
                        saves.height=20*im.n
                        gfile.source="./file/saves/num.txt"
                        var s=saves.sis.length+","
                        for(var i=0;i<saves.sis.length;i++)
                            s+=saves.sis[i].num+","
                        gfile.write(s)
                    }
                }
            }
            ScrollView{
                x:2
                y:25
                width: 320+effectiveScrollBarWidth
                height:saves_window.height*2-62
                scale: 0.5
                transformOrigin: Item.TopLeft
                contentHeight: saves.height*2
                id:saves_scoll
                Item{
                    width: 160
                    id:saves
                    scale: 2
                    transformOrigin: Item.TopLeft
                    property var sis:[]
                    function remove(n){
                        n--
                        sis[n].destroy()
                        var i,s
                        for(i=n;i<sis.length-1;i++)
                        {
                            sis[i]=sis[i+1]
                            sis[i].n-=1
                            sis[i].y-=20
                        }
                        sis.pop()
                        saves.height-=20
                        s=sis.length+","
                        for(i=0;i<sis.length;i++)
                            s+=sis[i].num+","
                        gfile.source="./file/saves/num.txt"
                        gfile.write(s)
                    }
                }
                
                Component.onCompleted: {
                    gfile.source="./file/saves/num.txt"
                    var s=gfile.read()
                    var a=Number(s.slice(0,s.indexOf(","))),im
                    var Csaves=Qt.createComponent("./CSaveItem.qml")
                    for(var n=1;n<=a;n++)
                    {
                        saves.sis.push(im=Csaves.createObject(saves))
                        im.file=gfile
                        im.par=saves
                        im.n=n
                        s=s.slice(s.indexOf(",")+1,s.length)
                        im.num=s.slice(0,s.indexOf(","))
                        im.y=(n-1)*20
                        im.parent=saves
                    }
                    saves.height=20*a
                }
            }
        }
    }
    Window{//个性化
        id:custom
        visible:false
        flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
        width: 212
        height:27
        color:"#00000000"
        property var sub_windows:[]
        property var buttons:[]
        property int detect_height:50
        property bool show_above:false
        onVisibleChanged: {
            if(visible)
                text__.text=text_.text
            else
                text_.text=text__.text
        }

        Component.onCompleted: {
            buttons.push(opacity_button)
            buttons.push(font_button)
            buttons.push(back_button)
            buttons.push(border_button)
            sub_windows.push(opacity_window)
            sub_windows.push(font_window)
            sub_windows.push(back_window)
            sub_windows.push(border_window)
        }
        function unChecked(){
            for(var i=0;i<buttons.length;i++)
                buttons[i].checked=false
        }
        function isSubShow()
        {
            for(var i=0;i<sub_windows.length;i++)
                if(sub_windows[i].visible==true)
                    return true
            return false
        }
        function get_showWindow(){
            for(var i=0;i<sub_windows.length;i++)
                if(sub_windows[i].visible==true)
                    return sub_windows[i]
        }
        function rePlace(){
            x=Math.max(Math.min(window.x+window.width/2-width/2,sys_width-5),5)
            custom.opacity=1
            custom.y=window.y+window.height+5
            if((isSubShow()?window.y+window.height+5+height+5+get_showWindow().height:window.y+window.height+5+height+5)>sys_height)
            {
                y-=height+10+window.height
                show_above=true
            }
            else
                show_above=false
        }
        Rectangle{
            width: custom.width
            height: 27
            border.color: topic_color
            color:"#f2f2f2"
        }
        Item{
            x:1
            y:1
            width: custom.width-2
            height: custom.height-2
            Rectangle{
                width: 8
                height: 25
                color: topic_color
                MouseArea {
                    id:drag_detect
                    anchors.fill: parent
                    property bool dragging
                    onPressed: {
                        dragging = true
                    }
                    onReleased: {
                        dragging = false
                    }
                }
            }
            Cbutton{
                id:opacity_button
                x:10
                type:2
                width: 25
                height: 25
                onClicked: {
                    custom.unChecked()
                    checked=true
                }
                
                seleted: checked
                img:"./images/opacity.png"
                Window{
                    id:opacity_window
                    opacity: custom.opacity
                    visible:custom.visible?opacity_button.checked:false
                    flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                    x:custom.x
                    y:custom.show_above?custom.y-4-height:custom.y+31
                    width: 184
                    height:22
                    color:"#00000000"
                    Rectangle{
                        anchors.fill: parent
                        border.color: topic_color
                        color:"#f2f2f2"
                    }
                    CscrollBar{
                        id:window_opacity
                        x:3
                        y:3
                        width: 179
                        height: 16
                        text: "透明度"
                        text_width: 43
                        minValue: 1
                        maxValue: 100
                        onValueChanged: window.opacity=value/100
                    }
                }
            }
            Cbutton{
                id:font_button
                x:40
                type:2
                width: 25
                height: 25
                onClicked: {
                    custom.unChecked()
                    checked=true
                }
                seleted: checked
                img:"./images/font.png"
                Window{
                    id:font_window
                    opacity: custom.opacity
                    visible:custom.visible?font_button.checked:false
                    flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                    x:custom.x
                    y:custom.show_above?custom.y-4-height:custom.y+31
                    width: 214
                    height:122
                    color:"#00000000"
                    Rectangle{
                        anchors.fill: parent
                        color:"#f2f2f2"
                        border.color: window.topic_color
                    }
                    GComboBox {
                        id: font_combo
                        x:3
                        y:2
                        height: 20
                        width: 160
                        transformOrigin: Item.TopLeft
                        model: Qt.fontFamilies()
                        currentIndex: model.indexOf(window.font_.family)
                        onActivated: window.font_.family = currentText
                    }
                    Cbutton{
                        id:font_bord
                        x:191
                        y:1
                        width: 20
                        height: 20
                        type:2
                        img:"./images/bord.png"
                        font.bold: true
                        checkable: true
                        seleted: checked
                        onCheckedChanged: window.font_.bold=checked
                    }

                    Cbutton{
                        id:font_center
                        x:171
                        y:1
                        width: 20
                        height: 20
                        type:2
                        img:"./images/center.png"
                        checkable: true
                        seleted: checked
                        onCheckedChanged: {
                            if(seleted)
                                text_.horizontalAlignment=text__.horizontalAlignment=Text.AlignLeft
                            else
                                text_.horizontalAlignment=text__.horizontalAlignment=Text.AlignHCenter
                        }
                        Component.onCompleted: checked=true
                    }
                    CscrollBar{
                        id:font_size
                        x:3
                        y:103
                        width: 207
                        height: 16
                        text: "大小"
                        text_width: 30
                        minValue: 1
                        maxValue: 180
                        Component.onCompleted: setValue(30)
                        onValueChanged: window.font_.pixelSize=value
                    }
                    ColorPickerItem{
                        id:font_color_picker
                        y:22
                        x:3
                        onColor_Changed: window.font_color=color_
                    }
                }
            }
            Cbutton{
                id:border_button
                x:70
                type:2
                width: 25
                height: 25
                onClicked: {
                    custom.unChecked()
                    checked=true
                }
                
                seleted: checked
                img:"./images/border.png"
                Window{
                    id:border_window
                    opacity: custom.opacity
                    visible:custom.visible?border_button.checked:false
                    flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                    x:custom.x
                    y:custom.show_above?custom.y-4-height:custom.y+31
                    width: 214
                    height:102
                    color:"#00000000"
                    Rectangle{
                        anchors.fill: parent
                        border.color: window.topic_color
                        color:"#f2f2f2"
                    }
                    CscrollBar{
                        id:border_size
                        x:3
                        y:3
                        width: 209
                        height: 16
                        text: "边框大小"
                        text_width: 60
                        minValue: 0
                        maxValue: 20
                        Component.onCompleted: setValue(0)
                        onValueChanged: window.border_width=value
                    }
                    ColorPickerItem{
                        id:border_color_picker
                        y:22
                        x:3
                        onColor_Changed: window.border_color=color_
                    }
                }
            }
            Cbutton{
                id:back_button
                x:100
                type:2
                width: 25
                height: 25
                onClicked: {
                    custom.unChecked()
                    checked=true
                }
                seleted: checked
                img:"./images/back.png"
                Window{
                    id:back_window
                    opacity: custom.opacity
                    visible:custom.visible?back_button.checked:false
                    flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                    x:custom.x
                    y:custom.show_above?custom.y-4-height:custom.y+31
                    width: 208
                    height:82
                    color:"#00000000"
                    Rectangle{
                        anchors.fill: parent
                        color:"#f2f2f2"
                        border.color: window.topic_color
                    }
                    ColorPickerItem{
                        id:back_color_picker
                        y:3
                        x:3
                        onColor_Changed: window.back_color=color_
                        Component.onCompleted: setColor(0,0,0,0)
                    }
                }
            }
            Cbutton{
                x:130
                type:2
                width: 25
                height: 25
                onClicked: Clipboard.copyText(text__.text)

                img:"./images/copy.png"
            }
            Cbutton{
                x:160
                type:2
                width: 25
                height: 25
                onClicked: text__.text=text_.text=Clipboard.pasteText()
                img:"./images/paste.png"
            }
            Cbutton{
                x:parent.width-25
                type:2
                width: 25
                height: 25
                onClicked: {
                    custom_button.checked=false
                    custom.visible=false
                    custom.unChecked()
                    save()
                }
                img:"./images/check.png"
            }
        }
        DragHandler {//按下拖动以移动窗口
            grabPermissions: TapHandler.CanTakeOverFromAnything
            onActiveChanged: {
                if (active && drag_detect.dragging)
                {
                    custom.startSystemMove()
                }
            }
        }
    }
    
}
