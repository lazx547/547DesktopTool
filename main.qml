import QtQuick
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
    Item{
        id:app
        property GFile file:GFile{}
        SysTray{ id:sysTray }
        Clock{ id:clock }
        Rand_bar{ id:rand_bar }
        Rand{ id:rand }
        PasterLoad{ id:pasterLoad }
        About{ id:about }
        Setting{ id:setting }
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
                               default:
                               console.log("unkown mesenge from C++")
                           }
                       }
    }
}
