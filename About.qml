import QtQuick

Window{
    id:about
    flags:Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint
    color: "#00000000"
    x:about.screen.width/2-width/2
    y:about.screen.height/2-height/2
    width: 300
    height: 230
    minimumHeight: height
    maximumHeight: height
    minimumWidth: width
    maximumWidth: width
    Rectangle{
        anchors.fill: parent
        border.color: $topic_color
        color:"#f2f2f2"
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
            text:"关于"
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
                    about.x += mouseX - dragX
                    about.y += mouseY - dragY
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
                about.visible=false
            }
        }
    }
    Item{
        y:20
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
            text:"547clock v0.14.2"
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
            x:170
            y:170
            height: 20
            onClicked: Qt.openUrlExternally("https://lazx547.github.io")
        }
    }
}
