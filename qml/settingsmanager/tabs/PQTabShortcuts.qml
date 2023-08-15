/**************************************************************************
 **                                                                      **
 ** Copyright (C) 2011-2023 Lukas Spies                                  **
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

import QtQuick 2.9
import QtQuick.Controls 2.2

import "./shortcuts"
import "../../elements"
import "../../modal"

Item {

    id: tab_shortcuts

    property var actions: {

        // IMAGE VIEWING

                                 //: Name of shortcut action
        "__next":               [em.pty+qsTranslate("settingsmanager_shortcuts", "Next image"), "viewingimages"],
                                 //: Name of shortcut action
        "__prev":               [em.pty+qsTranslate("settingsmanager_shortcuts", "Previous image"), "viewingimages"],
                                 //: Name of shortcut action
        "__goToFirst":          [em.pty+qsTranslate("settingsmanager_shortcuts", "Go to first image"), "viewingimages"],
                                 //: Name of shortcut action
        "__goToLast":           [em.pty+qsTranslate("settingsmanager_shortcuts", "Go to last image"), "viewingimages"],
                                 //: Name of shortcut action
        "__zoomIn":             [em.pty+qsTranslate("settingsmanager_shortcuts", "Zoom In"), "viewingimages"],
                                 //: Name of shortcut action
        "__zoomOut":            [em.pty+qsTranslate("settingsmanager_shortcuts", "Zoom Out"), "viewingimages"],
                                 //: Name of shortcut action
        "__zoomActual":         [em.pty+qsTranslate("settingsmanager_shortcuts", "Zoom to Actual Size"), "viewingimages"],
                                 //: Name of shortcut action
        "__zoomReset":          [em.pty+qsTranslate("settingsmanager_shortcuts", "Reset Zoom"), "viewingimages"],
                                 //: Name of shortcut action
        "__rotateR":            [em.pty+qsTranslate("settingsmanager_shortcuts", "Rotate Right"), "viewingimages"],
                                 //: Name of shortcut action
        "__rotateL":            [em.pty+qsTranslate("settingsmanager_shortcuts", "Rotate Left"), "viewingimages"],
                                 //: Name of shortcut action
        "__rotate0":            [em.pty+qsTranslate("settingsmanager_shortcuts", "Reset Rotation"), "viewingimages"],
                                 //: Name of shortcut action
        "__flipH":              [em.pty+qsTranslate("settingsmanager_shortcuts", "Flip Horizontally"), "viewingimages"],
                                 //: Name of shortcut action
        "__flipV":              [em.pty+qsTranslate("settingsmanager_shortcuts", "Flip Vertically"), "viewingimages"],
                                 //: Name of shortcut action
        "__loadRandom":         [em.pty+qsTranslate("settingsmanager_shortcuts", "Load a random image"), "viewingimages"],
                                 //: Name of shortcut action
        "__showFaceTags":       [em.pty+qsTranslate("settingsmanager_shortcuts", "Hide/Show face tags (stored in metadata)"), "viewingimages"],
                                 //: Name of shortcut action
        "__fitInWindow":        [em.pty+qsTranslate("settingsmanager_shortcuts", "Toggle: Fit in window"), "viewingimages"],
                                 //: Name of shortcut action
        "__toggleAlwaysActualSize": [em.pty+qsTranslate("settingsmanager_shortcuts", "Toggle: Show always actual size by default"), "viewingimages"],
                                 //: Name of shortcut action
        "__chromecast":         [em.pty+qsTranslate("settingsmanager_shortcuts", "Stream content to Chromecast device"), "viewingimages"],
                                 //: Name of shortcut action
        "__moveViewLeft":       [em.pty+qsTranslate("settingsmanager_shortcuts", "Move view left"), "viewingimages"],
                                 //: Name of shortcut action
        "__moveViewRight":      [em.pty+qsTranslate("settingsmanager_shortcuts", "Move view right"), "viewingimages"],
                                 //: Name of shortcut action
        "__moveViewUp":         [em.pty+qsTranslate("settingsmanager_shortcuts", "Move view up"), "viewingimages"],
                                 //: Name of shortcut action
        "__moveViewDown":       [em.pty+qsTranslate("settingsmanager_shortcuts", "Move view down"), "viewingimages"],
                                 //: Name of shortcut action
        "__goToLeftEdge":       [em.pty+qsTranslate("settingsmanager_shortcuts", "Go to left edge of image"), "viewingimages"],
                                 //: Name of shortcut action
        "__goToRightEdge":      [em.pty+qsTranslate("settingsmanager_shortcuts", "Go to right edge of image"), "viewingimages"],
                                 //: Name of shortcut action
        "__goToTopEdge":        [em.pty+qsTranslate("settingsmanager_shortcuts", "Go to top edge of image"), "viewingimages"],
                                 //: Name of shortcut action
        "__goToBottomEdge":     [em.pty+qsTranslate("settingsmanager_shortcuts", "Go to bottom edge of image"), "viewingimages"],


        // SPECIAL ACTION WITH CURRENT IMAGE

                                 //: Name of shortcut action
        "__histogram":          [em.pty+qsTranslate("settingsmanager_shortcuts", "Show Histogram"), "currentimage"],
                                 //: Name of shortcut action
        "__showMapCurrent":     [em.pty+qsTranslate("settingsmanager_shortcuts", "Show Image on Map"), "currentimage"],
                                 //: Name of shortcut action
        "__viewerMode":         [em.pty+qsTranslate("settingsmanager_shortcuts", "Enter viewer mode"), "currentimage"],
                                 //: Name of shortcut action
        "__scale":              [em.pty+qsTranslate("settingsmanager_shortcuts", "Scale Image"), "currentimage"],
                                 //: Name of shortcut action
        "__rename":             [em.pty+qsTranslate("settingsmanager_shortcuts", "Rename File"), "currentimage"],
                                 //: Name of shortcut action
        "__delete":             [em.pty+qsTranslate("settingsmanager_shortcuts", "Delete File"), "currentimage"],
                                 //: Name of shortcut action
        "__deletePermanent":    [em.pty+qsTranslate("settingsmanager_shortcuts", "Delete File (without confirmation)"), "currentimage"],
                                 //: Name of shortcut action
        "__copy":               [em.pty+qsTranslate("settingsmanager_shortcuts", "Copy File to a New Location"), "currentimage"],
                                 //: Name of shortcut action
        "__move":               [em.pty+qsTranslate("settingsmanager_shortcuts", "Move File to a New Location"), "currentimage"],
                                 //: Name of shortcut action
        "__clipboard":          [em.pty+qsTranslate("settingsmanager_shortcuts", "Copy Image to Clipboard"), "currentimage"],
                                 //: Name of shortcut action
        "__saveAs":             [em.pty+qsTranslate("settingsmanager_shortcuts", "Save image in another format"), "currentimage"],
                                 //: Name of shortcut action
        "__print":              [em.pty+qsTranslate("settingsmanager_shortcuts", "Print current photo"), "currentimage"],
                                 //: Name of shortcut action
        "__wallpaper":          [em.pty+qsTranslate("settingsmanager_shortcuts", "Set as Wallpaper"), "currentimage"],
                                 //: Name of shortcut action
        "__imgurAnonym":        [em.pty+qsTranslate("settingsmanager_shortcuts", "Upload to imgur.com (anonymously)"), "currentimage"],
                                 //: Name of shortcut action
        "__imgur":              [em.pty+qsTranslate("settingsmanager_shortcuts", "Upload to imgur.com user account"), "currentimage"],
                                 //: Name of shortcut action
        "__playPauseAni":       [em.pty+qsTranslate("settingsmanager_shortcuts", "Play/Pause animation/video"), "currentimage"],
                                 //: Name of shortcut action
        "__tagFaces":           [em.pty+qsTranslate("settingsmanager_shortcuts", "Start tagging faces"), "currentimage"],


        // ACTION WITH CURRENT FOLDER

                                 //: Name of shortcut action
        "__open":               [em.pty+qsTranslate("settingsmanager_shortcuts", "Open file (browse images)"), "currentfolder"],
                                 //: Name of shortcut action
        "__showMapExplorer":    [em.pty+qsTranslate("settingsmanager_shortcuts", "Show map explorer"), "currentfolder"],
                                //: Name of shortcut action
        "__filterImages":       [em.pty+qsTranslate("settingsmanager_shortcuts", "Filter images in folder"), "currentfolder"],
                                 //: Name of shortcut action
        "__advancedSort":       [em.pty+qsTranslate("settingsmanager_shortcuts", "Advanced image sort (Setup)"), "currentfolder"],
                                 //: Name of shortcut action
        "__advancedSortQuick":  [em.pty+qsTranslate("settingsmanager_shortcuts", "Advanced image sort (Quickstart)"), "currentfolder"],
                                 //: Name of shortcut action
        "__slideshow":          [em.pty+qsTranslate("settingsmanager_shortcuts", "Start Slideshow (Setup)"), "currentfolder"],
                                 //: Name of shortcut action
        "__slideshowQuick":     [em.pty+qsTranslate("settingsmanager_shortcuts", "Start Slideshow (Quickstart)"), "currentfolder"],


        // INTERFACE

                                 //: Name of shortcut action
        "__contextMenu":        [em.pty+qsTranslate("settingsmanager_shortcuts", "Show Context Menu"), "interface"],
                                 //: Name of shortcut action
        "__showMainMenu":       [em.pty+qsTranslate("settingsmanager_shortcuts", "Hide/Show main menu"), "interface"],
                                 //: Name of shortcut action
        "__showMetaData":       [em.pty+qsTranslate("settingsmanager_shortcuts", "Hide/Show metadata"), "interface"],
                                 //: Name of shortcut action
        "__showThumbnails":     [em.pty+qsTranslate("settingsmanager_shortcuts", "Hide/Show thumbnails"), "interface"],
                                 //: Name of shortcut action
        "__navigationFloating": [em.pty+qsTranslate("settingsmanager_shortcuts", "Show floating navigation buttons"), "interface"],
                                 //: Name of shortcut action
        "__fullscreenToggle":   [em.pty+qsTranslate("settingsmanager_shortcuts", "Toggle fullscreen mode"), "interface"],
                                 //: Name of shortcut action
        "__close":              [em.pty+qsTranslate("settingsmanager_shortcuts", "Close window (hides to system tray if enabled)"), "interface"],
                                 //: Name of shortcut action
        "__quit":               [em.pty+qsTranslate("settingsmanager_shortcuts", "Quit PhotoQt"), "interface"],



        // OTHER ELEMENTS

                                //: Name of shortcut action
        "__settings":           [em.pty+qsTranslate("settingsmanager_shortcuts", "Show Settings"), "other"],
                                //: Name of shortcut action
        "__about":              [em.pty+qsTranslate("settingsmanager_shortcuts", "About PhotoQt"), "other"],
                                //: Name of shortcut action
        "__logging":            [em.pty+qsTranslate("settingsmanager_shortcuts", "Show log/debug messages"), "other"],
                                //: Name of shortcut action
        "__resetSession":       [em.pty+qsTranslate("settingsmanager_shortcuts", "Reset current session"), "other"],
                                //: Name of shortcut action
        "__resetSessionAndHide":[em.pty+qsTranslate("settingsmanager_shortcuts", "Reset current session and hide window"), "other"],

    }

    property var entries: []

    property var entriesHeights: []

    signal highlightEntry(var idx)

    property var handleExisting: ({})
    signal highlightExisting(var entryindex, var entryid)

    Flickable {

        id: cont

        contentHeight: col.height
        onContentHeightChanged: {
            if(visible)
                settingsmanager_top.scrollBarVisible = scroll.visible
        }

        width: stack.width
        height: stack.height

        ScrollBar.vertical: PQScrollBar { id: scroll }

        maximumFlickVelocity: 1500
        boundsBehavior: Flickable.StopAtBounds

        Column {

            id: col

            x: 10

            spacing: 15

            Item {
                width: 1
                height: 1
            }

            PQTextXL {
                id: title
                width: cont.width-30
                horizontalAlignment: Text.AlignHCenter
                font.weight: baselook.boldweight
                text: em.pty+qsTranslate("settingsmanager", "Shortcuts")
            }

            Item {
                width: 1
                height: 1
            }

            PQText {
                id: desc
                width: cont.width-30
                wrapMode: Text.WordWrap
                text: em.pty+qsTranslate("settingsmanager_shortcuts", "Here the shortcuts are managed. Shortcuts are grouped by key combination. Multiple actions can be set for each group of key combinations, with the option of cycling through them one by one, or executing all of them at the same time. When cycling through them one by one, a timeout can be set after which the cycle will be reset to the beginning. Any group that has no key combinations set will be deleted when the settings are saved.")
            }

            PQHorizontalLine { expertModeOnly: msmve.expertmodeonly }
            PQMouseWheelMoveImage { id: msmve }
            PQHorizontalLine { expertModeOnly: msmve.expertmodeonly }
            PQDoubleClick { id: dblclk }
            PQHorizontalLine { expertModeOnly: dblclk.expertmodeonly }

            PQButton {
                text: em.pty+qsTranslate("settingsmanager_shortcuts", "Add new shortcuts group")
                onClicked: {
                    tab_shortcuts.entries.unshift([[],[],1,0,0])
                    tab_shortcuts.entriesChanged()
                    highlightNew.restart()
                }
            }
            // We use a short timeout to make sure the newly added item has been added and heights updated
            Timer {
                id: highlightNew
                interval: 50
                repeat: false
                running: false
                onTriggered: {
                    ensureVisible(0)
                }
            }

            PQText {
                width: cont.width-30
                text: em.pty+qsTranslate("settingsmanager_shortcuts", "The shortcuts can be filtered by either the key combinations, shortcut actions, category, or all three. For the string search, PhotoQt will by default check if any action/key combination includes whatever string is entered. Adding a dollar sign ($) at the start or end of the search term forces a match to be either at the start or the end of a key combination or action.")
                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            }

            Row {

                spacing: 5

                PQLineEdit {
                    id: filter_combo
                    width: Math.min(800, parent.width/2)
                    enabled: (newaction.opacity!=1 && newshortcut.opacity!=1)
                    placeholderText: em.pty+qsTranslate("settingsmanager_shortcuts", "Filter key combinations")
                }

                PQLineEdit {
                    id: filter_action
                    width: (col.width-filter_combo.width)/2-20
                    enabled: (newaction.opacity!=1 && newshortcut.opacity!=1)
                    placeholderText: em.pty+qsTranslate("settingsmanager_shortcuts", "Filter shortcut actions")
                }

                PQComboBox {
                    id: filter_category
                    width: (col.width-filter_combo.width)/2-20
                    height: filter_action.height
                    model: [em.pty+qsTranslate("settingsmanager_shortcuts", "Show all categories"),
                            em.pty+qsTranslate("settingsmanager_shortcuts", "Category:") + " " + em.pty+qsTranslate("settingsmanager_shortcuts", "Viewing images"),
                            em.pty+qsTranslate("settingsmanager_shortcuts", "Category:") + " " + em.pty+qsTranslate("settingsmanager_shortcuts", "Current image"),
                            em.pty+qsTranslate("settingsmanager_shortcuts", "Category:") + " " + em.pty+qsTranslate("settingsmanager_shortcuts", "Current folder"),
                            em.pty+qsTranslate("settingsmanager_shortcuts", "Category:") + " " + em.pty+qsTranslate("settingsmanager_shortcuts", "Interface"),
                            em.pty+qsTranslate("settingsmanager_shortcuts", "Category:") + " " + em.pty+qsTranslate("settingsmanager_shortcuts", "Other"),
                            em.pty+qsTranslate("settingsmanager_shortcuts", "Category:") + " " + em.pty+qsTranslate("settingsmanager_shortcuts", "External")]
                }

            }


            Item {
                id: nothingfound
                width: col.width
                height: 100
                visible: entriesview.contentHeight==0
                PQTextL {
                    anchors.centerIn: parent
                    font.italic: true
                    font.weight: baselook.boldweight
                    opacity: 0.4
                    text: entries.length == 0 ? em.pty+qsTranslate("settingsmanager_shortcuts", "no shortcuts set") : em.pty+qsTranslate("settingsmanager_shortcuts", "no shortcuts found")
                }
            }

            ListView {

                id: entriesview

                width: cont.width
                height: childrenRect.height

                orientation: ListView.Vertical
                interactive: false

                model: tab_shortcuts.entries.length

                delegate: Rectangle {

                    id: deleg

                    width: cont.width

                    property var combos: tab_shortcuts.entries[index][0]
                    property var commands: tab_shortcuts.entries[index][1]
                    property int cycle: tab_shortcuts.entries[index][2]
                    property int cycletimeout: tab_shortcuts.entries[index][3]
                    property int simultaneous: tab_shortcuts.entries[index][4]
                    property int currentShortcutIndex: index

                    Behavior on opacity { NumberAnimation { duration: 200 } }

                    height: opacity>0 ? Math.max(ontheleft.height, ontheright.height)+behaviorcont.height : 0
                    Behavior on height { NumberAnimation { duration: 200 } }
                    visible: height>0

                    property bool deleteMe: false
                    onOpacityChanged: {
                        if(!deleteMe || opacity > 0)
                            return
                        height = 0
                    }

                    onHeightChanged: {
                        tab_shortcuts.entriesHeights[index] = height

                        if(!deleteMe || height > 0)
                            return
                        tab_shortcuts.entries.splice(deleg.currentShortcutIndex,1)
                        tab_shortcuts.entriesChanged()
                    }

                    clip: true

                    color: "#00000000"
                    Behavior on color {
                        SequentialAnimation {
                            loops: 4
                            ColorAnimation { from: "#00ffffff"; to: "#44ffffff"; duration: 400 }
                            ColorAnimation { from: "#44ffffff"; to: "#00ffffff"; duration: 400 }
                        }
                    }

                    /************************/
                    // SHORTCUT COMBOS
                    Column {
                        id: ontheleft
                        y: (ontheright.height>height ? ((ontheright.height-height)/2) : 0)
                        width: Math.min(800, parent.width/2)

                        spacing: 5

                        // key combo strings
                        Flow {

                            width: parent.width

                            padding: 5

                            Item {

                                width: ontheleft.width
                                height: deleg.combos.length==0 ? (n.height+20) : 0
                                visible: height > 0
                                opacity: height==(n.height+20) ? 1 : 0

                                Behavior on opacity { NumberAnimation { duration: 200 } }
                                Behavior on height { NumberAnimation { duration: 200 } }

                                // no key combination selected
                                PQText {
                                    id: n
                                    x: 5
                                    y: 10
                                    text: em.pty+qsTranslate("settingsmanager_shortcuts", "no key combination set")
                                    opacity: 0.4
                                    font.italic: true
                                }
                            }

                            Repeater {
                                model: deleg.combos.length
                                delegate:

                                    Item {

                                        id: combodeleg

                                        x: (parent.width-width)/2
                                        height: 60
                                        width: comborect.width+10

                                        Behavior on opacity { NumberAnimation { duration: 200 } }
                                        Behavior on width { NumberAnimation { duration: 200 } }

                                        property bool deleteMe: false
                                        onOpacityChanged: {
                                            if(deleteMe && opacity == 0)
                                                width = 0
                                        }

                                        onWidthChanged: {

                                            if(!deleteMe || width>0)
                                                return

                                            tab_shortcuts.entries[deleg.currentShortcutIndex][0].splice(index,1)
                                            tab_shortcuts.entriesChanged()

                                        }

                                        Rectangle {

                                            id: comborect

                                            x: 5
                                            y: 5
                                            height: 50
                                            width: delrect.width+combolabel.width+35
                                            radius: 10

                                            color: combomouse.containsMouse ? "#484848" : "#2f2f2f"
                                            Behavior on color { ColorAnimation { duration: 200 } }

                                            // deletion 'x' for shortcut
                                            Rectangle {
                                                id: delrect
                                                x: 15
                                                y: (parent.height-height)/2
                                                width: 20
                                                height: 20
                                                color: "#ff0000"
                                                radius: 5
                                                opacity: 0.2
                                                Behavior on opacity { NumberAnimation { duration: 200 } }
                                                Text {
                                                    anchors.centerIn: parent
                                                    font.weight: baselook.boldweight
                                                    color: "white"
                                                    text: "x"
                                                }
                                            }

                                            PQText {
                                                id: combolabel
                                                x: delrect.width+20
                                                y: (parent.height-height)/2
                                                font.weight: baselook.boldweight
                                                text: keymousestrings.translateShortcut(deleg.combos[index])
                                            }

                                            PQMouseArea {

                                                id: combomouse

                                                anchors.fill: parent
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                tooltip: em.pty+qsTranslate("settingsmanager_shortcuts", "Click to change key combination")

                                                onClicked:
                                                    newshortcut.show(deleg.currentShortcutIndex, index)

                                            }

                                            PQMouseArea {
                                                anchors.fill: delrect
                                                hoverEnabled: true
                                                cursorShape: Qt.PointingHandCursor
                                                tooltip: em.pty+qsTranslate("settingsmanager_shortcuts", "Click to delete key combination")
                                                onEntered:
                                                    delrect.opacity = 0.8
                                                onExited:
                                                    delrect.opacity = 0.2
                                                onClicked: {
                                                    combodeleg.deleteMe = true
                                                    combodeleg.opacity = 0
                                                }
                                            }
                                        }

                                    }
                            }

                            Item {

                                height: 60
                                width: addcombocont.width+6

                                Rectangle {
                                    id: addcombocont
                                    x: 3
                                    y: (parent.height-height)/2
                                    width: addcombo.width+6
                                    height: addcombo.height+6
                                    color: "#2f2f2f"
                                    radius: 5
                                    PQTextS {
                                        id: addcombo
                                        x: 3
                                        y: 3
                                        //: Written on small button, used as in: add new key combination. Please keep short!
                                        text: em.pty+qsTranslate("settingsmanager_shortcuts", "ADD")
                                    }

                                    PQMouseArea {

                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        tooltip: em.pty+qsTranslate("settingsmanager_shortcuts", "Click to add new key combination")

                                        onClicked: {
                                            newshortcut.show(deleg.currentShortcutIndex, -1)
                                        }

                                    }
                                }

                            }

                        }

                        Rectangle {

                            id: exstre

                            width: parent.width
                            height: exstre_col.height+20
                            color: "#181818"

                            opacity: 0
                            visible: opacity>0
                            Behavior on opacity { NumberAnimation { duration: 200 } }

                            SequentialAnimation {
                                loops: Animation.Infinite
                                running: exstre.visible
                                PropertyAnimation { target: exstre; property: "color"; from: "#181818"; to: "#333333"; duration: 400 }
                                PropertyAnimation { target: exstre; property: "color"; from: "#333333"; to: "#181818"; duration: 400 }
                            }

                            Connections {
                                target: tab_shortcuts
                                onHighlightExisting: {
                                    if(entryindex == index) {
                                        countdwn.s = 5
                                        undobut.entryid = entryid
                                        exstre.opacity = 1
                                    }
                                }
                            }

                            Column {

                                id: exstre_col

                                x: 5
                                y: 10
                                spacing: 10
                                width: parent.width

                                PQText {
                                    width: parent.width
                                    font.weight: baselook.boldweight
                                    wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                    text: em.pty+qsTranslate("settingsmanager_shortcuts", "The new shortcut was in use by another shortcuts group. It has been reassigned to this group.")
                                }

                                Row {

                                    x: 5
                                    spacing: 10

                                    PQButton {
                                        id: undobut
                                        property string entryid: ""
                                        text: em.pty+qsTranslate("settingsmanager_shortcuts", "Undo reassignment")
                                        onClicked: {
                                            var dat = tab_shortcuts.handleExisting[entryid]
                                            tab_shortcuts.entries[dat[0]][0].push(dat[2])
                                            tab_shortcuts.entries[dat[1]][0].splice(tab_shortcuts.entries[dat[1]][0].indexOf(dat[2]), 1)
                                            tab_shortcuts.entriesChanged()
                                            exstre.opacity = 0
                                        }
                                    }

                                    PQText {
                                        id: countdwn
                                        y: (undobut.height-height)/2
                                        property int s: 5
                                        text: s
                                        Timer {
                                            interval: 1000
                                            running: exstre.opacity==1
                                            repeat: true
                                            onTriggered: {
                                                parent.s -= 1
                                                if(parent.s == 0)
                                                    exstre.opacity = 0
                                            }
                                        }
                                    }

                                }

                            }

                        }

                    }

                    /************************/
                    // white divider
                    Rectangle {
                        x: ontheleft.width
                        width: 1
                        height: Math.max(ontheleft.height, ontheright.height)
                        color: "#555555"
                    }

                    /************************/
                    // SHORTCUT ACTIONS
                    Column {
                        id: ontheright
                        y: (ontheleft.height>height ? ((ontheleft.height-height)/2) : 0)
                        x: ontheleft.width+20
                        width: deleg.width-ontheleft.width-40

                        spacing: 5

                        Item {
                            width: 1
                            height: 5
                        }

                        Item {

                            width: ontheright.width
                            height: deleg.commands.length==0 ? (c.height+10) : 0
                            visible: opacity > 0
                            opacity: height>0 ? 1 : 0

                            Behavior on opacity { NumberAnimation { duration: 200 } }
                            Behavior on height { NumberAnimation { duration: 200 } }

                            // no shortcut action selected
                            PQText {
                                id: c
                                x: 5
                                y: (parent.height-height)/2
                                //: The action here is a shortcut action
                                text: em.pty+qsTranslate("settingsmanager_shortcuts", "no action selected")
                                opacity: 0.4
                                font.italic: true
                            }
                        }

                        // show all shortcut actions
                        Repeater {
                            model: deleg.commands.length

                            Rectangle {

                                id: cmddeleg

                                property string cmd: deleg.commands[index]

                                width: ontheright.width
                                height: c2.height+10
                                radius: 5

                                color: actmouse.containsMouse ? "#484848" : "#2f2f2f"
                                Behavior on color { ColorAnimation { duration: 200 } }

                                Behavior on opacity { NumberAnimation { duration: 200 } }
                                Behavior on height { NumberAnimation { duration: 200 } }

                                property bool deleteMe: false
                                onOpacityChanged: {
                                    if(!deleteMe || opacity > 0)
                                        return
                                    height = 0
                                }
                                onHeightChanged: {
                                    if(!deleteMe || height > 0)
                                        return
                                    tab_shortcuts.entries[deleg.currentShortcutIndex][1].splice(index,1)
                                    tab_shortcuts.entriesChanged()
                                }

                                // shortcut action
                                PQText {
                                    id: c2
                                    x: 30
                                    y: (parent.height-height)/2
                                    text: cmd.startsWith("__")                                                     //: The unknown here refers to an unknown internal action that was set as shortcut
                                                ? (cmd in tab_shortcuts.actions ? tab_shortcuts.actions[cmd][0] : ("<i>"+em.pty+qsTranslate("settingsmanager_shortcuts", "unknown:")+"</i> "+cmd))
                                                  //: This is an identifier in the shortcuts settings used to identify an external shortcut.
                                                : ("<i>" + em.pty+qsTranslate("settingsmanager_shortcuts", "external") + "</i>: " +
                                                   cmd.split(":/:/:")[0] + " " + cmd.split(":/:/:")[1] +
                                                   //: This is used for listing external commands for shortcuts, showing if the quit after checkbox has been checked
                                                   (cmd.split(":/:/:")[2]*1==1 ? " (" + em.pty+qsTranslate("settingsmanager_shortcuts", "quit after") + ")" : ""))
                                }

                                PQMouseArea {
                                    id: actmouse
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    tooltip: em.pty+qsTranslate("settingsmanager_shortcuts", "Click to change shortcut action")
                                    onClicked: {
                                        newaction.change(deleg.currentShortcutIndex, index)
                                    }
                                }

                                // deletion 'x' for action
                                Rectangle {
                                    x: 5
                                    y: (parent.height-height)/2
                                    width: 20
                                    height: 20
                                    color: "#ff0000"
                                    radius: 5
                                    opacity: 0.2
                                    Behavior on opacity { NumberAnimation { duration: 200 } }
                                    Text {
                                        anchors.centerIn: parent
                                        font.weight: baselook.boldweight
                                        color: "white"
                                        text: "x"
                                    }
                                    PQMouseArea {
                                        anchors.fill: parent
                                        hoverEnabled: true
                                        cursorShape: Qt.PointingHandCursor
                                        tooltip: em.pty+qsTranslate("settingsmanager_shortcuts", "Click to delete shortcut action")
                                        onEntered:
                                            parent.opacity = 0.8
                                        onExited:
                                            parent.opacity = 0.2
                                        onClicked: {
                                            cmddeleg.deleteMe = true
                                            cmddeleg.opacity = 0
                                        }
                                    }
                                }

                            }

                        }

                        Item {

                            height: addactioncont.height+10
                            width: addactioncont.width+6

                            Rectangle {
                                id: addactioncont
                                x: 3
                                y: 3
                                width: addaction.width+6
                                height: addaction.height+6
                                color: "#2f2f2f"
                                radius: 5
                                PQTextS {
                                    id: addaction
                                    x: 3
                                    y: 3
                                    //: Written on small button, used as in: add new shortcut action. Please keep short!
                                    text: em.pty+qsTranslate("settingsmanager_shortcuts", "ADD")
                                }

                                PQMouseArea {

                                    anchors.fill: parent
                                    hoverEnabled: true
                                    cursorShape: Qt.PointingHandCursor
                                    //: The action here is a shortcut action
                                    tooltip: em.pty+qsTranslate("settingsmanager_shortcuts", "Click to add new action")
                                    onClicked: {
                                        newaction.show(deleg.currentShortcutIndex)
                                    }

                                }
                            }

                        }


                    }

                    /************************/
                    // What to do with multiple actions
                    Rectangle {

                        id: behaviorcont

                        y: Math.max(ontheleft.height, ontheright.height)
                        width: cont.width
                        height: deleg.commands.length>1 ? behavior.height+20 : 0
                        Behavior on height { NumberAnimation { duration: 200 } }

                        visible: height>0
                        clip: true

                        color: "#1f1f1f"

                        ButtonGroup { id: radioGroup }

                        Column {
                            id: behavior
                            x: 20
                            y: 10
                            width: parent.width-2*x

                            spacing: 10

                            Row {

                                spacing: 10

                                Item {
                                    width: 1
                                    height: 1
                                }

                                PQRadioButton {
                                    id: radio_cycle
                                    //: The actions here are shortcut actions
                                    text: em.pty+qsTranslate("settingsmanager_shortcuts", "cycle through actions one by one")
                                    font.pointSize: baselook.fontsize_s
                                    checked: deleg.cycle
                                    ButtonGroup.group: radioGroup
                                }

                                Item {
                                    width: timeout_check.width
                                    height: radio_cycle.height
                                    enabled: radio_cycle.checked
                                    PQCheckbox {
                                        id: timeout_check
                                        y: (parent.height-height)/2
                                        boxWidth: 15
                                        boxHeight: 15
                                        checked: deleg.cycletimeout>0
                                        //: The cycle here is the act of cycling through shortcut actions one by one
                                        text: em.pty+qsTranslate("settingsmanager_shortcuts", "timeout for resetting cycle:")
                                        font.pointSize: baselook.fontsize_s
                                    }
                                }

                                Item {
                                    width: cycletimeout_slider.width
                                    height: radio_cycle.height
                                    PQSlider {
                                        id: cycletimeout_slider
                                        y: (parent.height-height)/2
                                        overrideBackgroundHeight: 4
                                        handleWidth: 15
                                        handleHeight: 15
                                        from: 0
                                        to: 10
                                        value: deleg.cycletimeout
                                        enabled: timeout_check.checked&&radio_cycle.checked
                                        tooltip: (value==0
                                                      //: Used in tooltip for slider in shortcuts settings
                                                    ? em.pty+qsTranslate("settingsmanager_shortcuts", "Timeout: none")
                                                       //: Used in tooltip for slider in shortcuts settings
                                                    : (em.pty+qsTranslate("settingsmanager_shortcuts", "Timeout in seconds:")+" "+value))
                                    }
                                }

                            }

                            Row {

                                spacing: 10

                                Item {
                                    width: 1
                                    height: 1
                                }

                                PQRadioButton {
                                    x: 40
                                    //: The actions here are shortcut actions
                                    text: em.pty+qsTranslate("settingsmanager_shortcuts", "run all actions at once")
                                    font.pointSize: baselook.fontsize_s
                                    ButtonGroup.group: radioGroup
                                    checked: deleg.simultaneous
                                }

                            }
                        }


                    }

                    Rectangle {
                        y: parent.height-1
                        width: parent.width
                        height: 1
                        color: "white"
                    }

                    Connections {
                        target: filter_combo
                        onTextChanged:
                            performFilter()
                    }
                    Connections {
                        target: filter_action
                        onTextChanged:
                            performFilter()
                    }
                    Connections {
                        target: filter_category
                        onCurrentIndexChanged:
                            performFilter()
                    }

                    Connections {
                        target: tab_shortcuts
                        onHighlightEntry: {
                            if(idx == deleg.currentShortcutIndex) {
                                deleg.color = "#44ffffff"
                            }
                        }
                    }

                    Component.onCompleted: {
                        tab_shortcuts.entriesHeights[index] = height
                    }

                    function performFilter() {

                        if((filter_combo.text == "" || filter_combo.text == "$") && (filter_action.text == "" || filter_action.text == "$") && filter_category.currentIndex==0) {
                            deleg.opacity = 1
                            return
                        }

                        var longcommands = []
                        for(var i in commands) {
                            var cmd = commands[i]
                            if(cmd.startsWith("__")) {
                                if(cmd in tab_shortcuts.actions)
                                    longcommands.push(tab_shortcuts.actions[cmd][0])
                                longcommands.push(cmd)
                            } else
                                longcommands.push(cmd.split(":/:/:")[0] + " " + cmd.split(":/:/:")[1] + (cmd.split(":/:/:")[2]*1==1 ? " (quit after)" : ""))
                        }

                        var vis = true

                        if(filter_combo.text != "") {
                            var c = filter_combo.text.toLowerCase()
                            var yes = false
                            for(var i = 0; i < combos.length; ++i) {
                                if(c.startsWith("$") && !c.endsWith("$")) {
                                    if(combos[i].toLowerCase().startsWith(c.substring(1)))
                                        yes = true
                                } else if(!c.startsWith("$") && c.endsWith("$")) {
                                    if(combos[i].toLowerCase().endsWith(c.substring(0,c.length-1)))
                                        yes = true
                                } else if(c.startsWith("$") && c.endsWith("$")) {
                                    if(combos[i].toLowerCase() == c.substring(1,c.length-1))
                                        yes = true
                                } else {
                                    if(combos[i].toLowerCase().includes(c))
                                        yes = true
                                }
                            }
                            if(!yes)
                                vis = false
                        }

                        if(filter_action.text != "") {
                            var c = filter_action.text.toLowerCase()
                            var yes = false
                            for(var i = 0; i < longcommands.length; ++i) {
                                if(c.startsWith("$") && !c.endsWith("$")) {
                                    if(longcommands[i].toLowerCase().startsWith(c.substring(1)))
                                        yes = true
                                } else if(!c.startsWith("$") && c.endsWith("$")) {
                                    if(longcommands[i].toLowerCase().endsWith(c.substring(0,c.length-1)))
                                        yes = true
                                } else if(c.startsWith("$") && c.endsWith("$")) {
                                    if(longcommands[i].toLowerCase() == c.substring(1,c.length-1))
                                        yes = true
                                } else {
                                    if(longcommands[i].toLowerCase().includes(c))
                                        yes = true
                                }
                            }
                            if(!yes)
                                vis = false
                        }

                        if(filter_category.currentIndex != 0) {

                            var categories = ["viewingimages","currentimage","currentfolder","interface","other","external"]
                            var filtercat = categories[filter_category.currentIndex-1]

                            var yes = false
                            for(var i = 0; i < commands.length; ++i) {
                                if(tab_shortcuts.actions[commands[i]][1] == filtercat)
                                    yes = true
                            }
                            if(!yes)
                                vis = false

                        }

                        deleg.opacity = (vis ? 1 : 0)
                    }

                }


            }


            Item {
                width: 1
                height: 20
            }

        }

    }

    PQNewAction {

        id: newaction

        onAddAction: {

            tab_shortcuts.entries[idx][1].push(act)
            tab_shortcuts.entriesChanged()

        }

        onUpdateAction: {

            tab_shortcuts.entries[idx][1][subidx] = act
            tab_shortcuts.entriesChanged()

        }

    }

    PQNewShortcut {
        id: newshortcut
        onNewCombo: {

            // this case should never actually happen
            if(combo.startsWith("Left Button")) {
                return
            }

            // first we need to check if that shortcut is already used somewhere
            var usedIndex = -1
            for(var i in tab_shortcuts.entries) {
                var combos = tab_shortcuts.entries[i][0]
                if(combos.includes(combo)) {
                    usedIndex = i
                    break
                }
            }

            // reassign shortcut, save reassignment data, and show undo button
            if(usedIndex != -1) {
                var newid = handlingGeneral.getUniqueId()
                handleExisting[newid] = [usedIndex, index, combo]
                tab_shortcuts.entries[usedIndex][0].splice(tab_shortcuts.entries[usedIndex][0].indexOf(combo), 1)
                tab_shortcuts.entriesChanged()
                tab_shortcuts.highlightExisting(index, newid)
            }

            if(subindex == -1)
                tab_shortcuts.entries[index][0].push(combo)
            else
                tab_shortcuts.entries[index][0][subindex] = combo
            tab_shortcuts.entriesChanged()

        }
    }

    Connections {

        target: settingsmanager_top

        onLoadAllSettings: {
            load()
        }

        onSaveAllSettings: {
            PQShortcuts.saveAllCurrentShortcuts(tab_shortcuts.entries)
        }

    }

    Component.onCompleted: {
        load()
    }

    function load() {
        filter_action.text = ""
        filter_combo.text = ""
        filter_category.currentIndex = 0
        tab_shortcuts.entries = PQShortcuts.getAllCurrentShortcuts()
    }

    function ensureVisible(index) {

        if(cont.contentHeight > cont.height) {

            var offset = 0
            for(var idx = 0; idx < index; ++idx)
                offset += tab_shortcuts.entriesHeights[idx]

            var cy_top = Math.min(entriesview.y + offset, cont.contentHeight-cont.height)
            var cy_bot = Math.min(entriesview.y + offset-cont.height+tab_shortcuts.entriesHeights[index], cont.contentHeight-cont.height)
            if(cont.contentY > cy_top)
                cont.contentY = cy_top
            else if(cont.contentY < cy_bot)
                cont.contentY = cy_bot

        }

        tab_shortcuts.highlightEntry(index)

    }

}
