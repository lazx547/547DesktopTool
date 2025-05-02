import QtQuick

Window {
    visible: false
    minimumHeight: 500
    maximumHeight: 500
    minimumWidth: 500
    maximumWidth: 500
    title: "About Qt"
    width: 500
    height: 500
    Image{
        x:10
        y:10
        width: 80
        height: 80
        source: "./images/Qt.png"
    }
    Item{
        x:100
        y:10
        width: 380
        height: 480
        Text{
            wrapMode: Text.WordWrap
            anchors.fill: parent
            text:"This program uses Qt version 6.7.2.\n\nQt is a C++ to olkit for cross-platform application development.\n\nQt provides single-source portability across all major desktop operating syste ms.It is also available for embedded Linux and other embedded and mobile operating systems.\n\nQt is available under multiple licensing options designed to accommodate the needs of our various users.\n\nQt licensed under our commercial license agreement is appropriate for development of proprietary/commercial software where you do not want to share any source code with third parties or otherwise cannot comply with the tems of GNU (L)GPL.\n\nQt licensed under GNU (L)GPL is appropriate for the development ofQt applications provided you can comply with the terms and conditions of therespective licenses.\n\nPlease see qt.io/licensing for an overview of Qt licensing.\n\nCopyright (C) 2024 The Qt Company Ltd and other contributors.\n\nQt and the Qt logo are trademarks of The Qt Company Ltd.\n\nQt is The Qt Company Ltd product developed as an open source project. See qt.io for more information."
        }
    }
}
