import QtQuick

Rectangle{
    property string path:""
    property int num
    property bool active:false
    property color colorBg:active?"#DDDDDD":"#FFFFFF"
    color: colorBg
    onPathChanged: {
        im.source=path+"/ico.png"
        $file.source="./file/"+path.slice(2,path.length)+"/.info"
        var s=$file.read()
        title.text=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        s=s.slice(s.indexOf(",")+1,s.length)
        description.text=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
    }

    width: 330
    height:60
    Rectangle{
        border.color: "#80808080"
        radius: 9
        width: 52
        height: 52
        x:4
        y:4
        Image{
            id:im
            width: 50
            height: 50
            x:1
            y:1
        }
    }
    Item{
        x:57
        Text{
            id:title
            y:5
            font.pixelSize: 20
        }
        Text{
            id:description
            x:2
            y:35
            font.pixelSize: 12
            color: "#686868"
        }
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            $moduleControl.resetActive()
            parent.active=true
            $ModuleErs[num].visible=true
        }
    }
}
