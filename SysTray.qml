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
        function add(s_){
            var menuItem = Qt.createQmlObject(`
                                              import Qt.labs.platform
                                              MenuItem {
                                                property var s
                                                property string name
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
            menuItem.name=s
            s=s.slice(s.indexOf("("),s.length)
            menuItem.text=s
            menu_.insertItem(0, menuItem)

        }
        function del(s){
            for(var i=0;i<menu_.items.length;i++)
                if(menu_.items[i].name==s)
                {
                    menu_.items[i].destroy()
                    menu_.removeItem(menu_.items[i])
                }

        }
        function sv(s){
            for(var i=0;i<menu_.items.length;i++)
                if(menu_.items[i].name==s)
                {
                    menu_.items[i].checked=!menu_.items[i].checked
                }
        }
        function rename(s,name)
        {
            for(var i=0;i<menu_.items.length;i++)
            {
                if(menu_.items[i].name==s)
                    menu_.items[i].text=name
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
            Platform.MenuItem{
                text: "截图"
                onTriggered: pasterLoad.shot()
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
            }
            Platform.MenuItem{
                text: "退出"
                onTriggered: Qt.quit()
                icon.source:"qrc:/images/exit.png"
            }
        }
    }
}

