import QtQuick 2.9
import QtQuick.Controls 2.2

import "../../../elements"

PQSetting {
    //: A settings title.
    title: em.pty+qsTranslate("settingsmanager", "opacity")
    helptext: em.pty+qsTranslate("settingsmanager", "The opacity of the metadata element.")
    expertmodeonly: true
    content: [

        Row {

            spacing: 10

            Text {
                y: (parent.height-height)/2
                color: "white"
                text: "0%"
            }

            PQSlider {
                id: meta_opacity
                y: (parent.height-height)/2
                from: 0
                to: 100
                toolTipSuffix: "%"
            }

            Text {
                y: (parent.height-height)/2
                color: "white"
                text: "100%"
            }

        }

    ]

    Connections {

        target: settingsmanager_top

        onLoadAllSettings: {
            load()
        }

        onSaveAllSettings: {
            PQSettings.metadataOpacity = 255*meta_opacity.value/100
        }

    }

    Component.onCompleted: {
        load()
    }

    function load() {
        meta_opacity.value = Math.round(100*PQSettings.metadataOpacity/255)
    }

}
