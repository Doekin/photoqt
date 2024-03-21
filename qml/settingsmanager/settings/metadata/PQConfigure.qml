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
import PQCNotify

import "../../../elements"

// required top level properties for all settings:
//
// 1) property bool settingChanged
// 2) function applyChanges()
// 3) function revertChanges()

// settings in this file:
// - metadataGpsMap
// - metadataAutoRotation
// - metadataElementFloating

Flickable {

    id: setting_top

    anchors.fill: parent
    anchors.margins: 10

    contentHeight: contcol.height

    property bool settingChanged: false
    property bool settingsLoaded: false

    ScrollBar.vertical: PQVerticalScrollBar {}

        //: Part of the meta information about the current image.
    property var labels: [["Filename", qsTranslate("settingsmanager", "file name")],
        //: Part of the meta information about the current image.
        ["FileType", qsTranslate("settingsmanager", "file type")],
        //: Part of the meta information about the current image.
        ["FileSize", qsTranslate("settingsmanager", "file size")],
        //: Part of the meta information about the current image.
        ["ImageNumber", qsTranslate("settingsmanager", "image #/#")],
        //: Part of the meta information about the current image.
        ["Dimensions", qsTranslate("settingsmanager", "dimensions")],
        //: Part of the meta information about the current image.
        ["Copyright", qsTranslate("settingsmanager", "copyright")],
        //: Part of the meta information about the current image.
        ["ExposureTime", qsTranslate("settingsmanager", "exposure time")],
        //: Part of the meta information about the current image.
        ["Flash", qsTranslate("settingsmanager", "flash")],
        //: Part of the meta information about the current image.
        ["FLength", qsTranslate("settingsmanager", "focal length")],
        //: Part of the meta information about the current image.
        ["FNumber", qsTranslate("settingsmanager", "f-number")],
        //: Part of the meta information about the current image.
        ["Gps", qsTranslate("settingsmanager", "GPS position")],
        ["Iso", "ISO"],
        //: Part of the meta information about the current image.
        ["Keywords", qsTranslate("settingsmanager", "keywords")],
        //: Part of the meta information about the current image.
        ["LightSource", qsTranslate("settingsmanager", "light source")],
        //: Part of the meta information about the current image.
        ["Location", qsTranslate("settingsmanager", "location")],
        //: Part of the meta information about the current image.
        ["Make", qsTranslate("settingsmanager", "make")],
        //: Part of the meta information about the current image.
        ["Model", qsTranslate("settingsmanager", "model")],
        //: Part of the meta information about the current image.
        ["SceneType", qsTranslate("settingsmanager", "scene type")],
        //: Part of the meta information about the current image.
        ["Software", qsTranslate("settingsmanager", "software")],
        //: Part of the meta information about the current image.
        ["Time", qsTranslate("settingsmanager", "time photo was taken")]]

    property var currentCheckBoxStates: ["0","0","0","0","0",
                       "0","0","0","0","0",
                       "0","0","0","0","0",
                       "0","0","0","0"]
    property string _defaultCurrentCheckBoxStates: ""
    onCurrentCheckBoxStatesChanged:
    checkDefault()

    signal labelsLoadDefault()
    signal labelsSaveChanges()

    signal selectAllLabels()
    signal selectNoLabels()

    Column {

        id: contcol

        width: parent.width

        spacing: 10

        PQSetting {

            //: Settings title
            title: qsTranslate("settingsmanager", "Labels")

            helptext: qsTranslate("settingsmanager",  "Whenever an image is loaded PhotoQt tries to find as much metadata about the image as it can. The found information is then displayed in the metadata element that can be accesses either through one of the screen edges or as floating element. Since not all information might be wanted by everyone, individual information labels can be disabled.")

            content: [

                Rectangle {

                    width: Math.min(parent.width, 600)
                    height: 500
                    color: "transparent"
                    border.width: 1
                    border.color: PQCLook.baseColorHighlight

                    PQLineEdit {
                        id: labels_filter
                        width: parent.width
                        //: placeholder text in a text edit
                        placeholderText: qsTranslate("settingsmanager", "Filter labels")
                        onControlActiveFocusChanged: {
                            if(labels_filter.controlActiveFocus) {
                                PQCNotify.ignoreKeysExceptEnterEsc = true
                            } else {
                                PQCNotify.ignoreKeysExceptEnterEsc = false
                                fullscreenitem.forceActiveFocus()
                            }
                        }
                        Component.onDestruction: {
                            PQCNotify.ignoreKeysExceptEnterEsc = false
                            fullscreenitem.forceActiveFocus()
                        }
                    }

                    Flickable {

                        id: labels_flickable

                        x: 5
                        y: labels_filter.height
                        width: parent.width - (labels_scroll.visible ? 5 : 10)
                        height: parent.height-labels_filter.height-labels_buts.height

                        contentHeight: labels_col.height
                        clip: true

                        ScrollBar.vertical: PQVerticalScrollBar { id: labels_scroll }

                        Grid {

                            id: labels_col
                            spacing: 5

                            columns: 2
                            padding: 5

                            Repeater {

                                model: labels.length

                                Rectangle {

                                    id: deleg

                                    property bool matchesFilter: (labels_filter.text===""||labels[index][1].toLowerCase().indexOf(labels_filter.text.toLowerCase()) > -1)

                                    width: (labels_flickable.width - (labels_scroll.visible ? labels_scroll.width+1 : 0))/2 - labels_col.spacing
                                    height: matchesFilter ? 35 : 0
                                    opacity: matchesFilter ? 1 : 0
                                    radius: 5

                                    Behavior on height { NumberAnimation { duration: 200 } }
                                    Behavior on opacity { NumberAnimation { duration: 150 } }

                                    color: tilemouse.containsMouse||check.checked ? PQCLook.baseColorActive : PQCLook.baseColorHighlight
                                    Behavior on color { ColorAnimation { duration: 200 } }

                                    PQCheckBox {
                                        id: check
                                        x: 10
                                        y: (parent.height-height)/2
                                        text: labels[index][1]
                                        font.weight: PQCLook.fontWeightBold
                                        color: tilemouse.containsMouse||check.checked ? PQCLook.textColorActive : PQCLook.textColor
                                        onCheckedChanged: {
                                            currentCheckBoxStates[index] = (checked ? "1" : "0")
                                            currentCheckBoxStatesChanged()
                                        }

                                        Connections {
                                            target: setting_top
                                            function onSelectAllLabels() {
                                                check.checked = true
                                            }
                                            function onSelectNoLabels() {
                                                check.checked = false
                                            }
                                        }

                                    }

                                    PQMouseArea {
                                        id: tilemouse
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onClicked:
                                            check.checked = !check.checked
                                    }

                                    Connections {

                                        target: setting_top

                                        function onLabelsLoadDefault() {
                                            check.checked = PQCSettings["metadata"+labels[index][0]]
                                        }

                                        function onLabelsSaveChanges() {
                                            PQCSettings["metadata"+labels[index][0]] = check.checked
                                        }
                                    }

                                }

                            }

                            Item {
                                width: 1
                                height: 1
                            }

                        }

                    }

                    Item {

                        id: labels_buts
                        y: (parent.height-height)
                        width: parent.width
                        height: 50

                        Rectangle {
                            width: parent.width
                            height: 1
                            color: PQCLook.baseColorHighlight
                        }

                        Row {
                            x: 5
                            y: (parent.height-height)/2
                            spacing: 5
                            PQButton {
                                width: (labels_buts.width-15)/2
                                //: written on button
                                text: qsTranslate("settingsmanager", "Select all")
                                smallerVersion: true
                                onClicked:
                                    setting_top.selectAllLabels()
                            }
                            PQButton {
                                width: (labels_buts.width-15)/2
                                //: written on button
                                text: qsTranslate("settingsmanager", "Select none")
                                smallerVersion: true
                                onClicked:
                                    setting_top.selectNoLabels()
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
            title: qsTranslate("settingsmanager", "Auto Rotation")

            helptext: qsTranslate("settingsmanager",  "When an image is taken with the camera turned on its side, some cameras store that rotation in the metadata. PhotoQt can use that information to display an image the way it was meant to be viewed. Disabling this will load all photos without any rotation applied by default.")

            content: [
                PQCheckBox {
                    id: autorot
                    text: qsTranslate("settingsmanager", "Apply default rotation automatically")
                    onCheckedChanged: checkDefault()
                }
            ]

        }

        /**********************************************************************/
        PQSettingsSeparator {}
        /**********************************************************************/

        PQSetting {

            //: Settings title
            title: qsTranslate("settingsmanager", "GPS map")

            helptext: qsTranslate("settingsmanager",  "Some cameras store the location of where the image was taken in the metadata of its images. PhotoQt can use that information in multiple ways. It can show a floating embedded map with a pin on that location, and it can show the GPS coordinates in the metadata element. In the latter case, a click on the GPS coordinates will open the location in an online map service, the choice of which can be set here.")

            content: [

                PQRadioButton {
                    id: osm
                    text: "openstreetmap.org"
                    onCheckedChanged: checkDefault()
                },
                PQRadioButton {
                    id: google
                    text: "maps.google.com"
                    onCheckedChanged: checkDefault()
                },
                PQRadioButton {
                    id: bing
                    text: "bing.com/maps"
                    onCheckedChanged: checkDefault()
                }

            ]
        }

        /**********************************************************************/
        PQSettingsSeparator {}
        /**********************************************************************/

        PQSetting {

            //: Settings title
            title: qsTranslate("settingsmanager", "Floating element")

            helptext: qsTranslate("settingsmanager", "The metadata element can be show in two different ways. It can either be shown hidden behind one of the screen edges and shown when the cursor is close to said edge. Or it can be shown as floating element that can be triggered by shortcut and stays visible until manually hidden.")

            content: [

                PQRadioButton {
                    id: screenegde
                    text: qsTranslate("settingsmanager", "hide behind screen edge")
                    checked: !PQCSettings.metadataElementFloating
                    onCheckedChanged: checkDefault()
                },

                PQRadioButton {
                    id: floating
                    text: qsTranslate("settingsmanager", "use floating element")
                    checked: PQCSettings.metadataElementFloating
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

        if(_defaultCurrentCheckBoxStates !== currentCheckBoxStates.join("")) {
            settingChanged = true
            return
        }

        settingChanged = (autorot.hasChanged() || osm.hasChanged() || google.hasChanged() ||
                          bing.hasChanged() || screenegde.hasChanged() || floating.hasChanged())

    }

    Timer {
        interval: 100
        id: loadtimer
        onTriggered: {

            setting_top.labelsLoadDefault()

            saveDefaultCheckTimer.restart()

            settingChanged = false
            settingsLoaded = true
        }
    }

    Timer {
        interval: 100
        id: saveDefaultCheckTimer
        onTriggered: {
            _defaultCurrentCheckBoxStates = currentCheckBoxStates.join("")
        }
    }

    function load() {

        loadtimer.restart()

        autorot.loadAndSetDefault(PQCSettings.metadataAutoRotation)

        osm.loadAndSetDefault(PQCSettings.metadataGpsMap==="openstreetmap.org")
        google.loadAndSetDefault(PQCSettings.metadataGpsMap==="maps.google.com")
        bing.loadAndSetDefault(PQCSettings.metadataGpsMap==="bing.com/maps")

        screenegde.loadAndSetDefault(!PQCSettings.metadataElementFloating)
        floating.loadAndSetDefault(PQCSettings.metadataElementFloating)

    }

    function applyChanges() {

        setting_top.labelsSaveChanges()
        _defaultCurrentCheckBoxStates = currentCheckBoxStates.join("")

        PQCSettings.metadataAutoRotation = autorot.checked

        if(osm.checked)
            PQCSettings.metadataGpsMap = "openstreetmap.org"
        else if(google.checked)
            PQCSettings.metadataGpsMap = "maps.google.com"
        else
            PQCSettings.metadataGpsMap = "bing.com/maps"

        PQCSettings.metadataElementFloating = floating.checked

        autorot.saveDefault()
        osm.saveDefault()
        google.saveDefault()
        bing.saveDefault()
        screenegde.saveDefault()
        floating.saveDefault()

        settingChanged = false

    }

    function revertChanges() {
        load()
    }

}
