import QtQuick
import QtQuick.Controls
import QtQuick.Window
import GFile
import QtQuick.Dialogs
import QtQuick.Controls.Basic

GWindow {
    id: window
    flags: Qt.FramelessWindowHint|Qt.Window
    visible:false
    width: 584
    height: 334
    title: "547抽号器"
    image:"qrc:/images/rand.png"
    x:window.screen.width/2-width/2
    y:window.screen.height/2-height/2
    property int sumn:0//所抽的序号
    property int nummm: 1
    property int sim
    property int cclass:0
    property var a:[]//名单
    property var names:[]
    property var clas:[]
    property var num_xh:[]
    property var clas_name:[]//班级名称
    property var clas_objs:[]//班级选择对象
    property var obj:Qt.createComponent("./SourceItem.qml")

    onVisibleChanged: if(visible)  mesenge.show("已找到"+clas.length+"个班级"+",已选择\""+clas_name[cclass]+"\"",3000)
    onCclassChanged:
    {
        reEnable()
    }
    function reEnable(){
        if(num_xh[cclass]==-1)
        {
            mesenge2.show("已选择\""+clas_name[cclass]+"\""+",没有学号",3000)
            qb.checked=true
            qb.enabled=false
            xh.enabled=false
            mz.enabled=false
        }
        else
        {
            mesenge2.show("已选择\""+clas_name[cclass]+"\"",3000)
            qb.enabled=true
            xh.enabled=true
            mz.enabled=true
        }
    }
    Component.onCompleted:  {
        load()
    }
    function load(){
        file.source="./source/.ini"
        if(file.is("./source/.ini"))
        {
            file.source="./source/.ini"
            var s=file.read()
            var i=0,l=s.length,j=0,k,p
            do
            {
                p=s.slice(0,s.indexOf(","))
                clas.push(p)
                i=s.indexOf(",")+1
                s=s.slice(i,l)
            }
            while(i!=0)
            clas.pop()
            for(k=0;k<clas.length;k++)
            {
                file.source="./source/"+clas[k]+".ini"
                s=file.read()
                clas_name.push(s.slice(0,s.indexOf(",")))
                i=s.indexOf(",")+1
                s=s.slice(i,s.length)
                num_xh.push(s.slice(0,s.indexOf(",")))
                i=s.indexOf(",")+1
                s=s.slice(i,s.length)
                a.push([])
                do
                {
                    try{
                        a[k].push(s.slice(0,s.indexOf(",")))
                    }
                    catch(TypeError){
                        p=1
                        break
                    }
                    i=s.indexOf(",")+1
                    s=s.slice(i,s.length)
                }
                while(s.indexOf(",")!=-1)
                clas_objs.push(obj.createObject(clasItem))
                clas_objs[k].name=clas_name[k]
                clas_objs[k].per=window
                clas_objs[k].num=a[k].length
                clas_objs[k].y=k*41
                clas_objs[k].n=k
                clasItem_sv.contentHeight=82*(k+1)
            }
            mesenge.show("已找到"+k+"个班级"+",已选择\""+clas_name[cclass]+"\"",3000)
            reEnable()
        }
        else
        {
            mesenge.show("未找到文件",3000)
            c1.enabled=false
            cn.enabled=false
        }
    }
    function cou(n=0){
        var a=coul(n)
        if(xh.checked)
            a=a.slice(0,num_xh[cclass])
        else if(mz.checked)
            a=a.slice(num_xh[cclass],a.length)
        return a
    }
    function coul(n=0){
        var b;
        if(n===0){
            b=Math.floor(Math.random() * a[cclass].length)
            return a[cclass][b]
        }
        else{

            b=Math.floor(Math.random() * names.length)
            var s=names[b]
            for(var i=b;i<names.length-1;i++)
            {
                names[i]=names[i+1]
            }
            names.pop()
            return s
        }
    }
    GWindow {
        id: win_s
        flags: Qt.FramelessWindowHint|Qt.Window
        visible:false
        width: 304
        height: 334
        title: window.title+">设置"
        image:"qrc:/images/rand.png"
        GMesenger{
            id:mesenge2
            z:46578
            width: parent.width-20
            x:20
            y:20
            onFocusChanged: {
                if(!mesenge2.focus)
                    mesenge2.enabled=false
            }
        }
        Item{
            y:20
            x:2
            ScrollView{
                id:clasItem_sv
                transformOrigin: Item.TopLeft
                width: 600
                height: 620
                scale:0.5
                ScrollBar.vertical.policy: ScrollBar.AlwaysOn
                Rectangle{
                    transformOrigin: Item.TopLeft
                    id:clasItem
                    scale: 2
                    width: 300
                }
            }
        }
    }
    GMesenger{
        id:mesenge
        z:46578
        width: parent.width-40
        x:20
        y:20
        onFocusChanged: {
            if(!mesenge.focus)
                mesenge.enabled=false
        }
    }
    GFile{
        id:file
        function save(){
            source=getDesktop()+"/547output"+ Qt.formatDateTime(new Date(), "yy-mm-dd-hh-mm-ss")+".txt"
            write(output.text)
            mesenge.show("已导出到"+source,5000)
        }
    }
    Cbutton{
        x:window.width-80
        width: 50
        height: 20
        text: "设置"
        font.pixelSize: 15
        colorBg: "#00000000"
        colorBorder: "#00000000"
        padding: 0
        topPadding: 0
        onClicked: {
            if(!win_s.visible)
            {
                win_s.x=window.x+window.width
                win_s.y=window.y
            }

            win_s.visible=true
        }
    }
    Rectangle{
        x:10
        y:40
        width: 330
        height: 280
        color: "#E8E8E8"
        ScrollView {
            id:output__
            anchors.fill: parent
            TextEdit {
                x:(output__.parent.width-width)/2
                width: contentWidth
                id:output
                text: ""
                horizontalAlignment: Text.Center
                font.pixelSize: 30
                color: "black"
                onFocusChanged: mesenge.enabled=false
            }
            ScrollBar.vertical: ScrollBar {
                id:output_
                height: parent.height
                policy: output__.contentHeight>output__.height?ScrollBar.AlwaysOn:ScrollBar.AlwaysOff
                x:parent.width-output_.width
            }
        }
    }
    Item{
        x:350
        y:48
        width: 280
        height: 80
        MouseArea{
            anchors.fill: parent
            z:-1
            onClicked: mesenge.enabled=false
        }
        Cbutton{
            id:c1
            x:0
            y:0
            width: 100
            height: 30
            text: "抽一次"
            font.pixelSize: 20
            onClicked: {
                sumn++
                output.text+=(sumn==1?"":"\n")+"["+sumn+"]"+cou()
                if(output__.contentHeight>output__.height)output_.position=(output__.contentHeight-output__.height)/output__.contentHeight
            }
        }
        Cbutton{
            id:cn
            x:120
            y:0
            width: 100
            height: 30
            text: "抽n次"
            font.pixelSize: 20
            onClicked: {
                if(n.value>0)
                {
                    var i=0
                    for(i=0;i<names.length;i++)
                        names.pop()
                    for(i=0;i<a[cclass].length;i++)
                        names.push(a[cclass][i])
                    if(n.value<=names.length)
                    {
                        n.enabled=false
                        for(i=0;i<n.value;i++)
                        {
                            sumn++
                            output.text+=(sumn==1?"":"\n")+"["+sumn+"]"+cou()
                        }
                        n.enabled=true
                        if(output__.contentHeight>output__.height)output_.position=(output__.contentHeight-output__.height)/output__.contentHeight
                    }
                    else
                        mesenge.show("n不能大于班级总人数",3000)
                }
            }
        }
        Text{
            y:40
            font.pixelSize: 20
            text:"n="
        }

        CscrollBar{
            id:n
            y:45
            x:30
            text_width: 0
            height: 20
            maxValue: 50
            Component.onCompleted: setValue(1)
            width: 190
        }
        Cbutton{
            x:0
            y:80
            width: 100
            height:30
            text: "清除"
            font.pixelSize: 20
            onClicked: {
                output.text=""
                sumn=0
            }
        }
        Cbutton{
            x:120
            y:80
            width: 100
            height:30
            text: "导出"
            font.pixelSize: 20
            onClicked: file.save()
        }
        Rectangle{
            x:0
            y:130
            width: parent.width-60
            height: 100
            border.color: "#80808080"
            color: "#00000000"
            CCheckBox{
                id:qb
                width: parent.width-20
                height: 25
                x:10
                y:5
                text: "显示学号和名字"
                font.pixelSize:15
                checkable: false
                checked: true
                onClicked: checked=!checked
                onCheckedChanged: {
                    if(checked)
                    {
                        xh.checked=false
                        mz.checked=false
                    }
                }
            }
            CCheckBox{
                id:xh
                width: parent.width-20
                height: 25
                x:10
                y:35
                text: "只显示学号"
                font.pixelSize: 15
                checkable: false
                onClicked: checked=!checked
                onCheckedChanged: {
                    if(checked)
                    {
                        qb.checked=false
                        mz.checked=false
                    }
                }
            }
            CCheckBox{
                id:mz
                width: parent.width-20
                height: 25
                x:10
                y:65
                text: "只显示名字"
                font.pixelSize: 15
                checkable: false
                onClicked: checked=!checked
                onCheckedChanged: {
                    if(checked)
                    {
                        xh.checked=false
                        qb.checked=false
                    }
                }
            }
        }

    }
}
