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

Item {

    id: load_top

    signal mainmenuPassOn(var what, var param)
    signal metadataPassOn(var what, var param)
    signal filedialogPassOn(var what, var param)
    signal mapViewPassOn(var what, var param)
    signal mapCurrentPassOn(var what, var param)
    signal mapExplorerPassOn(var what, var param)
    signal slideshowPassOn(var what, var param)
    signal slideshowControlsPassOn(var what, var param)
    signal fileRenamePassOn(var what, var param)
    signal fileDeletePassOn(var what, var param)
    signal copyMoveFilePassOn(var what, var param)
    signal scalePassOn(var what, var param)
    signal aboutPassOn(var what, var param)
    signal imgurPassOn(var what, var param)
    signal wallpaperPassOn(var what, var param)
    signal filterPassOn(var what, var param)
    signal faceTaggerPassOn(var what, var param)
    signal settingsManagerPassOn(var what, var param)
    signal fileSaveAsPassOn(var what, var param)
    signal navigationFloatingPassOn(var what, var param)
    signal notificationPassOn(var what, var param)
    signal chromecastPassOn(var what, var param)
    signal loggingPassOn(var what, var param)
    signal advancedSortPassOn(var what, var param)
    signal advancedSortBusyPassOn(var what, var param)

    function passOn(ele, what, param) {

        ensureItIsReady(ele)

        if(ele == "mainmenu")
            mainmenuPassOn(what, param)

        else if(ele == "metadata")
            metadataPassOn(what, param)

        else if(ele == "filedialog")
            filedialogPassOn(what, param)

        else if(ele == "slideshowsettings")
            slideshowPassOn(what, param)

        else if(ele == "slideshowcontrols")
            slideshowControlsPassOn(what, param)

        else if(ele == "filedelete")
            fileDeletePassOn(what, param)

        else if(ele == "filerename")
            fileRenamePassOn(what, param)

        else if(ele == "scale")
            scalePassOn(what, param)

        else if(ele == "about")
            aboutPassOn(what, param)

        else if(ele == "imgur" || ele == "imguranonym")
            imgurPassOn(what, param)

        else if(ele == "wallpaper")
            wallpaperPassOn(what, param)

        else if(ele == "settingsmanager")
            settingsManagerPassOn(what, param)

        else if(ele == "filter")
            filterPassOn(what, param)

        else if(ele == "facetagger")
            faceTaggerPassOn(what, param)

        else if(ele == "copymove")
            copyMoveFilePassOn(what, param)

        else if(ele == "unavailable" || ele == "unavailablepopout" || ele == "notification")
            notificationPassOn(what, param)

        else if(ele == "navigationfloating")
            navigationFloatingPassOn(what, param)

        else if(ele == "chromecast")
            chromecastPassOn(what, param)

        else if(ele == "logging")
            loggingPassOn(what, param)

        else if(ele == "advancedsort")
            advancedSortPassOn(what, param)

        else if(ele == "advancedsortbusy")
            advancedSortBusyPassOn(what, param)

        else if(ele == "mapview")
            mapViewPassOn(what, param)

        else if(ele == "mapcurrent")
            mapCurrentPassOn(what, param)

        else if(ele == "mapexplorer")
            mapExplorerPassOn(what, param)

        else if(ele == "filesaveas")
            fileSaveAsPassOn(what, param)

    }

    function show(ele) {

        if(ele == "chromecast" && !handlingGeneral.isChromecastEnabled()) {
            passOn("notification", "show", undefined)
            notification.item.statustext = em.pty+qsTranslate("notification", "The chromecast feature is not available in this build of PhotoQt.")
            return
        } else if((ele == "mapcurrent" || ele == "mapexplorer") && !handlingGeneral.isLocationSupportEnabled()) {
            passOn("notification", "show", undefined)
            notification.item.statustext = em.pty+qsTranslate("notification", "The location feature is not available in this build of PhotoQt.")
            return
        }

        if(ele == "imguranonym")
            passOn(ele, "show_anonym", undefined)
        else
            passOn(ele, "show", undefined)

    }

    function passMouseEvent(ele, buttons, mod) {

        passOn(ele, "mouseevent", [buttons, mod])

    }

    function passKeyEvent(ele, key, mod) {

        passOn(ele, "keyevent", [key, mod])

    }

    function ensureItIsReady(ele) {

        if(ele == "mainmenu") {

            if(PQSettings.interfacePopoutMainMenu && mainmenu.source != "menumeta/PQMainMenuPopout.qml")
                mainmenu.source = "menumeta/PQMainMenuPopout.qml"

             else if(!PQSettings.interfacePopoutMainMenu && mainmenu.source != "menumeta/PQMainMenu.qml")
                mainmenu.source = "menumeta/PQMainMenu.qml"

        } else if(ele == "metadata") {

            if(PQSettings.interfacePopoutMetadata && metadata.source != "menumeta/PQMetaDataPopout.qml")
                metadata.source = "menumeta/PQMetaDataPopout.qml"

             else if(!PQSettings.interfacePopoutMetadata && metadata.source != "menumeta/PQMetaData.qml")
                metadata.source = "menumeta/PQMetaData.qml"

        } else if(ele == "filedialog") {

            if((windowsizepopup.fileDialog || PQSettings.interfacePopoutOpenFile) && filedialog.source != "filedialog/PQFileDialogPopout.qml")
                filedialog.source = "filedialog/PQFileDialogPopout.qml"

            else if(!windowsizepopup.fileDialog && !PQSettings.interfacePopoutOpenFile && filedialog.source != "filedialog/PQFileDialog.qml")
                filedialog.source = "filedialog/PQFileDialog.qml"

        } else if(ele == "histogram") {

            if(PQSettings.interfacePopoutHistogram && histogram.source != "histogram/PQHistogramPopout.qml")
                histogram.source = "histogram/PQHistogramPopout.qml"

            else if(!PQSettings.interfacePopoutHistogram && histogram.source != "histogram/PQHistogram.qml")
                histogram.source = "histogram/PQHistogram.qml"

        } else if(ele == "slideshowsettings") {

            if((windowsizepopup.slideShowSettings || PQSettings.interfacePopoutSlideShowSettings) && slideshowsettings.source != "slideshow/PQSlideShowSettingsPopout.qml")
                slideshowsettings.source = "slideshow/PQSlideShowSettingsPopout.qml"

            else if(!windowsizepopup.slideShowSettings && !PQSettings.interfacePopoutSlideShowSettings && slideshowsettings.source != "slideshow/PQSlideShowSettings.qml")
                slideshowsettings.source = "slideshow/PQSlideShowSettings.qml"

        } else if(ele == "slideshowcontrols") {

            if(PQSettings.interfacePopoutSlideShowControls && slideshowcontrols.source != "slideshow/PQSlideShowControlsPopout.qml")
                slideshowcontrols.source = "slideshow/PQSlideShowControlsPopout.qml"

            else if(!PQSettings.interfacePopoutSlideShowControls && slideshowcontrols.source != "slideshow/PQSlideShowControls.qml")
                slideshowcontrols.source = "slideshow/PQSlideShowControls.qml"

        } else if(ele == "filerename") {

            if(PQSettings.interfacePopoutFileRename && filerename.source != "filemanagement/PQRenamePopout.qml")
                filerename.source = "filemanagement/PQRenamePopout.qml"

            else if(!PQSettings.interfacePopoutFileRename && filerename.source != "filemanagement/PQRename.qml")
                filerename.source = "filemanagement/PQRename.qml"

        } else if(ele == "filedelete") {

            if(PQSettings.interfacePopoutFileDelete && filedelete.source != "filemanagement/PQDeletePopout.qml")
                filedelete.source = "filemanagement/PQDeletePopout.qml"

            else if(!PQSettings.interfacePopoutFileDelete && filedelete.source != "filemanagement/PQDelete.qml")
                filedelete.source = "filemanagement/PQDelete.qml"

        } else if(ele == "scale") {

            if((windowsizepopup.scaleImage || PQSettings.interfacePopoutScale) && scaleimage.source != "scale/PQScalePopout.qml")
                scaleimage.source = "scale/PQScalePopout.qml"

            else if(!windowsizepopup.scaleImage && !PQSettings.interfacePopoutScale && scaleimage.source != "scale/PQScale.qml")
                scaleimage.source = "scale/PQScale.qml"

        } else if(ele == "about") {

            if((windowsizepopup.about || PQSettings.interfacePopoutAbout) && about.source != "about/PQAboutPopout.qml")
                about.source = "about/PQAboutPopout.qml"

            else if(!windowsizepopup.about && !PQSettings.interfacePopoutAbout && about.source != "about/PQAbout.qml")
                about.source = "about/PQAbout.qml"

        } else if(ele == "imgur" || ele == "imguranonym") {

            if(PQSettings.interfacePopoutImgur && imgur.source != "imgur/PQImgurPopout.qml")
                imgur.source = "imgur/PQImgurPopout.qml"

            else if(!PQSettings.interfacePopoutImgur && imgur.source != "imgur/PQImgur.qml")
                imgur.source = "imgur/PQImgur.qml"

        } else if(ele == "wallpaper") {

            if((windowsizepopup.wallpaper || PQSettings.interfacePopoutWallpaper) && wallpaper.source != "wallpaper/PQWallpaperPopout.qml")
                wallpaper.source = "wallpaper/PQWallpaperPopout.qml"

            else if(!windowsizepopup.wallpaper && !PQSettings.interfacePopoutWallpaper && wallpaper.source != "wallpaper/PQWallpaper.qml")
                wallpaper.source = "wallpaper/PQWallpaper.qml"

        } else if(ele == "filter") {

            if((windowsizepopup.filter || PQSettings.interfacePopoutFilter) && filter.source != "filter/PQFilterPopout.qml")
                filter.source = "filter/PQFilterPopout.qml"

            else if(!windowsizepopup.filter && !PQSettings.interfacePopoutFilter && filter.source != "filter/PQFilter.qml")
                filter.source = "filter/PQFilter.qml"

        } else if(ele == "settingsmanager") {

            if((windowsizepopup.settingsManager || PQSettings.interfacePopoutSettingsManager) && settingsmanager.source != "settingsmanager/PQSettingsManagerPopout.qml")
                settingsmanager.source = "settingsmanager/PQSettingsManagerPopout.qml"

            else if(!windowsizepopup.settingsManager && !PQSettings.interfacePopoutSettingsManager && settingsmanager.source != "settingsmanager/PQSettingsManager.qml")
                settingsmanager.source = "settingsmanager/PQSettingsManager.qml"

        } else if(ele == "copymove") {

            if(copymove.source != "filemanagement/PQCopyMove.qml")
                copymove.source = "filemanagement/PQCopyMove.qml"

        } else if(ele == "filesaveas") {

            if((windowsizepopup.saveAs || PQSettings.interfacePopoutFileSaveAs) && filesaveas.source != "filemanagement/PQSaveAsPopout.qml")
                filesaveas.source = "filemanagement/PQSaveAsPopout.qml"

            else if(!windowsizepopup.saveAs && !PQSettings.interfacePopoutFileSaveAs && filesaveas.source != "filemanagement/PQSaveAs.qml")
                filesaveas.source = "filemanagement/PQSaveAs.qml"

        } else if(ele == "chromecast") {

            if((windowsizepopup.chromecast || PQSettings.interfacePopoutChromecast) && chromecast.source != "chromecast/PQChromecastPopout.qml")
                chromecast.source = "chromecast/PQChromecastPopout.qml"

            else if(!windowsizepopup.chromecast && !PQSettings.interfacePopoutChromecast && chromecast.source != "chromecast/PQChromecast.qml")
                chromecast.source = "chromecast/PQChromecast.qml"

        } else if(ele == "advancedsort") {

            if((windowsizepopup.advancedSort || PQSettings.interfacePopoutAdvancedSort) && advancedsort.source != "advancedsort/PQAdvancedSortPopout.qml")
                advancedsort.source = "advancedsort/PQAdvancedSortPopout.qml"

            else if(!windowsizepopup.advancedSort && !PQSettings.interfacePopoutAdvancedSort && advancedsort.source != "advancedsort/PQAdvancedSort.qml")
                advancedsort.source = "advancedsort/PQAdvancedSort.qml"

        } else if(ele == "mapexplorer") {

            if((windowsizepopup.mapExplorer || PQSettings.interfacePopoutMapExplorer) && mapexplorer.source != "mapview/PQMapExplorerPopout.qml")
                mapexplorer.source = "mapview/PQMapExplorerPopout.qml"

            else if(!PQSettings.interfacePopoutMapExplorer && mapexplorer.source != "mapview/PQMapExplorer.qml")
                mapexplorer.source = "mapview/PQMapExplorer.qml"

        } else if(ele == "mapcurrent") {

            if(PQSettings.interfacePopoutMapCurrent && mapcurrent.source != "mapview/PQMapCurrentPopout.qml")
                mapcurrent.source = "mapview/PQMapCurrentPopout.qml"

            else if(!PQSettings.interfacePopoutMapCurrent && mapcurrent.source != "mapview/PQMapCurrent.qml")
                mapcurrent.source = "mapview/PQMapCurrent.qml"

        } else if(ele == "advancedsortbusy") {

            if(advancedsortbusy.source != "advancedsort/PQAdvancedSortBusy.qml")
                advancedsortbusy.source = "advancedsort/PQAdvancedSortBusy.qml"

        } else if(ele == "navigationfloating") {

            navigationfloating.source = "mainwindow/PQNavigation.qml"

        } else if(ele == "unavailable" || ele == "unavailablepopout" || ele == "notification") {

            notification.source = "notification/PQNotification.qml"

        } else if(ele == "logging") {

            logging.source = "logging/PQLogging.qml"

        }

    }

    function resetAll() {
        mainmenu.source = ""
        metadata.source = ""
        filedialog.source = ""
        histogram.source = ""
        slideshowsettings.source = ""
        slideshowcontrols.source = ""
        filerename.source = ""
        filedelete.source = ""
        scaleimage.source = ""
        about.source = ""
        imgur.source = ""
        wallpaper.source = ""
        filter.source = ""
        settingsmanager.source = ""
        copymove.source = ""
        filesaveas.source = ""
        chromecast.source = ""
        advancedsort.source = ""
        advancedsortbusy.source = ""
        navigationfloating.source = ""
        notification.source = ""
        logging.source = ""
        mapview.source = ""
        mapcurrent.source = ""
    }

}
