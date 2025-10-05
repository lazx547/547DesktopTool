import QtQuick
import QtQuick.Controls
import GFile 1.2
import EventSender

Window{
    id:root
    visible: true
    flags: Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
    width: 1
    height:1
    x:-1
    y:-1
    property var $menu
    property color $topic_color:"#2080f0"
    property bool $press_ctrl:false
    Item{
        id:app
        property GFile file:GFile{ id:_file}
        SysTray{ id:sysTray }
        Clock{ id:clock }
        Rand_bar{ id:rand_bar }
        Rand{ id:rand }
        PasterLoad{ id:pasterLoad }
        About{ id:about }
        Setting{ id:setting }
        Watermark{ id:watermark }
    }
    EventSender{
        id:eventSender
        onDataChanged: (data)=>{
                           switch(data){
                               case 0:
                               pasterLoad.shot()
                               break
                               case 1:
                               pasterLoad.create()
                               break
                               case 2:
                               setting.copyTime()
                               break
                               case -1:
                               $press_ctrl=true
                               break
                               case -2:
                               $press_ctrl=false
                               break
                               default:
                               console.log("unkown mesenge from C++")
                           }
                       }
    }

    Component.onCompleted: {
        _file.source="./file/saves/.num"
        var s=_file.read()
        var a=Number(s.slice(0,s.indexOf(","))),im
        var Csaves=Qt.createComponent("./CSaveItem.qml")
        for(var n=1;n<=a;n++){
            s=s.slice(s.indexOf(",")+1,s.length)
            im=s.slice(0,s.indexOf(","))
            sysTray.paster.add_(im)
        }
    }
}
