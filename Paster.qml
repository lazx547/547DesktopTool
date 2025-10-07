import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Dialogs
import Clipboard 1.0
import GFile 1.2
Window{
    id:window
    width: 100
    height: 100
    minimumWidth: 50
    minimumHeight: 50
    flags:{
        var r=Qt.FramelessWindowHint|Qt.Window|Qt.Tool
        r|=top?Qt.WindowStaysOnTopHint:0
        r|=ghost?Qt.WindowTransparentForInput:0
        return r
    }
    color:"#00000000"
    visible:true

    //属性变量
    property int thisn:-1
    property string path:""
    property string name:""

    //临时变量
    property var lastScaleW
    property var lastScaleH
    property bool first:true

    //自定义属性变量
    property int bw:border_width<=3?3:border_width
    property color color_text:Qt.rgba(0,0,0,1)
    property color color_back:Qt.rgba(1,1,1,0.2)
    property color color_border:Qt.rgba(0,0,0,1)
    property bool named:false
    property int border_width:4
    property bool text_center:false
    property font text_font:{
        pixelSize:30
        bold: false
        family: "微软雅黑"
    }

    property bool ghost:false
    property bool top:true
    property bool lock:false

    onThisnChanged: {
        file.load(path)
        if(path==="./data.json"){
            metrics.text=Clipboard.pasteText()
            text__.text=text_.text=Clipboard.pasteText()
        }
        window.visible=true
    }
    onWidthChanged: {
        if(lastScaleW==win.scale)
            lastScaleW=win.scale
        else
            win.width=window.width/win.scale
    }
    onHeightChanged: {
        if(lastScaleH==win.scale)
            lastScaleH=win.scale
        else
            win.height=window.height/win.scale
    }

    onNameChanged: {
        console.log("changed")
    }

    GFile{
        id:file
        function load(s="./data.json") {
            file.source=s
            if(file.is(s)){
                var data=JSON.parse(file.read())
                // 窗口设置
                if (data.window) {
                    opacity = data.window.opacity || 1
                }

                // 颜色设置
                if (data.color) {
                    if (data.color.font) {
                        font_color_picker.setColor(
                                    data.color.font.r || 0,
                                    data.color.font.g || 0,
                                    data.color.font.b || 0,
                                    data.color.font.a || 1
                                    )
                    }
                    if (data.color.back) {
                        back_color_picker.setColor(
                                    data.color.back.r || 1,
                                    data.color.back.g || 1,
                                    data.color.back.b || 1,
                                    data.color.back.a || 0.2,
                                    )
                    }
                    if (data.color.border) {
                        border_color_picker.setColor(
                                    data.color.border.r || 0,
                                    data.color.border.g || 0,
                                    data.color.border.b || 0,
                                    data.color.border.a || 1
                                    )
                    }
                }
                // 字体设置
                if (data.font) {
                    font_size.value = data.font.size || 30
                    font_bord.checked = data.font.bord !== undefined ? data.font.bord : false
                    font_center.checked = data.font.center !== undefined ? data.font.center : false
                    font_combo.currentIndex=font_combo.model.indexOf(data.font.family || font_.family)
                }
                if(s!="./data.json")
                {
                    text_.text=text__.text=data.text
                    width=data.window.width || width
                    height=data.window.height || height
                    x=data.window.x || (window.screen.width-width)/2
                    y=data.window.y || (window.screen.height-height)/2
                    if(data.name.is){
                        named=true
                        name=data.name.name
                        console.log(data.name.name)
                        sysTray.paster.rename(thisn,name)
                    }
                }
            }
            else
                file.save()
        }

        // 保存设置到JSON文件
        function save(s="./data.json") {
            var settingsData = s==="./data.json"?{
                "window": {
                    "opacity": opacity,
                    "width":width,
                    "height":height
                },
                "color": {
                    "font": {
                        "r": font_color_picker.r,
                        "g": font_color_picker.g,
                        "b": font_color_picker.b,
                        "a": font_color_picker.a
                    },
                    "back": {
                        "r": back_color_picker.r,
                        "g": back_color_picker.g,
                        "b": back_color_picker.b,
                        "a": back_color_picker.a
                    },
                    "border": {
                        "r": border_color_picker.r,
                        "g": border_color_picker.g,
                        "b": border_color_picker.b,
                        "a": border_color_picker.a
                    }
                },
                "font": {
                    "size": font_size.value,
                    "bord": font_bord.checked,
                    "center": font_center.checked,
                    "family":text_font.family
                }
            }:{
                "window": {
                    "opacity": opacity,
                    "width":width,
                    "height":height,
                    "x":x,
                    "y":y
                },
                "color": {
                    "font": {
                        "r": font_color_picker.r,
                        "g": font_color_picker.g,
                        "b": font_color_picker.b,
                        "a": font_color_picker.a
                    },
                    "back": {
                        "r": back_color_picker.r,
                        "g": back_color_picker.g,
                        "b": back_color_picker.b,
                        "a": back_color_picker.a
                    },
                    "border": {
                        "r": border_color_picker.r,
                        "g": border_color_picker.g,
                        "b": border_color_picker.b,
                        "a": border_color_picker.a
                    }
                },
                "font": {
                    "size": font_size.value,
                    "bord": font_bord.checked,
                    "center": font_center.checked,
                    "family":text_font.family
                },
                "text":text_.text,
                "name":{
                    "is":named,
                    "name":name
                }
            }
            var jsonString = JSON.stringify(settingsData, null, 4)
            file.source=s
            file.write(jsonString)
        }
    }

    //缩放比例显示窗口
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
    //窗口主体
    Rectangle{
        id:win
        scale: 1
        transformOrigin: Item.TopLeft
        color:color_back
        border.color: color_border
        border.width: border_width==0?(custom.visible?3:0):border_width

        //拖放区域
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
                           metrics.text=a
                       }
        }
        //拖放区域指示
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

        //自动调整临时文字
        Text{
            id:metrics
            font: text_font
            visible: false
            onTextChanged: {
                if(metrics.width>=window.screen.width){
                }
                else{
                    win.width=metrics.width+border_width*2+1
                    win.height=metrics.height+border_width*2
                    window.width=win.width*win.scale
                    window.height=win.height*win.scale
                }
                if(first){
                    window.x=(window.screen.width-window.width)/2
                    window.y=(window.screen.height-window.height)/2
                    first=false
                }
            }
        }

        //文字显示区域
        Text{
            id:text_
            x:border_width
            y:border_width
            width: win.width-2*border_width
            height: win.height-2*border_width
            font: text_font
            color:color_text
            wrapMode: Text.Wrap
            padding: 0
            text:"NoText"
            clip: true
            visible: !custom.visible
        }
        TextArea{
            z:20
            id:text__
            x:border_width
            y:border_width
            width: win.width-2*border_width
            height: win.height-2*border_width
            font: text_font
            color:color_text
            wrapMode: Text.Wrap
            selectByMouse: true
            leftPadding: 0
            rightPadding: 0
            padding: 0
            clip: true
            visible: custom.visible
        }
    }
    MouseArea{
        z:custom.visible?-1:10
        property int dragX: 0
        property int dragY: 0
        property bool dragging: false
        property int x0
        property int y0
        anchors.fill: parent
        hoverEnabled: true
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
                                if(window_opacity.value<=95)
                                window_opacity.setValue(window_opacity.value+5)
                                else
                                window_opacity.setValue(100)
                            }
                            else if(wheel.angleDelta.y<0)
                            {
                                if(window_opacity.value>=10)
                                window_opacity.setValue(window_opacity.value-5)
                                else
                                window_opacity.setValue(1)
                            }
                            opacity_text_window.show()
                        }
                        else{
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
                            menu.x=window.x+mouseX
                            menu.y=window.y+mouseY
                            if(menu.x+menu.width>window.screen.width) menu.x-=menu.width
                            if(menu.y+menu.height>window.screen.height) menu.y-=menu.height
                            menu.visible=true
                        }

                    }
        onPositionChanged: {
            if (dragging) {
                window.x += mouseX - dragX
                window.y += mouseY - dragY
            }
        }
    }

    //右键菜单窗口
    Window{
        id:menu
        visible:false
        width: 112
        height: 302
        color:"#00000000"
        minimumWidth: 112
        flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint


        onActiveFocusItemChanged: {
            if(!activeFocusItem)
                visible=false
        }
        onVisibleChanged: {
            if(!visible){
                menu.width=menu.minimumWidth
                saves_button.seleted=false
            }
        }

        Rectangle{//右键菜单窗口背景
            id:menu_back
            width: menu.width
            height:menu.height
            border.width: 1
            border.color: "#80808080"
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
            y:21
            width: 110
            height:parent.height-2
            Cbutton{
                id:top_button
                type:1
                width: parent.width
                text: "置顶"
                checkable: true
                checked: true
                onCheckedChanged: window.top=checked
                onClicked: menu.visible=false
            }
            Cbutton{
                id:lock_button
                type:1
                y:20*1
                width: parent.width
                text: "锁定"
                checkable: true
                onCheckedChanged: lock=checked
                onClicked: menu.visible=false
            }
            Cbutton{
                id:saves_button
                y:20*2
                type:1
                width: parent.width
                text: "存档"
                onClicked: {
                    menu.width= menu.width==menu.minimumWidth? menu.minimumWidth+saves_item.width:menu.minimumWidth
                    seleted=menu.width==menu.minimumWidth?false:true
                }
            }
            Cbutton{
                id:custom_button
                y:20*3
                type:1
                width: parent.width
                text: "编辑"
                checkable: true
                onClicked: {
                    if(!checked)
                    {
                        menu.visible=false
                        custom.unChecked()
                        custom.visible=false
                    }
                    else
                    {
                        menu.visible=false
                        custom.rePlace()
                        custom.visible=true
                    }
                    menu.visible=false
                }
            }
            Cbutton{
                y:20*4
                type:1
                width: parent.width
                text:"复制"
                onClicked: {
                    Clipboard.copyText(text__.text)
                    menu.visible=false
                }
            }
            Cbutton{
                y:20*5
                type:1
                width: parent.width
                text:"粘贴"
                onClicked: {
                    text__.text=text_.text=Clipboard.pasteText()
                    metrics.text=Clipboard.pasteText()
                    menu.visible=false
                }
            }
            Cbutton{
                y:20*6
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
                        menu.visible=false
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
                y:20*7
                type:1
                width: parent.width
                text:"自动调整大小"
                onClicked: {
                    menu.visible=false
                    metrics.text=""
                    metrics.text=text_.text
                }
            }
            Cbutton{
                y:20*8
                type:1
                width: parent.width
                text:"保存为"
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
                onClicked: {
                    menu.visible=false
                    filed.open()
                }
            }
            Cbutton{
                y:20*9
                type:1
                width: parent.width
                text:"转换为图片"
                onClicked: {
                    menu.visible=false
                    win.grabToImage(function(result) {
                        pasterLoad.toImage(thisn,result.image)
                    });
                }
            }
            Cbutton{
                y:20*10
                type:1
                width: parent.width
                text:"保存为图片"
                onClicked: {
                    menu.visible=false
                    win.grabToImage(function(result) {
                        console.log(result)
                        Clipboard.saveAs(result.image)
                    });
                }
            }
            Cbutton{
                y:20*11
                type:1
                width: parent.width
                text: "隐藏"
                onClicked: {
                    pasterLoad.setV(thisn)
                    menu.visible=false
                }
            }
            Cbutton{
                y:20*12
                type:1
                width: parent.width
                text: "幽灵模式"
                onClicked: {
                    menu.visible=false
                    ghost=true
                }
            }
            Cbutton{
                y:20*13
                type:1
                width: parent.width
                text: "关闭"
                onClicked: {
                    menu.visible=false
                    file.save()
                    pasterLoad.exit(thisn)
                }
            }
        }
        Item {
            id: saves_item
            width: 143+saves_scoll.effectiveScrollBarWidth/2
            height: menu.height
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
                        file.save("./file/saves/"+save_text.text+".json")
                        var Csaves=Qt.createComponent("./CSaveItem.qml"),im
                        saves.sis.push(im=Csaves.createObject(saves))
                        im.file=file
                        im.par=saves
                        im.n=saves.sis.length
                        im.num=save_text.text
                        im.y=(im.n-1)*20
                        im.parent=saves
                        saves.height=20*im.n
                        file.source="./file/saves/.num"
                        var s=saves.sis.length+","
                        for(var i=0;i<saves.sis.length;i++)
                            s+=saves.sis[i].num+","
                        file.write(s)
                        sysTray.paster.add_(im.num)
                    }
                }
            }
            ScrollView{
                x:2
                y:25
                width: 320+effectiveScrollBarWidth
                height:saves_item.height*2-62
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
                        sysTray.paster.del_(sis[n].num)
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
                        file.source="./file/saves/.num"
                        file.write(s)
                    }
                }

                Component.onCompleted: {
                    file.source="./file/saves/.num"
                    var s=file.read()
                    var a=Number(s.slice(0,s.indexOf(","))),im
                    var Csaves=Qt.createComponent("./CSaveItem.qml")
                    for(var n=1;n<=a;n++)
                    {
                        saves.sis.push(im=Csaves.createObject(saves))
                        im.file=file
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
    //编辑窗口
    Window{
        id:custom
        visible:false
        flags:Qt.FramelessWindowHint|Qt.Window|Qt.Tool|Qt.WindowStaysOnTopHint
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
            x=Math.max(Math.min(window.x+window.width/2-width/2,window.screen.width-5),5)
            custom.opacity=1
            custom.y=window.y+window.height+5
            if((isSubShow()?window.y+window.height+5+height+5+get_showWindow().height:window.y+window.height+5+height+5)>window.screen.height)
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
            border.color: $topic_color
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
                color: $topic_color
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
                        border.color: $topic_color
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
            //字体调整
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
                        border.color: $topic_color
                    }
                    //字体
                    GComboBox {
                        id: font_combo
                        x:3
                        y:2
                        height: 20
                        width: 160
                        transformOrigin: Item.TopLeft
                        model: Qt.fontFamilies()
                        onActivated: text_font.family = currentText
                    }
                    //字体加粗
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
                        onCheckedChanged: text_font.bold=checked
                    }
                    //文字居中
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
                        onCheckedChanged: text_center=checked
                    }
                    //字体大小
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
                        onValueChanged: text_font.pixelSize=value
                    }
                    //字体颜色
                    ColorPickerItem{
                        id:font_color_picker
                        y:22
                        x:3
                        Component.onCompleted: setColor(0,0,0,1)
                        onColor_Changed: color_text=color_
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
                        border.color: $topic_color
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
                        Component.onCompleted: setValue(2)
                        onValueChanged:border_width=value
                    }
                    ColorPickerItem{
                        id:border_color_picker
                        y:22
                        x:3
                        Component.onCompleted: setColor(0,0,0,1)
                        onColor_Changed: color_border=color_
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
                        border.color: $topic_color
                    }
                    ColorPickerItem{
                        id:back_color_picker
                        y:3
                        x:3
                        onColor_Changed: color_back=color_
                        Component.onCompleted: setColor(1,1,1,0.2)
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
                onClicked: {
                    metrics.text=Clipboard.pasteText()
                    text__.text=text_.text=Clipboard.pasteText()
                }
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
                    file.save()
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
