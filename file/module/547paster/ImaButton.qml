import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Shapes
import Qt5Compat.GraphicalEffects

Button {
    id: control
    property int radiusBg: 0
    property color colorBorder: enabled?(control.hovered?(danger? (control.down ? "#ff1600" : "#FF7070") : (control.down ? "#1677ff" : "#4096ff")):color_):Qt.rgba(0,0,0,0.45)
    property string contentDescription: text
    property string img:""
    property bool danger:false
    property string toolTipText

    property color color_:"#80808080"
    width:20
    height:20
    padding: 0
    topPadding:0
    bottomPadding: 0
    contentItem: Rectangle{
        scale: 0.5
        color:"#00123456"
        Image {
            id:img_
            anchors.centerIn:parent
            source: img
            width: parent.width>parent.height ? 2*parent.height : 2*parent.width
            height: width
            ColorOverlay{
                    anchors.fill: parent
                    color: enabled?(danger? (control.down ? "#ff1600" : "#FF7070") : (control.down ? "#1677ff" : "#4096ff")):Qt.rgba(0,0,0,0.45)
                    source: parent
                    visible: control.hovered ? true:false
                }
            ColorOverlay{
                    anchors.fill: parent
                    color: color_
                    source: parent
                    visible: control.hovered ? false:true
                }
        }

    }

    background: Item {
        Rectangle {
            id: __bg
            width: realWidth
            height: realHeight
            anchors.centerIn: parent
            radius:control.radiusBg
            color:"#00123456"
            border.width: 1
            border.color: control.enabled ? control.colorBorder : "transparent"

            property real realWidth: parent.width
            property real realHeight: parent.height
        }
    }
    Accessible.role: Accessible.Button
    Accessible.name: control.text
    Accessible.description: contentDescription
    Accessible.onPressAction: control.clicked();
}


