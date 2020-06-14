import QtQuick 2.9
import QtQuick.Controls 2.2

import "../../../elements"

PQSetting {
    title: "Fit in Window"
    helptext: "Zoom smaller images to fill the full window width and/or height."
    content: [

        PQCheckbox {
            id: fitinwin
            text: "Fit smaller images in window"
        }

    ]

    Connections {

        target: settingsmanager_top

        onLoadAllSettings: {
            fitinwin.checked = PQSettings.fitInWindow
        }

        onSaveAllSettings: {
            PQSettings.fitInWindow = fitinwin.checked
        }

    }

}
