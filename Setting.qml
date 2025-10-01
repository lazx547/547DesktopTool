import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import GFile

Window{
    id:setting
    visible:false
    flags:Qt.Window|Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
    x:(root.screen.width-width)/2
    y:(root.screen.height-height)/2
    width: 410
    height:362
    color:"#00000000"
    title:"547desktopTool设置"

    property bool auto_save:auto_save.checked
    property bool h_type:h_type.checked
    property string h_type_t:h_type_t.text
    property bool show_type_ss:show_type_ss.checked
    property bool show_type_zzz:show_type_zzz.checked
    property int delT:delT.delT
    property bool refresh_top:refresh_top.checked
    property int auto_save_delt
    property bool color_shot:colorful_shot.checked
    GFile{
        id:file
    }
    function get_clock_value(){
        return refresh_top.checked+","+delT.value+","+h_type_t.text+","+h_type.checked+","+show_type_ss.checked+","+show_type_zzz.checked
    }
    function set_clock_value(s){
        refresh_top.checked=s.slice(0,s.indexOf(","))=="true" ? true : false
        s=s.slice(s.indexOf(",")+1,s.length)
        delT.setValue(s.slice(0,s.indexOf(",")))
        s=s.slice(s.indexOf(",")+1,s.length)
        h_type_t.text=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        h_type.checked=s.slice(0,s.indexOf(","))=="true" ? true : false
        s=s.slice(s.indexOf(",")+1,s.length)
        show_type_ss.checked=s.slice(0,s.indexOf(","))=="true" ? true : false
        s=s.slice(s.indexOf(",")+1,s.length)
        show_type_zzz.checked=s.slice(0,s.indexOf(","))=="true" ? true : false
        s=s.slice(s.indexOf(",")+1,s.length)
    }

    function save(){
        file.source="./setting.ini"
        var a
        a=topic_color_picker.r+","+topic_color_picker.g+","+topic_color_picker.b+","+topic_color_picker.a+","
        a+=auto_save.checked+","+clock.ghost+","+rand_bar.visible+","+colorful_shot.checked+","
        file.write(a)
    }
    function read(){
        file.source="./setting.ini"
        var s=file.read(),r_,g_,b_,a_
        r_=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        g_=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        b_=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        a_=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        topic_color_picker.setColor(r_,g_,b_,a_)
        auto_save.checked=s.slice(0,s.indexOf(","))=="true" ? true : false
        s=s.slice(s.indexOf(",")+1,s.length)
        clock.ghost=s.slice(0,s.indexOf(","))=="true" ? true : false
        s=s.slice(s.indexOf(",")+1,s.length)
        rand_bar.visible=s.slice(0,s.indexOf(","))=="true" ? true : false
        s=s.slice(s.indexOf(",")+1,s.length)
        colorful_shot.checked=s.slice(0,s.indexOf(","))=="true" ? true : false
    }

    Rectangle{
        anchors.fill: parent
        border.color: $topic_color
        color:"#f2f2f2"
        border.width: 2
    }
    Rectangle{
        width: parent.width
        height: 20
        color: $topic_color
        Image{
            width: 20
            height: 20
            source:"qrc:/547dt.png"
            scale: 0.7
        }
        Text{
            x:20
            text:"547desktopTool设置"
            font.pixelSize: 15
        }
        MouseArea {
            anchors.fill: parent
            property int dragX
            property int dragY
            property bool dragging
            onPressed: {
                dragX = mouseX
                dragY = mouseY
                dragging = true
            }
            onReleased: {
                dragging = false
            }
            onPositionChanged: {
                if (dragging) {
                    setting.x += mouseX - dragX
                    setting.y += mouseY - dragY
                }
            }
        }
        Cbutton{
            x:parent.width-20
            y:0
            type:3
            width: 20
            height: 20
            text: "×"
            colorBg: "#00000000"
            colorBorder: "#00000000"
            font.pixelSize: 25
            padding: 0
            topPadding: 0
            onClicked: {
                setting.visible=false
            }
        }
        Item{
            x:1
            y:20
            Text{
                text:"主题色"
                font.pixelSize: 15
            }
            ColorPickerItem{
                id:topic_color_picker
                y:20
                onColor_Changed: $topic_color=color_
                Component.onCompleted: setColor(32/256, 128/256, 240/256,1)
            }
            CCheckBox{
                id:colorful_shot
                height: 16
                y:100
                x:2
                transformOrigin: Item.TopLeft
                font.pixelSize: 15
                text:"绚丽截图"
            }
            Rectangle{
                y:120
                x:2
                width: 200
                height: 165
                border.color: "#80000000"
                border.width: 1
                color:"#00000000"
                Text{
                    x:2
                    text:"定位配置文件/目录"
                    font.pixelSize: 15
                }
                Cbutton{
                    y:20
                    x:20
                    width: 160
                    height: 20
                    text: "设置配置文件"
                    onClicked:
                    {
                        file.source="./setting.txt"
                        file.showPath()
                    }
                }
                Cbutton{
                    y:40
                    x:20
                    width: 160
                    height: 20
                    text: "547抽号器（边栏）名单配置"
                    onClicked:
                    {
                        file.source="./source_.ini"
                        file.showPath()
                    }
                }
                Cbutton{
                    y:60
                    x:20
                    width: 160
                    height: 20
                    text: "547clock个性化配置"
                    onClicked:
                    {
                        file.source="./value_clock.txt"
                        file.showPath()
                    }
                }
                Cbutton{
                    y:80
                    x:20
                    width: 160
                    height: 20
                    text: "547paster个性化配置"
                    onClicked:
                    {
                        file.source="./data.ini"
                        file.showPath()
                    }
                }
                Cbutton{
                    y:100
                    x:20
                    width: 160
                    height: 20
                    text: "547抽号器班级名单目录"
                    onClicked:
                    {
                        file.source="./source"
                        file.showPath()
                    }
                }
                Cbutton{
                    y:120
                    x:20
                    width: 160
                    height: 20
                    text: "547clock存档目录"
                    onClicked:
                    {
                        file.source="./file/saves_clock"
                        file.showPath()
                    }
                }
                Cbutton{
                    y:140
                    x:20
                    width: 160
                    height: 20
                    text: "547paster存档目录"
                    onClicked:
                    {
                        file.source="./file/saves"
                        file.showPath()
                    }
                }
            }

            Cbutton{
                text:"关于"
                y:295
                x:2
                width: 100
                height:20
                onClicked:
                {
                    about.visible=true
                    about.raise()
                }
            }

        }
        Item{
            x:206
            y:20
            Text{
                text:"547clock"
                font.pixelSize: 15
            }
            CCheckBox{
                y:17
                id:refresh_top
                scale: 0.75
                transformOrigin: Item.TopLeft
                text: "刷新显示在最上层"
            }
            CscrollBar{
                id:delT
                y:41
                width: 200
                height: 15
                text: "时差"
                minValue: -60
                maxValue: 60
                Component.onCompleted: setValue(reset)
                reset:0
                property int delT:value
            }
            Rectangle{
                y:56
                Text{
                    text:"显示模式"
                    font.pixelSize: 15
                }
                CCheckBox{
                    id:show_type_ss
                    height: 16
                    x:80
                    transformOrigin: Item.TopLeft
                    font.pixelSize: 15
                    text:"秒"
                }
                CCheckBox{
                    id:show_type_zzz
                    enabled: show_type_ss.checked
                    height: 16
                    x:120
                    transformOrigin: Item.TopLeft
                    font.pixelSize: 15
                    text:"毫秒"
                }
            }
            Item{
                y:75
                CCheckBox{
                    id:auto_save
                    height: 16
                    transformOrigin: Item.TopLeft
                    font.pixelSize: 15
                    text:"自动保存"
                    onCheckedChanged: save()
                }
                Timer{
                    interval: 72000
                    running: auto_save.checked
                    onTriggered: {
                        clock.save()
                        setting.save()
                    }
                }
            }
            Rectangle{
                y:97
                Text{
                    x:2
                    text:"高级显示模式:"
                    font.pixelSize: 15
                }
                CCheckBox{
                    id:h_type
                    x:90
                    y:-1
                    font.pixelSize: 11
                    text:"启用(不兼容时差)"
                }
                TextArea{
                    id:h_type_t
                    x:2
                    y:20
                    width: 196
                    height: 20
                    text:"hh:mm:ss"
                    color: "black"
                    padding:0
                    font.pixelSize: 15
                    background:Rectangle{
                        anchors.fill: parent
                        border.width: 1
                        border.color: "#80808080"
                    }
                }
                Rectangle{
                    x:2
                    y:42
                    width: 196
                    height: 177
                    TextArea{
                        padding:0
                        font.pixelSize:12
                        property string tex:"d 日 (1-31)       dd日 (01-31)\nddd 星期 (Mon-Sun)\ndddd 星期 (Monday-Sunday)\nM 月 (1-12)      MM 月 (01-12)\nMMM 月 (Jan-Dec)\nMMMM 月 (January-December)\nyy 年 (00-99)    yyyy 年\nh 小时 (0-23)    hh 小时 (00-23)\nm 分钟 (0-59)   mm 分钟 (00-59)\ns 秒 (0-59)        ss 秒 (00-59)\nz 毫秒 (0-999)   zzz 毫秒(000-999)"
                        text:tex
                        background:Rectangle{
                            anchors.fill: parent
                            border.width: 1
                            border.color: "#80808080"
                        }
                        onTextChanged: text=tex
                    }
                }
            }
        }
        Rectangle{
            width: parent.width-2
            x:1
            height: 20
            y:342
            color: $topic_color
            Cbutton{
                x:208
                width: 100
                height: 20
                text: "保存"
                onClicked:
                {
                    clock.save()
                    setting.save()
                }
            }
            Cbutton{
                x:308
                width: 100
                height: 20
                text: "完成"
                onClicked:
                {
                    clock.save()
                    setting.save()
                    setting.visible=false
                }
            }
        }
    }
}
