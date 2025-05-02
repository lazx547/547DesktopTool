import QtQuick
import QtQuick.Controls

Item {
    width: 320
    height: 340
    property int num:234567890
    property var objs:[]
    property var objectItems:[]
    property double lelen:23456789
    property string path:"1234567890-"
    property var objectItem:Qt.createComponent("./ObjectItem.qml")

    onPathChanged: {
        $file.source="./file/"+$ModuleErs[num].path.slice(2,$ModuleErs[num].path.length)+"/.info"
        var s=$file.read()
        title.text=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        title.text+=" "+s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        s=s.slice(s.indexOf(",")+1,s.length)
        s=s.slice(0,s.indexOf(","))=="true"?true:false
    }

    Text{
        id:title
        y:5
        font.pixelSize: 20
    }

    Rectangle{
        width: 323-lelen
        height: 30
        border.color: "#808080"
        y:30
        border.width: 1
        Cbutton{
            id:open
            text: "打开"
            width:60
            height: 30
            onClicked: {
                createnew(num)
            }
        }
        Cbutton{
            text: "全部关闭"
            width: 100
            x:140
            height: 30
            onClicked: {
                for(var i=0;i<objs.length;i++)
                {
                    objs[i].destroy()
                    objectItems[i].destroy()
                }
                objs=[]
                objectItems=[]
            }
        }

    }

    function createnew(n)
    {
        objs.push($modules[n].createObject())
        var a=objs.length-1,b=10000*Math.random()
        objs[a].thisn=a
        objs[a].thistype=n
        objs[a].path="./file/module/"+$modules_name[n]
        objs[a].thisnum=b
        objectItems.push(objectItem.createObject(moduleErItems))
        objectItems[a].le=moduleErItem_sv.effectiveScrollBarWidth
        objectItems[a].x=0
        objectItems[a].num=a
        objectItems[a].type=num
        objectItems[a]._text=b
        objectItems[a].y=31*a
        objectItems[a].visible=true
        moduleErItem_sv.contentHeight=62*a+62
    }

    function del(n){
        objs[n].destroy()
        for(var i=n;i<objs.length-1;i++)
        {
            objs[i]=objs[i+1]
            objs[i].thisn--
        }
        objs.pop()
        objectItems[n].destroy()
        for(i=n;i<objectItems.length-1;i++)
        {
            objectItems[i]=objectItems[i+1]
            objectItems[i].num--
            objectItems[i].y-=31
        }
        objectItems.pop()
    }

    ScrollView{
        id:moduleErItem_sv
        transformOrigin: Item.TopLeft
        width: (323-lelen)*2
        height: 620
        y:60
        scale:0.5
        ScrollBar.vertical.policy: ScrollBar.AlwaysOn
        Rectangle{
            transformOrigin: Item.TopLeft
            id:moduleErItems
            scale: 2
            width: (parent.width-moduleErItem_sv.effectiveScrollBarWidth)/2
        }
    }
}
