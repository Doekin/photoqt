pragma ComponentBehavior: Bound
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
import PQCFileFolderModel
import PQCScriptsConfig
import PQCScriptsContextMenu
import PQCWindowGeometry

import "../elements"
import "../"

Rectangle {

    id: mainmenu_top

    x: setVisible ? visiblePos[0] : invisiblePos[0]
    y: setVisible ? visiblePos[1] : invisiblePos[1]
    Behavior on x { NumberAnimation { duration: dragrightMouse.enabled&&dragrightMouse.clickStart!=-1 ? 0 : 200 } }

    color: PQCLook.transColor // qmllint disable unqualified

    radius: PQCScriptsConfig.isQtAtLeast6_5() ? 0 : 5 // qmllint disable unqualified

    property PQMainWindow access_toplevel: toplevel // qmllint disable unqualified

    // visibility status
    opacity: setVisible&&windowSizeOkay ? 1 : 0
    visible: opacity>0
    Behavior on opacity { NumberAnimation { duration: 200 } }

    property int parentWidth
    property int parentHeight
    width: Math.max(400, PQCSettings.mainmenuElementSize.width) // qmllint disable unqualified
    height: Math.min(access_toplevel.height, PQCSettings.mainmenuElementSize.height) // qmllint disable unqualified

    property bool setVisible: false
    property var visiblePos: [0,0]
    property var invisiblePos: [0, 0]
    property int hotAreaSize: PQCSettings.interfaceHotEdgeSize*5 // qmllint disable unqualified
    property rect hotArea: Qt.rect(0, access_toplevel.height-hotAreaSize, access_toplevel.width, hotAreaSize)
    property bool windowSizeOkay: true

    // this is set to true/false by the popout window
    // this is a way to reliably detect whether it is used
    property bool popoutWindowUsed: false

    property bool isPopout: PQCSettings.interfacePopoutMainMenu||PQCWindowGeometry.mainmenuForcePopout // qmllint disable unqualified

    state: isPopout
           ? "popout"
           : (PQCSettings.interfaceEdgeLeftAction==="mainmenu" // qmllint disable unqualified
              ? "left"
              : (PQCSettings.interfaceEdgeRightAction==="mainmenu"
                 ? "right"
                 : "disabled" ))

    property int gap: 40

    PQBlurBackground { thisis: "mainmenu" }
    PQShadowEffect { masterItem: mainmenu_top }

    // the four states corresponding to screen edges
    states: [
        State {
            name: "left"
            PropertyChanges {
                mainmenu_top.visiblePos: [mainmenu_top.gap, mainmenu_top.gap]
                mainmenu_top.invisiblePos: [-mainmenu_top.width, mainmenu_top.gap]
                mainmenu_top.hotArea: Qt.rect(0,0,mainmenu_top.hotAreaSize, mainmenu_top.access_toplevel.height)
                mainmenu_top.windowSizeOkay: mainmenu_top.access_toplevel.width>500 && mainmenu_top.access_toplevel.height>500
            }
        },
        State {
            name: "right"
            PropertyChanges {
                mainmenu_top.visiblePos: [mainmenu_top.access_toplevel.width-mainmenu_top.width-mainmenu_top.gap, mainmenu_top.gap]
                mainmenu_top.invisiblePos: [mainmenu_top.access_toplevel.width, mainmenu_top.gap]
                mainmenu_top.hotArea: Qt.rect(mainmenu_top.access_toplevel.width-mainmenu_top.hotAreaSize, 0, mainmenu_top.hotAreaSize, mainmenu_top.access_toplevel.height)
                mainmenu_top.windowSizeOkay: mainmenu_top.access_toplevel.width>500 && mainmenu_top.access_toplevel.height>500
            }
        },
        State {
            name: "popout"
            PropertyChanges {
                mainmenu_top.setVisible: true
                mainmenu_top.hotArea: Qt.rect(0,0,0,0)
                mainmenu_top.width: mainmenu_top.parentWidth
                mainmenu_top.height: mainmenu_top.parentHeight
                mainmenu_top.windowSizeOkay: true
            }
        },
        State {
            name: "disabled"
            PropertyChanges {
                mainmenu_top.setVisible: false
                mainmenu_top.hotArea: Qt.rect(0,0,0,0)
            }
        }
    ]

    Component.onCompleted: {
        if(isPopout) {
            mainmenu_top.opacity = 1
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onWheel: (wheel) =>{
            wheel.accepted = true
        }
    }

    property bool anythingLoaded: PQCFileFolderModel.countMainView>0 // qmllint disable unqualified

    property int colwidth: width-2*flickable.anchors.margins

    property int normalEntryHeight: 20


    MouseArea {
        id: dragmouse
        width: parent.width
        height: 20
        hoverEnabled: true
        cursorShape: Qt.SizeAllCursor
        acceptedButtons: Qt.RightButton|Qt.LeftButton
        onWheel: (wheel) =>{
            wheel.accepted = true
        }
        drag.target: mainmenu_top
        drag.axis: Drag.YAxis
        drag.minimumY: 0
        drag.maximumY: toplevel.height-mainmenu_top.height // qmllint disable unqualified
    }

    Flickable {

        id: flickable

        anchors.fill: parent
        anchors.margins: 10
        anchors.topMargin: 20

        contentHeight: flickable_col.height
        contentWidth: flickable_col.width

        clip: true

        ScrollBar.vertical: PQVerticalScrollBar { }

        Column {

            id: flickable_col

            spacing: 20

            /*************************/
            // Navigation

            Rectangle {

                width: flickable.width
                height: nav_txt.height+10
                color: PQCLook.transColorHighlight // qmllint disable unqualified
                radius: 5

                PQTextXL {
                    id: nav_txt
                    x: 5
                    y: 5
                    //: This is a category in the main menu.
                    text: qsTranslate("MainMenu", "navigation")
                    font.weight: PQCLook.fontWeightBold // qmllint disable unqualified
                    opacity: 0.8
                }

            }

            Column {

                id: nav_col

                spacing: 5

                Row {

                    PQMainMenuEntry {
                        id: prevarrow
                        img: "previous.svg"
                        //: as in: PREVIOUS image. Please keep short.
                        txt: qsTranslate("MainMenu", "previous")
                        cmd: "__prev"
                        smallestWidth: mainmenu_top.colwidth/2
                        font.pointSize: PQCLook.fontSizeL // qmllint disable unqualified
                        font.weight: PQCLook.fontWeightBold // qmllint disable unqualified
                        alignCenter: true
                        menuColWidth: mainmenu_top.colwidth
                    }

                    PQMainMenuEntry {
                        id: nextarrow
                        img_end: "next.svg"
                        //: as in: NEXT image. Please keep short.
                        txt: qsTranslate("MainMenu", "next")
                        cmd: "__next"
                        smallestWidth: mainmenu_top.colwidth/2
                        font.pointSize: PQCLook.fontSizeL // qmllint disable unqualified
                        font.weight: PQCLook.fontWeightBold // qmllint disable unqualified
                        alignCenter: true
                        menuColWidth: mainmenu_top.colwidth
                    }

                }

                Row {

                    PQMainMenuEntry {
                        img: "first.svg"
                        //: as in: FIRST image. Please keep short.
                        txt: qsTranslate("MainMenu", "first")
                        cmd: "__goToFirst"
                        smallestWidth: prevarrow.width
                        alignCenter: true
                        menuColWidth: mainmenu_top.colwidth
                    }

                    PQMainMenuEntry {
                        img_end: "last.svg"
                        //: as in: LAST image. Please keep short.
                        txt: qsTranslate("MainMenu", "last")
                        cmd: "__goToLast"
                        smallestWidth: nextarrow.width
                        alignCenter: true
                        menuColWidth: mainmenu_top.colwidth
                    }

                }

                PQMainMenuEntry {
                    img: "browse.svg"
                    txt: qsTranslate("MainMenu", "Browse images")
                    cmd: "__open"
                    closeMenu: true
                    menuColWidth: mainmenu_top.colwidth
                    onHeightChanged:
                        mainmenu_top.normalEntryHeight = height
                }

                PQMainMenuEntry {
                    img: "mapmarker.svg"
                    txt: qsTranslate("MainMenu", "Map Explorer")
                    cmd: "__showMapExplorer"
                    closeMenu: true
                    menuColWidth: mainmenu_top.colwidth
                    visible: PQCScriptsConfig.isLocationSupportEnabled() // qmllint disable unqualified
                }

            }

            /*************************/
            // image view

            Rectangle {

                width: flickable.width
                height: view_txt.height+10
                color: PQCLook.transColorHighlight // qmllint disable unqualified
                radius: 5

                PQTextXL {
                    id: view_txt
                    x: 5
                    y: 5
                    //: This is a category in the main menu.
                    text: qsTranslate("MainMenu", "current image")
                    font.weight: PQCLook.fontWeightBold // qmllint disable unqualified
                    opacity: 0.8
                }

            }

            Column {

                id: view_col

                spacing: 5

                // ZOOM

                Row {

                    spacing: 10

                    Item {
                        width: Math.max(zoom_txt.width, Math.max(rotate_txt.width, flip_txt.width))
                        height: zoom_txt.height
                        PQText {
                            id: zoom_txt
                            x: (parent.width-width)
                            y: (zoomin_icn.height-height)/2
                            //: Entry in main menu. Please keep short.
                            text: qsTranslate("MainMenu", "Zoom") + ":"
                            opacity: 0.6
                            font.weight: PQCLook.fontWeightBold // qmllint disable unqualified
                        }
                    }

                    PQMainMenuIcon {
                        id: zoomin_icn
                        img: "zoomin.svg"
                        cmd: "__zoomIn"
                        scaleFactor: 1
                        active: mainmenu_top.anythingLoaded
                        normalEntryHeight: mainmenu_top.normalEntryHeight
                    }

                    PQMainMenuIcon {
                        y: (zoomin_icn.height-height)/2
                        img: "zoomout.svg"
                        cmd: "__zoomOut"
                        scaleFactor: 1
                        active: mainmenu_top.anythingLoaded
                        normalEntryHeight: mainmenu_top.normalEntryHeight
                    }

                    PQMainMenuEntry {
                        y: (zoomin_icn.height-height)/2
                        img: "actualsize.svg"
                        txt: "100%"
                        cmd: "__zoomActual"
                        smallestWidth: 10
                        active: mainmenu_top.anythingLoaded
                        menuColWidth: mainmenu_top.colwidth
                    }

                    PQMainMenuEntry {
                        y: (zoomin_icn.height-height)/2
                        img: "reset.svg"
                        //: Used as in RESET zoom.
                        txt: qsTranslate("MainMenu", "reset")
                        cmd: "__zoomReset"
                        smallestWidth: 10
                        active: mainmenu_top.anythingLoaded
                        menuColWidth: mainmenu_top.colwidth
                    }

                    PQMainMenuEntry {
                        y: (zoomin_icn.height-height)/2
                        img: "padlock.svg"
                        smallestWidth: 10
                        menuColWidth: mainmenu_top.colwidth
                        opacity: PQCSettings.imageviewPreserveZoom ? 1 : 0.1 // qmllint disable unqualified
                        tooltip: qsTranslate("MainMenu", "Enable to preserve zoom levels across images")
                        Behavior on opacity { NumberAnimation { duration: 200 } }
                        onClicked: PQCSettings.imageviewPreserveZoom = !PQCSettings.imageviewPreserveZoom // qmllint disable unqualified
                    }

                }

                // ROTATION

                Row {

                    spacing: 10

                    Item {
                        width: Math.max(zoom_txt.width, Math.max(rotate_txt.width, flip_txt.width))
                        height: rotate_txt.height
                        PQText {
                            id: rotate_txt
                            x: (parent.width-width)
                            y: (rotate_left.height-height)/2
                            //: Entry in main menu. Please keep short.
                            text: qsTranslate("MainMenu", "Rotation")
                            opacity: 0.6
                            font.weight: PQCLook.fontWeightBold // qmllint disable unqualified
                        }
                    }

                    PQMainMenuIcon {
                        id: rotate_left
                        img: "rotateleft.svg"
                        cmd: "__rotateL"
                        scaleFactor: 1
                        active: mainmenu_top.anythingLoaded
                        normalEntryHeight: mainmenu_top.normalEntryHeight
                    }

                    PQMainMenuIcon {
                        y: (rotate_left.height-height)/2
                        img: "rotateright.svg"
                        cmd: "__rotateR"
                        scaleFactor: 1
                        active: mainmenu_top.anythingLoaded
                        normalEntryHeight: mainmenu_top.normalEntryHeight
                    }

                    PQMainMenuEntry {
                        y: (rotate_left.height-height)/2
                        img: "reset.svg"
                        //: Used as in RESET rotation.
                        txt: qsTranslate("MainMenu", "reset")
                        cmd: "__rotate0"
                        smallestWidth: 10
                        active: mainmenu_top.anythingLoaded
                        menuColWidth: mainmenu_top.colwidth
                    }

                    PQMainMenuEntry {
                        y: (zoomin_icn.height-height)/2
                        img: "padlock.svg"
                        smallestWidth: 10
                        menuColWidth: mainmenu_top.colwidth
                        opacity: PQCSettings.imageviewPreserveRotation ? 1 : 0.1 // qmllint disable unqualified
                        tooltip: qsTranslate("MainMenu", "Enable to preserve rotation angle across images")
                        Behavior on opacity { NumberAnimation { duration: 200 } }
                        onClicked: PQCSettings.imageviewPreserveRotation = !PQCSettings.imageviewPreserveRotation // qmllint disable unqualified
                    }

                }

                // FLIP

                Row {

                    spacing: 10

                    Item {
                        width: Math.max(zoom_txt.width, Math.max(rotate_txt.width, flip_txt.width))
                        height: flip_txt.height
                        PQText {
                            id: flip_txt
                            x: (parent.width-width)
                            y: (flip_ver.height-height)/2
                            //: Mirroring (or flipping) an image. Please keep short.
                            text: qsTranslate("MainMenu", "Mirror")
                            opacity: 0.6
                            font.weight: PQCLook.fontWeightBold // qmllint disable unqualified
                        }
                    }

                    PQMainMenuIcon {
                        y: (flip_ver.height-height)/2
                        img: "leftrightarrow.svg"
                        cmd: "__flipH"
                        scaleFactor: 1
                        active: mainmenu_top.anythingLoaded
                        normalEntryHeight: mainmenu_top.normalEntryHeight
                    }

                    PQMainMenuIcon {
                        id: flip_ver
                        img: "updownarrow.svg"
                        cmd: "__flipV"
                        scaleFactor: 1
                        active: mainmenu_top.anythingLoaded
                        normalEntryHeight: mainmenu_top.normalEntryHeight
                    }

                    PQMainMenuEntry {
                        y: (flip_ver.height-height)/2
                        img: "reset.svg"
                        //: Used as in RESET mirroring.
                        txt: qsTranslate("MainMenu", "reset")
                        cmd: "__flipReset"
                        smallestWidth: 10
                        active: mainmenu_top.anythingLoaded
                        menuColWidth: mainmenu_top.colwidth
                    }

                    PQMainMenuEntry {
                        y: (zoomin_icn.height-height)/2
                        img: "padlock.svg"
                        smallestWidth: 10
                        menuColWidth: mainmenu_top.colwidth
                        opacity: PQCSettings.imageviewPreserveMirror ? 1 : 0.1 // qmllint disable unqualified
                        tooltip: qsTranslate("MainMenu", "Enable to preserve mirror across images")
                        Behavior on opacity { NumberAnimation { duration: 200 } }
                        onClicked: PQCSettings.imageviewPreserveMirror = !PQCSettings.imageviewPreserveMirror // qmllint disable unqualified
                    }

                }

                // Histogram/Map

                PQMainMenuEntry {
                    img: "histogram.svg"
                    txt: PQCSettings.histogramVisible ? qsTranslate("MainMenu", "Hide histogram") : qsTranslate("MainMenu", "Show histogram") // qmllint disable unqualified
                    cmd: "__histogram"
                    menuColWidth: mainmenu_top.colwidth
                }

                PQMainMenuEntry {
                    img: "mapmarker.svg"
                    txt: PQCSettings.mapviewCurrentVisible ? qsTranslate("MainMenu", "Hide current location") : qsTranslate("MainMenu", "Show current location") // qmllint disable unqualified
                    cmd: "__showMapCurrent"
                    menuColWidth: mainmenu_top.colwidth
                }

            }



            /*************************/
            // Folder Actions

            Rectangle {

                width: flickable.width
                height: folder_txt.height+10
                color: PQCLook.transColorHighlight // qmllint disable unqualified
                radius: 5

                PQTextXL {
                    id: folder_txt
                    x: 5
                    y: 5
                    //: This is a category in the main menu.
                    text: qsTranslate("MainMenu", "all images")
                    font.weight: PQCLook.fontWeightBold // qmllint disable unqualified
                    opacity: 0.8
                }

            }

            Column {

                id: folder_col

                spacing: 5

                // SLIDESHOW

                Row {

                    spacing: 10

                    Item {
                        width: Math.max(advanced_txt.width, slideshow_txt.width)
                        height: slideshow_txt.height
                        PQText {
                            id: slideshow_txt
                            x: parent.width-width
                            y: (slideshow_start.height-height)/2
                            //: Entry in main menu. Please keep short.
                            text: qsTranslate("MainMenu", "Slideshow") + ":"
                            opacity: 0.6
                            font.weight: PQCLook.fontWeightBold // qmllint disable unqualified
                        }
                    }

                    PQMainMenuEntry {
                        id: slideshow_start
                        img: "slideshow.svg"
                        //: Used as in START slideshow. Please keep short
                        txt: qsTranslate("MainMenu", "Start")
                        cmd: "__slideshowQuick"
                        smallestWidth: (mainmenu_top.colwidth-slideshow_txt.parent.width-20)/2
                        closeMenu: true
                        active: mainmenu_top.anythingLoaded
                        menuColWidth: mainmenu_top.colwidth
                    }

                    PQMainMenuEntry {
                        img: "setup.svg"
                        //: Used as in SETUP slideshow. Please keep short
                        txt: qsTranslate("MainMenu", "Setup")
                        cmd: "__slideshow"
                        smallestWidth: slideshow_start.width
                        closeMenu: true
                        active: mainmenu_top.anythingLoaded
                        menuColWidth: mainmenu_top.colwidth
                    }

                }

                // ADVANCED SORT

                Row {

                    spacing: 10

                    Item {
                        width: Math.max(advanced_txt.width, slideshow_txt.width)
                        height: advanced_txt.height
                        PQText {
                            id: advanced_txt
                            x: parent.width-width
                            y: (advanced_start.height-height)/2
                            //: Entry in main menu. Please keep short.
                            text: qsTranslate("MainMenu", "Sort") + ":"
                            opacity: 0.6
                            font.weight: PQCLook.fontWeightBold // qmllint disable unqualified
                        }
                    }

                    PQMainMenuEntry {
                        id: advanced_start
                        img: "sort.svg"
                        //: Used as in START advanced sort. Please keep short
                        txt: qsTranslate("MainMenu", "Start")
                        cmd: "__advancedSortQuick"
                        smallestWidth: (mainmenu_top.colwidth-advanced_txt.parent.width-20)/2
                        closeMenu: true
                        active: mainmenu_top.anythingLoaded
                        menuColWidth: mainmenu_top.colwidth
                    }

                    PQMainMenuEntry {
                        img: "setup.svg"
                        //: Used as in SETUP advanced sort. Please keep short
                        txt: qsTranslate("MainMenu", "Setup")
                        cmd: "__advancedSort"
                        smallestWidth: advanced_start.width
                        closeMenu: true
                        active: mainmenu_top.anythingLoaded
                        menuColWidth: mainmenu_top.colwidth
                    }

                }

                // FILTER/STREAMING/DEFAULT

                PQMainMenuEntry {
                    img: "filter.svg"
                    txt: qsTranslate("MainMenu", "Filter images")
                    cmd: "__filterImages"
                    closeMenu: true
                    active: mainmenu_top.anythingLoaded
                    menuColWidth: mainmenu_top.colwidth
                }

                PQMainMenuEntry {
                    visible: PQCScriptsConfig.isChromecastEnabled() // qmllint disable unqualified
                    img: "streaming.svg"
                    txt: qsTranslate("MainMenu", "Streaming (Chromecast)")
                    cmd: "__chromecast"
                    closeMenu: true
                    active: mainmenu_top.anythingLoaded
                    menuColWidth: mainmenu_top.colwidth
                }

                PQMainMenuEntry {
                    img: "browse.svg"
                    txt: qsTranslate("MainMenu", "Open in default file manager")
                    cmd: "__defaultFileManager"
                    closeMenu: true
                    active: mainmenu_top.anythingLoaded
                    menuColWidth: mainmenu_top.colwidth
                }

            }

            /*************************/
            // PhotoQt

            Rectangle {

                width: flickable.width
                height: photoqt_txt.height+10
                color: PQCLook.transColorHighlight // qmllint disable unqualified
                radius: 5

                PQTextXL {
                    id: photoqt_txt
                    x: 5
                    y: 5
                    //: This is a category in the main menu.
                    text: qsTranslate("MainMenu", "general")
                    font.weight: PQCLook.fontWeightBold // qmllint disable unqualified
                    opacity: 0.8
                }

            }

            Column {

                id: photoqt_col

                spacing: 5

                Row {

                    PQMainMenuEntry {
                        img: "setup.svg"
                        txt: qsTranslate("MainMenu", "Settings")
                        cmd: "__settings"
                        smallestWidth: flickable.width/2
                        closeMenu: true
                        menuColWidth: mainmenu_top.colwidth
                    }

                    PQMainMenuEntry {
                        img: "about.svg"
                        txt: qsTranslate("MainMenu", "About")
                        cmd: "__about"
                        smallestWidth: flickable.width/2
                        closeMenu: true
                        menuColWidth: mainmenu_top.colwidth
                    }

                }

                Row {

                    PQMainMenuEntry {
                        img: "help.svg"
                        txt: qsTranslate("MainMenu", "Online help")
                        cmd: "__onlineHelp"
                        smallestWidth: flickable.width/2
                        closeMenu: true
                        menuColWidth: mainmenu_top.colwidth
                    }

                    PQMainMenuEntry {
                        img: "quit.svg"
                        txt: qsTranslate("MainMenu", "Quit")
                        cmd: "__quit"
                        smallestWidth: flickable.width/2
                        menuColWidth: mainmenu_top.colwidth
                    }

                }

            }

            /*************************/
            // Custom

            Rectangle {

                width: flickable.width
                height: custom_txt.height+10
                color: PQCLook.transColorHighlight // qmllint disable unqualified
                radius: 5

                visible: PQCSettings.mainmenuShowExternal // qmllint disable unqualified

                PQTextXL {
                    id: custom_txt
                    x: 5
                    y: 5
                    //: This is a category in the main menu.
                    text: qsTranslate("MainMenu", "custom")
                    font.weight: PQCLook.fontWeightBold // qmllint disable unqualified
                    opacity: 0.8
                }

            }

            Column {

                id: custom_col

                visible: PQCSettings.mainmenuShowExternal // qmllint disable unqualified

                spacing: 5

                property list<var> entries: []

                Repeater {

                    model: custom_col.entries.length

                    PQMainMenuEntry {

                        id: deleg

                        required property int modelData

                        property var cur: custom_col.entries[modelData]

                        customEntry: true

                        img: cur[0]==="" ? "application.svg" : ("data:image/png;base64," + cur[0])
                        txt: cur[2]
                        cmd: cur[1]
                        custom_close: cur[3]
                        custom_args: cur[4]

                        smallestWidth: flickable.width
                        closeMenu: true

                        menuColWidth: mainmenu_top.colwidth
                    }

                }

                Component.onCompleted: {
                    if(PQCSettings.mainmenuShowExternal) // qmllint disable unqualified
                        custom_col.entries = PQCScriptsContextMenu.getEntries()
                }

                Connections {
                    target: PQCSettings // qmllint disable unqualified
                    function onMainmenuShowExternalChanged() {
                        if(PQCSettings.mainmenuShowExternal) // qmllint disable unqualified
                            custom_col.entries = PQCScriptsContextMenu.getEntries()
                        else
                            custom_col.entries = []
                    }
                }

                Connections {
                    target: PQCScriptsContextMenu // qmllint disable unqualified
                    function onCustomEntriesChanged() {
                        if(PQCSettings.mainmenuShowExternal) // qmllint disable unqualified
                            custom_col.entries = PQCScriptsContextMenu.getEntries()
                        else
                            custom_col.entries = []
                    }
                }

            }

        }

    }

    // drag vertically
    MouseArea {
        y: (parent.height-height)
        width: parent.width
        height: 10
        cursorShape: Qt.SizeVerCursor

        property int clickStart: -1
        property int origHeight: PQCSettings.mainmenuElementSize.height // qmllint disable unqualified
        onPressed: (mouse) => {
            clickStart = mouse.y
        }
        onReleased:
            clickStart = -1

        onPositionChanged: (mouse) => {
            if(clickStart == -1)
                return
            var diff = mouse.y-clickStart
            PQCSettings.mainmenuElementSize.height = Math.round(origHeight+diff) // qmllint disable unqualified

        }

    }

    // drag from left to right
    MouseArea {
        x: (parent.width-width)
        width: 10
        height: parent.height
        cursorShape: enabled ? Qt.SizeHorCursor : Qt.ArrowCursor
        enabled: parent.state==="left"

        property int clickStart: -1
        property int origWidth: PQCSettings.mainmenuElementSize.width // qmllint disable unqualified
        onPressed: (mouse) => {
            clickStart = mouse.x
        }
        onReleased:
            clickStart = -1

        onPositionChanged: (mouse) => {
            if(clickStart == -1)
                return
            var diff = mouse.x-clickStart
            PQCSettings.mainmenuElementSize.width = Math.round(Math.min(mainmenu_top.access_toplevel.width/2, Math.max(200, origWidth+diff))) // qmllint disable unqualified

        }

    }

    MouseArea {
        id: dragrightMouse
        x: 0
        width: 10
        height: parent.height
        cursorShape: enabled ? Qt.SizeHorCursor : Qt.ArrowCursor
        enabled: parent.state==="right"

        property int clickStart: -1
        property int origWidth: PQCSettings.mainmenuElementSize.width // qmllint disable unqualified
        onPressed: (mouse) => {
            clickStart = mouse.x
        }
        onReleased:
            clickStart = -1

        onPositionChanged: (mouse) => {
            if(clickStart == -1)
                return
            var diff = clickStart-mouse.x
            PQCSettings.mainmenuElementSize.width = Math.round(Math.min(mainmenu_top.access_toplevel.width/2, Math.max(200, origWidth+diff))) // qmllint disable unqualified

        }

    }

    Image {
        x: 5
        y: 5
        width: 15
        height: 15
        visible: !PQCWindowGeometry.mainmenuForcePopout // qmllint disable unqualified
        enabled: visible
        source: "image://svg/:/" + PQCLook.iconShade + "/popinpopout.svg" // qmllint disable unqualified
        sourceSize: Qt.size(width, height)
        opacity: popinmouse.containsMouse ? 1 : 0.4
        Behavior on opacity { NumberAnimation { duration: 200 } }
        PQMouseArea {
            id: popinmouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            text: PQCSettings.interfacePopoutMainMenu ? // qmllint disable unqualified
                      //: Tooltip of small button to merge a popped out element (i.e., one in its own window) into the main interface
                      qsTranslate("popinpopout", "Merge into main interface") :
                      //: Tooltip of small button to show an element in its own window (i.e., not merged into main interface)
                      qsTranslate("popinpopout", "Move to its own window")
            onClicked: {
                mainmenu_top.hideMainMenu()
                if(!PQCSettings.interfacePopoutMainMenu) // qmllint disable unqualified
                    PQCSettings.interfacePopoutMainMenu = true
                else
                    mainmenu_popout.close()
                PQCNotify.executeInternalCommand("__showMainMenu")
            }
        }
    }

    // if a small play/pause button is shown then moving the mouse to the screen edge around it does not trigger the main menu
    property int ignoreBottomMotion: PQCNotify.isMotionPhoto&&PQCSettings.filetypesMotionPhotoPlayPause ? 100 : 0 // qmllint disable unqualified

    Connections {
        target: PQCNotify // qmllint disable unqualified
        function onMouseMove(posx : int, posy : int) {

            if(PQCNotify.slideshowRunning || PQCNotify.faceTagging) { // qmllint disable unqualified
                mainmenu_top.setVisible = false
                return
            }

            if(!mainmenu_top.windowSizeOkay && !mainmenu_top.isPopout) {
                mainmenu_top.setVisible = false
                return
            }

            if(mainmenu_top.setVisible) {
                if(posx < mainmenu_top.x-50 || posx > mainmenu_top.x+mainmenu_top.width+50 || posy < mainmenu_top.y-50 || posy > mainmenu_top.y+mainmenu_top.height+50)
                    mainmenu_top.setVisible = false
            } else {
                if(mainmenu_top.hotArea.x <= posx && mainmenu_top.hotArea.x+mainmenu_top.hotArea.width > posx && mainmenu_top.hotArea.y < posy && mainmenu_top.hotArea.height+mainmenu_top.hotArea.y-mainmenu_top.ignoreBottomMotion > posy)
                    mainmenu_top.setVisible = true
            }
        }
    }

    Connections {
        target: loader // qmllint disable unqualified

        function onPassOn(what : string, param : string) {

            if(what === "show") {
                if(param === "mainmenu") {
                    mainmenu_top.showMainMenu()
                }
            } else if(what === "toggle") {
                if(param === "mainmenu") {
                    mainmenu_top.toggle()
                }
            }

        }

    }

    function toggle() {
        mainmenu_top.setVisible = !mainmenu_top.setVisible
    }

    function hideMainMenu() {
        mainmenu_top.setVisible = false
        if(popoutWindowUsed)
            mainmenu_popout.visible = false // qmllint disable unqualified
    }

    function showMainMenu() {
        mainmenu_top.setVisible = true
        if(popoutWindowUsed)
            mainmenu_popout.visible = true // qmllint disable unqualified
    }

}
