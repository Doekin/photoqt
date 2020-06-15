import QtQuick 2.9
import QtQuick.Controls 2.2

import "../../../elements"

PQSetting {
    id: set
    title: "Quick info"
    helptext: "The quick info refers to the labels along the top edge of the main view."
    content: [

        PQCheckbox {
            id: quick_show
            text: "Show quick info"
            opacity: variables.settingsManagerExpertMode ? 0 : 1
            Behavior on opacity { NumberAnimation { duration: 200 } }
            visible: opacity > 0
            property bool skipCheckedCheck: false
            onCheckedChanged: {
                if(!skipCheckedCheck) {
                    if(checked) {
                        quick_counter.checked = true
                        quick_filepath.checked = false
                        quick_filename.checked = true
                        quick_zoom.checked = true
                        quick_exit.checked = true
                    } else {
                        quick_counter.checked = false
                        quick_filepath.checked = false
                        quick_filename.checked = false
                        quick_zoom.checked = false
                        quick_exit.checked = false
                    }
                }
            }
        },

        Column {

            spacing: 15

            Flow {
                id: quick_flow
                width: set.contwidth
                spacing: 10
                opacity: variables.settingsManagerExpertMode ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 200 } }
                visible: opacity > 0

                PQCheckbox {
                    y: (parent.height-height)/2
                    id: quick_counter
                    text: "Counter"
                    onCheckedChanged: {
                        quick_show.skipCheckedCheck = true
                        quick_show.checked = (howManyChecked() > 0)
                        quick_show.skipCheckedCheck = false
                    }

                }

                PQCheckbox {
                    y: (parent.height-height)/2
                    id: quick_filepath
                    text: "Filepath"
                    onCheckedChanged: {
                        quick_show.skipCheckedCheck = true
                        quick_show.checked = (howManyChecked() > 0)
                        quick_show.skipCheckedCheck = false
                    }
                }

                PQCheckbox {
                    y: (parent.height-height)/2
                    id: quick_filename
                    text: "Filename"
                    onCheckedChanged: {
                        quick_show.skipCheckedCheck = true
                        quick_show.checked = (howManyChecked() > 0)
                        quick_show.skipCheckedCheck = false
                    }
                }

                PQCheckbox {
                    y: (parent.height-height)/2
                    id: quick_zoom
                    text: "Current zoom level"
                    onCheckedChanged: {
                        quick_show.skipCheckedCheck = true
                        quick_show.checked = (howManyChecked() > 0)
                        quick_show.skipCheckedCheck = false
                    }
                }

                PQCheckbox {
                    y: (parent.height-height)/2
                    id: quick_exit
                    text: "Exit button"
                    onCheckedChanged: {
                        quick_show.skipCheckedCheck = true
                        quick_show.checked = (howManyChecked() > 0)
                        quick_show.skipCheckedCheck = false
                    }
                }

            }

            Row {
                spacing: 5
                width: parent.width
                opacity: variables.settingsManagerExpertMode ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 200 } }
                visible: opacity > 0
                Text {
                    y: (parent.height-height)/2
                    color: "white"
                    text: "Size of exit button:"
                }
                PQSlider {
                    id: quick_exitsize
                    y: (parent.height-height)/2
                    from: 5
                    to: 25
                }
            }

        }

    ]

    function howManyChecked() {
        var howmany = 0
        if(quick_counter.checked) howmany += 1
        if(quick_filepath.checked) howmany += 1
        if(quick_filename.checked) howmany += 1
        if(quick_zoom.checked) howmany += 1
        if(quick_exit.checked) howmany += 1
        return howmany
    }

    Connections {

        target: settingsmanager_top

        onLoadAllSettings: {
            quick_counter.checked = !PQSettings.quickInfoHideCounter
            quick_filepath.checked = !PQSettings.quickInfoHideFilepath
            quick_filename.checked = !PQSettings.quickInfoHideFilename
            quick_zoom.checked = !PQSettings.quickInfoHideZoomLevel
            quick_exit.checked = !PQSettings.quickInfoHideX

            quick_exitsize.value = PQSettings.quickInfoCloseXSize

            if(howManyChecked() == 0)
                quick_show.checked = false
            else
                quick_show.checked = true
        }

        onSaveAllSettings: {

            PQSettings.quickInfoHideCounter = !quick_counter.checked
            PQSettings.quickInfoHideFilepath = !quick_filepath.checked
            PQSettings.quickInfoHideFilename = !quick_filename.checked
            PQSettings.quickInfoHideZoomLevel = !quick_zoom.checked
            PQSettings.quickInfoHideX = !quick_exit.checked

            PQSettings.quickInfoCloseXSize = quick_exitsize.value

        }

    }

}
