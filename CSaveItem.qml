import QtQuick
import GFile

Rectangle{
    property var file
    property var par
    property string num:""
    property int n
    property bool type:true
    border.width: 1
    border.color: "#80808080"
    width: 140
    height: 20

    GFile{
        id:afile
    }
    z:-1

    Text{
        x:2
        text:num
        font.pixelSize: 15
    }
    ImaButton{
        id:b0
        x:60
        radiusBg: 0
        colorBorder: "#00000000"
        width: 18
        height: 18
        y:1
        img:"./images/pause.png"
        toolTipText: "新开"
        onClicked: pasterLoad.newP("./file/saves/"+num+".json")
    }
    ImaButton{
        id:b1
        x:80
        radiusBg: 0
        colorBorder: "#00000000"
        width: 18
        height: 18
        y:1
        img:"./images/reset.png"
        toolTipText: "加载"
        onClicked: file.load("./file/saves/"+num+".json")//load.newP("./file/saves/"+num+".txt")
    }
    ImaButton{
        id:b2
        x:100
        radiusBg: 0
        colorBorder: "#00000000"
        width: 18
        height: 18
        y:1
        img:"./images/save.png"
        toolTipText:  "保存"
        onClicked:file.save("./file/saves/"+num+".json")
    }
    ImaButton{
        id:b3
        x:120
        radiusBg: 0
        colorBorder: "#00000000"
        width: 18
        height: 18
        y:1
        img:"./images/del.png"
        toolTipText:  "删除"
        onClicked: {
            afile.source="./file/saves/"+num+".json"
            afile.del()
            par.remove(n)
        }
    }
}
