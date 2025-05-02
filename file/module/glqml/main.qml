import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Window 2.12
import GFile 1.2

Window {

    property int  w: 0;
    property int  a: 0;
    property int  s: 0;
    property int  d: 0;
    property int  q: 0;
    property int  e: 0;
    property int  r: 0;
    property int  sp:0;
    property int  ts: 0;
    property var bos:[30];
    property int issh: 0
    property int num:0;
    property string last:"w"
    property string llst:"q"
    property real v1: 12
    property int tttt:0
    property string file_q_source
    id:winn

    property int thisn
    property int thistype
    property string path
    property int thisnum
    //width: 1200
    //height: 700

    visible: true;
    title: qsTr("Green Game");
    Component.onCompleted: {
        if(Qt.platform.os=="windows")
        {
            winn.visibility=Window.FullScreen
            item_bu.visible=false
            bss.source="./i/but/noo.png"
        }
        else
        {
            bss.source="./i/but/yes.png"
            item_bu.visible=true
            winn.orientationUpdateMask=Screen.Landscape
        }
        file_q_source="C:/Users/"+file_q.getUser()+"/AppData/Local/Green_Game_m"
        file_q.create(file_q_source)
        file_q.source=file_q_source+"/game.ff"
        if(file_q.is(file_q.source))
        {

            file_q.source=file_q_source+"/x.ff"
            item2_back.x=Number(file_q.read())
            file_q.source=file_q_source+"/y.ff"
            item2_back.y=Number(file_q.read())
            file_q.source=file_q_source+"/1.ff"
            tank.rotation=Number(file_q.read())
            file_q.source=file_q_source+"/2.ff"
            tank_top.rotation=Number(file_q.read())
            console.log("1")
        }
        else
        {
            file_q.write("1145134253647854736278457432898")
            file_q.source=file_q_source+"/x.ff"
            file_q.write("0")
            file_q.source=file_q_source+"/y.ff"
            file_q.write("0")
            file_q.source=file_q_source+"/1.ff"
            file_q.write("0")
            file_q.source=file_q_source+"/2.ff"
            file_q.write("0")
        }
    }
    GFile{
        id:file_q
    }

    //背景
    Image {
        width: winn.width
        height: winn.height
        visible:true
        source:"./i/back.png"
    }
    //创造炮弹
    function creata_b(){
        //本体
        var image = Qt.createQmlObject("import QtQuick 2.12; Image { source: './i/a_b.png'; width: 9; height: 14.5}", item2_back);
        image.x = tank.x+(tank.width+image.width)/3.0+3-item2_back.x
        image.y =tank.y+(tank.height+image.height)/3.0+2-item2_back.y
        image.rotation=(tank.rotation+tank_top.rotation)%360
        var ree=(image.rotation-90)*Math.PI/180.0
        image.x+=Math.cos(ree) * 60;
        image.y+=Math.sin(ree) * 60
        //计时器
        var timer = Qt.createQmlObject("import QtQuick 2.12; Timer {property real tt:15}", image);
        timer.repeat = true;
        timer.interval = 16;

        timer.triggered.connect(function()
        {
            if(timer.tt<=0.3)
            {
                creatpop(image.x,image.y,image,item2_back)
                creatbol(image.x,image.y,item2_back);
                timer.stop();
                image.visible=false;
                image.destroy();
            }
            else
            {
                timer.tt-=0.25;
                var re=(image.rotation-90)*Math.PI/180.0
                image.x += Math.cos(re) * timer.tt;
                image.y += Math.sin(re) * timer.tt;
                //超出范围删除
                if (image.x > 2000 )
                {
                    timer.stop();
                    image.destroy();
                }
                else if ( image.y > 1400)
                {
                    timer.stop();
                    image.destroy();
                }
                else if( image.x<0 )
                {
                    timer.stop();
                    image.destroy();
                }
                else if(image.y<0)
                {
                    timer.stop();
                    image.destroy();
                }
            }
        });
        timer.start();
        tit.start()
        issh=1
        fit.ty=1
    }

    //创造单个子弹
    function creatpr(v){
        var image = Qt.createQmlObject("import QtQuick 2.12; Image { source: './i/pr2.png'; width: 5; height: 12}", item2_back);
        image.x = tank.x+(tank.width+image.width)/3.0+3-item2_back.x
        image.y =tank.y+(tank.height+image.height)/3.0+2-item2_back.y
        image.rotation=(tank.rotation+tank_top.rotation)%360
        var ree=(image.rotation-90)*Math.PI/180.0
        image.x+=Math.cos(ree) * 60;
        image.y+=Math.sin(ree) * 60;
        var timer = Qt.createQmlObject("import QtQuick 2.12; Timer {property real tt:"+v+"}", image);
        timer.interval = 16;
        timer.repeat = true;
        timer.triggered.connect(function()
        {
            if(timer.tt<=0.3)
            {
                creatbol2(image.x,image.y);
                timer.stop();
                image.visible=false;
                image.destroy();
            }
            else
            {
                timer.tt-=0.25;
                var re=(image.rotation-90)*Math.PI/180.0
                image.x += Math.cos(re) * timer.tt;
                image.y += Math.sin(re) * timer.tt;
                if (image.x > 2000 )
                {
                    timer.stop();
                    image.destroy();
                }
                else if ( image.y > 1400)
                {
                    timer.stop();
                    image.destroy();
                }
                else if( image.x<0 )
                {
                    timer.stop();
                    image.destroy();
                }
                else if(image.y<0)
                {
                    timer.stop();
                    image.destroy();
                }
            }
        });
        timer.start();
        issh=1
        fit.ty=1
    }

    //创造子弹
    function creatprs(){
        creatpr(12)
        v1-=0.25
        tit2.start()
        var t1 = Qt.createQmlObject("import QtQuick 2.12; Timer {}",winn);
        t1.interval = 200;
        t1.repeat = false;
        t1.triggered.connect(function(){
            creatpr(v1)
            v1-=0.25
            var t1 = Qt.createQmlObject("import QtQuick 2.12; Timer {}",winn);
            t1.interval = 200;
            t1.repeat = false;
            t1.triggered.connect(function(){
                creatpr(v1)
                v1-=0.25
                var t1 = Qt.createQmlObject("import QtQuick 2.12; Timer {}",winn);
                t1.interval = 200;
                t1.repeat = false;
                t1.triggered.connect(function(){
                    creatpr(v1)
                    v1-=0.25
                    var t1 = Qt.createQmlObject("import QtQuick 2.12; Timer {}",winn);
                    t1.interval = 200;
                    t1.repeat = false;
                    t1.triggered.connect(function(){
                        creatpr(v1)
                        v1-=0.25
                        var t1 = Qt.createQmlObject("import QtQuick 2.12; Timer {}",winn);
                        t1.interval = 200;
                        t1.repeat = false;
                        t1.triggered.connect(function(){
                            creatpr(v1)
                            v1-=0.25
                            var t1 = Qt.createQmlObject("import QtQuick 2.12; Timer {}",winn);
                            t1.interval = 200;
                            t1.repeat = false;
                            t1.triggered.connect(function(){
                                creatpr(v1)
                                v1-=0.25
                                var t1 = Qt.createQmlObject("import QtQuick 2.12; Timer {}",winn);
                                t1.interval = 200;
                                t1.repeat = false;
                                t1.triggered.connect(function(){
                                    creatpr(v1)
                                    v1-=0.25
                                    var t1 = Qt.createQmlObject("import QtQuick 2.12; Timer {}",winn);
                                    t1.interval = 200;
                                    t1.repeat = false;
                                    t1.triggered.connect(function(){
                                        creatpr(v1)
                                        v1-=0.25
                                        var t1 = Qt.createQmlObject("import QtQuick 2.12; Timer {}",winn);
                                        t1.interval = 200;
                                        t1.repeat = false;
                                        t1.triggered.connect(function(){
                                            creatpr(v1)
                                            v1-=0.25
                                            var t1 = Qt.createQmlObject("import QtQuick 2.12; Timer {}",winn);
                                            t1.interval = 200;
                                            t1.repeat = false;
                                            t1.triggered.connect(function(){
                                                creatpr(v1)
                                                v1-=0.25
                                                var t1 = Qt.createQmlObject("import QtQuick 2.12; Timer {}",winn);
                                                t1.interval = 200;
                                                t1.repeat = false;
                                                t1.triggered.connect(function(){
                                                    creatpr(v1)
                                                    v1-=0.25
                                                    var t1 = Qt.createQmlObject("import QtQuick 2.12; Timer {}",winn);
                                                    t1.interval = 200;
                                                    t1.repeat = false;
                                                    t1.triggered.connect(function(){
                                                        creatpr(v1)
                                                        v1-=0.25
                                                        var t1 = Qt.createQmlObject("import QtQuick 2.12; Timer {}",winn);
                                                        t1.interval = 200;
                                                        t1.repeat = false;
                                                        t1.triggered.connect(function(){
                                                            creatpr(v1)
                                                            v1-=0.25
                                                            var t1 = Qt.createQmlObject("import QtQuick 2.12; Timer {}",winn);
                                                            t1.interval = 200;
                                                            t1.repeat = false;
                                                            t1.triggered.connect(function(){
                                                                creatpr(v1)
                                                                v1-=0.25
                                                                var t1 = Qt.createQmlObject("import QtQuick 2.12; Timer {}",winn);
                                                                t1.interval = 200;
                                                                t1.repeat = false;
                                                                t1.triggered.connect(function(){
                                                                    creatpr(v1)
                                                                    v1=12
                                                                })
                                                                t1.start()
                                                            })
                                                            t1.start()
                                                        })
                                                        t1.start()
                                                    })
                                                    t1.start()
                                                })
                                                t1.start()
                                            })
                                            t1.start()
                                        })
                                        t1.start()
                                    })
                                    t1.start()
                                })
                                t1.start()
                            })
                            t1.start()
                        })
                        t1.start()
                    })
                    t1.start()
                })
                t1.start()
            })
            t1.start()
        })
        t1.start()
    }

    //创造爆炸特效 大型
    function creatbol(x,y,ptr){
        var image = Qt.createQmlObject("import QtQuick 2.12; Image { source: './i/explo1/1.png'; width: 50; height: 50}", ptr);
        image.x = x-20.5
        image.y = y-17.75
        image.rotation=0
        var timer = Qt.createQmlObject("import QtQuick 2.12; Timer {property int tt:1}", image);
        timer.interval = 40;
        timer.repeat = true;
        timer.triggered.connect(function()
        {
            timer.tt++
            switch(timer.tt)
            {
            case 2:
                image.source="./i/explo1/2.png";
                break
            case 3:
                image.source="./i/explo1/3.png";
                break
            case 4:
                image.source="./i/explo1/4.png";
                break
            case 5:
                image.source="./i/explo1/5.png";
                break
            case 6:
                image.source="./i/explo1/6.png";
                break
            case 7:
                image.source="./i/explo1/7.png";
                break
            case 8:
                image.source="./i/explo1/8.png";
                break
            case 9:
                image.source="./i/explo1/9.png";
                break
            case 10:
                image.source="./i/explo1/10.png";
                break
            case 11:
                image.source="./i/explo1/11.png";
                break
            case 12:
                image.source="./i/explo1/12.png";
                break
            case 13:
                image.source="./i/explo1/13.png";
                break
            default:
                timer.stop();
                image.destroy()
            }
        });
        timer.start();
    }

    //创造爆炸特效 小型
    function creatbol2(x,y){
        var image = Qt.createQmlObject("import QtQuick 2.12; Image { source: './i/explo1/e1.png'; width: 30; height: 30}", item2_back);
        image.x = x-12.5
        image.y = y-9
        image.rotation=0
        var timer = Qt.createQmlObject("import QtQuick 2.12; Timer {property int tt:1}", image);
        timer.interval = 40;
        timer.repeat = true;
        timer.triggered.connect(function()
        {
            timer.tt++
            switch(timer.tt)
            {
            case 2:
                image.source="./i/explo1/e2.png";
                break
            case 3:
                image.source="./i/explo1/e3.png";
                break
            case 4:
                image.source="./i/explo1/e4.png";
                break
            case 5:
                image.source="./i/explo1/e5.png";
                break
            case 6:
                image.source="./i/explo1/e6.png";
                break
            case 7:
                image.source="./i/explo1/e7.png";
                break
            case 8:
                image.source="./i/explo1/e8.png";
                break
            case 9:
                image.source="./i/explo1/e9.png";
                break
            case 10:
                image.source="./i/explo1/e91.png";
                break
            case 11:
                image.source="./i/explo1/e92.png";
                break
            case 12:
                image.source="./i/explo1/e93.png";
                break
            case 13:
                image.source="./i/explo1/e94.png";
                break
            default:
                timer.stop();
                image.destroy()
            }
        });
        timer.start();
    }

    //创造冲击波
    function creatpop(x,y,ptr1,ptr2){
        var image = Qt.createQmlObject("import QtQuick 2.12; Image { source: './i/shoge.png'; width: 10; height: 10}", ptr2);
        image.x = x+(ptr1.width-10)/2
        image.y = y+(ptr1.height-10)/2
        image.rotation=0
        image.opacity=1
        var timer = Qt.createQmlObject("import QtQuick 2.12; Timer {property real tt:10;property real tii:5}", image);
        timer.interval = 40;
        timer.repeat = true;
        timer.triggered.connect(function()
        {
            timer.tii-=0.25
            timer.tt+=5
            image.width=timer.tt
            image.height=timer.tt
            image.opacity=1-(timer.tt-10)/90
            image.x-=2.5
            image.y-=2.5
            if(timer.tt>=100)
            {
                image.visible=false
                timer.stop()
            }
        });
                timer.start();
    }

    //控制事件
    Timer {
        function mant(){
            if(tank.source=="./i/artillery1.png")
                tank.source="./i/artillery2.png"
            else
                tank.source="./i/artillery1.png"
        }

        function ifw(){
            var ra= (tank.rotation-90)*Math.PI/180;
            var a=item2_back.x-Math.cos(ra) * 1;
            if(a<=tank.x && a>=(tank.x-2000+tank.width*Math.cos(ra)))
                item2_back.x=a
            a=item2_back.y-Math.sin(ra) * 1;
            if(a<=tank.y && a>=(tank.y-1400+Math.sin(ra) * tank.height))
                item2_back.y=a
        }
        function ifs(){
            var ra= (tank.rotation-90)*Math.PI/180;
            var a=item2_back.x+Math.cos(ra) * 0.6;
            if(a<=tank.x && a>=(tank.x-2000+tank.width*Math.cos(ra)))
                item2_back.x=a
            a=item2_back.y+Math.sin(ra) * 0.6;
            if(a<=tank.y && a>=(tank.y-1400+Math.sin(ra) * tank.height))
                item2_back.y=a
        }
        function ifa(){
                 tank.rotation-=0.5;
        }
        function ifd(){
                tank.rotation+=0.5;
        }
        id: timer;
        interval: 20;
        repeat: true;
        running:false;
        onTriggered:{
            var ra= (tank.rotation-90)*Math.PI/180;
            //坦克移动，转向
            if(last=="w"){
                if(w==1 && s==1 && a==0 && d==0)
                {
                    tttt++
                    mant()
                    last="w"
                    ifs()
                }
                else if(w==1 && ( a==1 || d==1 ) && s==0)
                {
                    tttt++
                    mant()
                    last="w"
                    ifw()
                    if(a==1)
                        ifa()
                    else
                        ifd()
                }
                else if(w==1)
                {
                    tttt++
                    mant()
                    last="w"
                    ifw()
                }
                else if(s==1)
                {
                    tttt++
                    mant()
                    last="s"
                    ifs()
                }
                else if(a==1)
                {
                    tttt++
                    mant()
                    last="a"
                    ifa()
                }
                else if(d==1)
                {
                    tttt++
                    mant()
                    last="d"
                    ifd()
                }
            }
            else if(last=="s"){
                if(s==1 && w==1 && a==0 && d==0)
                {
                    tttt++
                    mant()
                    last="s"
                    ifw()
                }
                else if(s==1 && ( a==1 || d==1 ) && w==0)
                {
                    tttt++
                    mant()
                    ifs()
                    last="s"
                    if(a==1)
                        ifa()
                    else
                        ifd()
                }
                else if(w==1)
                {
                    tttt++
                    mant()
                    last="w"
                    ifw()
                }
                else if(s==1)
                {
                    tttt++
                    mant()
                    last="s"
                    ifs()
                }
                else if(a==1)
                {
                    tttt++
                    mant()
                    last="a"
                    ifa()
                }
                else if(d==1)
                {
                    tttt++
                    mant()
                    last="d"
                    ifd()
                }
            }
            else if(last=="a"){
                if(a==1 && d==1 && w==0 && s==0)
                {
                    tttt++
                    mant()
                    last="a"
                    ifd()
                }
                else if(a==1 && ( w==1 || s==1 ) && d==0)
                {
                    tttt++
                    mant()
                    ifa()
                    last="a"
                    if(w==1)
                        ifw()
                    else
                        ifs()
                }
                else if(w==1)
                {
                    tttt++
                    mant()
                    last="w"
                    ifw()
                }
                else if(s==1)
                {
                    tttt++
                    mant()
                    last="s"
                    ifs()
                }
                else if(a==1)
                {
                    tttt++
                    mant()
                    last="a"
                    ifa()
                }
                else if(d==1)
                {
                    tttt++
                    mant()
                    last="d"
                    ifd()
                }
            }
            else if(last=="d"){
                if(d==1 && a==1 && w==0 && s==0)
                {
                    tttt++
                    mant()
                    last="d"
                    ifa()
                }
                else if(d==1 && ( w==1 || s==1 ) && a==0)
                {
                    tttt++
                    mant()
                    ifd()
                    last="d"
                    if(w==1)
                        ifw()
                    else
                        ifs()
                }
                else if(w==1)
                {
                    tttt++
                    mant()
                    last="w"
                    ifw()
                }
                else if(s==1)
                {
                    tttt++
                    mant()
                    last="s"
                    ifs()
                }
                else if(a==1)
                {
                    tttt++
                    mant()
                    last="a"
                    ifa()
                }
                else if(d==1)
                {
                    tttt++
                    mant()
                    last="d"
                    ifd()
                }
            }
            if(w==0 && s==0)
            {
                ba.source="./i/but/left.svg"
                bd.source="./i/but/right.svg"
            }
            if(a==0 && d==0)
            {
                bw.source="./i/but/front.svg"
                bs.source="./i/but/behi.svg"
            }
            //切换弹药类型
            if(r==1)
            {
                r=0
                if(br.iss==0)
                {
                    br.iss=1
                    br.source="./i/but/bilbil.svg"
                }
                else
                {
                    br.iss=0
                    br.source="./i/but/tobol.svg"
                }
            }
            //炮塔转向
            if(issh==0)
            {
                if(llst=="q")
                {
                    if(q==1 && e==1)
                    {
                        tank_top.rotation+=0.4
                        llst="q"
                    }
                    else if(q==1)
                    {
                        tank_top.rotation-=0.4
                        llst="q"
                    }
                    else if(e==1)
                    {
                        tank_top.rotation+=0.4
                        llst="e"
                    }
                }
                else  if(llst=="e")
                {
                    if(q==1 && e==1)
                    {
                        tank_top.rotation-=0.4
                        llst="e"
                    }
                    else if(q==1)
                    {
                        tank_top.rotation-=0.4
                        llst="q"
                    }
                    else if(e==1)
                    {
                        tank_top.rotation+=0.4
                        llst="e"
                    }
                }
            }
            else
            {
                q==0
                e==0
            }
            //射击 space
            if(ts>0)
            {
                ts--;
                tex.text=qsTr("装弹："+ts+"ms")
            }
            else if(sp==1)
            {
                sp=0;
                bsp.source="./i/but/space2.svg"
                bq.source="./i/but/left2_n.svg"
                be.source="./i/but/right2_n.svg"
                if(br.iss==0)
                {
                    ts=150;
                    creata_b()
                }
                else
                {
                    ts=200
                    creatprs()
                }
            }
            else
            {
                bsp.iss=0
                bsp.source="./i/but/space.svg"
            }
            file_q.source=file_q_source+"/x.ff"
            file_q.write(item2_back.x.toString())
            file_q.source=file_q_source+"/y.ff"
            file_q.write(item2_back.y.toString())
            file_q.source=file_q_source+"/1.ff"
            file_q.write(tank.rotation.toString())
            file_q.source=file_q_source+"/2.ff"
            file_q.write(tank_top.rotation.toString())
        }
    }

    //单位选择视图
    Item {
        id:item_ch
        width: winn.width
        height:winn.height
        x:0
        y:0
        visible: false
        property int type_ch:1
        Image {
            id:ch_tank
            source: "./i/artillery1.png"
            width: 58
            height: 76
            x:(winn.width-width)/2
            y:(winn.height-height)/2
            Image {
                id: ch_tank_top
                width: 26;
                height: 130;
                x: 16
                y:-25
                source: "./i/artillery_turret.png"
            }
        }
        //上一个
        Image {
            id:ch_last
            width: 80
            height:400
            x:0
            y:(winn.height-400)/2
            source: "./i/but/ch_last.svg"
        }
        //下一个
        Image {
            id: ch_next
            width: 80
            height:400
            x:winn.width-80
            y:(winn.height-400)/2
            source: "./i/but/ch_next.svg"
        }
        //开始按钮
        Image {
            id: ch_done
            x:winn.width-width-10
            y:winn.height-height-10
            source: "./i/but/start.svg"
            MouseArea {
                anchors.fill: parent;
                z: 1
                onClicked: {
                    wclick(ch_done,function(){
                        cet.startl(1,function(){
                            item_ch.visible=false;
                            item2.visible=true;})
                        timer.start()
                        item2.forceActiveFocus()
                        timer.running=true;
                    })
                }
                onEntered: {
                }
            }
        }
        //返回
        Image {
            id: ch_exit
            x:10
            y:winn.height-height-10
            source: "./i/but/mune.svg"
            MouseArea {
                anchors.fill: parent;
                z: 1
                onClicked: {
                    wclick(ch_exit,function(){
                        cet.startl(1,function(){
                            item_ch.visible=false;
                            item1.visible=true;})
                        item1.forceActiveFocus()
                    })
                }
            }
        }
    }
    //开始视图
    Item {
        id: item1
        visible: true;
        x: 0
        y: 0
        width: winn.width
        height: winn.height
        //标题
        Image {
            id:titlle;
            width: 650
            visible: true
            source: "./i/titlle.png"
            anchors.verticalCenterOffset: -124
            anchors.horizontalCenterOffset: 0
            anchors.centerIn:item1;
        }
        //开始按钮
        Image {
            id:start_bu_q
            y: (winn.height-height)/2
            visible: true;
            source: "./i/but/start.svg"
            anchors.centerIn: item1;
            MouseArea {
                anchors.fill: parent;
                z: 1
                onClicked: {
                    wclick(start_bu_q,function(){
                        cet.startl(1,function(){
                            item1.visible=false;
                            item_ch.visible=true;})
                        timer.start()
                        item2.forceActiveFocus()
                        timer.running=true;
                    })

                }
            }
        }
        //退出按钮
        Image {
            id: exit_q
            source: "./i/but/exit.svg"
            x:(winn.width-width)/2
            y:setting.y+75
            MouseArea {
                anchors.fill: parent;
                z: 1
                onClicked: {
                    wclick(exit_q,function(){
                    $moduleControl.exit(thisn,thistype)
                    })
                }
            }
        }
        //设置按钮
        Image {
            id: setting
            source: "./i/but/setting.svg"
            x:(winn.width-width)/2
            y:start_bu_q.y+75
            MouseArea {
                anchors.fill: parent;
                z: 1
                onClicked: {
                    wclick(setting,function(){
                        item3.visible=true
                    })

                }
            }
        }
    }

    //游戏视图
    Item {
        id:item2;
        visible: false;
        anchors.fill: parent
        rotation: 0
        focus: true;
        //背景
        Item {
            id: item2_back
            x:0
            y:0
            visible: true
            width: 2000
            height: 1400;
            Image {
                width: 2000
                height: 1400;
                source: "./i/playing.png"
            }
        }

        //坦克
        Image {
            id:tank;
            x: 471
            y: 312
            width: 58;
            height: 76;
            rotation: 0;
            source: "./i/artillery1.png";
            //坦克炮管
            Image {
                id: tank_top
                width: 26;
                height: 130;
                rotation: 0;
                x: 16
                y:-25
                source: "./i/artillery_turret.png"
                //炮管后移
                Timer {
                    id:tit
                    interval : 40;
                    repeat : true;
                    property int ii:0
                    property real di:0
                    onTriggered:{
                        //console.log("st")
                        var re=(tank_top.rotation-90)*Math.PI/180.0;
                        switch(ii){
                        case 0:
                            issh=1
                            di=-1.5
                            break
                        case 1:
                        case 2:
                        case 3:
                        case 4:
                            di=-1.5
                            break
                        case 5:
                        case 6:
                        case 7:
                        case 8:
                        case 9:
                        case 10:
                        case 11:
                        case 12:
                        case 13:
                        case 14:
                        case 15:
                        case 16:
                        case 17:
                        case 18:
                            di=0.5
                            break
                        default:
                            bq.source="./i/but/left2.svg"
                            be.source="./i/but/right2.svg"
                            bsp
                            di=0.5
                            ii=0
                            tit.stop()
                            issh=0
                            break
                        }
                        tank_top.x+=Math.cos(re) * di
                        tank_top.y+=Math.sin(re) * di
                        ii++
                    }
                }
                Timer {
                    id:tit2
                    interval : 40;
                    repeat : true;
                    property int ii:0
                    property int i2:0
                    property real di:0
                    onTriggered:{
                        //console.log("ii"+ii+"i2"+i2)
                        var re=(tank_top.rotation-90)*Math.PI/180.0;
                        switch(ii){
                        case 0:
                            issh=1
                            di=-0.1
                            break
                        case 1:
                        case 2:
                        case 3:
                            di=-0.1
                            break
                        case 4:
                            di=0
                            if(i2<15)
                            {
                                ii=-1
                                i2++
                            }
                            break
                        case 5:
                        case 6:
                        case 7:
                        case 8:
                        case 9:
                        case 10:
                        case 11:
                        case 12:
                        case 13:
                        case 14:
                        case 15:
                        case 16:
                        case 17:
                        case 18:
                            di=0.5
                            break
                        default:
                            bq.source="./i/but/left2.svg"
                            be.source="./i/but/right2.svg"
                            bsp
                            di=0
                            ii=0
                            tank_top.x=16
                            tank_top.y=-25
                            tit2.stop()
                            issh=0
                            i2=0
                            break
                        }
                        tank_top.x+=Math.cos(re) * di
                        tank_top.y+=Math.sin(re) * di
                        ii++
                    }
                }
            }
            //炮口火花
            Image {
                id:fir
                width: 18
                height: 30
                source:"./i/explo1/f1.png"
                Timer {
                    id:fit
                    interval:30
                    repeat:true
                    running:true
                    property int ty:0
                    onTriggered:{
                        fir.rotation=tank_top.rotation
                        var re=(fir.rotation-90)*Math.PI/180.0
                        fir.x=(tank.width-fir.width)/2+2+Math.cos(re)*75
                        fir.y=(tank.height-fir.height)/2+Math.sin(re)*75
                        switch(fit.ty)
                        {
                        case 1:
                        case 2:
                        case 3:
                        case 4:
                            fit.ty++
                            break
                        case 5:
                            fit.ty=6
                            fir.visible=true
                            fir.source="./i/explo1/f1.png"
                            break
                        case 6:
                            fit.ty=7
                            fir.source="./i/explo1/f2.png"
                            break
                        case 7:
                            fit.ty=8
                            fir.source="./i/explo1/f3.png"
                            break
                        case 8:
                            fit.ty=9
                            fir.source="./i/explo1/f4.png"
                            break
                        default:
                            fit.ty=0
                            fir.visible=false
                        }
                    }
                }
            }
        }
        //装弹进度
        Image {
            x:70
            y:10
            width: 180
            height: 50
            source: "./i/tt.png"
            Text {
                        id: tex
                        text: qsTr("装弹：0s")
                        anchors.centerIn: parent
                        font.pixelSize:30
                    }
            }

        //炮弹类型图标兼切换按钮
        Image {
            id:br
            width:84
            height: 59
            x:winn.width-90
            y:10
            source:"./i/but/tobol.svg"
            visible: true
            property int iss:0
            MouseArea {
                anchors.fill: parent;
                z: 1
                onPressed: {
                    r=1
                }
            }
        }
        //设置按钮
        Image {
            id: pece
            source: "./i/but/pause.png"
            x:10
            y:10
            width: 50
            height: 50
            MouseArea {
                anchors.fill: parent;
                z: 2
                onClicked: {
                    item3.visible=true
                    item3.forceActiveFocus()
                    exit_q2.visible=true
                    menu.visible=true
                }
            }
        }
        //键盘事件
        Keys.onPressed:{
            if(event.key===Qt.Key_A)
                a=1;
            else if(event.key===Qt.Key_D)
                d=1;
            else if(event.key===Qt.Key_W)
                w=1;
            else if(event.key===Qt.Key_S)
                s=1;
            else if(event.key===Qt.Key_Q)
                q=1;
            else if(event.key===Qt.Key_E)
                e=1;
            else if(event.key===Qt.Key_Space)
                sp=1;
            else if(event.key===Qt.Key_R)
                r=1
            else if(event.key===Qt.Key_Escape)
            {
                item3.visible=true
                item3.forceActiveFocus()
                exit_q2.visible=true
                timer.stop()
                menu.visible=true
                a=d=w=s=q=e=sp=0
            }
        }
        Keys.onReleased: {
            if(event.key===Qt.Key_A)
                a=0;
            else if(event.key===Qt.Key_D)
                d=0;
            else if(event.key===Qt.Key_W)
                w=0;
            else if(event.key===Qt.Key_S)
                s=0;
            else if(event.key===Qt.Key_Q)
                q=0;
            else if(event.key===Qt.Key_E)
                e=0;
            else if(event.key===Qt.Key_Space)
                sp=0
        }
        //按钮
        Item {
            id:item_bu
            x:0
            y:0
            visible: true
            width: 1000
            height: 700
            Image {
                id:bw
                width: 62
                height: 74
                x:100
                y:winn.height-180
                source: "./i/but/front.svg"
                visible: true
                MouseArea {
                    anchors.fill: parent;
                    z: 1
                    Timer {
                        interval : 40;
                        repeat : true;
                    }
                    onPressed: {
                        var a=bw
                        a.width=53
                        a.height=60
                        a.x+=4.4
                        a.y+=7
                        w=1
                    }
                    onReleased: {
                        var a=bw
                        a.width=62
                        a.height=74
                        a.x-=4.4
                        a.y-=7
                        w=0
                    }
                }
            }
            Image {
                id:ba
                width: 74
                height: 62
                x:10
                y:winn.height-86
                source: "./i/but/left.svg"
                visible: true
                MouseArea {
                    anchors.fill: parent;
                    z: 1
                    onPressed: {
                        var ai=ba
                        ai.width=60
                        ai.height=53
                        ai.x+=7
                        ai.y+=4.4
                        a=1
                    }
                    onReleased: {
                        var ai=ba
                        ai.width=74
                        ai.height=62
                        ai.x-=7
                        ai.y-=4.4
                        a=0
                    }
                }
            }
            Image {
                id:bs
                width: 62
                height: 74
                x:100
                y:winn.height-84
                source: "./i/but/behi.svg"
                visible: true
                MouseArea {
                    anchors.fill: parent;
                    z: 1
                    onPressed: {
                        var a=bs
                        a.width=53
                        a.height=60
                        a.x+=4.4
                        a.y+=7
                        s=1
                    }
                    onReleased: {
                        var a=bs
                        a.width=62
                        a.height=74
                        a.x-=4.4
                        a.y-=7
                        s=0
                    }
                }
            }
            Image {
                id:bd
                width: 74
                height: 62
                x:178
                y:winn.height-86
                source: "./i/but/right.svg"
                visible: true
                MouseArea {
                    anchors.fill: parent;
                    z: 1
                    onPressed: {
                        var a=bd
                        a.width=60
                        a.height=53
                        a.x+=7
                        a.y+=4.4
                        d=1
                    }
                    onReleased: {
                        var a=bd
                        a.width=74
                        a.height=62
                        a.x-=7
                        a.y-=4.4
                        d=0
                    }
                }
            }
            Image {
                id:bq
                width: 74
                height: 58
                x:winn.width-194
                y:winn.height-140
                source: "./i/but/left2.svg"
                visible: true
                MouseArea {
                    anchors.fill: parent;
                    z: 1
                    onPressed: {
                        if(bq.source=="./i/but/left2_n.svg")
                            return
                        var a=bq
                        a.width=60
                        a.height=47
                        a.x+=7
                        a.y+=5.5
                        q=1
                    }
                    onReleased: {
                        var a=bq
                        a.width=74
                        a.height=58
                        a.x-=7
                        a.y-=5.5
                        q=0
                    }
                }
            }
            Image {
                id:be
                width: 74
                height: 58
                x:winn.width-86
                y:winn.height-140
                source: "./i/but/right2.svg"
                visible: true
                MouseArea {
                    anchors.fill: parent;
                    z: 1
                    onPressed: {
                        if(bq.source=="./i/but/left2_n.svg")
                            return
                        var a=be
                        a.width=60
                        a.height=47
                        a.x+=7
                        a.y+=5.5
                        e=1
                    }
                    onReleased: {
                        var a=be
                        a.width=74
                        a.height=58
                        a.x-=7
                        a.y-=5.5
                        e=0
                    }
                }
            }
            Image {
                id:bsp
                width: 158
                height: 67
                x:winn.width-183
                y:winn.height-70
                source: "./i/but/space.svg"
                visible: true
                property int iss:0
                MouseArea {
                    anchors.fill: parent;
                    z: 1
                    onPressed: {
                        if(bsp.iss==0)
                        {
                            sp=1
                            bsp.iss=1
                            bsp.source="./i/but/space2.svg"
                        }
                    }
                }
            }
        }
    }

    //设置界面
    Item {
        id: item3
        width: 600
        height: 600
        x:(winn.width-width)
        y:(winn.height-height)
        visible: false
        z:1
        anchors.centerIn:item1;
        //背景
        Image {
            id: back1
            width: 600
            height: 600
            source: "./i/back2.png"
        }
        //退出设置按钮
        Image {
            id: exit_q_set
            source: "./i/but/no.png"
            x:525
            y:0
            width: 75
            height: 75
            MouseArea {
                anchors.fill: parent;
                z: 2
                onClicked: {
                    if(item2.visible==true)
                    {
                        item3.visible=false
                        exit_q2.visible=false
                        item2.forceActiveFocus()
                        timer.start()
                    }
                    else
                        item3.visible=false
                }
            }
        }
        //显示控制按钮设置文字
        Text {
            x:60
            y:50
            id: tx
            text: qsTr("显示控制按钮")
            color:"#00FF00"
            font.pixelSize:30
        }
        //显示设置按钮设置按钮
        Image {
            id:bss
            x:260
            y:40
            source: "./i/but/noo.png"
            visible: true
            property int issss
            MouseArea {
                anchors.fill: parent;
                z: 1
                onClicked:{
                        if(bss.source=="./i/but/yes.png")
                        {
                            creatbol(275.5,56.5,item3)
                            bss.source="./i/but/noo.png"
                            item_bu.visible=false
                            item2.forceActiveFocus()
                        }
                        else
                        {
                            bss.source="./i/but/yes.png"
                            item_bu.visible=true
                            item2.forceActiveFocus()
                        }
                }
            }
        }
        //退出游戏按钮
        Image {
            id: exit_q2
            visible: false
            source: "./i/but/exit.svg"
            x:10
            y:item3.height-height
            MouseArea {
                anchors.fill: parent;
                z: 1
                onClicked: {
                    wclick(exit_q,function(){
                        $moduleControl.exit(thisn,thistype)
                    })
                }
            }
        }
        //返回主菜单按钮
        Image {
            id: menu
            visible: false
            source: "./i/but/mune.svg"
            x:item3.width-10-width
            y:item3.height-height
            MouseArea {
                anchors.fill: parent;
                z: 1
                onClicked: {
                    wclick(exit_q,function(){
                        cet.startl(2,function(){
                            item2.visible=false
                            item3.visible=false
                            exit_q2.visible=false
                            menu.visible=false
                            item1.visible=true
                            timer.stop()
                            ts=0
                            issh=0
                            br.iss=0
                            tex.text=qsTr("装弹："+ts+"ms")
                            br.source="./i/but/tobol.svg"
                        })
                    })
                }
            }
        }
        Keys.onPressed:{
            if(event.key===Qt.Key_Escape)
            {
                item3.visible=false
                exit_q2.visible=false
                item2.forceActiveFocus()
                timer.start()
            }
        }
    }
    //切换特效
    Image {
        id: witer
        source: "./i/witer.png"
        x:0
        y:0
        width: winn.width
        height: winn.height
        visible: true
        opacity: 0
        z:2
        Timer {
            function startl(x1,func)
            {
                x=x1
                running=true
                fun=func
            }

            id:cet
            interval:30
            repeat:true
            running:false
            property real aa:0
            property int aaa:0
            property int x:0
            property var fun
            onTriggered:{
                if(aaa==0)
                    aa+=0.05
                else
                    aa-=0.05
                if(aa>=1)
                {
                    fun()
                    aaa=1
                }
                if(aa<=0 && aaa==1)
                {
                    running=false
                    aaa=0
                    aa=0

                }
                    witer.opacity=aa
            }
        }
    }
    function wclick(ptr,fun){
        var i=0
        var j=0.95
        var x0=ptr.x,y0=ptr.y,w0=ptr.width,h0=ptr.height
        var t1 = Qt.createQmlObject("import QtQuick 2.12; Timer {}",winn);
        t1.interval = 40;
        t1.repeat = true
        t1.triggered.connect(function(){
            i++
            /*ptr.x+=ptr.width*(1-j)
            ptr.y+=ptr.height*(1-j)
            ptr.width*=j
            ptr.height*=j*/
            if(i===5)
            {
                t1.interval = 100;
                fun()
            }
            if(i>10)
            {
                t1.stop()
                ptr.width=w0
                ptr.height=h0
                ptr.x=x0
                ptr.y=y0
            }
        })
        t1.start()
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.66;height:700;width:1000}D{i:11;anchors_height:700;anchors_width:1000}
}
##^##*/
