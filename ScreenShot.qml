import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Clipboard 1.0

Window {
    id: root
    width: Screen.width
    height: Screen.height
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    color: "transparent"
    visible: true
    property string name
    onNameChanged:image.source=name

    Image{
        id:image
        anchors.fill: parent
    }

    // 半透明背景层
    Item {
        id: overlay
        anchors.fill: parent
        Rectangle{
            color: setting.color_shot?"#80FF0000":"#80000000"
            x:0
            y:0
            width: selectionRect.x+selectionRect.width
            height: selectionRect.y
        }
        Rectangle{
            color: setting.color_shot?"#8000FF00":"#80000000"
            x:selectionRect.x+selectionRect.width
            y:0
            width: root.screen.width-selectionRect.width-selectionRect.x
            height: selectionRect.y+selectionRect.height
        }
        Rectangle{
            color: setting.color_shot?"#800000FF":"#80000000"
            x:selectionRect.x
            y:selectionRect.y+selectionRect.height
            width:root.screen.width-selectionRect.x
            height: root.screen.height-selectionRect.y-selectionRect.height
        }
        Rectangle{
            color: setting.color_shot?"#80000000":"#80000000"
            x:0
            y:selectionRect.y
            width:selectionRect.x
            height: root.screen.height-selectionRect.y
        }
    }

    // 截取区域
    Rectangle {
        id: selectionRect
        color: "#00FFFFFF"
        border.color: "#2080f0"
        border.width: 1
        visible: false
    }

    // 鼠标区域
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton|Qt.RightButton

        property point startPos

        onPressed: (mouse)=>{
                       ender.visible=false
                       if(mouse.button==Qt.LeftButton)
                       {
                           startPos = Qt.point(mouse.x, mouse.y)
                           selectionRect.x = mouse.x
                           selectionRect.y = mouse.y
                           selectionRect.width = 0
                           selectionRect.height = 0
                           selectionRect.visible = true
                       }
                       else
                       pasterLoad.endShot()
                   }

        onPositionChanged: (mouse)=>{
                               if (pressed) {
                                   selectionRect.x = Math.min(startPos.x, mouse.x)
                                   selectionRect.y = Math.min(startPos.y, mouse.y)
                                   selectionRect.width = Math.abs(mouse.x - startPos.x)
                                   selectionRect.height = Math.abs(mouse.y - startPos.y)
                               }
                           }

        onReleased: (mouse)=>{
                        ender.x=mouse.x
                        ender.y=mouse.y
                        if(ender.x+ender.width>root.screen.width)
                        ender.x-=ender.width
                        if(ender.y+ender.height>root.screen.height)
                        ender.y-=ender.height
                        ender.visible=true
                    }
    }

    Window{
        id:ender
        visible:false
        flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
        width: 87
        height:27
        color:"#00000000"
        property var sub_windows:[]
        property var buttons:[]
        property int detect_height:50
        property bool show_above:false
        Rectangle{
            width: ender.width
            height: 27
            border.color: $topic_color
            color:"#f2f2f2"
        }
        Item{
            x:1
            y:1
            width: ender.width-2
            height: ender.height-2
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
                id:copy_bu
                x:10
                type:2
                width: 25
                height: 25
                onClicked: {
                    visible=false
                    var s=String(image.source)
                    s=s.slice(s.indexOf("/")+1,s.length)
                    s=s.slice(s.indexOf("/")+1,s.length)
                    s=s.slice(0,s.indexOf("."))
                    Clipboard.shot(selectionRect.x, selectionRect.y,selectionRect.width, selectionRect.height,s)
                    pasterLoad.endShot()
                }
                img:"./images/copy.png"
            }
            Cbutton{
                id:paste
                x:35
                type:2
                width: 25
                height: 25
                onClicked: {
                    var s=String(image.source)
                    s=s.slice(s.indexOf("/")+1,s.length)
                    s=s.slice(s.indexOf("/")+1,s.length)
                    s=s.slice(0,s.indexOf("."))
                    pasterLoad.shotPaster(selectionRect.x, selectionRect.y,selectionRect.width, selectionRect.height,s)
                    pasterLoad.endShot()
                }
                img:"./images/top.png"
            }
            Cbutton{
                x:60
                type:2
                width: 25
                height: 25
                onClicked: {
                    pasterLoad.endShot()
                }
                img:"./images/close.png"
            }
        }
        DragHandler {//按下拖动以移动窗口
            grabPermissions: TapHandler.CanTakeOverFromAnything
            onActiveChanged: {
                if (active && drag_detect.dragging)
                {
                    ender.startSystemMove()
                }
            }
        }
    }


    // ESC键退出
    Shortcut {
        sequence: "Escape"
        onActivated: pasterLoad.endShot()
    }
}
