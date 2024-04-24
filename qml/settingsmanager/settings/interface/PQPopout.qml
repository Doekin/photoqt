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
// - interfacePopoutMainMenu
// - interfacePopoutMetadata
// - interfacePopoutHistogram
// - interfacePopoutScale
// - interfacePopoutSlideshowSetup
// - interfacePopoutSlideshowControls
// - interfacePopoutFileRename
// - interfacePopoutFileDelete
// - interfacePopoutAbout
// - interfacePopoutImgur
// - interfacePopoutWallpaper
// - interfacePopoutFilter
// - interfacePopoutSettingsManager
// - interfacePopoutExport
// - interfacePopoutChromecast
// - interfacePopoutAdvancedSort
// - interfacePopoutMapCurrent
// - interfacePopoutMapExplorer
// - interfacePopoutFileDialog
// - interfacePopoutMapExplorerNonModal
// - interfacePopoutFileDialogNonModal
// - interfacePopoutWhenWindowIsSmall
// - interfacePopoutSettingsManagerNonModal

Flickable {

    id: setting_top

    anchors.fill: parent
    anchors.margins: 10

    contentHeight: contcol.height

    property bool settingChanged: false
    property bool settingsLoaded: false

    ScrollBar.vertical: PQVerticalScrollBar {}

    //: Used as identifying name for one of the elements in the interface
    property var pops: [["interfacePopoutFileDialog", qsTranslate("settingsmanager", "File dialog")],
                        //: Used as identifying name for one of the elements in the interface
                        ["interfacePopoutMapExplorer", qsTranslate("settingsmanager", "Map explorer")],
                        //: Used as identifying name for one of the elements in the interface
                        ["interfacePopoutSettingsManager", qsTranslate("settingsmanager", "Settings manager")],
                        //: Used as identifying name for one of the elements in the interface
                        ["interfacePopoutMainMenu", qsTranslate("settingsmanager", "Main menu")],
                        //: Used as identifying name for one of the elements in the interface
                        ["interfacePopoutMetadata", qsTranslate("settingsmanager", "Metadata")],
                        //: Used as identifying name for one of the elements in the interface
                        ["interfacePopoutHistogram", qsTranslate("settingsmanager", "Histogram")],
                        //: Used as identifying name for one of the elements in the interface
                        ["interfacePopoutMapCurrent", qsTranslate("settingsmanager", "Map (current image)")],
                        //: Used as identifying name for one of the elements in the interface
                        ["interfacePopoutScale", qsTranslate("settingsmanager", "Scale")],
                        //: Used as identifying name for one of the elements in the interface
                        ["interfacePopoutSlideshowSetup", qsTranslate("settingsmanager", "Slideshow setup")],
                        //: Used as identifying name for one of the elements in the interface
                        ["interfacePopoutSlideshowControls", qsTranslate("settingsmanager", "Slideshow controls")],
                        //: Used as identifying name for one of the elements in the interface
                        ["interfacePopoutFileRename", qsTranslate("settingsmanager", "Rename file")],
                        //: Used as identifying name for one of the elements in the interface
                        ["interfacePopoutFileDelete", qsTranslate("settingsmanager", "Delete file")],
                        //: Used as identifying name for one of the elements in the interface
                        ["interfacePopoutExport", qsTranslate("settingsmanager", "Export file")],
                        //: Used as identifying name for one of the elements in the interface
                        ["interfacePopoutAbout", qsTranslate("settingsmanager", "About")],
                        //: Used as identifying name for one of the elements in the interface
                        ["interfacePopoutImgur", qsTranslate("settingsmanager", "Imgur")],
                        //: Used as identifying name for one of the elements in the interface
                        ["interfacePopoutWallpaper", qsTranslate("settingsmanager", "Wallpaper")],
                        //: Noun, not a verb. Used as identifying name for one of the elements in the interface
                        ["interfacePopoutFilter", qsTranslate("settingsmanager", "Filter")],
                        //: Used as identifying name for one of the elements in the interface
                        ["interfacePopoutAdvancedSort", qsTranslate("settingsmanager", "Advanced image sort")],
                        //: Used as identifying name for one of the elements in the interface
                        ["interfacePopoutChromecast", qsTranslate("settingsmanager", "Streaming (Chromecast)")],
                        //: Used as identifying name for one of the elements in the interface
                        ["interfaceMinimapPopout", qsTranslate("settingsmanager", "Minimap")]]

    property var currentCheckBoxStates: ["0","0","0","0","0",
                                         "0","0","0","0","0",
                                         "0","0","0","0","0",
                                         "0","0","0","0","0"]
    property string _defaultCurrentCheckBoxStates: ""
    onCurrentCheckBoxStatesChanged:
        checkDefault()

    signal popoutLoadDefault()
    signal popoutSaveChanges()

    signal selectAllPopouts()
    signal selectNoPopouts()
    signal invertPopoutSelection()

    Column {

        id: contcol

        x: (parent.width-width)/2

        spacing: 10

        PQSetting {

            //: Settings title
            title: qsTranslate("settingsmanager", "Popout")

            helptext: qsTranslate("settingsmanager",  "Almost all of the elements for displaying information or performing actions can either be shown integrated into the main window or shown popped out in their own window. Most of them can also be popped out/in through a small button at the top left corner of each elements.")

            content: [

                Rectangle {

                    width: Math.min(parent.width, 600)
                    height: 350
                    color: "transparent"
                    border.width: 1
                    border.color: PQCLook.baseColorHighlight

                    PQLineEdit {
                        id: popout_filter
                        width: parent.width
                        //: placeholder text in a text edit
                        placeholderText: qsTranslate("settingsmanager", "Filter popouts")
                        onControlActiveFocusChanged: {
                            if(popout_filter.controlActiveFocus) {
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

                        id: popout_flickable

                        x: 5
                        y: popout_filter.height
                        width: parent.width - (popout_scroll.visible ? 5 : 10)
                        height: parent.height-popout_filter.height-popout_buts.height

                        contentHeight: popout_col.height
                        clip: true

                        ScrollBar.vertical: PQVerticalScrollBar { id: popout_scroll }

                        Grid {

                            id: popout_col
                            spacing: 5

                            columns: 3
                            padding: 5

                            Repeater {

                                model: pops.length

                                Rectangle {

                                    id: deleg

                                    property bool matchesFilter: (popout_filter.text===""||pops[index][1].toLowerCase().indexOf(popout_filter.text.toLowerCase()) > -1)

                                    width: (popout_flickable.width - (popout_scroll.visible ? popout_scroll.width : 0))/3 - popout_col.spacing
                                    height: matchesFilter ? 30 : 0
                                    opacity: matchesFilter ? 1 : 0
                                    radius: 5

                                    Behavior on height { NumberAnimation { duration: 200 } }
                                    Behavior on opacity { NumberAnimation { duration: 150 } }

                                    property bool hovered: false

                                    color: hovered||check.checked ? PQCLook.baseColorActive : PQCLook.baseColorHighlight
                                    Behavior on color { ColorAnimation { duration: 200 } }

                                    ToolTip {
                                        delay: 500
                                        timeout: 5000
                                        visible: deleg.hovered
                                        text: pops[index][1]
                                    }

                                    PQCheckBox {
                                        id: check
                                        x: 10
                                        width: deleg.width-20
                                        y: (parent.height-height)/2
                                        text: pops[index][1]
                                        font.weight: PQCLook.fontWeightNormal
                                        font.pointSize: PQCLook.fontSizeS
                                        elide: Text.ElideRight
                                        color: PQCLook.textColor
                                        onCheckedChanged: {
                                            currentCheckBoxStates[index] = (checked ? "1" : "0")
                                            currentCheckBoxStatesChanged()
                                        }

                                        Connections {
                                            target: setting_top
                                            function onSelectAllPopouts() {
                                                check.checked = true
                                            }
                                            function onSelectNoPopouts() {
                                                check.checked = false
                                            }
                                            function onInvertPopoutSelection() {
                                                check.checked = !check.checked
                                            }
                                        }

                                    }

                                    PQMouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        onEntered:
                                            deleg.hovered = true
                                        onExited:
                                            deleg.hovered = false
                                        onClicked:
                                            check.checked = !check.checked
                                    }

                                    Connections {

                                        target: setting_top

                                        function onPopoutLoadDefault() {
                                            check.checked = PQCSettings[pops[index][0]]
                                        }

                                        function onPopoutSaveChanges() {
                                            PQCSettings[pops[index][0]] = check.checked
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

                        id: popout_buts
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
                                width: (popout_buts.width-20)/3
                                //: written on button
                                text: qsTranslate("settingsmanager", "Select all")
                                smallerVersion: true
                                onClicked:
                                    setting_top.selectAllPopouts()
                            }
                            PQButton {
                                width: (popout_buts.width-20)/3
                                //: written on button
                                text: qsTranslate("settingsmanager", "Select none")
                                smallerVersion: true
                                onClicked:
                                    setting_top.selectNoPopouts()
                            }
                            PQButton {
                                width: (popout_buts.width-20)/3
                                //: written on button, referring to inverting the selected options
                                text: qsTranslate("settingsmanager", "Invert")
                                smallerVersion: true
                                onClicked:
                                    setting_top.invertPopoutSelection()
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

            id: set_keep

            //: Settings title
            title: qsTranslate("settingsmanager", "Non-modal popouts")

            helptext: qsTranslate("settingsmanager", "All popouts by default are modal windows. That means that they block the main interface until they are closed again. Some popouts can be switched to a non-modal behavior, allowing them to stay open while using the main interface.") + "<br><br>" + qsTranslate("settingsmanager", "Please note: If a popout is set to be non-modal then it will not be able to receive any shortcut commands anymore.")

            content: [

                PQCheckBox {
                    id: keepopen_fd_check
                    enforceMaxWidth: set_keep.rightcol
                    text: qsTranslate("settingsmanager", "make file dialog non-modal")
                    onCheckedChanged:
                        checkDefault()
                },

                PQCheckBox {
                    id: keepopen_me_check
                    enforceMaxWidth: set_keep.rightcol
                    text: qsTranslate("settingsmanager", "make map explorer non-modal")
                    onCheckedChanged:
                        checkDefault()
                },

                PQCheckBox {
                    id: keepopen_sm_check
                    enforceMaxWidth: set_keep.rightcol
                    text: qsTranslate("settingsmanager", "make settings manager non-modal")
                    onCheckedChanged:
                        checkDefault()
                }

            ]

        }

        /**********************************************************************/
        PQSettingsSeparator {}
        /**********************************************************************/

        PQSetting {

            id: set_small

            //: Settings title
            title: qsTranslate("settingsmanager", "Pop out when window is small")

            helptext: qsTranslate("settingsmanager",  "Some elements might not be as usable or function well when the window is too small. Thus it is possible to force such elements to be popped out automatically whenever the application window is too small.")

            content: [

                PQCheckBox {
                    id: checksmall
                    enforceMaxWidth: set_small.rightcol
                    text: qsTranslate("settingsmanager",  "pop out when application window is small")
                    onCheckedChanged:
                        checkDefault()
                }

            ]

        }

        Item {
            width: 1
            height: 10
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

        if(keepopen_fd_check.hasChanged() || keepopen_me_check.hasChanged() || keepopen_sm_check.hasChanged() || checksmall.hasChanged()) {
            settingChanged = true
            return
        }

        settingChanged = false

    }

    Timer {
        interval: 300
        id: loadtimer
        onTriggered: {

            setting_top.popoutLoadDefault()

            keepopen_fd_check.loadAndSetDefault(PQCSettings.interfacePopoutFileDialogNonModal)
            keepopen_me_check.loadAndSetDefault(PQCSettings.interfacePopoutMapExplorerNonModal)
            keepopen_sm_check.loadAndSetDefault(PQCSettings.interfacePopoutSettingsManagerNonModal)
            checksmall.loadAndSetDefault(PQCSettings.interfacePopoutWhenWindowIsSmall)

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
    }

    function applyChanges() {

        setting_top.popoutSaveChanges()
        PQCSettings.interfacePopoutFileDialogNonModal = keepopen_fd_check.checked
        PQCSettings.interfacePopoutMapExplorerNonModal = keepopen_me_check.checked
        PQCSettings.interfacePopoutSettingsManagerNonModal = keepopen_sm_check.checked
        PQCSettings.interfacePopoutWhenWindowIsSmall = checksmall.checked

        _defaultCurrentCheckBoxStates = currentCheckBoxStates.join("")
        keepopen_fd_check.saveDefault()
        keepopen_me_check.saveDefault()
        keepopen_sm_check.saveDefault()
        checksmall.saveDefault()

        settingChanged = false

    }

    function revertChanges() {
        load()
    }

}
