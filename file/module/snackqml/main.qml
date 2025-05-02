pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import GFile
import QtMultimedia

ApplicationWindow {
    id:win
    //opacity: 0.1
    property string filel       //用于处理文件操作
    property bool doud:true     //是否开启音效
    property bool donot:true
    property bool canStart:false
    property bool commom:false
    property bool pausen:false
    visible: true

    property int thisn
    property int thistype
    property string path
    property int thisnum
    minimumHeight: 600
    maximumHeight: 600
    minimumWidth: 900
    maximumWidth: 900
    width: 900
    height: 600
    title: "SnackQML ("+thisnum+")"
    function set_item(item_a,item_b,fun_1,fun_2){
        var timer = Qt.createQmlObject("import QtQuick 2.14; Timer {}", win);
        timer.repeat = true;
        timer.interval = 10;
        timer.triggered.connect(function(){
            if(item_a.opacity>0)
                item_a.opacity-=0.01
            else
            {
                fun_1()
                item_a.visible=false
                item_b.visible=true
                triggered.connect(function(){
                    if(item_b.opacity<1)
                        item_b.opacity+=0.01
                    else
                    {
                        fun_2()
                        this.destroy()
                    }
                })
            }
        })
    }

    GFile{
        id:file
    }
    SoundEffect{//按键音效
        id:press_su
        source: "./images/raw/click.wav"
        function play_()
        {
            if(doud) press_su.play()
        }
    }
    SoundEffect{//吃到食物音效
        id:move_ea
        source: "./images/raw/eat.wav"
    }
    Image{
        anchors.fill: parent
        source: "./images/back_load.png"
        Image{
            anchors.fill: parent
            source: "./images/pause.png"
        }
    }
    Sett{
        id:sett
    }

    Load{
        id:load_item
    }

    Playing{
        id:item
    }
    Start{
        id:start_item
    }

    Photo_s{
        id:photo
    }

    Help{
        id:help
    }
    Greengame{
        id:winn
    }
    Start_set{
        id:start_set
    }
}
