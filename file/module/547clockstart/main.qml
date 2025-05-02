import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import GFile 1.2

Window{
    id:win
    flags:Qt.FramelessWindowHint|Qt.Window
    visible: true
    width: 660
    height: 404
    color:"#00000000"
    title:"547clock管理"

    property int thisn
    property int thistype
    property string path
    property int thisnum

    property int run_num:{
        for(var i=0;i<$modules_name.length;i++)
            if($modules_name[i]=="547clock")
                return i
    }
    property var runClock:$ModuleErs[run_num]
    property var createCItem:Qt.createComponent("./CItem.qml")
    property var createGroup:Qt.createComponent("./Group.qml")
    property var createCItems:Qt.createComponent("./CItems.qml")
    property var groups:[]
    property var groupsItems:[]
    property var items:[]

    function createnew(n){
        var s=runClock.createnew()
        groupsItems[n].objs.push(s)
        groupsItems[n].obj_items.push(createCItem.createObject(items[n].sub))
        var j=groupsItems[n].obj_items.length-1
        groupsItems[n].obj_items[j].y=31*j
        groupsItems[n].obj_items[j].le=groups_sv.effectiveScrollBarWidth/2
        groupsItems[n].obj_items[j]._text=s
        items[n].contentHeight=62*j+62
    }

    function reActive(){
        for(var i=0;i<groupsItems.length;i++)
        {
            groupsItems[i].active=false
            items[i].visible=false
        }
    }

    function close(n){
        for(var i=0;i<groupsItems[n].objs.length;i++)
            runClock.del(groupsItems[n].objs[i].thisn)
    }

    onPathChanged:{
        $file.source=path+"/saves/.info"
        var s=$file.read(),i,j,k
        do
        {
            try{
                groups.push(s.slice(0,s.indexOf(",")))
            }
            catch(TypeError){
                break
            }
            i=s.indexOf(",")+1
            s=s.slice(i,s.length)
        }
        while(s.indexOf(",")!=-1)
        for(i=0;i<groups.length;i++)
        {
            groupsItems.push(createGroup.createObject(groups_it))
            groups_sv.contentHeight=groups_it.height=31*(i+1)*2
            groupsItems[i].name=groups[i]
            groupsItems[i].y=31*i
            groupsItems[i].num=i
            groupsItems[i].le=groups_sv.effectiveScrollBarWidth/2
            groupsItems[i].per=win
            $file.source=path+"/saves/"+groups[i]+"/.info"
            s=$file.read()
            items.push(createCItems.createObject(item_it))
            items[i].visible=false
            items[i].num=i
            items[i].path=path+"/"+groups[i]
            items[i].per=win
            do
            {
                try{
                    groupsItems[i].objs.push(s.slice(0,s.indexOf(",")))
                }
                catch(TypeError){
                    break
                }
                s=s.slice(s.indexOf(",")+1,s.length)
            }
            while(s.indexOf(",")!=-1)
            for(j=0;j<groupsItems[i].objs.length;j++)
            {
                groupsItems[i].obj_items.push(createCItem.createObject(items[i].sub))
                groupsItems[i].obj_items[j].y=31*j
                groupsItems[i].obj_items[j].le=groups_sv.effectiveScrollBarWidth/2
                groupsItems[i].obj_items[j]._text=groupsItems[i].objs[j]
                items[i].contentHeight=62*j+62
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
                    source:"./ico.png"
                    width: 30
                    height: 30
                }

                Text{
                    x:32
                    y:2
                    text:"547clock管理"
                    font.pixelSize: 20
                }
                ImaButton{
                    x:win.width-96
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
                Cbutton{
                    x:win.width-66
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
                    x:win.width-36
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
            Item{
                y:30
                TextArea{
                    id:save_text
                    y:0
                    width: 80
                    height: 20
                    color: "black"
                    padding:0
                    topPadding: 0
                    font.pixelSize: 15
                    background:Rectangle{
                        anchors.fill: parent
                        border.width: 1
                        border.color: "#80808080"
                    }
                    onTextChanged: {
                        if(text.length>8)
                            text=text.slice(0,8)
                        if(text=="") save_new.enabled=false
                        else{
                            var a=false
                            for(var i=0;i<groups.length;i++)
                                if(groups[i]==text)
                                {
                                    save_new.enabled=false
                                    a=true
                                    break
                                }
                            if(!a)
                                save_new.enabled=true
                        }
                    }

                }
                Cbutton{
                    x:80
                    width: 80
                    height: 20
                    text: "创建新组"
                    id:save_new
                    enabled: false
                    onClicked: {
                        enabled=false
                        $file.create(path+"/saves/"+save_text.text+"/")
                        $file.source=path+"/saves/"+save_text.text+"/.info"
                        $file.write(",")
                        groups.push(save_text.text)
                        groupsItems.push(createGroup.createObject(groups_it))
                        var i=groupsItems.length-1
                        groups_sv.contentHeight=groups_it.height=31*(i+1)*2
                        groupsItems[i].path=path+"/"+groups[i]
                        groupsItems[i].num=i
                        groupsItems[i].name=groups[i]
                        groupsItems[i].y=31*i
                        groupsItems[i].le=groups_sv.effectiveScrollBarWidth/2
                        groupsItems[i].per=win
                        items.push(createCItems.createObject(item_it))
                        items[i].visible=false
                    }
                }
                Cbutton{
                    x:160
                    width: 80
                    height: 20
                    text: "关闭全部"
                    onClicked: {
                        runClock.delAll()
                    }
                }
                Item{
                    y:20
                    Rectangle{
                        border.color: "#808080"
                        border.width: 1
                        width: 200
                        height: 350
                        ScrollView{
                            transformOrigin: Item.TopLeft
                            id:groups_sv
                            ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                            width: 400
                            height: 698
                            scale: 0.5
                            Rectangle{
                                transformOrigin: Item.TopLeft
                                id:groups_it
                                scale: 2
                                width: 200
                            }
                        }
                    }
                    Rectangle{
                        border.color: "#808080"
                        border.width: 1
                        width: 402
                        height: 350
                        x:200
                        id:item_it
                    }
                }
            }
        }
    }
}
