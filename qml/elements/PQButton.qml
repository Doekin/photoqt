import QtQuick 2.9
import QtQuick.Controls 2.2

Button {
    id: control

    text: ""

    implicitHeight: 40
    width: (forceWidth==0) ? undefined : forceWidth

    property string backgroundColor: "#333333"
    property string backgroundColorHover: "#3a3a3a"
    property string backgroundColorActive: "#444444"
    property string textColor: "#ffffff"
    property string textColorHover: "#ffffff"
    property string textColorActive: "#ffffff"

    property bool clickOpensMenu: false
    property var listMenuItems: []

    property string imageButtonSource: ""
    property real imageOpacity: 1

    property bool mouseOver: false

    property alias tooltip: mousearea.tooltip
    property alias tooltipFollowsMouse: mousearea.tooltipFollowsMouse

    property int forceWidth: 0

    signal menuItemClicked(var item)

    //: This is a generic string written on clickable buttons - please keep short!
    property string genericStringOk: em.pty+qsTranslate("buttongeneric", "Ok")
    //: This is a generic string written on clickable buttons - please keep short!
    property string genericStringCancel: em.pty+qsTranslate("buttongeneric", "Cancel")
    //: This is a generic string written on clickable buttons - please keep short!
    property string genericStringSave: em.pty+qsTranslate("buttongeneric", "Save")
    //: This is a generic string written on clickable buttons - please keep short!
    property string genericStringClose: em.pty+qsTranslate("buttongeneric", "Close")

    contentItem: Item {
        width: childrenRect.width+20
        height: control.height
        Text {
            id: txt
            text: control.text
            font: control.font
            y: (parent.height-height)/2
            x: 10
            width: (forceWidth==0) ? undefined : forceWidth-20
            opacity: enabled ? 1.0 : 0.3
            color: control.down ? control.textColorActive : (control.mouseOver ? control.textColorHover : control.textColor)
            Behavior on color { ColorAnimation { duration: 100 } }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }

    background: Rectangle {
        implicitWidth: contentItem.width
        color: control.down ? control.backgroundColorActive : (control.mouseOver ? control.backgroundColorHover : control.backgroundColor)
        Behavior on color { ColorAnimation { duration: 100 } }
        implicitHeight: contentItem.height
        opacity: enabled ? 1 : 0.3
        radius: 2

        Image {

            id: iconview

            source: imageButtonSource

            opacity: imageOpacity
            visible: imageButtonSource!=undefined&&imageButtonSource!=""

            sourceSize: Qt.size(30,30)

            x: (parent.width-width)/2
            y: (parent.height-height)/2

        }

    }

    PQMouseArea {
        id: mousearea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onEntered:
            control.mouseOver = true
        onExited:
            control.mouseOver = false
        onPressed:
            control.down = true
        onReleased:
            control.down = false
        onClicked: {
            if(clickOpensMenu) {
                var pos = parent.mapFromItem(parent, mouse.x, mouse.y)
                menu.popup(Qt.point(parent.x+pos.x, parent.y+pos.y))
            } else
                control.clicked()
        }
    }

    PQMenu {

        id: menu

        model: listMenuItems
        onTriggered: control.menuItemClicked(listMenuItems[index])

    }

}
