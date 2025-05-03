import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Window
import QtQuick.Dialogs
import Clipboard 1.0
import GFile 1.2
Window {
    id: root
    width: 640
    height: 480
    minimumWidth: 100
    minimumHeight: 100
    flags: Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
    color: "#00000000"
    visible: true

    readonly property real sys_width: root.screen.width
    readonly property real sys_height: root.screen.height
    property int edgeThreshold: 5
    property font sfont
    property int thisn
    property int thistype
    property string path
    property int thisnum

    onPathChanged: {
        if($file.is(path+"/.ini"))
        {
            $file.source=path+"/.ini"
            var s=$file.read(),r_,g_,b_,a_
            r_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            g_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            b_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            a_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            color_text.setColor(r_,g_,b_,a_)
            r_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            g_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            b_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            a_=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            color_back.setColor(r_,g_,b_,a_)
            text_size.setValue(Number(s.slice(0,s.indexOf(","))))
            s=s.slice(s.indexOf(",")+1,s.length)
            sfont.family=s.slice(0,s.indexOf(","))
            s=s.slice(s.indexOf(",")+1,s.length)
            text_.text=text__.text=s.slice(0,s.indexOf(","))
        }
        else
        {
            sfont.family="微软雅黑"
        }
    }
    function save(){
        var a=color_text.r.toString()+","+color_text.g.toString()+","+color_text.b.toString()+","+color_text.a.toString()+","
        a+=color_back.r.toString()+","+color_back.g.toString()+","+color_back.b.toString()+","+color_back.a.toString()+","
        a+=text_size.value.toString()+","
        a+=sfont.family+","
        a+=text__.text+","
        $file.source=path+"/.ini"
        $file.write(a)
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        // 定义操作类型
        property string operation: "none"
        property point startPos: Qt.point(0, 0)
        property rect startGeometry: Qt.rect(0, 0, 0, 0)

        // 根据鼠标位置更新光标和操作类型
        onPositionChanged:
            (mouse) => {
                if (!pressed) {
                    // 检测鼠标悬停区域
                    const isRightEdge = (mouseX >= root.width - edgeThreshold)
                    const isBottomEdge = (mouseY >= root.height - edgeThreshold)

                    // 更新光标形状
                    if (isRightEdge && isBottomEdge) {
                        cursorShape = Qt.SizeFDiagCursor
                        operation = "resize_both"
                    } else if (isRightEdge) {
                        cursorShape = Qt.SizeHorCursor
                        operation = "resize_width"
                    } else if (isBottomEdge) {
                        cursorShape = Qt.SizeVerCursor
                        operation = "resize_height"
                    } else {
                        cursorShape = Qt.SizeAllCursor
                        operation = "move"
                    }
                }
                else
                {
                    const deltaX = mouseX - startPos.x
                    const deltaY = mouseY - startPos.y

                    switch(operation) {
                        case "move":
                        root.x += deltaX
                        root.y += deltaY
                        break

                        case "resize_width":
                        root.width = Math.max(
                            root.minimumWidth,
                            startGeometry.width + deltaX
                            )
                        break
                        case "resize_height":
                        root.height = Math.max(
                            root.minimumHeight,
                            startGeometry.height + deltaY
                            )
                        break

                        case "resize_both":
                        root.width = Math.max(
                            root.minimumWidth,
                            startGeometry.width + deltaX
                            )
                        root.height = Math.max(
                            root.minimumHeight,
                            startGeometry.height + deltaY
                            )
                        break
                    }
                }
            }

        // 鼠标按下：记录初始状态
        onPressed: (mouse) => {
                       startPos = Qt.point(mouseX, mouseY)
                       startGeometry = Qt.rect(root.x, root.y, root.width, root.height)
                   }
        // 鼠标释放：重置状态
        onReleased: {
            operation = "none"
            if(root.x==startGeometry.x && root.y==startGeometry.y && root.width==startGeometry.width &&root.height==startGeometry.height)
                menu.visible=!menu.visible
        }
    }

    Rectangle{
        id:win
        anchors.fill: parent
        color:Qt.rgba(color_back.r,color_back.g,color_back.b,color_back.a)
        Item{
            TextArea{
                id:text__
                visible: menu.visible
                horizontalAlignment: Text.AlignHCenter
                x:edgeThreshold
                y:edgeThreshold
                width: root.width-2*edgeThreshold
                height: root.height-20-2*edgeThreshold
                wrapMode: Text.Wrap
                padding: 0
                color:Qt.rgba(color_text.r,color_text.g,color_text.b,color_text.a)
                leftPadding: 0
                rightPadding: 0
                font.pixelSize: text_size.value*100
                font.bold: text_bord.checked
                font.family: sfont.family
                onVisibleChanged: {
                    if(visible)
                    {
                        text=text_.text
                    }
                    else
                    {
                        text_.text=text
                    }
                }
            }
            Text{
                x:edgeThreshold
                y:edgeThreshold
                horizontalAlignment: Text.AlignHCenter
                font.family: sfont.family
                width: root.width-2*edgeThreshold
                height: root.height-20-2*edgeThreshold
                id:text_
                color:Qt.rgba(color_text.r,color_text.g,color_text.b,color_text.a)
                visible: !menu.visible
                wrapMode: Text.Wrap
                font.pixelSize: text_size.value*100
                font.bold: text_bord.checked
            }
        }
    }
    onWidthChanged: {
        if(menu.minWidth>root.width){
            menu.scale=root.width/menu.minWidth
        }
        else
            menu.scale=1
    }

    Rectangle {
        id:menu
        width: scale==1?parent.width:minWidth
        property int minWidth:600
        transformOrigin: Item.TopLeft
        y:root.height-20*scale-edgeThreshold
        height: 20
        color: "#05e0e0e0"
        ImaButton{//退出
            color_:Qt.rgba(color_text.r,color_text.g,color_text.b,color_text.a)
            width: 20
            height: 20
            img:"./images/exit.png"
            danger: true
            onClicked:
            {
                save()
                $moduleControl.exit(thisn,thistype)
            }
        }
        ImaButton{//置顶
            id:window_top
            width: 20
            height: 20
            x:20
            color_:Qt.rgba(color_text.r,color_text.g,color_text.b,color_text.a)
            img:"./images/top.png"
            checked: true
            onCheckedChanged: {
                if(!checked)
                {
                    img="./images/top_.png"
                    root.flags=Qt.FramelessWindowHint
                }
                else
                {
                    img="./images/top.png"
                    root.flags=Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                }
                menu.visible=false
            }
            onClicked: checked=!checked
        }
        ImaButton{//锁定
            id:window_lock
            x:40
            width: 20
            height: 20
            color_:Qt.rgba(color_text.r,color_text.g,color_text.b,color_text.a)
            img:"./images/locked_.png"
            checked: false
            onCheckedChanged: {
                if(!checked)
                    img="./images/locked_.png"
                else
                    img="./images/locked.png"
                menu.visible=false
            }
        }
        Cbutton{
            width: 45
            height: 20
            x:60
            text:"粘贴"
            color_:Qt.rgba(color_text.r,color_text.g,color_text.b,color_text.a)
            checked: false
            onClicked: {
                text__.text=text_.text=Clipboard.pasteText()
            }
        }
        Cbutton{
            width: 45
            height: 20
            x:105
            text:"复制"
            color_:Qt.rgba(color_text.r,color_text.g,color_text.b,color_text.a)
            checked: false
            onClicked: {
                Clipboard.copyText(text__.text)
            }
        }
        Cbutton{//加粗
            id:text_bord
            width: 20
            height: 20
            x:150
            text:"B"
            color_:Qt.rgba(color_text.r,color_text.g,color_text.b,color_text.a)
            checked: false
            checkable: true
            font.bold: checked
        }
        Cbutton{//居中
            id:text_center
            width: 20
            height: 20
            x:170
            text:"="
            color_:Qt.rgba(color_text.r,color_text.g,color_text.b,color_text.a)
            checked: true
            checkable: true
            font.bold: checked
            onCheckedChanged: {
                if(checked)
                {
                    text_.horizontalAlignment=Text.AlignHCenter
                    text__.horizontalAlignment=Text.AlignHCenter
                }
                else
                {
                    text_.horizontalAlignment=Text.AlignLeft
                    text__.horizontalAlignment=Text.AlignLeft
                }
            }
        }
        CscrollBar{//字体大小
            x:190
            id:text_size
            minValue: 5
            maxValue: 105
            color_:Qt.rgba(color_text.r,color_text.g,color_text.b)
            Component.onCompleted: setValue(0.32)
            text:"大小"
        }
        ComboBox {
            x:400
            scale: 0.5
            transformOrigin: Item.TopLeft
            id: fontFamilyBox
            model: Qt.fontFamilies()
            currentIndex: model.indexOf(sfont.family)
            onActivated: sfont.family = currentText
        }

        Item{//背景
            x:menu.width-60
            Cbutton{
                id:color_back_button
                width: 60
                height: 20
                color_:Qt.rgba(color_text.r,color_text.g,color_text.b,color_text.a)
                text:"背景>"
                onClicked: {
                    if(text==="背景>")
                    {
                        color_back.x=root.x+root.width
                        color_back.y=root.y+root.height-color_back.height
                        if(color_back.x+color_back.width>sys_width) color_back.x-=root.width+color_back.width
                        //hidewindows()
                        color_back.visible=true
                    }
                }
            }
            ColorPicker{
                id:color_back
                x:240
                color__:Qt.rgba(color_text.r,color_text.g,color_text.b)
                color_:Qt.rgba(color_back.r,color_back.g,color_back.b,color_back.a)
                onActiveFocusItemChanged: {//失去焦点时隐藏
                    if(!activeFocusItem)
                        visible=false
                }
                Component.onCompleted: setColor(1,1,1,0.5)
                onVisibleChanged: {
                    if(visible)color_back_button.text="背景<"
                    else color_back_button.text="背景>"
                }
            }
        }
        Item{//颜色
            id:color_set
            x:menu.width-120
            Cbutton{
                id:color_text_button
                width: 60
                height: 20
                color_:Qt.rgba(color_text.r,color_text.g,color_text.b,color_text.a)
                text:"文字>"
                onClicked: {
                    if(text==="文字>")
                    {
                        color_text.x=root.x+root.width
                        color_text.y=root.y+root.height-color_text.height
                        if(color_text.x+color_text.width>sys_width) color_text.x-=root.width+color_text.width
                        color_text.visible=true
                    }
                }
            }
            ColorPicker{
                id:color_text
                x:240
                color__:Qt.rgba(color_text.r,color_text.g,color_text.b)
                color_:Qt.rgba(color_back.r,color_back.g,color_back.b,color_back.a)
                onActiveFocusItemChanged: {//失去焦点时隐藏
                    if(!activeFocusItem && !menu.active)
                        visible=false
                }
                Component.onCompleted: setColor(0,0,0,1)
                onVisibleChanged: {
                    if(visible)color_text_button.text="文字<"
                    else color_text_button.text="文字>"
                }
            }
        }
    }


}




//                     CscrollBar{//圆角大小
//                         y:45
//                         id:border_radiu
//                         minValue:0
//                         maxValue:win.height/2
//                         step:1/(win.width/2)
//                         reset:0
//                         Component.onCompleted: setValue(reset)
//                         text:"圆角"
//                     }
//                 }
//                 Item{//颜色
//                     id:color_set
//                     y:195
//                     Text{
//                         text:"颜色"
//                         font.pixelSize:18
//                     }
//                     Item{//文字
//                         y:20
//                         Text{
//                             text:"文字:"
//                             height: 60
//                             font.pixelSize: 16
//                         }
//                         Cbutton{
//                             x:menuItems.width-132
//                             width: 55
//                             height: 20
//                             text:"同边框"
//                             font.pixelSize: 14
//                             onClicked: {
//                                 color_text.setColor(color_border.r,color_border.g,color_border.b,color_border.a)
//                             }

//                         }
//                         Cbutton{
//                             x:menuItems.width-77
//                             width: 55
//                             height: 20
//                             text:"同背景"
//                             font.pixelSize: 14
//                             onClicked: {
//                                 color_text.setColor(color_back.r,color_back.g,color_back.b,color_back.a)
//                             }
//                         }
//                         Cbutton{
//                             id:color_text_button
//                             x:menuItems.width-22
//                             width: 20
//                             height: 20
//                             text:">"
//                             onClicked: {
//                                 if(text===">")
//                                 {
//                                     color_text.x=menu.x+menu.width
//                                     color_text.y=menu.y+color_set.y+20
//                                     if(color_text.x+color_text.width>sys_width) color_text.x-=menu.width+color_text.width
//                                     color_text.visible=true
//                                 }
//                             }
//                         }
//                         ColorPicker{
//                             id:color_text
//                             x:240
//                             onActiveFocusItemChanged: {//失去焦点时隐藏
//                                 if(!activeFocusItem && !menu.active)
//                                     visible=false
//                             }
//                             Component.onCompleted: setColor(0,0,0,1)
//                             onVisibleChanged: {
//                                 if(visible)color_text_button.text="<"
//                                 else color_text_button.text=">"
//                             }
//                         }
//                     }

//
//                 Item{//设置
//                     x:0
//                     y:menuItems.height-52

//                     Cbutton{//存档
//                         id:saves_button
//                         x:150
//                         width: 50
//                         height: 25
//                         text:"存档>"
//                         font.pixelSize: 13
//                         onClicked: {
//                             if(text==="存档>")
//                             {
//                                 saves_window.x=menu.x+menu.width
//                                 saves_window.y=menu.y
//                                 if(saves_window.x+saves_window.width>sys_width) saves_window.x-=menu.width+saves_window.width
//                                 saves_window.visible=true
//                                 text="存档<"
//                             }
//                             else
//                                 text="存档>"
//                         }
//                         Window {
//                             id: saves_window
//                             width: 164+saves_scoll.effectiveScrollBarWidth/2
//                             height: menu.height
//                             flags: Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
//                             color: "#11111100"
//                             onActiveFocusItemChanged: {//失去焦点时隐藏
//                                 if(!activeFocusItem)
//                                 {
//                                     visible=false
//                                     saves_button.text="存档>"
//                                 }
//                             }
//                             Rectangle{
//                                 anchors.fill: parent
//                                 border.width: 2
//                                 border.color: "#80808080"

//                             }
//                             Rectangle{
//                                 x:2
//                                 y:4
//                                 TextArea{
//                                     id:save_text
//                                     x:2
//                                     y:1
//                                     width: 80
//                                     height: 25
//                                     color: "black"
//                                     padding:2
//                                     font.pixelSize: 18
//                                     background:Rectangle{
//                                         anchors.fill: parent
//                                         border.width: 1
//                                         border.color: "#80808080"
//                                     }
//                                     onTextChanged: {
//                                         if(text.length>5)
//                                             text=text.slice(0,5)
//                                         if(text=="") save_new.enabled=false
//                                         else{
//                                             var a=false
//                                             for(var i=0;i<saves.sis.length;i++)
//                                                 if(saves.sis[i].num==text)
//                                                 {
//                                                     save_new.enabled=false
//                                                     a=true
//                                                     break
//                                                 }
//                                             if(!a)
//                                                 save_new.enabled=true
//                                         }
//                                     }

//                                 }

//                                 Cbutton{
//                                     x:100
//                                     width: 60
//                                     text:"保存"

//                                     id:save_new
//                                     enabled: false
//                                     onClicked: {
//                                         enabled=false
//                                         file.source=path+"/saves/"+save_text.text+".txt"
//                                         file.save2(file.source)
//                                         var Csaves=Qt.createComponent("./CSaveItem.qml"),im
//                                         saves.sis.push(im=Csaves.createObject(saves))
//                                         im.file=file
//                                         im.path=path
//                                         im.par=saves
//                                         im.n=saves.sis.length
//                                         im.num=save_text.text
//                                         im.y=(im.n-1)*50
//                                         im.parent=saves
//                                         saves.height=50*im.n
//                                         file.source=path+"/saves/num.txt"
//                                         var s=saves.sis.length+","
//                                         for(var i=0;i<saves.sis.length;i++)
//                                             s+=saves.sis[i].num+","
//                                         file.write(s)
//                                     }
//                                 }
//                             }
//                             ScrollView{
//                                 x:2
//                                 y:35
//                                 width: 320+effectiveScrollBarWidth
//                                 height:saves_window.height*2-82
//                                 scale: 0.5
//                                 transformOrigin: Item.TopLeft
//                                 contentHeight: saves.height*2
//                                 id:saves_scoll
//                                 Item{
//                                     width: 160
//                                     id:saves
//                                     scale: 2
//                                     transformOrigin: Item.TopLeft
//                                     property var sis:[]
//                                     function remove(n){
//                                         n--
//                                         sis[n].destroy()
//                                         var i,s
//                                         for(i=n;i<sis.length-1;i++)
//                                         {
//                                             sis[i]=sis[i+1]
//                                             sis[i].n-=1
//                                             sis[i].y-=50
//                                         }
//                                         sis.pop()
//                                         saves.height-=50
//                                         s=sis.length+","
//                                         for(i=0;i<sis.length;i++)
//                                             s+=sis[i].num+","
//                                         file.source=path+"/saves/num.txt"
//                                         file.write(s)
//                                     }
//                                 }

//                                 function load(){
//                                     file.source=path+"/saves/num.txt"
//                                     var s=file.read()
//                                     var a=Number(s.slice(0,s.indexOf(","))),im
//                                     var Csaves=Qt.createComponent("./CSaveItem.qml")
//                                     for(var n=1;n<=a;n++)
//                                     {
//                                         saves.sis.push(im=Csaves.createObject(saves))
//                                         im.file=file
//                                         im.par=saves
//                                         im.n=n
//                                         im.path=path
//                                         s=s.slice(s.indexOf(",")+1,s.length)
//                                         im.num=s.slice(0,s.indexOf(","))
//                                         im.y=(n-1)*50
//                                         im.parent=saves
//                                     }
//                                     saves.height=50*a
//                                 }
//                             }
//                         }
//                     }
//                     Item{//第二行
//                         y:25
//                         ImaButton{//退出

//                             width: 25
//                             height: 25
//                             img:"./images/exit.png"
//                             danger: true
//                             onClicked:
//                             {
//                                 mstg_window.save()
//                                 file.save()
//                                 $moduleControl.exit(thisn,thistype)
//                             }
//                         }
//                         ImaButton{//保存按钮
//                             width: 25
//                             height: 25
//                             img: "./images/save.png"
//                             x:25
//                             onClicked:
//                             {
//                                 mstg_window.save()
//                                 file.save()
//                             }
//                         }
//                         ImaButton{//不保存并退出按钮
//                             width: 25
//                             height: 25
//                             img: "./images/exit_not_save.png"
//                             x:75
//                             onClicked: $moduleControl.exit(thisn,thistype)
//                             danger:true

//                         }
//                         Cbutton{//窗口上移
//                             width: 25
//                             height: 25
//                             x:100
//                             rotation: 90
//                             text: "<"
//                             font.pixelSize: 25
//                             onClicked:
//                             {
//                                 window.y-=1
//                             }
//                         }
//                         Cbutton{//窗口下移
//                             width: 25
//                             height: 25
//                             rotation: 90
//                             x:125
//                             text: ">"
//                             font.pixelSize: 25
//                             onClicked:
//                             {
//                                 window.y+=1
//                             }
//                         }
//                         Cbutton{//窗口左移
//                             width: 25
//                             height: 25
//                             x:150
//                             text: "<"
//                             font.pixelSize: 25
//                             onClicked:
//                             {
//                                 window.x-=1
//                             }
//                         }
//                         Cbutton{//窗口右移
//                             width: 25
//                             height: 25
//                             x:175
//                             text: ">"
//                             font.pixelSize: 25
//                             onClicked:
//                             {
//                                 window.x+=1
//                             }
//                         }
//                     }
//                 }
//             }
//         }

//     }
// }
