import QtQuick
import QtQuick.Controls
import QtQuick.Window

Item{
    id:pickerItem
    property real value:slider.value
    property real maxValue:100
    property real minValue:0
    property string text
    property real step:0.01
    property real reset:-1
    property color color_:"#80808080"
    onTextChanged: text_.text=text
    function setValue(vl){
        slider.x = Math.max(0,vl*(pickerItem_.width-slider.width))
    }
    onResetChanged: {
        if(reset>=0)
        {
            pickerItem_.width=100
            bur.x=140
            shvr.x=150
            reseter.visible=true
        }
        else
        {
            pickerItem_.width=115
            bur.x=155
            shvr.x=165
            reseter.visible=false
        }
    }

    Text{
        id:text_
        text:text
        color:pickerItem.color_
        font.pixelSize: 14
        y:2
    }
    Cbutton{
        x:30
        radiusBg:0
        width: 10
        height: 20
        text:"<"
        color_:pickerItem.color_
        font.pixelSize: 10
        padding: 0
        topPadding: 0
        bottomPadding: 0
        onClicked: setValue(value-step)
        toolTipText: "减小"
    }
    Cbutton{
        id:bur
        x:155
        radiusBg:0
        width: 10
        height: 20
        text:">"
        color_:pickerItem.color_
        font.pixelSize: 10
        padding: 0
        topPadding: 0
        bottomPadding: 0
        onClicked: setValue(value+step)
        toolTipText: "增加"
    }
    Item {
        id: pickerItem_
        width: 115
        height: 20
        x:40
        y:0
        Rectangle {
            anchors.fill: parent
            border.color: pickerItem.color_
            border.width: 2
            color:"#00123456"
            ToolTip.visible: false
        }
        Rectangle {
            id: slider
            x: parent.width - width
            width: height
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            border.color: pickerItem.color_
            color:"#00123456"
            border.width: 2
            scale: 0.9
            property real value: x / (pickerItem_.width - width)
        }

        MouseArea {
            anchors.fill: parent

            function handleCursorPos(x) {
                let halfWidth = slider.width * 0.5;
                slider.x = Math.max(0, Math.min(width, x + halfWidth) - slider.width);
            }
            onPressed: (mouse) => {
                           handleCursorPos(mouse.x, mouse.y);
                       }
            onPositionChanged: (mouse) => handleCursorPos(mouse.x);
            onWheel:(wheel)=>{
                        if(true)
                        {
                            if(wheel.angleDelta.y>0) setValue(value+step)
                            else if(wheel.angleDelta.y<0)
                                setValue(value-step)
                        }
                    }
        }
    }
    Rectangle{
        id:shvr
        x:165
        y:0
        z:-1
        width: 35
        height: 20
        border.color: pickerItem.color_
        color:"#00000000"
        Text{
            anchors.fill: parent
            id:vr
            text:(slider.value * (maxValue-minValue)+minValue).toFixed(0)
            font.pixelSize: 14
            color: pickerItem.color_
            horizontalAlignment:Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
    Cbutton{
        radiusBg: 0
        id:reseter
        text:"R"
        color_:pickerItem.color_
        x:185
        visible: false
        width: 20
        height: 20
        onClicked: setValue(reset)
        toolTipText: "重置"
    }
}
