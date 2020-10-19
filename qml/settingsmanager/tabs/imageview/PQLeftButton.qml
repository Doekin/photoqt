import QtQuick 2.9
import QtQuick.Controls 2.2

import "../../../elements"

PQSetting {
    //: A settings title
    title: em.pty+qsTranslate("settingsmanager", "left mouse button")
    helptext: em.pty+qsTranslate("settingsmanager", "The left button of the mouse is by default used to move the image around. However, this prevents the left mouse button from being used for shortcuts.")
    expertmodeonly: true
    content: [

        PQCheckbox {
            id: left_check
            text: em.pty+qsTranslate("settingsmanager", "use left button to move image")
        }

    ]

    Connections {

        target: settingsmanager_top

        onLoadAllSettings: {
            load()
        }

        onSaveAllSettings: {
            PQSettings.leftButtonMouseClickAndMove = left_check.checked
        }

    }

    Component.onCompleted: {
        load()
    }

    function load() {
        left_check.checked = PQSettings.leftButtonMouseClickAndMove
    }

}
