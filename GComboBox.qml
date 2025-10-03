import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
ComboBox {
    id:root
    transformOrigin: Item.TopLeft
    y:25
    width: 200
    // 自定义背景
    background: Rectangle {
        color: root.down ? "#e0e0e0" : "#f5f5f5"
        border.color: root.pressed ? $topic_color : "#b9b9b9"
        border.width: 1
    }
    font.pixelSize: 13
    // 自定义内容项
    contentItem: Text {
        padding: 1
        text: root.displayText
        font: root.font
        color: root.pressed ? $topic_color : "#000"
        verticalAlignment: Text.AlignVCenter
        leftPadding: 10
        rightPadding: root.indicator.width + 10
    }


    // 自定义下拉菜单代理
    delegate: ItemDelegate {
        padding: 1
        width: root.width
        contentItem: Text {
            text: root.model[index]
            color: "#000"
            font: root.font
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
        }
        highlighted: root.highlightedIndex === index
        background: Rectangle {
            color: highlighted ? "#804498ff" : "transparent"
        }
    }
}
