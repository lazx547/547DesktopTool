import QtQuick
import GFile 1.2
import Qt.labs.platform
import QtQuick.Controls

Window {
    id:win
    flags:Qt.FramelessWindowHint|Qt.Window
    visible: true
    width: 660
    height: 404
    color:"#00000000"
    property var $file:GFile{}
    property var $modules:[]
    property var $modules_name:[]
    property var $Modules:[]
    property var $ModuleErs:[]
    property var module:Qt.createComponent("./Module.qml")
    property var moduleEr:Qt.createComponent("./ModuleEr.qml")
    property var $moduleControl:ModuleControl{}
    function load(){
        $file.source="./file/module/.list"
        var s=$file.read(),ts,tm
        var i=0,l=s.length,j=0
        do
        {
            $modules_name.push(s.slice(0,s.indexOf(",")))
            i=s.indexOf(",")+1
            s=s.slice(i,l)
            j++
        }
        while(i!=0)
        $modules_name.pop()
        for(i=0;i<$modules_name.length;i++)
        {
            moduleItem.height+=60
            moduleItem_sv.contentHeight=moduleItem.height*2
            ts=$modules_name[i]
            $modules.push(Qt.createComponent("./module/"+ts+"/main.qml"))
            $Modules.push(module.createObject(moduleItem))
            $Modules[i].path="./module/"+ts
            $Modules[i].num=i
            $Modules[i].x=0
            $Modules[i].y=60*i
            $Modules[i].visible=true
            $ModuleErs.push(moduleEr.createObject(moduleErItem))
            $ModuleErs[i].lelen=moduleItem_sv.effectiveScrollBarWidth/2
            $ModuleErs[i].num=i
            $ModuleErs[i].path="./module/"+ts
            $ModuleErs[i].visible=false
        }
    }
    function unload(){
        for(var i=0;i<=$modules.length;i++)
        {
            $modules[i].destroy()
            $Modules[i].destroy()
            $ModuleErs[i].destroy()
        }
        $modules=[]
        $Modules=[]
        $ModuleErs=[]
    }


    Component.onCompleted: {
        load()
    }
    SystemTrayIcon{
        icon.source:"qrc:/547dt.png"
        visible:true
        id:tray
        onActivated:(reason)=>{
                        if (reason === SystemTrayIcon.Context) {
                            sysMenu.open()
                        } else {
                            win.show();
                            win.raise();
                            win.requestActivate();
                        }
                    }
        menu:Menu{
            id: sysMenu
            MenuItem{
                text: "退出"
                onTriggered: Qt.quit()
            }
        }
    }
    
    DragHandler {//按下拖动以移动窗口
        grabPermissions: TapHandler.CanTakeOverFromAnything
        onActiveChanged: {
            if (active)
            {
                win.startSystemMove()
            }
        }
    }
    Rectangle{
        anchors.fill: parent
        border.color: "#80808080"
        border.width: 2
        Item{
            x:2
            y:2
            Rectangle{
                width: win.width-4
                height: 30
                color:"#BBBBBB"
                Image{
                    source:"./module/core/ico.png"
                    width: 30
                    height: 30
                }

                Text{
                    x:32
                    y:2
                    text:"547DesktopTool"
                    font.pixelSize: 20
                }
                ImaButton{
                    x:536
                    y:-3
                    width: 30
                    height: 30
                    img:"./images/top_.png"
                    font.pixelSize: 30
                    colorBorder: "#00000000"
                    padding: 0
                    topPadding: 5
                    onClicked: {
                        if(img=="./images/top.png")
                        {
                            img="./images/top_.png"
                            win.flags=Qt.FramelessWindowHint|Qt.Window
                        }
                        else
                        {
                            img="./images/top.png"
                            win.flags=Qt.FramelessWindowHint|Qt.Window|Qt.WindowStaysOnTopHint
                        }
                    }
                }

                ImaButton{
                    x:566
                    y:-3
                    width: 30
                    height: 30
                    img:"./images/setting.png"
                    font.pixelSize: 30
                    colorBorder: "#00000000"
                    padding: 0
                    topPadding: 5
                    onClicked: {
                        win_s.visible=true

                    }
                }
                Cbutton{
                    x:596
                    y:-5
                    width: 30
                    height: 30
                    text: "-"
                    font.pixelSize: 30
                    colorBg: "#00000000"
                    colorBorder: "#00000000"
                    padding: 0
                    topPadding: 5
                    onClicked: {
                        win.visibility=Window.Minimized
                    }
                }
                Cbutton{
                    x:626
                    y:-5
                    width: 30
                    height: 30
                    text: "×"
                    colorBg: "#00000000"
                    colorBorder: "#00000000"
                    font.pixelSize: 30
                    padding: 0
                    danger:true
                    topPadding: 5
                    onClicked: {
                        win.visible=false
                    }
                }


            }
            Rectangle{
                x:2
                y:30
                width: 331+moduleItem_sv.effectiveScrollBarWidth/2
                height: 370
                border.color: "#CCCCCC"
                border.width: 1
                ScrollView{
                    id:moduleItem_sv
                    transformOrigin: Item.TopLeft
                    width: 330*2+moduleItem_sv.effectiveScrollBarWidth
                    height: 740
                    scale:0.5
                    ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                    Rectangle{
                        transformOrigin: Item.TopLeft
                        id:moduleItem
                        scale: 2
                        width: 281
                    }
                }
            }
            Item{
                transformOrigin: Item.TopLeft
                x:333+moduleItem_sv.effectiveScrollBarWidth/2
                y:30
                width: 318
                id:moduleErItem
            }
            
        }
        
        
    }
}
