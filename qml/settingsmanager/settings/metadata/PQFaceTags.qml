/**************************************************************************
 **                                                                      **
 ** Copyright (C) 2011-2024 Lukas Spies                                  **
 ** Contact: https://photoqt.org                                         **
 **                                                                      **
 ** This file is part of PhotoQt.                                        **
 **                                                                      **
 ** PhotoQt is free software: you can redistribute it and/or modify      **
 ** it under the terms of the GNU General Public License as published by **
 ** the Free Software Foundation, either version 2 of the License, or    **
 ** (at your option) any later version.                                  **
 **                                                                      **
 ** PhotoQt is distributed in the hope that it will be useful,           **
 ** but WITHOUT ANY WARRANTY; without even the implied warranty of       **
 ** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        **
 ** GNU General Public License for more details.                         **
 **                                                                      **
 ** You should have received a copy of the GNU General Public License    **
 ** along with PhotoQt. If not, see <http://www.gnu.org/licenses/>.      **
 **                                                                      **
 **************************************************************************/

import QtQuick
import QtQuick.Controls

import PQCScriptsOther
import PQCNotify

import "../../../elements"

// required top level properties for all settings:
//
// 1) property bool settingChanged
// 2) function applyChanges()
// 3) function revertChanges()

// settings in this file:
// - metadataFaceTagsVisibility
// - metadataFaceTagsBorder
// - metadataFaceTagsBorderColor
// - metadataFaceTagsBorderWidth
// - metadataFaceTagsFontSize
// - metadataFaceTagsEnabled

Flickable {

    id: setting_top

    anchors.fill: parent
    anchors.margins: 10

    contentHeight: contcol.height

    property bool settingChanged: false
    property bool settingsLoaded: false

    ScrollBar.vertical: PQVerticalScrollBar {}

    Column {

        id: contcol

        width: parent.width

        spacing: 10

        PQSetting {

            //: Settings title
            title: qsTranslate("settingsmanager", "Show face tags")

            helptext: qsTranslate("settingsmanager", "PhotoQt can read face tags stored in its metadata. It offers a great deal of flexibility in how and when the face tags are shown. It is also possible to remove and add face tags using the face tagger interface (accessible through the context menu or by shortcut).")

            content: [
                PQCheckBox {
                    id: facetags_show
                    text: qsTranslate("settingsmanager", "Show face tags")
                    onCheckedChanged: checkDefault()
                }
            ]

        }

        /**********************************************************************/
        PQSettingsSeparator {}
        /**********************************************************************/

        PQSetting {

            //: Settings title
            title: qsTranslate("settingsmanager", "Look")

            helptext: qsTranslate("settingsmanager", "It is possible to adjust the border shown around tagged faces and the font size used for the displayed name. For the border, not only the width but also the color can be specified.")

            content: [

                PQSpinBoxAdvanced {
                    id: fontsize
                    minval: 5
                    maxval: 50
                    title: qsTranslate("settingsmanager", "font size:")
                    suffix: " pt"
                    onValueChanged:
                        checkDefault()
                },

                PQCheckBox {
                    id: border_show
                    text: qsTranslate("settingsmanager", "Show border around face tags")
                    onCheckedChanged: checkDefault()
                },

                Column {

                    spacing: 10

                    clip: true
                    enabled: border_show.checked
                    height: enabled ? (border_slider.height+border_color.height+spacing) : 0
                    Behavior on height { NumberAnimation { duration: 200 } }
                    opacity: enabled ? 1 : 0
                    Behavior on opacity { NumberAnimation { duration: 150 } }

                    PQSpinBoxAdvanced {
                        id: border_slider
                        minval: 1
                        maxval: 20
                        title: qsTranslate("settingsmanager", "border width:")
                        suffix: " px"
                        onValueChanged:
                            checkDefault()
                    }

                    Rectangle {
                        id: border_color
                        property var rgba: PQCScriptsOther.convertHexToRgba(PQCSettings.metadataFaceTagsBorderColor)
                        onRgbaChanged: checkDefault()
                        width: coltxt.width+100
                        height: coltxt.height+50
                        color: Qt.rgba(rgba[0]/255, rgba[1]/255, rgba[2]/255, rgba[3]/255)
                        Rectangle {
                            x: 45
                            y: 20
                            width: coltxt.width+10
                            height: coltxt.height+10
                            radius: 5
                            color: "#88000000"
                            PQText {
                                id: coltxt
                                x: 5
                                y: 5
                                textFormat: Text.RichText
                                text: "<table><tr><td>" + qsTranslate("settingsmanager", "red") + "</td><td>=</td><td>" + border_color.rgba[0] + "</td><td>&nbsp;(" + (100*border_color.rgba[0]/255).toFixed(0) + "%)</td></tr>" +
                                      "<tr><td>" + qsTranslate("settingsmanager", "green") + "</td><td>=</td><td>" + border_color.rgba[1] + "</td><td>&nbsp;(" + (100*border_color.rgba[1]/255).toFixed(0) + "%)</td></tr>" +
                                      "<tr><td>" + qsTranslate("settingsmanager", "blue") + "</td><td>=</td><td>" + border_color.rgba[2] + "</td><td>&nbsp;(" + (100*border_color.rgba[2]/255).toFixed(0) + "%)</td></tr>" +
                                      "<tr><td>" + qsTranslate("settingsmanager", "alpha") + "</td><td>=</td><td>" + border_color.rgba[3] + "</td><td>&nbsp;(" + (100*border_color.rgba[3]/255).toFixed(0) + "%)</td></tr></table>"
                            }
                        }

                        PQMouseArea {
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                PQCNotify.modalFileDialogOpen = true
                                var newcol = PQCScriptsOther.selectColor(parent.rgba)
                                PQCNotify.modalFileDialogOpen = false
                                if(newcol.length !== 0) {
                                    parent.rgba = newcol
                                }
                            }
                        }

                    }

                }

            ]

        }

        /**********************************************************************/
        PQSettingsSeparator {}
        /**********************************************************************/

        PQSetting {

            //: Settings title
            title: qsTranslate("settingsmanager", "Visibility")

            helptext: qsTranslate("settingsmanager", "The face tags can be shown under different conditions. It is possible to always show all face tags, to show all face tags when the mouse cursor is moving across the image, or to show an individual face tag only when the mouse cursor is above a face tags.")

            content: [

                PQRadioButton {
                    id: tags_always
                    //: used as in: always show all face tags
                    text: qsTranslate("settingsmanager", "always show all")
                    onCheckedChanged: checkDefault()
                },

                PQRadioButton {
                    id: tags_one
                    //: used as in: show one face tag on hover
                    text: qsTranslate("settingsmanager", "show one on hover")
                    onCheckedChanged: checkDefault()
                },

                PQRadioButton {
                    id: tags_all
                    //: used as in: show one face tag on hover
                    text: qsTranslate("settingsmanager", "show all on hover")
                    onCheckedChanged: checkDefault()
                }

            ]

        }

    }

    Component.onCompleted:
        load()

    function checkDefault() {

        if(!settingsLoaded) return
        if(PQCSettings.generalAutoSaveSettings) {
            applyChanges()
            return
        }

        settingChanged = (facetags_show.hasChanged() || fontsize.hasChanged() || border_show.hasChanged() ||
                          border_slider.hasChanged() || tags_always.hasChanged() || tags_one.hasChanged() ||
                          tags_all.hasChanged() ||
                          border_color.rgba !== PQCScriptsOther.convertHexToRgba(PQCSettings.metadataFaceTagsBorderColor))

    }

    function load() {

        facetags_show.loadAndSetDefault(PQCSettings.metadataFaceTagsEnabled)

        fontsize.loadAndSetDefault(PQCSettings.metadataFaceTagsFontSize)
        border_show.loadAndSetDefault(PQCSettings.metadataFaceTagsBorder)
        border_slider.loadAndSetDefault(PQCSettings.metadataFaceTagsBorderWidth)
        border_color.rgba = PQCScriptsOther.convertHexToRgba(PQCSettings.metadataFaceTagsBorderColor)

        tags_always.loadAndSetDefault(PQCSettings.metadataFaceTagsVisibility===1)
        tags_one.loadAndSetDefault(PQCSettings.metadataFaceTagsVisibility===2)
        tags_all.loadAndSetDefault(PQCSettings.metadataFaceTagsVisibility===3)

        settingChanged = false
        settingsLoaded = true

    }

    function applyChanges() {

        PQCSettings.metadataFaceTagsEnabled = facetags_show.checked

        PQCSettings.metadataFaceTagsFontSize = fontsize.value
        PQCSettings.metadataFaceTagsBorder = border_show.checked
        PQCSettings.metadataFaceTagsBorderWidth = border_slider.value
        PQCSettings.metadataFaceTagsBorderColor = PQCScriptsOther.convertRgbaToHex(border_color.rgba)

        if(tags_always.checked)
            PQCSettings.metadataFaceTagsVisibility = 1
        else if(tags_one.checked)
            PQCSettings.metadataFaceTagsVisibility = 2
        else
            PQCSettings.metadataFaceTagsVisibility = 3

        facetags_show.saveDefault()
        fontsize.saveDefault()
        border_show.saveDefault()
        border_slider.saveDefault()
        tags_always.saveDefault()
        tags_one.saveDefault()
        tags_all.saveDefault()

        settingChanged = false

    }

    function revertChanges() {
        load()
    }

}
