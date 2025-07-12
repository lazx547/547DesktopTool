import QtQuick
import GFile 1.2

Window{
    id:root
    visible: true
    flags: Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
    width: 1
    height:1
    x:-1
    y:-1
    property var $sysTray:SysTray{
        win:$clock
        rand:$randBar
    }
    property var $file:GFile{}
    property var $clock:Clock{}
    property var $randBar:Rand_bar{tray:$sysTray}
    property var $pasterLoad:PasterLoad{}
    property var $rand:Rand{
        visible: false
    }
    property var $about:About{}
    property var $menu
    property color $topic_color:"#2080f0"
    readonly property real sys_width: root.screen.width
    readonly property real sys_height: root.screen.height
}
