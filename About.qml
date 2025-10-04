import QtQuick

GWindow{
    id:about
    flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint|Qt.Window
    color: "#00000000"
    x:about.screen.width/2-width/2
    y:about.screen.height/2-height/2
    width: 320
    height: 230
    minimumHeight: height
    maximumHeight: height
    minimumWidth: width
    maximumWidth: width
    title: "547DesktopTool>关于"
    image:"qrc:/547dt.png"
    Item{
        y:20
        Image {
            x:20
            y:10
            width: 70
            height: 70
            source: "qrc:/547dt.png"
        }
        Text{
            x:90
            y:35
            font.pixelSize: 20
            text:"547DesktopTool v0.6"
        }
        Image {
            x:20
            y:90
            width: 70
            height: 70
            source: "./images/Qt.png"
        }
        Text{
            x:90
            y:105
            font.pixelSize: 20
            text:"Made with Qt6 (qml)"
        }
        Text {
            x:90
            y:125
            text: "(Desktop Qt 6.8.3 MinGW 64-bit)"
        }
        Cbutton{
            text:"源代码"
            font.pixelSize: 16
            width: 80
            x:30
            y:170
            height: 20
            onClicked: Qt.openUrlExternally("https://github.com/lazx547/547DesktopTool")
        }
        Cbutton{
            text:"547官网"
            font.pixelSize: 16
            width: 100
            x:180
            y:170
            height: 20
            onClicked: Qt.openUrlExternally("https://lazxg547b.pages.dev")
        }
    }
}
