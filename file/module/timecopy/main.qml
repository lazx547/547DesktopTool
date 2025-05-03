import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import Clipboard 1.0

Window{
    minimumWidth: 290
    minimumHeight: 200
    visible: true
    width: 250
    height: 222
    title:"复制时间"
    property int thisn
    property int thistype
    property string path
    property int thisnum
    TextArea{
        id:h_type_t
        x:2
        y:2
        width: parent.width-46
        height: 20
        text:"yyyy-MM-dd_hh:mm:ss"
        color: "black"
        padding:0
        font.pixelSize: 15
        background:Rectangle{
            anchors.fill: parent
            border.width: 1
            border.color: "#80808080"
        }
        onTextChanged: output.text=Qt.formatDateTime(new Date(), h_type_t.text)
    }
    Button{
        width: 40
        height: 20
        text: "刷新"
        onClicked: output.text=Qt.formatDateTime(new Date(), h_type_t.text)
        x:2
        y:22
    }
    TextArea{
        id:output
        x:42
        y:22
        width: parent.width-86
        height: 20
        text:Qt.formatDateTime(new Date(), h_type_t.text)
        color: "black"
        padding:0
        font.pixelSize: 15
        background:Rectangle{
            anchors.fill: parent
            border.width: 1
            border.color: "#80808080"
        }
    }
    Button{
        width: 40
        height: 22
        text: "粘贴"
        onClicked: h_type_t.text=Clipboard.pasteText()
        x:parent.width-42
    }
    Button{
        width: 40
        height: 22
        text: "复制"
        onClicked: Clipboard.copyText(output.text)
        x:parent.width-42
        y:22
    }

    Rectangle{
        x:2
        y:44
        width: parent.width-4
        height: 177
        TextArea{
            padding:0
            font.pixelSize:12
            anchors.fill: parent
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

