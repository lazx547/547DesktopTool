import QtQuick
import QtQuick.Controls

Rectangle{
    width: 400
    height:250
    property int contentHeight
    property var sub:item_it
    property string path
    property int num
    property bool opened
    property var per
    x:1
    Rectangle{
        width: 400
        height:20
        border.color: "#808080"
        border.width: 1
        Cbutton{
            id:open
            width: 45
            height: 20
            text: "打开"
            onClicked: {
                enabled=false
                close.enabled=true
                create.enabled=true
            }
        }
        Cbutton{
            id:close
            enabled: false
            width: 45
            x:50
            height: 20
            text: "关闭"
            onClicked: {
                enabled=false
                open.enabled=true
                create.enabled=false
                per.close(num)
            }
        }
        Cbutton{
            id:create
            width: 45
            height: 20
            enabled: false
            x:100
            text: "创建"
            onClicked: {
                per.createnew(num)
            }
        }
        Cbutton{
            width: 45
            x:150
            height: 20
            text: "删除"
            onClicked: {
            }
        }
    }
    ScrollView{
        id:item_sv
        width: 800
        height: 655
        y:20
        transformOrigin: Item.TopLeft
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        contentHeight:parent.contentHeight
        scale: 0.5
        Rectangle{
            transformOrigin: Item.TopLeft
            id:item_it
            scale: 2
        }
    }

}

