import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import GFile
import Clipboard 1.0

GWindow{
    id:setting
    visible:false
    flags:Qt.Window|Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
    x:(root.screen.width-width)/2
    y:(root.screen.height-height)/2
    width: 410
    height:377
    title:"547desktopTool>设置"
    image:"qrc:/547dt.png"

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
        a+=auto_save.checked+","+clock.ghost+","+rand_bar.visible+","+colorful_shot.checked+","+time_copy.text+","+watermark.type+","+watermark.visible+","
        file.write(a)
        file.source="./hotkey.ini"
        var s=file.write(String((hotkey_shot.text===""?hotkey_shot.placeholderText:hotkey_shot.text)+","
                                  +(hotkey_paster.text===""?hotkey_paster.placeholderText:hotkey_paster.text)+","))
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
        s=s.slice(s.indexOf(",")+1,s.length)
        time_copy.text=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        r_=s.slice(0,s.indexOf(","))=="true" ? true : false
        s=s.slice(s.indexOf(",")+1,s.length)
        g_=s.slice(0,s.indexOf(","))=="true" ? true : false
        sysTray.watermark_.reset(g_,r_)
        file.source="./hotkey.ini"
        s=file.read()
        hotkey_shot.text=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        hotkey_paster.text=s.slice(0,s.indexOf(","))
        s=s.slice(s.indexOf(",")+1,s.length)
        hotkey_time.text=s.slice(0,s.indexOf(","))
    }
    function copyTime(){
        var s;
        if(time_copy.text==="")
            s=Qt.formatDateTime(new Date(), time_copy.placeholderText)
        else
            s=Qt.formatDateTime(new Date(), time_copy.text)
        Clipboard.copyText(s)
        console.log(s)
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
            y:100
            x:2
            height: 16
            font.pixelSize: 15
            text:"绚丽截图"
        }
        Item{
            y:100
            x:102
            CCheckBox{
                id:auto_save
                height: 16
                font.pixelSize: 15
                text:"自动保存"
                onCheckedChanged: save()
            }
            Timer{
                interval: 72000
                running: auto_save.checked
                repeat: true
                onTriggered: {
                    clock.save()
                    setting.save()
                }
            }
        }
        Rectangle{
            width: 200
            height: 140
            y:122
            x:2
            border.color: "#80000000"
            border.width: 1
            color:"#00000000"
            Text{
                y:3
                text:"截图快捷键（全局）"
                font.pixelSize: 13
            }

            TextField {
                id: hotkey_shot
                y:20
                x:1
                transformOrigin: Item.TopLeft
                width: 198
                padding:1
                font.pixelSize: 14
                placeholderText: "Ctrl+ALt+S"
                background:Rectangle{
                    anchors.fill: parent
                    border.width: 1
                    border.color: "#80808080"
                }
            }
            Text{
                y:43
                text:"贴图快捷键（全局）"
                font.pixelSize: 13
            }
            TextField {
                id: hotkey_paster
                y:60
                x:1
                transformOrigin: Item.TopLeft
                width: 198
                padding:1
                font.pixelSize: 14
                placeholderText: "Ctrl+ALt+P"
                background:Rectangle{
                    anchors.fill: parent
                    border.width: 1
                    border.color: "#80808080"
                }
            }
            Text{
                y:83
                text:"复制时间快捷键（全局）"
                font.pixelSize: 13
            }
            TextField {
                id: hotkey_time
                y:100
                x:1
                transformOrigin: Item.TopLeft
                width: 198
                padding:1
                font.pixelSize: 14
                placeholderText: "Ctrl+ALt+C"
                background:Rectangle{
                    anchors.fill: parent
                    border.width: 1
                    border.color: "#80808080"
                }
            }
        }

        Item{
            y:258
            x:2
            Text{
                y:5
                text:"定位/打开配置文件（夹）"
                font.pixelSize: 15
            }
            GComboBox {
                id:locatee
                transformOrigin: Item.TopLeft
                y:25
                width: 200
                onCurrentValueChanged:
                    file_open.enabled=currentIndex<=5
                model: ["全局快捷键配置文件","程序缩放配置文件","设置配置文件","547抽号器（边栏）名单配置","547clock个性化配置","547paster个性化配置","547抽号器班级名单目录","547clock存档目录","547paster存档目录"
                ]
                function getValue(){
                    var s
                    switch(currentIndex){
                    case 0:
                        s="./hotkey.ini"
                        break
                    case 1:
                        s="./scale.txt"
                        break
                    case 2:
                        s="./setting.ini"
                        break
                    case 3:
                        s="./source_.ini"
                        break
                    case 4:
                        s="./value_clock.txt"
                        break
                    case 5:
                        s="./data.json"
                        break
                    case 6:
                        s="./source"
                        break
                    case 7:
                        s="./file/saves_clock"
                        break
                    case 8:
                        s="./file/saves"
                        break
                    }
                    return s;
                }
            }
            Cbutton{
                y:55
                width: 100
                height: 20
                text: "定位"
                onClicked:
                {
                    file.source=locatee.getValue()
                    file.showPath()
                }
            }
            Cbutton{
                id:file_open
                y:55
                x:100
                width: 100
                height: 20
                text: "打开"
                onClicked:
                {
                    file.source=locatee.getValue()
                    file.openFile()
                }
            }
        }
    }
    Item{
        x:206
        y:20

        Text{
            y:3
            text:"复制时间格式"
            font.pixelSize: 13
        }
        TextField {
            id: time_copy
            y:20
            x:1
            transformOrigin: Item.TopLeft
            width: 198
            padding:1
            font.pixelSize: 14
            placeholderText: "yyyy-MM-dd-hh-mm-ss"
            background:Rectangle{
                anchors.fill: parent
                border.width: 1
                border.color: "#80808080"
            }
        }
        Item{
            y:40
            Text{
                text:"547clock"
                font.pixelSize: 15
            }
            CCheckBox{
                y:17
                id:refresh_top
                height: 16
                font.pixelSize: 15
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
            Rectangle{
                y:75
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

    }

    Rectangle{
        width: parent.width-2
        x:1
        height: 20
        y:setting.height-20
        color: $topic_color
        Cbutton{
            text:"关于"
            x:108
            width: 100
            height:20
            onClicked:
            {
                about.visible=true
                about.raise()
            }
        }
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
