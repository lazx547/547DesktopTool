import QtQuick
import Qt.labs.platform 1.1 as Platform
import QtQuick.Controls
import Clipboard 1.0
Window{
    x:-100
    y:-100
    width: 0
    height:0
    property var names:[]
    property Item paster:Item{
        function ghost(){
            ghost.checked=!ghost.checked
        }
        function add(s_,n){
            var menuItem = Qt.createQmlObject(`
                                              import Qt.labs.platform
                                              MenuItem {
                                                property var s
                                                checked:true
                                                checkable:true
                                                onCheckedChanged: {
                                                    if(s.ghost)
                                                    {
                                                        s.ghost=false
                                                        checked=true
                                                    }
                                                    s.visible=checked
                                                }
                                              }
                                              `, menu)
            menuItem.s=s_
            var s=String(s_)
            s=s.slice(s.indexOf("("),s.length)
            menuItem.text=s
            menu_.insertItem(0, menuItem)

        }
        function delA(){
            for(var i=0;i<menu_.items.length;i++)
            {
                menu_.items[i].destroy()
                menu_.removeItem(menu_.items[i])
            }
        }

        function del(n){
            for(var i=0;i<menu_.items.length;i++)
                if(menu_.items[i].s.thisn==n)
                {
                    menu_.items[i].destroy()
                    menu_.removeItem(menu_.items[i])
                }

        }
        function sv(n){
            for(var i=0;i<menu_.items.length;i++)
                if(menu_.items[i].s.thisn==n)
                {
                    menu_.items[i].checked=!menu_.items[i].checked
                }
        }
        function rename(n,name)
        {
            for(var i=0;i<menu_.items.length;i++)
            {
                if(menu_.items[i].s.thisn==n)
                    menu_.items[i].text=name
            }
        }
        function add_(s_){
            var menuItem = Qt.createQmlObject(`
                                              import Qt.labs.platform
                                              MenuItem {
                                                property string n
                                                onTriggered: pasterLoad.newP("./file/saves/"+n+".json")
                                              }
                                              `, menu)
            menuItem.n=s_
            menuItem.text=s_
            menu_paster.insertItem(menu_paster.items.length, menuItem)
        }
        function del_(name){
            for(var i=0;i<menu_paster.items.length;i++)
                if(menu_paster.items[i].n==name)
                {
                    menu_paster.items[i].destroy()
                    menu_paster.removeItem(menu_paster.items[i])
                }
        }
    }
    property Item clock_:Item{
        function add(s_){
            var menuItem = Qt.createQmlObject(`
                                              import Qt.labs.platform
                                              MenuItem {
                                                property var s
                                                onTriggered: s.run()
                                              }
                                              `, menu)
            menuItem.s=s_
            menuItem.text=menuItem.s.name
            menu_clock.insertItem(menu_clock.items.length, menuItem)
        }
        function del(name){
            for(var i=0;i<menu_clock.items.length;i++)
                if(menu_clock.items[i].text==name)
                {
                    menu_clock.items[i].destroy()
                    menu_clock.removeItem(menu_clock.items[i])
                }
        }
    }
    property Item watermark_:Item{
        function reset(i,t){
            if(i){
                if(t)
                    watermark1.checked=true
                else
                    watermark2.checked=true
            }
            else
                watermark.reset(false,true)
        }
    }

    Platform.SystemTrayIcon {//托盘图标
        id:sysTray
        visible: true
        icon.source: "qrc:/547dt.png"
        onActivated:(reason)=>{
                        switch(reason){
                            case Platform.SystemTrayIcon.Context:
                                menu.open()
                                break
                            case Platform.SystemTrayIcon.DoubleClick:
                                setting.visible=true
                                setting.raise()
                                break
                            case Platform.SystemTrayIcon.MiddleClick:
                                pasterLoad.shot()
                                break
                            case Platform.SystemTrayIcon.Trigger:
                                console.log( Clipboard.pasteText())
                                pasterLoad.create()
                                break
                            default:
                                console.log("unkown sysTrayEvent")
                        }
                    }
        menu:Platform.Menu{
            id:menu
            Platform.Menu{
                title: "工具"
                Platform.MenuItem{
                    text: "截图"
                    onTriggered: pasterLoad.shot()
                }
                Platform.MenuItem{
                    text: "复制时间"
                    onTriggered: setting.copyTime()
                }
                Platform.MenuSeparator{}
                Platform.MenuItem{
                    id:watermark1
                    text: "伪造激活水印"
                    checkable: true
                    onCheckedChanged: {
                        if(checked){
                            watermark2.checked=false
                            watermark.reset(true,true)
                        }
                        else if(!watermark2.checked)
                            watermark.reset(false,true)
                    }
                }
                Platform.MenuItem{
                    id:watermark2
                    text: "已激活水印"
                    checkable: true
                    onCheckedChanged: {
                        if(checked){
                            watermark1.checked=false
                            watermark.reset(true,false)
                        }
                        else if(!watermark1.checked)
                            watermark.reset(false,true)
                    }
                }
            }
            Platform.MenuSeparator{}
            Platform.MenuItem{
                text:"547抽号器"
                icon.source:"qrc:/images/rand.png"


                onTriggered:
                {
                    rand.visible=true
                    rand.raise()
                }
            }
            Platform.MenuItem{
                text: "隐藏"
                checkable: true
                checked: false
                onTriggered: checked=!rand_bar._Visible()
            }
            Platform.MenuSeparator{}
            Platform.Menu{
                icon.source:"qrc:/images/paster.png"
                title:"547Paster("+items.length+")"
                id:menu_
            }
            Platform.Menu{
                id:menu_paster
                title: "存档"
            }
            Platform.MenuItem{
                text: "全部显示"
                onTriggered: pasterLoad.showA()
            }
            Platform.MenuItem{
                text: "全部隐藏"
                onTriggered: pasterLoad.hideA()
            }
            Platform.MenuItem{
                text: "全部删除"
                onTriggered: pasterLoad.delA()
            }
            Platform.MenuSeparator{}
            Platform.Menu{
                icon.source:"qrc:/images/clock.png"
                title:"547clock"
                id:menu_clock
            }
            Platform.MenuItem{
                id:ghost
                text:"幽灵模式"
                checkable: true
                checked: clock.ghost
                onCheckedChanged: {
                    clock.ghost=checked
                }
            }
            Platform.MenuItem{
                text: "隐藏"
                checkable: true
                checked: !clock.visible
                onTriggered:clock.visible=!checked
            }
            Platform.MenuItem{
                text: "重载"
                onTriggered:clock.restart()
            }
            Platform.MenuSeparator{}
            Platform.MenuItem{
                text: "设置"
                onTriggered:
                {
                    setting.visible=true
                    setting.raise()
                }
            }
            Platform.MenuItem{
                text: "保存"
                onTriggered:
                {
                    setting.save()
                    clock.save()
                }
            }/*
            Platform.MenuItem{
                text: "重启"
                onTriggered:
                {
                    setting.save()
                    clock.save()
                    _file.restartApplication()
                }
            }*/
            Platform.MenuItem{
                text: "退出"
                onTriggered:
                {

                    clock.save()
                    setting.save()
                    Qt.quit()
                }
                icon.source:"qrc:/images/exit.png"
            }
        }
    }
}

