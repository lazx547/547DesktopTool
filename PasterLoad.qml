import QtQuick
import QtQuick.Controls
import GFile 1.2
import Clipboard 1.0

Item {
    property var paster:Qt.createComponent("./Paster.qml")
    property var imagePaster:Qt.createComponent("./ImagePaster.qml")
    property var menuItem:Qt.createComponent("./PMenuItem.qml")
    property var shoter:Qt.createComponent("./ScreenShot.qml")
    property var shotObj
    property var objs:[]
    function create(){
        if(!Clipboard.isEmpty()){
            console.log("ts:"+Clipboard.showType())
            objs.push(imagePaster.createObject())
            var n=objs.length-1
            objs[n].thisn=n
            objs[n].path="-1"
            var s=String(objs[n])
            objs[n].name=s.slice(s.indexOf("(")+1,s.length-1)
        }
        else console.log("clip empty")
    }
    function toImage(n,i){
        Clipboard.copyText(i)
        exit(n)
        objs.push(imagePaster.createObject())
        n=objs.length-1
        objs[n].thisn=n
        objs[n].path="-1"
        var s=String(objs[n])
        objs[n].name=s.slice(s.indexOf("(")+1,s.length-1)
    }

    function newP(p){
        objs.push(paster.createObject())
        var n=objs.length-1
        objs[n].thisn=n
        objs[n].path=p
        var s=String(objs[n])
        objs[n].name=s.slice(s.indexOf("(")+1,s.length-1)
        sysTray.paster.add(objs[n],n)
    }

    function addMenu(n){
        sysTray.paster.add(objs[n],n)
    }

    function toText(n){
        exit(n)
        console.log("toText")
        objs.push(paster.createObject())
        n=objs.length-1
        objs[n].thisn=n
        objs[n].path="-1"
        var s=String(objs[n])
        objs[n].name=s.slice(s.indexOf("(")+1,s.length-1)
        sysTray.paster.add(objs[n],n)
    }

    function setV(n){
        sysTray.paster.sv(objs[n])
    }

    function exit(n)
    {
        try{
            sysTray.paster.del(objs[n])
        }
        catch(i){
        }
        objs[n].destroy()
        for(var i=n;i<objs.length-1;i++)
        {
            objs[i]=objs[i+1]
            objs[i].thisn--
        }
        objs.pop()
    }

    function shot(){
        var a=Clipboard.shot()
        shotObj=shoter.createObject()
        shotObj.name=a
    }

    function endShot(){
        shotObj.destroy()
    }

    function setVisible(n,set)
    {
        objs[n].visible=set
    }

    function shotPaster(x,y,w,h,s){
        Clipboard.shot(x,y,w,h,s)
        objs.push(imagePaster.createObject())
        var n=objs.length-1
        objs[n].thisn=n
        objs[n].path="-1"
        objs[n].x=x
        objs[n].y=y
        s=String(objs[n])
        objs[n].name=s.slice(s.indexOf("(")+1,s.length-1)
    }

    function delA(){
        for(var i=0;i<objs.length;i++)
        {
            sysTray.paster.del(objs[i])
            objs[i].destroy()
        }
        objs=[]
    }
    function showA(){
        for(var i=0;i<objs.length;i++)
            objs[i].visible=true
    }
    function hideA(){
        for(var i=0;i<objs.length;i++)
            objs[i].visible=false
    }
    function rename(n,text){
        sysTray.paster.rename(objs[n],text)
    }



    Component {
        id: menuItemComponent
        MenuItem {
            property int thisn
            text: thisn
            onTriggered:{X
                load.setVisible(thisn,checked)
            }
        }
    }
    GFile{
        id:file
    }

    Component.onCompleted: {
    }
}
