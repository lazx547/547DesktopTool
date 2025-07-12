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
    property var win
    property var rand
    function ghost(){
        ghost.checked=!ghost.checked
    }
    function add(s_){
        var menuItem = Qt.createQmlObject(`
                                          import Qt.labs.platform
                                          MenuItem {
                                          property var s
                                          property string name
                                          checkable:true
                                          checked:true
                                          onCheckedChanged:{
                                            s.visible=checked
                                          }
                                          }
                                          `, menu)
        menuItem.s=s_
        var s=String(s_)
        menuItem.name=s
        s=(s.indexOf("Paster")>-1?"贴图":"文本")+s.slice(s.indexOf("("),s.length)
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

    Platform.SystemTrayIcon {//托盘图标
        id:root
        visible: true
        icon.source: "qrc:/547dt.png"
        onActivated:(reason)=>{
                        if (reason === Platform.SystemTrayIcon.Context) {
                            menu.open()
                        } else {
                            console.log( Clipboard.pasteText())
                            $pasterLoad.create()
                        }
                    }
        menu:Platform.Menu{
            id:menu
            Platform.MenuItem{
                text:"547抽号器"
                icon.source:"qrc:/images/rand.png"
                onTriggered:
                {
                    $rand.visible=true
                    $rand.raise()
                }
            }

            Platform.MenuItem{
                text: "抽号"
                onTriggered: {
                    rand.reRand()
                }
            }
            Platform.MenuItem{
                text: "隐藏"
                checkable: true
                checked: false
                onTriggered: checked=!rand._Visible()
            }
            Platform.MenuSeparator{}
            Platform.Menu{
                icon.source:"qrc:/images/paster.png"
                title:"547Paster("+items.length+")"
                id:menu_
            }
            Platform.MenuItem{
                text: "全部显示"
                onTriggered: $pasterLoad.showA()
            }
            Platform.MenuItem{
                text: "全部隐藏"
                onTriggered: $pasterLoad.hideA()
            }
            Platform.MenuItem{
                text: "全部删除"
                onTriggered: $pasterLoad.delA()
            }
            Platform.MenuItem{
                text: "截图"
                onTriggered: $pasterLoad.shot()
            }
            Platform.MenuSeparator{}
            Platform.MenuItem{
                icon.source:"qrc:/images/clock.png"
                text:"547clock"
                onTriggered: {
                    win.visible=true
                    win.raise()
                }
            }
            Platform.MenuItem{
                id:ghost
                text:"幽灵模式"
                checkable: true
                onCheckedChanged: {
                    if(checked)
                        win.flags=Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint| Qt.WindowTransparentForInput
                    else
                        win.flags=Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
                }
            }
            Platform.MenuItem{
                text: "重载"
                onTriggered:win.restart()
            }
            Platform.MenuItem{
                text: "设置"
                onTriggered:win.show_setting()
            }
            Platform.MenuSeparator{}
            Platform.MenuItem{
                text: "关于"
                onTriggered:$about.visible=true
            }
            Platform.MenuItem{
                text: "重新启动"
                onTriggered: Clipboard.restart()
            }
            Platform.MenuItem{
                text: "退出"
                onTriggered: Qt.quit()
                icon.source:"qrc:/images/exit.png"
            }
        }
    }
}

