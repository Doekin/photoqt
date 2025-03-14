/**************************************************************************
 **                                                                      **
 ** Copyright (C) 2011-2025 Lukas Spies                                  **
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
import QtQuick.Window

import PQCScriptsOther
import PQCFileFolderModel
import PQCScriptsConfig
import PQCNotify
import PQCWindowGeometry
import PQCScriptsFilesPaths
import PQCScriptsImages

import "manage"
import "image"
import "ongoing"

Window {

    id: toplevel

    flags: PQCSettings.interfaceWindowDecoration ? // qmllint disable unqualified
               (PQCSettings.interfaceKeepWindowOnTop ? (Qt.Window|Qt.WindowStaysOnTopHint) : Qt.Window) :
               (PQCSettings.interfaceKeepWindowOnTop ? (Qt.FramelessWindowHint|Qt.WindowStaysOnTopHint|Qt.Window|Qt.WindowMinMaxButtonsHint) : (Qt.FramelessWindowHint|Qt.Window|Qt.WindowMinMaxButtonsHint))

    color: "transparent"

    property string titleOverride: ""
    title: titleOverride!="" ?
               (titleOverride + " | PhotoQt") :
               ((PQCFileFolderModel.currentFile==="" ? "" : (PQCScriptsFilesPaths.getFilename(PQCFileFolderModel.currentFile) + " | "))+ "PhotoQt") // qmllint disable unqualified

    minimumWidth: 300
    minimumHeight: 200

    // if last geometry has been remembered that one is set in the show() function below
    width: 800
    height: 600

    // this signals whether the window is currently being resized or not
    property bool resizing: false
    onWidthChanged: {
        if(toplevel.startup) return
        toplevel.resizing = true
        resetResizing.restart()
    }
    onHeightChanged: {
        if(toplevel.startup) return
        toplevel.resizing = true
        resetResizing.restart()
    }
    Timer {
        id: resetResizing
        interval: 500
        onTriggered: {
            toplevel.resizing = false
        }
    }

    property bool isFullscreen: toplevel.visibility==Window.FullScreen

    property rect geometry: Qt.rect(x, y, width, height)
    onGeometryChanged: {
        if(!toplevel.startup && !toplevel.isFullscreen) {
            PQCWindowGeometry.mainWindowGeometry = geometry // qmllint disable unqualified
            PQCWindowGeometry.mainWindowMaximized = (toplevel.visibility == Window.Maximized)
        }
    }

    // we keep track of whether a window is maximized or windowed
    // when restoring the window we then can restore it to the state it was in before
    property bool maxAndNowWindowed: false
    onVisibilityChanged: {
        if(visibility === Window.Maximized)
            maxAndNowWindowed = true
        else if(visibility === Window.Windowed) {
            maxAndNowWindowed = false
        }
    }

    property bool startup: true

    PQMainWindowBackground {
        id: fullscreenitem
        anchors.fill: parent
    }

    // load this asynchronously
    Loader {
        id: shortcuts
        asynchronous: true
        source: "other/PQShortcuts.qml"
    }

    // this one we load synchronously for easier access
    PQLoader { id: loader }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onPositionChanged: (mouse) => {
            PQCNotify.mouseMove(mouse.x, mouse.y) // qmllint disable unqualified
        }
        onWheel: (wheel) => {
            PQCNotify.mouseWheel(Qt.point(wheel.x, wheel.y), wheel.angleDelta, wheel.modifiers) // qmllint disable unqualified
        }
    }

    // very cheap to set up, many properties needed everywhere -> no loader
    PQImage { id: image}

    /*************************************************/
    // load assynchronously at startup

    // startup message
    Loader { id: background; asynchronous: true; source: "other/PQBackgroundMessage.qml" }
    // status info
    Loader { id: statusinfo; asynchronous: true; source: "ongoing/PQStatusInfo.qml" }

    PQContextMenu { id: contextmenu }

    Loader { id: loader_trayicon; asynchronous: true; source: "ongoing/PQTrayIcon.qml" }

    Loader { id: windowbuttons; asynchronous: true; source: "ongoing/PQWindowButtons.qml" }
    Loader {
        id: windowbuttons_ontop
        asynchronous: true
        source: "ongoing/PQWindowButtons.qml"
        z: loader.visibleItem!=="filedialog" ? 999 : 0
        onStatusChanged: {
            if(windowbuttons_ontop.status == Loader.Ready)
                windowbuttons_ontop.item.visibleAlways = true
        }
    }

    /*************************************************/
    // load on-demand

    // ongoing
    Loader { id: loader_histogram }
    Loader { id: loader_mapcurrent }
    Loader { id: loader_navigationfloating }
    Loader { id: loader_slideshowcontrols }
    Loader { id: loader_slideshowhandler }
    Loader { id: loader_notification }
    Loader { id: loader_logging }
    Loader { id: loader_chromecast }

    // these should be above the other ongoing ones
    // the thumbnails loader can be asynchronous as it is always integrated and never popped out
    Loader { id: loader_thumbnails; asynchronous: true; }

    // these cannot be asynchronous, otherwise toggling the popped out state is buggy
    Loader { id: loader_metadata }
    Loader { id: loader_mainmenu }

    // actions
    Loader { id: loader_about }
    Loader { id: loader_advancedsort }
    Loader { id: loader_copy }
    Loader { id: loader_move }
    Loader { id: loader_export }
    Loader { id: loader_filedelete }
    Loader { id: loader_filedialog }
    Loader { id: loader_filerename }
    Loader { id: loader_filesaveas }
    Loader { id: loader_filter }
    Loader { id: loader_imgur }
    Loader { id: loader_mapexplorer }
    Loader { id: loader_scale }
    Loader { id: loader_settingsmanager }
    Loader { id: loader_slideshowsetup }
    Loader { id: loader_wallpaper }
    Loader { id: loader_chromecastmanager }
    Loader { id: loader_crop }

    /*************************************************/

    Item {
        id: fullscreenitem_foreground
        anchors.fill: parent
    }

    Loader {
        asynchronous: true
        active: PQCSettings.interfaceWindowMode && !PQCSettings.interfaceWindowDecoration // qmllint disable unqualified
        source: "ongoing/PQWindowHandles.qml"
    }


    /*************************************************/

    // on windows there is a white flash when the window is created
    // thus we set up the window with opacity set to 0
    // and this animation fades the window without white flash
    PropertyAnimation {
        id: showOpacity
        target: toplevel
        property: "opacity"
        from: 0
        to: 1
        duration: 100
    }

    Timer {
        id: resetStartup
        interval: 1000
        running: true
        onTriggered:
            toplevel.startup = false
    }

    Connections {
        target: PQCSettings // qmllint disable unqualified

        function onInterfaceWindowModeChanged() {
            toplevel.visibility = (PQCSettings.interfaceWindowMode ? (toplevel.maxAndNowWindowed ? Window.Maximized : Window.Windowed) : Window.FullScreen) // qmllint disable unqualified
        }

        function onInterfacePopoutMetadataChanged() {
            // this needs to be done with a delay otherwise the metadata wont be shown
            metadatadelay.restart()
        }

    }

    Timer {
        // this needs to be done with a delay otherwise the metadata wont be shown
        id: metadatadelay
        interval: 250
        onTriggered:
            loader.show("metadata")
    }

    Connections {

        target: PQCNotify // qmllint disable unqualified

        function onCmdOpen() : void {
            console.log("")
            loader.show("filedialog")
        }

        function onCmdShow() : void {

            console.log("")

            if(toplevel.visible) {
                toplevel.raise()
                toplevel.requestActivate()
                return
            }

            toplevel.visible = true
            if(toplevel.visibility === Window.Minimized)
                toplevel.visibility = (toplevel.maxAndNowWindowed ? Window.Maximized : Window.Windowed)
            toplevel.raise()
            toplevel.requestActivate()

        }

        function onCmdHide() : void {
            console.log("")
            PQCSettings.interfaceTrayIcon = 1 // qmllint disable unqualified
            toplevel.close()
        }

        function onCmdQuit() : void {
            console.log("")
            toplevel.quitPhotoQt()
        }

        function onCmdToggle() : void {

            console.log("")

            if(toplevel.visible) {
                PQCSettings.interfaceTrayIcon = 1 // qmllint disable unqualified
                toplevel.close()
            } else {
                toplevel.visible = true
                if(toplevel.visibility === Window.Minimized)
                    toplevel.visibility = (toplevel.maxAndNowWindowed ? Window.Maximized : Window.Windowed)
                toplevel.raise()
                toplevel.requestActivate()
            }

        }

        function onCmdTray(enabled : bool) : void {

            console.log("args: enabled =", enabled)

            if(enabled && PQCSettings.interfaceTrayIcon === 0) // qmllint disable unqualified
                PQCSettings.interfaceTrayIcon = 2
            else if(!enabled) {
                PQCSettings.interfaceTrayIcon = 0
                if(!toplevel.visible) {
                    toplevel.visible = true
                    if(toplevel.visibility === Window.Minimized)
                        toplevel.visibility = (toplevel.maxAndNowWindowed ? Window.Maximized : Window.Windowed)
                    toplevel.raise()
                    toplevel.requestActivate()
                }
            }

        }

        function onStartInTrayChanged() : void {

            console.log("")

            if(PQCNotify.startInTray) // qmllint disable unqualified
                PQCSettings.interfaceTrayIcon = 1
            else if(!PQCNotify.startInTray && PQCSettings.interfaceTrayIcon === 1)
                PQCSettings.interfaceTrayIcon = 0

        }

        function onFilePathChanged() : void {
            console.log("")
            PQCFileFolderModel.fileInFolderMainView = PQCNotify.filePath // qmllint disable unqualified
            if(!toplevel.visible)
                toplevel.visible = true
            if(toplevel.visibility === Window.Minimized)
                toplevel.visibility = (toplevel.maxAndNowWindowed ? Window.Maximized : Window.Windowed)
            toplevel.raise()
            toplevel.requestActivate()
        }

        // this one is handled directly in PQShortcuts class
        // function onCmdShortcutSequence(seq) {}

    }

    // clean up some temporary files, mostly from last session
    Timer {
        running: true
        interval: 500
        onTriggered:
            PQCScriptsFilesPaths.cleanupTemporaryFiles() // qmllint disable unqualified
    }

    Component.onCompleted: {

        fullscreenitem.setBackground()

        PQCScriptsConfig.updateTranslation() // qmllint disable unqualified

        if(PQCScriptsConfig.amIOnWindows() && !PQCNotify.startInTray)
            toplevel.opacity = 0

        // show window according to settings
        if(PQCSettings.interfaceWindowMode) {
            if(PQCSettings.interfaceSaveWindowGeometry) {
                var geo = PQCWindowGeometry.mainWindowGeometry
                toplevel.x = geo.x
                toplevel.y = geo.y
                toplevel.width = geo.width
                toplevel.height = geo.height
                if(PQCNotify.startInTray) {
                    PQCSettings.interfaceTrayIcon = 1
                    toplevel.hide()
                } else {
                    if(PQCWindowGeometry.mainWindowMaximized)
                        showMaximized()
                    else
                        showNormal()
                }
            } else {
                if(PQCNotify.startInTray) {
                    PQCSettings.interfaceTrayIcon = 1
                    toplevel.hide()
                } else
                    showMaximized()
            }
        } else {
            if(PQCNotify.startInTray) {
                PQCSettings.interfaceTrayIcon = 1
                toplevel.hide()
            } else
                showFullScreen()
        }

        loader.show("mainmenu")
        loader.show("metadata")
        loader.ensureItIsReady("thumbnails", loader.loadermapping["thumbnails"])

        if(PQCSettings.histogramVisible)
            loader.show("histogram")
        if(PQCSettings.mapviewCurrentVisible)
            loader.show("mapcurrent")
        if(PQCSettings.interfaceNavigationFloating)
            loader.show("navigationfloating")
        else
            loader.ensureItIsReady("navigationfloating", loader.loadermapping["navigationfloating"])

        if(PQCNotify.filePath !== "")
            PQCFileFolderModel.fileInFolderMainView = PQCNotify.filePath
        else if(PQCSettings.interfaceRememberLastImage)
            PQCFileFolderModel.fileInFolderMainView = PQCScriptsConfig.getLastLoadedImage()

        if(PQCScriptsConfig.amIOnWindows() && !PQCNotify.startInTray)
            showOpacity.restart()

    }

    function handleBeforeClosing() {

        PQCFileFolderModel.advancedSortMainViewCANCEL() // qmllint disable unqualified

        if(PQCFileFolderModel.currentIndex > -1 && PQCSettings.interfaceRememberLastImage)
            PQCScriptsConfig.setLastLoadedImage(PQCFileFolderModel.currentFile)
        else
            PQCScriptsConfig.deleteLastLoadedImage()

        PQCScriptsFilesPaths.cleanupTemporaryFiles()

        PQCScriptsOther.deleteScreenshots()

    }

    onClosing: (close) => {

        // We stop a running slideshow to make sure all settings are restored to their normal state
        if(PQCNotify.slideshowRunning) // qmllint disable unqualified
            loader_slideshowhandler.item.hide()

        if(PQCSettings.interfaceTrayIcon === 1) {
            close.accepted = false
            toplevel.visibility = Window.Hidden
            if(PQCSettings.interfaceTrayIconHideReset)
                PQCNotify.resetSessionData()
        } else {
            close.accepted = true
            quitPhotoQt()
        }
    }

    function quitPhotoQt() {
        handleBeforeClosing()
        Qt.quit()
    }

    function getDevicePixelRatio() {
        if(PQCSettings.imageviewRespectDevicePixelRatio) // qmllint disable unqualified
            return PQCScriptsImages.getPixelDensity()
        return 1
    }

}
