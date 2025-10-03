import QtQuick

Window{
    id:root
    flags:Qt.Window|Qt.FramelessWindowHint
    x:(root.screen.width-width)/2
    y:(root.screen.height-height)/2
    color:"#00000000"
    title:""
    //onFlagsChanged: flags|=Qt.Window|Qt.FramelessWindowHint
    property string image;
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
            source:image
            scale: 0.7
            onSourceChanged: {
                if(source==="-1")
                    title_text.x=2
                else
                    title_text.x=20
            }
        }
        Text{
            id:title_text
            x:20
            text:title
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
                    root.x += mouseX - dragX
                    root.y += mouseY - dragY
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
                root.visible=false
            }
        }
    }

}
