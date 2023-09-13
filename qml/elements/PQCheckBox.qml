import QtQuick
import QtQuick.Controls.Basic

CheckBox {

    id: control
    text: ""
    property int elide: Text.ElideNone

    font.pointSize: PQCLook.fontSize
    font.weight: PQCLook.fontWeightNormal

    indicator: Rectangle {
        implicitWidth: 22
        implicitHeight: 22
        x: control.leftPadding
        y: parent.height / 2 - height / 2

        border.color: PQCLook.inverseColor
        color: PQCLook.baseColorHighlight
        radius: 2
        Rectangle {
            width: 10
            height: 10
            anchors.centerIn: parent
            visible: control.checked
            color: PQCLook.inverseColor
            radius: 2
        }
    }

    contentItem: PQText {
        text: control.text
        elide: control.elide
        font: control.font
        opacity: enabled ? (control.checked ? 1.0 : 0.7) : 0.3
        Behavior on opacity { NumberAnimation { duration: 200 } }
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }

}
