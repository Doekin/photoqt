import QtQuick 2.9
import QtQuick.Controls 2.2

import "../../../elements"

PQSetting {
    //: A settings title about the margin around the main image
    title: em.pty+qsTranslate("settingsmanager", "margin")
    helptext: em.pty+qsTranslate("settingsmanager", "How much space to show between the main image and the application border.")
    expertmodeonly: true
    content: [

        Row {

            spacing: 10

            Text {
                y: (parent.height-height)/2
                color: "white"
                //: 'none' as in 'no margin between the main image and the window edges'
                text: em.pty+qsTranslate("settingsmanager", "none")
            }

            PQSlider {
                id: marginwidth
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
            PQSettings.marginAroundImage = marginwidth.value
        }

    }

    Component.onCompleted: {
        load()
    }

    function load() {
        marginwidth.value = PQSettings.marginAroundImage
    }

}
