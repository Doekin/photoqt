import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Dialogs 1.2

import "../../../elements"

PQSetting {
    id: set
    title: "face tags - border"
    helptext: "If and what style of border to show around tagged faces."
    expertmodeonly: true
    property var rgba: handlingGeneral.convertHexToRgba(PQSettings.peopleTagInMetaBorderAroundFaceColor)
    content: [

        Column {

            spacing: 20

            PQCheckbox {
                id: ft_border
                text: "show border"
            }

            Row {

                spacing: 10

                Text {
                    y: (parent.height-height)/2
                    color: ft_border.checked ? "white" : "#888888"
                    text: "1 px"
                }

                PQSlider {
                    id: ft_border_w
                    enabled: ft_border.checked
                    y: (parent.height-height)/2
                    from: 1
                    to: 20
                }

                Text {
                    y: (parent.height-height)/2
                    color: ft_border.checked ? "white" : "#888888"
                    text: "20 px"
                }

            }

            Rectangle {
                enabled: ft_border.checked
                y: (parent.height-height)/2
                id: rgba_rect
                width: rgba_txt.width+20
                height: rgba_txt.height+20
                border.width: 1
                border.color: "#333333"
                opacity: ft_border.checked ? 1 : 0.5
                color: Qt.rgba(rgba[0]/255, rgba[1]/255, rgba[2]/255, rgba[3]/255)
                Text {
                    id: rgba_txt
                    x: 10
                    y: 10
                    color: "white"
                    style: Text.Outline
                    styleColor: "black"
                    text: "rgba = %1, %2, %3, %4".arg(rgba[0]).arg(rgba[1]).arg(rgba[2]).arg(rgba[3])
                }
                PQMouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    tooltip: "Click to change color"
                    onClicked: {
                        colorDialog.color = Qt.rgba(rgba[0]/255, rgba[1]/255, rgba[2]/255, rgba[3]/255)
                        colorDialog.visible = true
                        settingsmanager_top.modalWindowOpen = true
                    }
                }
            }

        }

    ]

    ColorDialog {
        id: colorDialog
        title: "Please choose a color"
        showAlphaChannel: true
        modality: Qt.ApplicationModal
        onAccepted:
            rgba = handlingGeneral.convertHexToRgba(colorDialog.color)
        onRejected: {
            console.log("Canceled")
        }
    }

    Connections {

        target: settingsmanager_top

        onLoadAllSettings: {
            load()
        }

        onSaveAllSettings: {
            PQSettings.peopleTagInMetaBorderAroundFace = ft_border.checked
            PQSettings.peopleTagInMetaBorderAroundFaceWidth = ft_border_w.value
            PQSettings.peopleTagInMetaBorderAroundFaceColor = handlingGeneral.convertRgbaToHex(rgba)
        }

    }

    Component.onCompleted: {
        load()
    }

    function load() {
        ft_border.checked = PQSettings.peopleTagInMetaBorderAroundFace
        ft_border_w.value = PQSettings.peopleTagInMetaBorderAroundFaceWidth
        rgba = handlingGeneral.convertHexToRgba(PQSettings.peopleTagInMetaBorderAroundFaceColor)
    }

}
