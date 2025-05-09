import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Qt5Compat.GraphicalEffects
import GFile 1.2
import Qt.labs.platform
Window{
    id: window
    visible: true
    flags: Qt.FramelessWindowHint
    width: 200
    height: 200
    color:"#00000000"
    readonly property real scale:Screen.devicePixelRatio
    readonly property real winwid:window.screen.width
    readonly property real winhei:window.screen.height
    property real num:0
    property int thisn
    property int thistype
    property string path
    property int thisnum
    function reset(){
        fish.scale=0.8
        text_.scale=1
        text_.opacity=1
        text_.anchors.verticalCenterOffset=-30
        text_.visible=false
    }
    DragHandler {
        grabPermissions: TapHandler.CanTakeOverFromAnything
        onActiveChanged: if (active) { window.startSystemMove() }
    }
    Rectangle{
        width: 200
        height: 200
        color:Qt.rgba(pick_b.r,pick_b.g,pick_b.b,pick_b.a)
        id:win
        transformOrigin: Item.TopLeft
        Image{
            id:fish_
            anchors.fill: parent
            source:"./images/fish.png"
            visible: false
        }
        ColorOverlay{
            anchors.fill: fish_
            id:fish
            scale: 0.8
            property bool click:false
            property bool onNA:false
            color: Qt.rgba(pick_d.r,pick_d.g,pick_d.b,pick_d.a)
            source: fish_
            visible: true
            NumberAnimation on scale {
                running: fish.click
                duration: 100
                to: 1.0
                onStarted: fish.onNA=true
                onStopped: fish.click=false
            }

            NumberAnimation on scale {
                running: !fish.click
                duration: 250
                easing.type: Easing.OutBack
                easing.overshoot: 1.0
                to: 0.8
                onStopped:fish.onNA=false
            }
        }
        Text{
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -30
            font.pixelSize: 20
            text:"功德+1"
            color:Qt.rgba(pick_f.r,pick_f.g,pick_f.b,pick_f.a)
            visible: false
            id:text_
            NumberAnimation on scale {
                running: fish.onNA
                duration: 350
                to: 1.5
                onStopped: {
                    text_.scale=1.0
                    text_.visible=false
                }
                onStarted: text_.visible=true
            }
            NumberAnimation on anchors.verticalCenterOffset {
                running: fish.onNA
                duration: 350
                to: -90
                onStopped: text_.anchors.verticalCenterOffset=-30
            }
            NumberAnimation on opacity {
                running: fish.onNA
                duration: 350
                to: 0
                onStopped: text_.opacity=1
            }
        }
        Text{
            id:gd
            anchors.centerIn: parent
            anchors.verticalCenterOffset: 80
            font.pixelSize: 20
            text:"功德:0"
            color:Qt.rgba(pick_f.r,pick_f.g,pick_f.b,pick_f.a)

        }
    }
    onPathChanged:
    {
        num=file.read_g()
        gd.text="功德:"+num
    }
    MouseArea{
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton |Qt.MiddleButton
        onClicked: (mouse)=>{

                       if(mouse.button===Qt.RightButton)//如果按下右键 显示右键菜单
                       {
                           yjcd.x=mouseX+window.x
                           yjcd.y=mouseY+window.y
                           if(yjcd.y+yjcd.height>winhei) yjcd.y-=yjcd.height//如果窗口上方的高度不足以显示右键菜单，就显示在窗口下方
                           if(yjcd.x+yjcd.width>winwid) yjcd.x-=yjcd.width
                           yjcd.visible=true
                       }
                       else if(mouse.button===Qt.LeftButton)
                       {
                           if(!fish.onNA)
                           {
                               num++
                               gd.text="功德:"+num
                               file.save(num)
                               fish.click=true
                           }

                           yjcd.visible=false
                       }
                   }
        onWheel: (wheel)=>{//滚动鼠标滚轮时缩放窗口
                     if(wheel.angleDelta.y>0)
                     {
                         win.scale+=0.1
                         window.width=200*win.scale
                         window.height=200*win.scale
                     }
                     else
                     {
                         if(window.width>=10){//如果窗口宽度大于10，防止缩放过小时窗口直接消失
                             win.scale-=0.1
                             window.width=200*win.scale
                             window.height=200*win.scale

                         }
                     }
                 }
    }
    GFile{
        id:file
        function save(n){
            source=path+"/547.dll"
            write(n)
        }
        function read_g()
        {
            source=path+"/547.dll"
            return read()
        }
    }

    Window{//右键菜单
        id:yjcd
        flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint//无边框 最上层
        width: 124
        height: 139
        color: "#00000000"
        property bool pick_:false
        onActiveFocusItemChanged: {//失去焦点时隐藏
            if(!activeFocusItem && !pick_b.active && !pick_d.active && !pick_f.active)
                visible=false

        }
        Rectangle{
            anchors.fill: parent
            border.color: "#80808080"
            border.width: 2
        }
        Item
        {
            id:cd
            width: yjcd.width-4
            x:2
            y:2
            Text{
                y:92
                text:"标识:"+thisnum
                font.pixelSize:20
            }

            GButton{
                width: cd.width
                height: 20
                y:115
                text:"关闭"
                radiusBg: 0
                toolTipText: "关闭"
                danger:true
                onClicked:
                    $moduleControl.exit(thisn,thistype)
            }
            GScrollBar{
                y:80
                text:"A"
                onValueChanged: window.opacity=value*0.99+0.01
            }

            Rectangle{//调整颜色
                id:colo
                y:0
                Text{
                    text:"颜色"
                    font.pixelSize: 18
                }
                Item{
                    id:ys
                    GButton{
                        id:ys_s
                        x:cd.width-80
                        width: 40
                        height: 20
                        text:"深色"
                        font.pixelSize: 14
                        onClicked: {
                            pick_f.setColor(1,1,1,1)
                            pick_d.setColor(0,0,0,1)
                            pick_b.setColor(0,0,0,0)
                        }
                        toolTipText: "预设的颜色搭配"
                        radiusBg: 0
                    }
                    GButton{
                        id:ys_q
                        x:cd.width-40
                        width: 40
                        height: 20
                        text:"浅色"
                        font.pixelSize: 14
                        onClicked: {
                            pick_f.setColor(0,0,0,1)
                            pick_d.setColor(1,1,1,1)
                            pick_b.setColor(1,1,1,0)
                        }
                        toolTipText: "预设的颜色搭配"
                        radiusBg: 0
                    }
                }

                Item{
                    y:20
                    Text{
                        text:"文字:"
                        height: 60
                        font.pixelSize: 16
                    }
                    GButton{
                        id:pick_f_b
                        x:cd.width-20
                        width: 20
                        height: 20
                        text:">"
                        onClicked: {
                            if(text==">")
                            {
                                pick_f.x=yjcd.x+cd.width
                                pick_f.y=yjcd.y+colo.y+20
                                if(pick_f.x+pick_f.width>winwid) pick_f.x-=yjcd.width+pick_f.width

                                pick_f.visible=true
                            }
                        }
                        toolTipText: "展开颜色选择窗口"
                        radiusBg: 0
                    }
                    ColorPicker{
                        id:pick_f
                        x:240
                        onActiveFocusItemChanged: {//失去焦点时隐藏
                            if(!activeFocusItem && !yjcd.active)
                                visible=false
                        }
                        Component.onCompleted: setColor(0,134/255,1,1)
                        onVisibleChanged: {
                            if(visible)pick_f_b.text="<"
                            else pick_f_b.text=">"
                        }
                    }
                }
                Item{
                    y:40
                    Text{
                        text:"木鱼:"
                        height: 60
                        font.pixelSize: 16
                    }
                    GButton{
                        id:pick_d_b
                        x:cd.width-20
                        width: 20
                        height: 20
                        text:">"
                        onClicked: {
                            if(text===">")
                            {
                                pick_d.x=yjcd.x+cd.width
                                pick_d.y=yjcd.y+colo.y+40
                                if(pick_d.x+pick_d.width>winwid) pick_d.x-=yjcd.width+pick_d.width
                                pick_d.visible=true
                            }
                        }
                        toolTipText: "展开颜色选择窗口"
                        radiusBg: 0
                    }
                    ColorPicker{
                        id:pick_d
                        x:240
                        onActiveFocusItemChanged: {//失去焦点时隐藏
                            if(!activeFocusItem && !yjcd.active)
                                visible=false
                        }
                        Component.onCompleted: setColor(129/255,90/255,0,1)
                        onVisibleChanged: {
                            if(visible)pick_d_b.text="<"
                            else pick_d_b.text=">"
                        }
                    }
                }
                Item{
                    y:60
                    Text{
                        text:"背景:"
                        height: 60
                        font.pixelSize: 16
                    }
                    GButton{
                        id:pick_b_b
                        x:cd.width-20
                        width: 20
                        height: 20
                        text:">"
                        onClicked: {
                            if(!pick_b.visible)
                            {
                                pick_b.x=yjcd.x+cd.width
                                pick_b.y=yjcd.y+colo.y+60
                                if(pick_b.x+pick_b.width>winwid) pick_b.x-=yjcd.width+pick_b.width
                                pick_f.visible=false
                                pick_b.visible=true
                            }
                        }
                        toolTipText: "展开颜色选择窗口"
                        radiusBg: 0
                    }

                    ColorPicker{
                        id:pick_b
                        onActiveFocusItemChanged: {//失去焦点时隐藏
                            if(!activeFocusItem && !yjcd.active)
                                visible=false
                        }
                        Component.onCompleted: setColor(1,1,1,0)
                        onVisibleChanged: {
                            if(visible)pick_b_b.text="<"
                            else pick_b_b.text=">"
                        }
                    }
                }
            }

        }
    }
}

