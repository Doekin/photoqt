import QtQuick 2.9
import QtQuick.Controls 2.2

import "../../../elements"

PQSetting {
    title: "lift up"
    helptext: "How many pixels to lift up thumbnails when either hovered or active."
    content: [

        Row {

            spacing: 10

            Text {
                y: (parent.height-height)/2
                color: "white"
                text: "0 px"
            }

            PQSlider {
                id: liftup
                y: (parent.height-height)/2
                from: 0
                to: 100
                toolTipSuffix: " px"
            }

            Text {
                y: (parent.height-height)/2
                color: "white"
                text: "100 px"
            }

        }

    ]

    Connections {

        target: settingsmanager_top

        onLoadAllSettings: {
            load()
        }

        onSaveAllSettings: {
            PQSettings.thumbnailLiftUp = liftup.value
        }

    }

    Component.onCompleted: {
        load()
    }

    function load() {
        liftup.value = PQSettings.thumbnailLiftUp
    }

}
