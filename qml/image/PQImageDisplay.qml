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
import QtQuick.Window

import PQCFileFolderModel
import PQCNotify
import PQCScriptsImages
import PQCScriptsFilesPaths
import PQCScriptsOther

import "components"
import "imageitems"
import "../elements"

Loader {
    id: imageloaderitem

    property int mainItemIndex: -1
    property string containingFolder: ""
    property string lastModified: ""
    property bool imageLoadedAndReady: false
    property bool imageFullyShown: false
    property string imageSource: ""

    property Item access_fullscreen: fullscreenitem // qmllint disable unqualified

    signal iAmReady()

    signal busyTimerStopAndHide()
    signal busyTimerRestart()

    onMainItemIndexChanged: {
        imageLoadedAndReady = false
        active = false
        active = (mainItemIndex!=-1)
        if(active) {
            imageloaderitem.item.mainItemIndex = imageloaderitem.mainItemIndex
            imageloaderitem.item.finishSetup()
        }
    }
    active: false
    sourceComponent:
    Item {

        id: loader_top

        width: image_top.width // qmllint disable unqualified
        height: image_top.height // qmllint disable unqualified

        visible: false

        // some image properties
        property int imageRotation: 0
        property bool rotatedUpright: (Math.abs(imageRotation%180)!=90)
        property real imageScale: defaultScale
        property real defaultWidth
        property real defaultHeight
        property real defaultScale: 1
        property size imageResolution: Qt.size(0,0)

        onImageResolutionChanged: {
            if(loader_top.isMainImage)
                image_top.currentResolution = imageResolution // qmllint disable unqualified
        }

        property int imagePosX: 0
        property int imagePosY: 0
        property bool imageMirrorH: false
        property bool imageMirrorV: false

        property bool listenToClicksOnImage: false
        property bool thisIsAPhotoSphere: false
        property bool photoSphereManuallyEntered: false
        property real photoSphereDefaultScaleBackup: 1.0

        property bool videoLoaded: false
        property bool videoPlaying: false
        property real videoDuration: 0.0
        property real videoPosition: 0.0
        property bool videoHasAudio: false

        // this is set to the duplicate from the loader
        property int mainItemIndex: -1
        // when switching images, either one might be set to the current index, eventually (within milliseconds) both will be
        property bool isMainImage: (image_top.currentlyVisibleIndex===mainItemIndex || PQCFileFolderModel.currentIndex===mainItemIndex) // qmllint disable unqualified


        // some signals
        signal zoomInForKenBurns()
        signal zoomActualWithoutAnimation()
        signal zoomResetWithoutAnimation()
        signal rotationResetWithoutAnimation()
        signal rotationZoomResetWithoutAnimation()
        signal loadScaleRotation()
        signal stopVideoAndReset()
        signal restartVideoIfAutoplay()
        signal moveViewToCenter()
        signal resetToDefaults()

        signal videoTogglePlay()
        signal videoToPos(var s)
        signal imageClicked()

        signal finishSetup()

        onVideoPlayingChanged: {
            if(loader_top.isMainImage)
                image_top.currentlyShowingVideoPlaying = loader_top.videoPlaying // qmllint disable unqualified
        }
        onVideoHasAudioChanged: {
            if(loader_top.isMainImage)
                image_top.currentlyShowingVideoHasAudio = loader_top.videoHasAudio // qmllint disable unqualified
        }
        onVideoLoadedChanged: {
            if(loader_top.isMainImage)
                image_top.currentlyShowingVideo = loader_top.videoLoaded // qmllint disable unqualified
        }

        // keeping the shortcut for rotation pressed triggers it repeatedly very quickly
        // this rate limits the rotation operation to the interval below
        property bool delayImageRotate: false
        Timer {
            id: resetDelayImageRotate
            interval: 250
            onTriggered: {
                loader_top.delayImageRotate = false
            }
        }

        // react to user commands
        Connections {

            target: image_top // qmllint disable unqualified

            function onZoomIn(wheelDelta : point) {
                if(loader_top.isMainImage) {

                    if(PQCNotify.faceTagging || PQCNotify.showingPhotoSphere) return // qmllint disable unqualified

                    if(PQCSettings.imageviewZoomSpeedRelative) {

                        // compute zoom factor based on wheel movement (if done by mouse)
                        var zoomfactor
                        if(wheelDelta !== undefined)
                            zoomfactor = Math.max(1.01, Math.min(1.3, 1+Math.abs(Math.min(0.002, (0.3/wheelDelta.y))*PQCSettings.imageviewZoomSpeed)))
                        else
                            zoomfactor = Math.max(1.01, Math.min(1.3, 1+(PQCSettings.imageviewZoomSpeed*0.01)))

                        if(PQCSettings.imageviewZoomMaxEnabled)
                            loader_top.imageScale = Math.min((PQCSettings.imageviewZoomMax/100), loader_top.imageScale*zoomfactor)
                        else
                            loader_top.imageScale = Math.min(25, loader_top.imageScale*zoomfactor)

                    } else {

                        if(PQCSettings.imageviewZoomMaxEnabled)
                            loader_top.imageScale += Math.min(PQCSettings.imageviewZoomMax*0.01/toplevel.getDevicePixelRatio() - loader_top.imageScale, (PQCSettings.imageviewZoomSpeed*0.01)/toplevel.getDevicePixelRatio())
                        else
                            loader_top.imageScale += Math.min(25/toplevel.getDevicePixelRatio() - loader_top.imageScale, (PQCSettings.imageviewZoomSpeed*0.01)/toplevel.getDevicePixelRatio())

                    }
                }
            }
            function onZoomOut(wheelDelta : point) {
                if(loader_top.isMainImage) {

                    if(PQCNotify.faceTagging || PQCNotify.showingPhotoSphere) return // qmllint disable unqualified

                    if(PQCSettings.imageviewZoomSpeedRelative) {

                        // compute zoom factor based on wheel movement (if done by mouse)
                        var zoomfactor
                        if(wheelDelta !== undefined)
                            zoomfactor = Math.max(1.01, Math.min(1.3, 1+Math.abs(Math.min(0.002, (0.3/wheelDelta.y))*PQCSettings.imageviewZoomSpeed)))
                        else
                            zoomfactor = Math.max(1.01, Math.min(1.3, 1+PQCSettings.imageviewZoomSpeed*0.01))

                        if(PQCSettings.imageviewZoomMinEnabled)
                            loader_top.imageScale = Math.max(loader_top.defaultScale*(PQCSettings.imageviewZoomMin/100), loader_top.imageScale/zoomfactor)
                        else
                            loader_top.imageScale = Math.max(0.01, loader_top.imageScale/zoomfactor)

                    } else {

                        if(PQCSettings.imageviewZoomMinEnabled)
                            loader_top.imageScale = Math.max(loader_top.defaultScale*(PQCSettings.imageviewZoomMin/100)/toplevel.getDevicePixelRatio(), loader_top.imageScale - (PQCSettings.imageviewZoomSpeed*0.01)/toplevel.getDevicePixelRatio())
                        else
                            loader_top.imageScale = Math.max(0.01/toplevel.getDevicePixelRatio(), loader_top.imageScale - (PQCSettings.imageviewZoomSpeed*0.01)/toplevel.getDevicePixelRatio())

                    }
                }
            }
            function onZoomReset() {

                if(PQCNotify.faceTagging || PQCNotify.showingPhotoSphere) return // qmllint disable unqualified

                if(loader_top.isMainImage)
                    loader_top.imageScale = Qt.binding(function() { return loader_top.defaultScale } )
            }
            function onZoomActual() {

                if(PQCNotify.faceTagging || PQCNotify.showingPhotoSphere) return // qmllint disable unqualified

                if(loader_top.isMainImage)
                    loader_top.imageScale = 1/toplevel.getDevicePixelRatio()
            }
            function onRotateClock() {

                if(PQCNotify.faceTagging || PQCNotify.showingPhotoSphere) return // qmllint disable unqualified

                // rate limit rotation
                if(loader_top.delayImageRotate) {
                    if(!resetDelayImageRotate.running)
                        resetDelayImageRotate.restart()
                    return
                }
                loader_top.delayImageRotate = true
                resetDelayImageRotate.restart()

                if(loader_top.isMainImage)
                    loader_top.imageRotation += 90
            }
            function onRotateAntiClock() {

                if(PQCNotify.faceTagging || PQCNotify.showingPhotoSphere) return // qmllint disable unqualified

                // rate limit rotation
                if(loader_top.delayImageRotate) {
                    if(!resetDelayImageRotate.running)
                        resetDelayImageRotate.restart()
                    return
                }
                loader_top.delayImageRotate = true
                resetDelayImageRotate.restart()

                if(loader_top.isMainImage)
                    loader_top.imageRotation -= 90
            }
            function onRotateReset() {

                if(PQCNotify.faceTagging || PQCNotify.showingPhotoSphere) return // qmllint disable unqualified

                if(loader_top.isMainImage) {
                    // rotate to the nearest (rotation%360==0) degrees
                    var offset = loader_top.imageRotation%360
                    if(offset == 180 || offset == 270)
                        loader_top.imageRotation += (360-offset)
                    else if(offset == 90)
                        loader_top.imageRotation -= 90
                    else if(offset == -90)
                        loader_top.imageRotation += 90
                    else if(offset == -180 || offset == -270)
                        loader_top.imageRotation -= (360+offset)
                }
            }

            function onReloadImage() {
                if(loader_top.isMainImage)
                    loader_top.reloadTheImage()
            }

            function onEnterPhotoSphere() {
                if(!loader_top.isMainImage || !loader_top.thisIsAPhotoSphere || PQCSettings.filetypesPhotoSphereAutoLoad) // qmllint disable unqualified
                    return
                loader_top.doEnterPhotoSphere()
            }

            function onExitPhotoSphere() {
                if(!loader_top.isMainImage || !loader_top.thisIsAPhotoSphere || PQCSettings.filetypesPhotoSphereAutoLoad) // qmllint disable unqualified
                    return
                loader_top.doExitPhotoSphere()
            }

        }

        function doEnterPhotoSphere() {
            loader_top.photoSphereDefaultScaleBackup = loader_top.defaultScale
            loader_top.photoSphereManuallyEntered = true
            loader_top.finishSetup()
            image_wrapper.scale = 1
            loader_top.imageScale = image_wrapper.scale
        }

        function doExitPhotoSphere() {
            loader_top.photoSphereManuallyEntered = false
            loader_top.finishSetup()
            image_wrapper.scale = loader_top.photoSphereDefaultScaleBackup
            loader_top.defaultScale = image_wrapper.scale
            loader_top.imageScale = image_wrapper.scale
        }

        Connections {

            target: PQCSettings // qmllint disable unqualified

            function onImageviewColorSpaceDefaultChanged() {
                if(loader_top.isMainImage)
                    loader_top.reloadTheImage()
            }

        }

        function reloadTheImage() {

            if(image_loader_pdf.active) {
                image_loader_pdf.active = false
                image_loader_pdf.active = true
            } else if(image_loader_arc.active) {
                image_loader_arc.active = false
                image_loader_arc.active = true
            } else if(image_loader_mpv.active) {
                image_loader_mpv.active = false
                image_loader_mpv.active = true
            } else if(image_loader_vidqt.active) {
                image_loader_vidqt.active = false
                image_loader_vidqt.active = true
            } else if(image_loader_ani.active) {
                image_loader_ani.active = false
                image_loader_ani.active = true
            } else if(image_loader_svg.active) {
                image_loader_svg.active = false
                image_loader_svg.active = true
            } else if(image_loader_sph.active) {
                image_loader_sph.active = false
                image_loader_sph.active = true
            } else if(image_loader_img.active) {
                image_loader_img.active = false
                image_loader_img.active = true
            }

            minimap_loader.active = false
            minimap_loader.active = true
        }

        Flickable {

            id: flickable

            width: parent.width
            height: parent.height

            contentWidth: flickable_content.width
            contentHeight: flickable_content.height

            visibleArea.onXPositionChanged: {
                if(loader_top.isMainImage)
                    image_top.currentFlickableVisibleAreaX = visibleArea.xPosition // qmllint disable unqualified
            }
            visibleArea.onYPositionChanged: {
                if(loader_top.isMainImage)
                    image_top.currentFlickableVisibleAreaY = visibleArea.yPosition // qmllint disable unqualified
            }
            visibleArea.onWidthRatioChanged: {
                if(loader_top.isMainImage)
                    image_top.currentFlickableVisibleAreaWidthRatio = visibleArea.widthRatio // qmllint disable unqualified
            }
            visibleArea.onHeightRatioChanged: {
                if(loader_top.isMainImage)
                    image_top.currentFlickableVisibleAreaHeightRatio = visibleArea.heightRatio // qmllint disable unqualified
            }

            // When dragging the image out of bounds and it returning, the visibleArea property of Flickable does not tirgger an update
            // This is causing, e.g., the minimap to not update with the actual position of the view
            // This check here makes sure that we force an update to the position, but only if the image was dragged out of bounds
            // (See the onRunningChanged signal in the rebound animation)
            property bool needToRecheckPosition: false
            onMovementEnded: {
                if(needToRecheckPosition) {
                    flickable.contentX += 1
                    flickable.contentY += 1
                    flickable.contentX -= 1
                    flickable.contentY -= 1
                    needToRecheckPosition = false
                }
            }

            rebound: Transition {
                NumberAnimation {
                    properties: "x,y"
                    // we set this duration to 0 for slideshows as for certain effects (e.g. ken burns) we rather have an immediate return
                    duration: PQCNotify.slideshowRunning ? 0 : 250 // qmllint disable unqualified
                    easing.type: Easing.OutQuad
                }
                // Signal that the view was dragged out of bounds
                onRunningChanged:
                    flickable.needToRecheckPosition = true
            }

            interactive: !PQCNotify.faceTagging && !PQCNotify.showingPhotoSphere && !PQCNotify.slideshowRunning // qmllint disable unqualified

            contentX: loader_top.imagePosX
            onContentXChanged: {
                if(loader_top.imagePosX !== contentX)
                    loader_top.imagePosX = contentX
            }
            contentY: loader_top.imagePosY
            onContentYChanged: {
                if(loader_top.imagePosY !== contentY)
                    loader_top.imagePosY = contentY
            }

            Connections {

                target: PQCNotify // qmllint disable unqualified

                function onMouseWheel(angleDelta : point, modifiers : int) {
                    if(PQCSettings.imageviewUseMouseWheelForImageMove || PQCNotify.faceTagging || PQCNotify.showingPhotoSphere) // qmllint disable unqualified
                        return
                    flickable.interactive = false
                    reEnableInteractive.restart()
                }

                function onMousePressed(mods : int, button : string, pos : point) {

                    if(!PQCSettings.imageviewUseMouseLeftButtonForImageMove && !PQCNotify.faceTagging && !PQCNotify.showingPhotoSphere) { // qmllint disable unqualified
                        reEnableInteractive.stop()
                        flickable.interactive = false
                    }

                    if(!loader_top.isMainImage)
                        return

                    var locpos = flickable_content.mapFromItem(imageloaderitem.access_fullscreen, pos.x, pos.y)

                    if(PQCSettings.interfaceCloseOnEmptyBackground) {
                        if(locpos.x < 0 || locpos.y < 0 || locpos.x > flickable_content.width || locpos.y > flickable_content.height)
                            toplevel.close()
                        return
                    }

                    if(PQCSettings.interfaceNavigateOnEmptyBackground) {
                        if(locpos.x < 0 || (locpos.x < flickable_content.width/2 && (locpos.y < 0 || locpos.y > flickable_content.height)))
                            image_top.showPrev()
                        else if(locpos.x > flickable_content.width || (locpos.x > flickable_content.width/2 && (locpos.y < 0 || locpos.y > flickable_content.height)))
                            image_top.showNext()
                        return
                    }

                    if(PQCSettings.interfaceWindowDecorationOnEmptyBackground) {
                        if(locpos.x < 0 || locpos.y < 0 || locpos.x > flickable_content.width || locpos.y > flickable_content.height)
                            PQCSettings.interfaceWindowDecoration = !PQCSettings.interfaceWindowDecoration
                        return
                    }

                }

                function onMouseReleased() {
                    if(!PQCSettings.imageviewUseMouseLeftButtonForImageMove && !PQCNotify.faceTagging && !PQCNotify.showingPhotoSphere) { // qmllint disable unqualified
                        reEnableInteractive.restart()
                    }
                }

            }

            Timer {
                id: reEnableInteractive
                interval: 100
                repeat: false
                onTriggered:
                    flickable.interactive = Qt.binding(function() { return !PQCNotify.faceTagging && !PQCNotify.showingPhotoSphere && !PQCNotify.slideshowRunning })
            }

            // the container for the content
            Item {
                id: flickable_content

                x: Math.max(0, (flickable.width-width)/2)
                y: Math.max(0, (flickable.height-height)/2)
                width: (loader_top.rotatedUpright ? image_wrapper.width : image_wrapper.height)*image_wrapper.scale
                height: (loader_top.rotatedUpright ? image_wrapper.height : image_wrapper.width)*image_wrapper.scale

                // wrapper for the image
                // we need both this and the container to be able to properly hadle
                // all scaling and rotations while having the flickable properly flick the image
                Item {

                    id: image_wrapper

                    y: (loader_top.rotatedUpright ?
                            (height*scale-height)/2 :
                            (-(image_wrapper.height - image_wrapper.width)/2 + (width*scale-width)/2))
                    x: (loader_top.rotatedUpright ?
                            (width*scale-width)/2 :
                            (-(image_wrapper.width - image_wrapper.height)/2 + (height*scale-height)/2))

                    // some properties
                    property real prevW: loader_top.defaultWidth
                    property real prevH: loader_top.defaultHeight
                    property real prevScale: scale
                    property bool startupScale: false

                    property real kenBurnsZoomFactor: loader_top.defaultScale

                    rotation: 0
                    scale: loader_top.defaultScale

                    signal setMirrorHVToImage(var mirH, var mirV)

                    // update content position
                    onScaleChanged: {

                        var updContentX = 0
                        var updContentY = 0

                        // if the width is larger than the visible width
                        if(width*scale > flickable.width) {
                            updContentX = flickable.contentX+(width*scale - prevW)/2
                        }
                        // if the height is larger than the visible height
                        if(height*scale > flickable.height) {
                            updContentY = flickable.contentY+(height*scale - prevH)/2
                        }

                        flickable.contentX = updContentX
                        flickable.contentY = updContentY

                        prevW = width*scale
                        prevH = height*scale
                        prevScale = scale

                        if(loader_top.isMainImage)
                            image_top.currentScale = scale // qmllint disable unqualified

                    }

                    onRotationChanged: {
                        if(loader_top.isMainImage)
                            image_top.currentRotation = rotation // qmllint disable unqualified
                    }

                    // react to status changes
                    property int status: Image.Null
                    onStatusChanged: {
                        if(status == Image.Ready) {
                            imageloaderitem.imageLoadedAndReady = true
                            if(loader_top.isMainImage) {
                                imageloaderitem.busyTimerStopAndHide()
                                var tmp = image_wrapper.computeDefaultScale()
                                if(Math.abs(tmp-1) > 1e-6)
                                    image_wrapper.startupScale = true
                                loader_top.defaultWidth = width*loader_top.defaultScale
                                loader_top.defaultHeight = height*loader_top.defaultScale
                                loader_top.defaultScale = 0.99999999*tmp
                                image_top.defaultScale = loader_top.defaultScale // qmllint disable unqualified
                                imageloaderitem.iAmReady()
                                loader_top.setUpImageWhenReady()
                            }
                        } else if(loader_top.isMainImage)
                            imageloaderitem.busyTimerRestart()
                    }

                    onWidthChanged: {
                        if(imageloaderitem.imageLoadedAndReady) {
                            resetDefaults.triggered()
                        }
                    }
                    onHeightChanged: {
                        if(imageloaderitem.imageLoadedAndReady) {
                            resetDefaults.triggered()
                        }
                    }

                    /**********************************************************/
                    // This loader animates a faded out image in the background for the Ken Burns slideshow effect
                    // when there are empty bars left/right or above/below the image being animated
                    PQKenBurnsSlideshowBackground {
                        id: kenburnsBG
                    }
                    /**********************************************************/

                    // the actual image

                    Loader {
                        id: image_loader_pdf
                        asynchronous: true
                        active: false
                        sourceComponent:
                            PQDocument {

                                imageSource: imageloaderitem.imageSource

                                onWidthChanged: {
                                    image_wrapper.width = width
                                    loader_top.resetToDefaults()
                                    image_wrapper.startupScale = false
                                }
                                onHeightChanged: {
                                    image_wrapper.height = height
                                    loader_top.resetToDefaults()
                                    image_wrapper.startupScale = false
                                }

                                // we do not want to have a property binding for this
                                // otherwise we get error messages when the source changes to a different type
                                Component.onCompleted:
                                    imageSource = imageloaderitem.imageSource

                            }
                    }

                    Loader {
                        id: image_loader_arc
                        asynchronous: true
                        active: false
                        sourceComponent:
                            PQArchive {

                                imageSource: imageloaderitem.imageSource

                                onWidthChanged: {
                                    image_wrapper.width = width
                                    loader_top.resetToDefaults()
                                    image_wrapper.startupScale = false
                                }
                                onHeightChanged: {
                                    image_wrapper.height = height
                                    loader_top.resetToDefaults()
                                    image_wrapper.startupScale = false
                                }

                                // we do not want to have a property binding for this
                                // otherwise we get error messages when the source changes to a different type
                                Component.onCompleted:
                                    imageSource = imageloaderitem.imageSource

                            }
                    }

                    Loader {
                        id: image_loader_mpv
                        asynchronous: true
                        active: false
                        sourceComponent:
                            PQVideoMpv {

                                imageSource: imageloaderitem.imageSource

                                onWidthChanged: {
                                    image_wrapper.width = width
                                    loader_top.imageResolution.width = width
                                }
                                onHeightChanged: {
                                    loader_top.imageResolution.height = height
                                    image_wrapper.height = height
                                }

                                // we do not want to have a property binding for this
                                // otherwise we get error messages when the source changes to a different type
                                Component.onCompleted:
                                    imageSource = imageloaderitem.imageSource

                            }
                    }

                    Loader {
                        id: image_loader_vidqt
                        asynchronous: true
                        active: false
                        sourceComponent:
                            PQVideoQt {

                                imageSource: imageloaderitem.imageSource

                                onWidthChanged: {
                                    image_wrapper.width = width
                                    loader_top.imageResolution.width = width
                                }
                                onHeightChanged: {
                                    loader_top.imageResolution.height = height
                                    image_wrapper.height = height
                                }

                                // we do not want to have a property binding for this
                                // otherwise we get error messages when the source changes to a different type
                                Component.onCompleted:
                                    imageSource = imageloaderitem.imageSource

                            }
                    }

                    Loader {
                        id: image_loader_ani
                        asynchronous: true
                        active: false
                        sourceComponent:
                            PQImageAnimated {

                                imageSource: imageloaderitem.imageSource

                                onWidthChanged:
                                    image_wrapper.width = width
                                onHeightChanged:
                                    image_wrapper.height = height

                                // we do not want to have a property binding for this
                                // otherwise we get error messages when the source changes to a different type
                                Component.onCompleted:
                                    imageSource = imageloaderitem.imageSource
                            }
                    }

                    Loader {
                        id: image_loader_svg
                        asynchronous: true
                        active: false
                        sourceComponent:
                            PQSVG {

                                imageSource: imageloaderitem.imageSource

                                onWidthChanged:
                                    image_wrapper.width = width
                                onHeightChanged:
                                    image_wrapper.height = height

                                // we do not want to have a property binding for this
                                // otherwise we get error messages when the source changes to a different type
                                Component.onCompleted:
                                    imageSource = imageloaderitem.imageSource

                            }
                    }

                    Loader {
                        id: image_loader_sph
                        asynchronous: true
                        active: false
                        sourceComponent:
                            PQPhotoSphere { // qmllint disable

                                id: sphitem

                                imageSource: imageloaderitem.imageSource

                                onWidthChanged:
                                    image_wrapper.width = sphitem.width
                                onHeightChanged:
                                    image_wrapper.height = sphitem.height

                                // we do not want to have a property binding for this
                                // otherwise we get error messages when the source changes to a different type
                                Component.onCompleted:
                                    imageSource = imageloaderitem.imageSource

                            }
                    }

                    Loader {
                        id: image_loader_img
                        asynchronous: true
                        active: false
                        sourceComponent:
                            PQImageNormal {

                                imageSource: imageloaderitem.imageSource

                                onWidthChanged: {
                                    if(!ignoreSignals)
                                        image_wrapper.width = width
                                }
                                onHeightChanged: {
                                    if(!ignoreSignals)
                                        image_wrapper.height = height
                                }

                                // we do not want to have a property binding for this
                                // otherwise we get error messages when the source changes to a different type
                                Component.onCompleted:
                                    imageSource = imageloaderitem.imageSource

                            }
                    }

                    Connections {

                        target: loader_top

                        function onFinishSetup() {
                            image_top.currentFileInside = 0 // qmllint disable unqualified
                            image_top.currentFilesInsideCount = 0
                            image_top.currentFileInsideFilename = ""
                            loader_top.listenToClicksOnImage = false
                            loader_top.videoPlaying = false
                            loader_top.videoLoaded = false
                            loader_top.videoDuration = 0
                            loader_top.videoPosition = 0
                            loader_top.videoHasAudio = false
                            loader_top.thisIsAPhotoSphere = false
                            PQCNotify.showingPhotoSphere = false

                            image_loader_pdf.active = false
                            image_loader_arc.active = false
                            image_loader_mpv.active = false
                            image_loader_vidqt.active = false
                            image_loader_ani.active = false
                            image_loader_svg.active = false
                            image_loader_sph.active = false
                            image_loader_img.active = false

                            if(PQCScriptsImages.isPDFDocument(imageloaderitem.imageSource))
                                image_loader_pdf.active = true
                            else if(PQCScriptsImages.isArchive(imageloaderitem.imageSource))
                                image_loader_arc.active = true
                            else if(PQCScriptsImages.isMpvVideo(imageloaderitem.imageSource)) {
                                image_loader_mpv.active = true
                                loader_top.listenToClicksOnImage = true
                                loader_top.videoLoaded = true
                            } else if(PQCScriptsImages.isQtVideo(imageloaderitem.imageSource)) {
                                image_loader_vidqt.active = true
                                loader_top.listenToClicksOnImage = true
                                loader_top.videoLoaded = true
                            } else if(PQCScriptsImages.isItAnimated(imageloaderitem.imageSource)) {
                                image_loader_ani.active = true
                                loader_top.listenToClicksOnImage = true
                            } else if(PQCScriptsImages.isSVG(imageloaderitem.imageSource)) {
                                image_loader_svg.active = true
                            } else if(PQCScriptsImages.isPhotoSphere(imageloaderitem.imageSource) && (loader_top.photoSphereManuallyEntered || PQCSettings.filetypesPhotoSphereAutoLoad)) {
                                loader_top.thisIsAPhotoSphere = true
                                PQCNotify.showingPhotoSphere = true
                                image_loader_sph.active = true
                            } else {
                                loader_top.thisIsAPhotoSphere = PQCScriptsImages.isPhotoSphere(imageloaderitem.imageSource)
                                image_loader_img.active = true
                            }

                            image_top.currentlyShowingVideo = loader_top.videoLoaded
                            image_top.currentlyShowingVideoPlaying = loader_top.videoPlaying
                            image_top.currentlyShowingVideoHasAudio = loader_top.videoHasAudio

                        }

                    }

                    PQBarCodes {
                        id: barcodes
                    }

                    PQFaceTracker {
                        id: facetracker
                    }

                    PQFaceTagger {
                        id: facetagger
                    }

                    Loader {
                        id: minimap_loader
                        active: loader_top.isMainImage && PQCSettings.imageviewShowMinimap // qmllint disable unqualified
                        asynchronous: true
                        source: "components/" + (PQCSettings.interfaceMinimapPopout ? "PQMinimapPopout.qml" : "PQMinimap.qml") // qmllint disable unqualified
                    }

                    // scaling animation
                    PropertyAnimation {
                        id: scaleAnimation
                        target: image_wrapper
                        property: "scale"
                        from: image_wrapper.scale
                        to: loader_top.imageScale
                        duration: 200
                    }

                    // rotation animation
                    PropertyAnimation {
                        id: rotationAnimation
                        target: image_wrapper
                        duration: 200
                        property: "rotation"
                    }

                    // reset default properties when window size changed
                    Timer {
                        id: resetDefaults
                        interval: 100
                        onTriggered: {
                            var tmp = image_wrapper.computeDefaultScale()
                            if(Math.abs(image_wrapper.scale-loader_top.defaultScale) < 1e-6) {

                                loader_top.defaultScale = 0.99999999*tmp

                                if(!PQCSettings.imageviewRememberZoomRotationMirror || !(imageloaderitem.imageSource in image_top.rememberChanges)) { // qmllint disable unqualified
                                    if(!PQCSettings.imageviewPreserveZoom && !PQCSettings.imageviewPreserveRotation)
                                        loader_top.rotationZoomResetWithoutAnimation()
                                    else {
                                        if(!PQCSettings.imageviewPreserveZoom)
                                            loader_top.zoomResetWithoutAnimation()
                                        if(!PQCSettings.imageviewPreserveRotation)
                                            loader_top.rotationResetWithoutAnimation()
                                    }
                                }

                            } else {

                                loader_top.defaultScale = 0.99999999*tmp

                            }

                            if(loader_top.isMainImage) {
                                image_top.defaultScale = loader_top.defaultScale
                            }
                        }
                    }

                    PropertyAnimation {
                        id: animateX
                        target: flickable
                        property: "contentX"
                        duration: 200
                    }

                    PropertyAnimation {
                        id: animateY
                        target: flickable
                        property: "contentY"
                        duration: 200
                    }

                    Connections {
                        target: imageloaderitem.access_fullscreen // qmllint disable unqualified

                        function onWidthChanged() {
                            resetDefaults.restart()
                        }

                        function onHeightChanged() {
                            resetDefaults.restart()
                        }
                    }

                    Connections {

                        target: image_top // qmllint disable unqualified

                        function onPlayPauseAnimationVideo() {

                            if(!loader_top.isMainImage)
                                return

                            loader_top.videoTogglePlay()
                        }

                        function onMoveView(direction : string) {

                            if(!loader_top.isMainImage)
                                return

                            if(PQCNotify.showingPhotoSphere) // qmllint disable unqualified
                                return

                            if(direction === "left")
                                flickable.flick(1000,0)
                            else if(direction === "right")
                                flickable.flick(-1000,0)
                            else if(direction === "up")
                                flickable.flick(0,1000)
                            else if(direction === "down")
                                flickable.flick(0,-1000)
                            else if(direction === "leftedge") {
                                animateX.stop()
                                animateX.from = flickable.contentX
                                animateX.to = 0
                                animateX.start()
                            } else if(direction === "rightedge") {
                                animateX.stop()
                                animateX.from = flickable.contentX
                                animateX.to = flickable.contentWidth-flickable.width
                                animateX.start()
                            } else if(direction === "topedge") {
                                animateY.stop()
                                animateY.from = flickable.contentY
                                animateY.to = 0
                                animateY.start()
                            } else if(direction === "bottomedge") {
                                animateY.stop()
                                animateY.from = flickable.contentY
                                animateY.to = flickable.contentHeight-flickable.height
                                animateY.start()
                            }

                        }

                    }

                    // connect image wrapper to some of its properties
                    Connections {

                        target: loader_top

                        function onImageScaleChanged() {

                            if(!loader_top.isMainImage)
                                return

                            if(image_wrapper.startupScale) {
                                image_wrapper.startupScale = false
                                image_wrapper.scale = loader_top.imageScale
                            } else {
                                scaleAnimation.from = image_wrapper.scale
                                scaleAnimation.to = loader_top.imageScale
                                scaleAnimation.restart()
                            }
                        }

                        function onRotationZoomResetWithoutAnimation() {

                            if(!loader_top.isMainImage)
                                return

                            if(PQCNotify.showingPhotoSphere) // qmllint disable unqualified
                                return

                            scaleAnimation.stop()
                            rotationAnimation.stop()

                            image_wrapper.rotation = 0
                            loader_top.imageRotation = 0
                            image_wrapper.scale = loader_top.defaultScale
                            loader_top.imageScale = image_wrapper.scale

                        }

                        function onZoomActualWithoutAnimation() {

                            if(!loader_top.isMainImage)
                                return

                            if(PQCNotify.showingPhotoSphere) // qmllint disable unqualified
                                return

                            scaleAnimation.stop()

                            image_wrapper.scale = 1
                            loader_top.imageScale = image_wrapper.scale

                        }

                        function onZoomInForKenBurns() {

                            if(!loader_top.isMainImage)
                                return

                            // this function might be called more than once
                            // this check makes sure that we only do this once
                            if(image_top.width < flickable.contentWidth || image_top.height < flickable.contentHeight) // qmllint disable unqualified
                                return

                            if(PQCNotify.showingPhotoSphere)
                                return

                            scaleAnimation.stop()

                            // figure out whether the image is much wider or much higher than the other dimension

                            var facW = 1
                            var facH = 1

                            if(flickable.contentWidth > 0)
                                facW = image_top.width/flickable.contentWidth
                            if(flickable.contentHeight > 0)
                                facH = image_top.height/flickable.contentHeight

                            // we zoom images in to fill the full screen
                            // UNLESS the image dimensions are rather different AND differ from the window dimensions
                            var fac = Math.max(facW, facH)
                            var rel = image_wrapper.width/image_wrapper.height
                            if(((image_wrapper.width > image_wrapper.height && image_top.height > image_top.width) ||
                                (image_wrapper.height > image_wrapper.width && image_top.width > image_top.height)) &&
                                    (rel < 0.75 || rel > 1.25))
                                fac = Math.min(facW, facH)

                            // small images are not scaled as much as larger ones
                            if(loader_top.defaultScale > 0.99)
                                image_wrapper.kenBurnsZoomFactor = loader_top.defaultScale * fac*1.05
                            else
                                image_wrapper.kenBurnsZoomFactor = loader_top.defaultScale * fac*1.2

                            // set scale factors
                            image_wrapper.scale = image_wrapper.kenBurnsZoomFactor
                            loader_top.imageScale = image_wrapper.scale

                        }

                        function onLoadScaleRotation() {

                            if(!loader_top.isMainImage)
                                return

                            if(PQCNotify.showingPhotoSphere) // qmllint disable unqualified
                                return

                            if((PQCSettings.imageviewRememberZoomRotationMirror && (imageloaderitem.imageSource in image_top.rememberChanges)) ||
                                    ((PQCSettings.imageviewPreserveZoom || PQCSettings.imageviewPreserveRotation ||
                                      PQCSettings.imageviewPreserveMirror) && image_top.reuseChanges.length > 1)) {

                                var vals;
                                if(PQCSettings.imageviewRememberZoomRotationMirror && (imageloaderitem.imageSource in image_top.rememberChanges))
                                    vals = image_top.rememberChanges[imageloaderitem.imageSource]
                                else
                                    vals = image_top.reuseChanges

                                if(PQCSettings.imageviewRememberZoomRotationMirror || PQCSettings.imageviewPreserveZoom) {
                                    image_wrapper.scale = vals[2]
                                    loader_top.imageScale = vals[2]
                                }

                                if(PQCSettings.imageviewRememberZoomRotationMirror || PQCSettings.imageviewPreserveRotation) {
                                    image_wrapper.rotation = vals[3]
                                    loader_top.imageRotation = vals[3]
                                } else {
                                    image_wrapper.rotation = 0
                                    loader_top.imageRotation = 0
                                }

                                if(PQCSettings.imageviewRememberZoomRotationMirror || PQCSettings.imageviewPreserveMirror)
                                    image_wrapper.setMirrorHVToImage(vals[4], vals[5])
                                else
                                    image_wrapper.setMirrorHVToImage(false, false)

                                flickable.contentX = vals[0]
                                flickable.contentY = vals[1]
                                flickable.returnToBounds()

                            } else if(!PQCSettings.imageviewAlwaysActualSize) {

                                scaleAnimation.stop()
                                rotationAnimation.stop()

                                image_wrapper.rotation = 0
                                loader_top.imageRotation = 0
                                image_wrapper.setMirrorHVToImage(false, false)
                                image_wrapper.scale = loader_top.defaultScale
                                loader_top.imageScale = image_wrapper.scale

                            }

                        }

                        function onImageRotationChanged() {
                            if(loader_top.isMainImage) {
                                rotationAnimation.stop()
                                rotationAnimation.from = image_wrapper.rotation
                                rotationAnimation.to = loader_top.imageRotation
                                rotationAnimation.restart()
                                var oldDefault = loader_top.defaultScale
                                loader_top.defaultScale = 0.99999999*image_wrapper.computeDefaultScale()
                                if(Math.abs(loader_top.imageScale-oldDefault) < 1e-6)
                                    loader_top.imageScale = loader_top.defaultScale
                                image_top.defaultScale = loader_top.defaultScale // qmllint disable unqualified
                            }
                        }

                        function onMoveViewToCenter() {

                            if(!loader_top.isMainImage)
                                return

                            if(PQCNotify.showingPhotoSphere) // qmllint disable unqualified
                                return

                            if(PQCSettings.imageviewRememberZoomRotationMirror || PQCSettings.imageviewPreserveZoom ||
                                    PQCSettings.imageviewPreserveRotation || PQCSettings.imageviewPreserveMirror)
                                return
                            if(flickable.width < flickable.contentWidth)
                                flickable.contentX = (flickable.contentWidth-flickable.width)/2
                            if(flickable.height < flickable.contentHeight)
                                flickable.contentY = (flickable.contentHeight-flickable.height)/2
                        }

                        function onResetToDefaults() {
                            resetDefaults.triggered()
                        }

                    }

                    Connections {
                        target: PQCSettings // qmllint disable unqualified

                        function onThumbnailsVisibilityChanged() {
                            resetDefaults.restart()
                        }

                    }

                    // calculate the default scale based on the current rotation
                    function computeDefaultScale() : real {
                        if(loader_top.rotatedUpright)
                            return Math.min(1./toplevel.getDevicePixelRatio(), Math.min((flickable.width/width), (flickable.height/height))) // qmllint disable unqualified
                        return Math.min(1./toplevel.getDevicePixelRatio(), Math.min((flickable.width/height), (flickable.height/width)))
                    }

                    Timer {
                        id: hidecursor
                        interval: PQCSettings.imageviewHideCursorTimeout*1000 // qmllint disable unqualified
                        repeat: false
                        running: true
                        onTriggered: {
                            if(PQCSettings.imageviewHideCursorTimeout === 0) // qmllint disable unqualified
                                return
                            if(contextmenu.visible)
                                hidecursor.restart()
                            else
                                imagemouse.cursorShape = Qt.BlankCursor
                        }
                    }

                }

            }

        }

        PQMouseArea {
            id: imagemouse
            anchors.fill: parent
            anchors.leftMargin: -flickable_content.x
            anchors.rightMargin: -flickable_content.x
            anchors.topMargin: -flickable_content.y
            anchors.bottomMargin: -flickable_content.y
            hoverEnabled: true
            propagateComposedEvents: true
            acceptedButtons: Qt.AllButtons
            doubleClickThreshold: PQCSettings.interfaceDoubleClickThreshold // qmllint disable unqualified
            onPositionChanged: (mouse) => {
                cursorShape = Qt.ArrowCursor
                hidecursor.restart()
                var pos = imagemouse.mapToItem(imageloaderitem.access_fullscreen, mouse.x, mouse.y)
                PQCNotify.mouseMove(pos.x, pos.y) // qmllint disable unqualified
            }
            onWheel: (wheel) => {
                wheel.accepted = !PQCSettings.imageviewUseMouseWheelForImageMove // qmllint disable unqualified
                PQCNotify.mouseWheel(wheel.angleDelta, wheel.modifiers)
            }
            onPressed: (mouse) => {

                var locpos = flickable_content.mapFromItem(imageloaderitem.access_fullscreen, mouse.x, mouse.y)

                if(PQCSettings.interfaceCloseOnEmptyBackground && // qmllint disable unqualified
                      (locpos.x < flickable_content.x ||
                       locpos.y < flickable_content.y ||
                       locpos.x > flickable_content.x+flickable_content.width ||
                       locpos.y > flickable_content.y+flickable_content.height)) {

                    toplevel.close()
                    return

                }

                if(PQCSettings.interfaceNavigateOnEmptyBackground) {
                    if(locpos.x < flickable_content.x || (locpos.x < flickable_content.x+flickable_content.width/2 &&
                       (locpos.y < flickable_content.y || locpos.y > flickable_content.y+flickable_content.height))) {

                        image_top.showPrev()
                        return

                    } else if(locpos.x > flickable_content.x+flickable_content.width || (locpos.x > flickable_content.x+flickable_content.width/2 &&
                              (locpos.y < flickable_content.y || locpos.y > flickable_content.y+flickable_content.height))) {

                        image_top.showNext()
                        return

                    }
                }

                if(PQCSettings.interfaceWindowDecorationOnEmptyBackground &&
                   (locpos.x < flickable_content.x ||
                    locpos.y < flickable_content.y ||
                    locpos.x > flickable_content.x+flickable_content.width ||
                    locpos.y > flickable_content.y+flickable_content.height)) {

                    PQCSettings.interfaceWindowDecoration = !PQCSettings.interfaceWindowDecoration
                    return

                }

                if(PQCNotify.barcodeDisplayed && mouse.button === Qt.LeftButton)
                    image_top.barcodeClick()
                if(PQCSettings.imageviewUseMouseLeftButtonForImageMove && mouse.button === Qt.LeftButton && !PQCNotify.faceTagging) {
                    mouse.accepted = false
                    return
                }
                var pos = imagemouse.mapToItem(imageloaderitem.access_fullscreen, mouse.x, mouse.y)
                PQCNotify.mousePressed(mouse.modifiers, mouse.button, pos)
            }
            onMouseDoubleClicked: (mouse) => {
                var pos = imagemouse.mapToItem(imageloaderitem.access_fullscreen, mouse.x, mouse.y)
                PQCNotify.mouseDoubleClicked(mouse.modifiers, mouse.button, pos)
            }

            onReleased: (mouse) => {
                if(mouse.button === Qt.LeftButton && loader_top.listenToClicksOnImage)
                    loader_top.imageClicked()
                else {
                    var pos = imagemouse.mapToItem(imageloaderitem.access_fullscreen, mouse.x, mouse.y)
                    PQCNotify.mouseReleased(mouse.modifiers, mouse.button, pos) // qmllint disable unqualified
                }
            }
        }

        // we don't use a pinch area as we want to pass through flick events, something a pincharea cannot do
        MultiPointTouchArea {

            anchors.fill: parent

            mouseEnabled: false

            enabled: !PQCNotify.faceTagging && !PQCNotify.showingPhotoSphere && !PQCNotify.slideshowRunning // qmllint disable unqualified

            property list<point> initialPts: []
            property real initialScale

            onPressed: (points) => {

                pressAndHoldTimeout.touchPos = points[0]

                if(points.length === 2)
                    initialPts = [Qt.point(points[0].x, points[0].y), Qt.point(points[1].x, points[1].y)]
                else {
                    initialPts.push(Qt.point(points[0].x, points[0].y))
                    if(points.length === 1)
                        pressAndHoldTimeout.restart()
                }

                initialScale = image_wrapper.scale

            }
            onUpdated: (points) => {

                if(points.length === 1) {

                    if(Math.abs(points[0].x - pressAndHoldTimeout.touchPos.x) > 20 || Math.abs(points[0].y - pressAndHoldTimeout.touchPos.y) > 20)
                        pressAndHoldTimeout.stop()

                    flickable.flick(points[0].velocity.x*1.5, points[0].velocity.y*1.5)

                } else if(points.length === 2 && initialPts.length === 2) {

                    pressAndHoldTimeout.stop()

                    // compute the rate of change initiated by this pinch
                    var startLength = Math.sqrt(Math.pow(initialPts[0].x-initialPts[1].x, 2) + Math.pow(initialPts[0].y-initialPts[1].y, 2))
                    var curLength = Math.sqrt(Math.pow(points[0].x-points[1].x, 2) + Math.pow(points[0].y-points[1].y, 2))

                    if(startLength > 0 && curLength > 0) {

                        var val = initialScale * (curLength / startLength)

                        if(PQCSettings.imageviewZoomMaxEnabled) {
                            var max = PQCSettings.imageviewZoomMax/100
                            if(val > max)
                                val = max
                            else if(val > 25)
                                val = 25
                        }

                        if(PQCSettings.imageviewZoomMinEnabled) {
                            var min = loader_top.defaultScale*(PQCSettings.imageviewZoomMin/100)
                            if(val < min)
                                val = min
                            else if(val < 0.01)
                                val = 0.01
                        }

                        image_wrapper.scale = val
                        loader_top.imageScale = val

                    }

                } else
                    pressAndHoldTimeout.stop()

            }

            onReleased: (points) => {
                pressAndHoldTimeout.stop()
                initialPts = []
            }

            Timer {
                id: pressAndHoldTimeout
                interval: 1000
                property point touchPos: Qt.point(-1,-1)
                onTriggered: {
                    shortcuts.item.executeInternalFunction("__contextMenuTouch", touchPos) // qmllint disable unqualified
                }
            }

        }

        // animation to show the image
        PropertyAnimation {
            id: opacityAnimation
            target: loader_top
            property: "opacity"
            from: 0
            to: 1
            duration: PQCSettings.imageviewAnimationDuration*100 + (PQCNotify.slideshowRunning&&PQCSettings.slideshowTypeAnimation==="kenburns" ? 500 : 0) // qmllint disable unqualified

            onStarted: {
                if(loader_top.opacity > 0.9)
                    imageloaderitem.imageFullyShown = false
            }

            onFinished: {
                if(loader_top.opacity < 1e-6) {

                    // stop any possibly running video
                    loader_top.stopVideoAndReset()

                    // stop any ken burns animations if running
                    if(loader_kenburns.item != null)
                        loader_kenburns.item.stopAni() // qmllint disable missing-property

                    loader_top.visible = false

                    loader_top.handleWhenCompletelyHidden()

                } else
                    imageFullyShown = true

            }
        }

        // animation to show the image
        PropertyAnimation {
            id: xAnimation
            target: loader_top
            property: "x"
            from: -loader_top.width
            to: 0
            duration: PQCSettings.imageviewAnimationDuration*100 // qmllint disable unqualified
            onStarted: {
                if(Math.abs(loader_top.x) < 10)
                    imageloaderitem.imageFullyShown = false
            }

            onFinished: {
                if(Math.abs(loader_top.x) > 10) {

                    // stop any possibly running video
                    loader_top.stopVideoAndReset()

                    loader_top.visible = false

                    loader_top.handleWhenCompletelyHidden()

                } else
                    imageloaderitem.imageFullyShown = true

            }
        }

        // animation to show the image
        PropertyAnimation {
            id: yAnimation
            target: loader_top
            property: "y"
            from: -loader_top.height
            to: 0
            duration: PQCSettings.imageviewAnimationDuration*100 // qmllint disable unqualified
            onStarted: {
                if(Math.abs(loader_top.y) < 10)
                    imageloaderitem.imageFullyShown = false
            }

            onFinished: {
                if(Math.abs(loader_top.y) > 10) {

                    // stop any possibly running video
                    loader_top.stopVideoAndReset()

                    loader_top.visible = false

                    loader_top.handleWhenCompletelyHidden()

                } else
                    imageloaderitem.imageFullyShown = true

            }
        }

        // animation to show the image
        ParallelAnimation {
            id: rotAnimation
            PropertyAnimation {
                id: rotAnimation_rotation
                target: loader_top
                property: "rotation"
                from: 0
                to: 180
                duration: PQCSettings.imageviewAnimationDuration*100 // qmllint disable unqualified
            }
            PropertyAnimation {
                id: rotAnimation_opacity
                target: loader_top
                property: "opacity"
                from: 0
                to: 1
                duration: PQCSettings.imageviewAnimationDuration*100 // qmllint disable unqualified
            }
            onStarted: {
                loader_top.z = image_top.curZ+1 // qmllint disable unqualified
                if(loader_top.opacity > 0.9)
                    imageFullyShown = false
            }
            onFinished: {
                if(Math.abs(loader_top.rotation%360) > 1e-6) {

                    // stop any possibly running video
                    loader_top.stopVideoAndReset()

                    loader_top.visible = false
                    loader_top.rotation = 0
                    loader_top.z = image_top.curZ-5 // qmllint disable unqualified

                    loader_top.handleWhenCompletelyHidden()

                } else
                    imageFullyShown = true

            }
        }

        // animation to show the image
        ParallelAnimation {
            id: explosionAnimation
            PropertyAnimation {
                id: explosionAnimation_scale
                target: loader_top
                property: "scale"
                from: 1
                to: 2
                duration: PQCSettings.imageviewAnimationDuration*100 // qmllint disable unqualified
            }
            PropertyAnimation {
                id: explosionAnimation_opacity
                target: loader_top
                property: "opacity"
                from: 1
                to: 0
                duration: PQCSettings.imageviewAnimationDuration*90 // qmllint disable unqualified
            }
            onStarted: {
                loader_top.z = image_top.curZ+1 // qmllint disable unqualified
                if(loader_top.opacity > 0.9)
                    imageloaderitem.imageFullyShown = false
            }
            onFinished: {
                if(Math.abs(loader_top.scale-1) > 1e-6) {

                    // stop any possibly running video
                    loader_top.stopVideoAndReset()

                    loader_top.visible = false
                    loader_top.scale = 1

                    loader_top.z = image_top.curZ-5 // qmllint disable unqualified

                    loader_top.handleWhenCompletelyHidden()

                } else
                    imageloaderitem.imageFullyShown = true

            }
        }

        Loader {
            id: loader_kenburns
            active: PQCNotify.slideshowRunning && PQCSettings.slideshowTypeAnimation === "kenburns" // qmllint disable unqualified
            sourceComponent:
                PQKenBurnsSlideshowEffect { }
        }

        Timer {
            id: selectNewRandomAnimation
            interval: 50
            onTriggered: {
                var animValues = ["opacity","x","y","explosion","implosion","rotation"]
                image_top.randomAnimation = animValues[Math.floor(Math.random()*animValues.length)] // qmllint disable unqualified
            }
        }

        function showImage() {

            if(imageloaderitem.imageLoadedAndReady) {
                imageloaderitem.iAmReady()

                if(!imageloaderitem.imageFullyShown)
                    setUpImageWhenReady()
            }

        }

        function setUpImageWhenReady() {

            // this needs to be checked for early as we set currentlyVisibleIndex in a few lines
            var noPreviousImage = (image_top.currentlyVisibleIndex===-1) // qmllint disable unqualified

            PQCNotify.barcodeDisplayed = false

            image_top.currentlyVisibleIndex = loader_top.mainItemIndex
            image_top.imageFinishedLoading(loader_top.mainItemIndex)

            image_top.currentlyShowingVideo = loader_top.videoLoaded
            image_top.currentlyShowingVideoPlaying = loader_top.videoPlaying
            image_top.currentlyShowingVideoHasAudio = loader_top.videoHasAudio

            image_top.currentFlickableVisibleAreaX = flickable.visibleArea.xPosition
            image_top.currentFlickableVisibleAreaY = flickable.visibleArea.yPosition
            image_top.currentFlickableVisibleAreaWidthRatio = flickable.visibleArea.widthRatio
            image_top.currentFlickableVisibleAreaHeightRatio = flickable.visibleArea.heightRatio

            PQCNotify.showingPhotoSphere = loader_top.thisIsAPhotoSphere && (loader_top.photoSphereManuallyEntered || PQCSettings.filetypesPhotoSphereAutoLoad)

            // if a slideshow is running with the ken burns effect
            // then we need to do some special handling
            if(PQCNotify.slideshowRunning && PQCSettings.slideshowTypeAnimation === "kenburns") {

                if(!PQCNotify.showingPhotoSphere && !loader_top.videoLoaded) {
                    loader_top.resetToDefaults()
                    loader_top.zoomInForKenBurns()
                }
                flickable.returnToBounds()

                opacityAnimation.stop()

                loader_top.opacity = 0
                opacityAnimation.from = 0
                opacityAnimation.to = 1

                opacityAnimation.restart()

            } else {

                // don't pipe showing animation through the property animators
                // when no animation is set or no previous image has been shown
                if(PQCSettings.imageviewAnimationDuration === 0 || noPreviousImage) {

                    loader_top.opacity = 1
                    imageloaderitem.imageFullyShown = true

                } else {

                    var anim = PQCSettings.imageviewAnimationType
                    if(anim === "random")
                        anim = image_top.randomAnimation

                    if(anim === "opacity" || anim === "explosion" || anim === "implosion") {

                        opacityAnimation.stop()

                        loader_top.opacity = 0
                        opacityAnimation.from = 0
                        opacityAnimation.to = 1

                        opacityAnimation.restart()

                    } else if(anim === "x") {

                        xAnimation.stop()

                        // the from value depends on whether we go forwards or backwards in the folder
                        xAnimation.from = -width
                        if(visibleIndexPrevCur[1] === -1 || visibleIndexPrevCur[0] > visibleIndexPrevCur[1])
                            xAnimation.from = width

                        xAnimation.to = 0

                        xAnimation.restart()

                    } else if(anim === "y") {

                        yAnimation.stop()

                        // the from value depends on whether we go forwards or backwards in the folder
                        yAnimation.from = -height
                        if(visibleIndexPrevCur[1] === -1 || visibleIndexPrevCur[0] > visibleIndexPrevCur[1])
                            yAnimation.from = height

                        yAnimation.to = 0

                        yAnimation.restart()

                    } else if(anim === "rotation") {

                        rotAnimation.stop()

                        rotAnimation_rotation.from = -180
                        rotAnimation_rotation.to = 0

                        if(visibleIndexPrevCur[1] === -1 || visibleIndexPrevCur[0] > visibleIndexPrevCur[1]) {
                            rotAnimation_rotation.from = 180
                            rotAnimation_rotation.to = 0
                        }

                        rotAnimation_opacity.from = 0
                        rotAnimation_opacity.to = 1

                        rotAnimation.restart()

                    }

                }

            }

            z = image_top.curZ
            loader_top.visible = true

            // (re-)start any video
            loader_top.restartVideoIfAutoplay()

            image_top.curZ += 1

            image_top.currentScale = loader_top.imageScale
            image_top.currentRotation = loader_top.imageRotation
            image_top.currentResolution = loader_top.imageResolution

            if(PQCSettings.imageviewAnimationType === "random")
                selectNewRandomAnimation.restart()

            // these are only done if we are not in a slideshow with the ken burns effect
            if(!PQCNotify.slideshowRunning || !PQCSettings.slideshowTypeAnimation === "kenburns") {

                if(PQCSettings.imageviewAlwaysActualSize) {
                    loader_top.zoomActualWithoutAnimation()
                    adjustXY.restart()
                }

                loader_top.loadScaleRotation()

            }

            image_top.initialLoadingFinished = true

            if(!PQCNotify.slideshowRunning || !PQCSettings.slideshowTypeAnimation === "kenburns") {

                loader_top.resetToDefaults()
                loader_top.moveViewToCenter()

            }

        }

        // This is done with a slight delay IF the image is to be loaded at full scale
        // If done without delay then contentX/Y will be reset to 0
        Timer {
            id: adjustXY
            interval: 10
            onTriggered: {
                if(flickable.contentWidth > flickable.width)
                    flickable.contentX = (flickable.contentWidth-flickable.width)/2
                if(flickable.contentHeight > flickable.height)
                    flickable.contentY = (flickable.contentHeight-flickable.height)/2
            }
        }

        // hide the image
        function hideImage() {

            // ignore anything that happened during a slideshow
            if(!PQCNotify.slideshowRunning) { // qmllint disable unqualified

                if(loader_top.isMainImage) {

                    if((PQCSettings.imageviewRememberZoomRotationMirror || PQCSettings.imageviewPreserveZoom ||
                                                 PQCSettings.imageviewPreserveRotation || PQCSettings.imageviewPreserveMirror)) {
                        var vals = [loader_top.imagePosX,
                                    loader_top.imagePosY,
                                    loader_top.imageScale,
                                    loader_top.imageRotation,
                                    loader_top.imageMirrorH,
                                    loader_top.imageMirrorV]
                        if(PQCSettings.imageviewRememberZoomRotationMirror)
                            image_top.rememberChanges[imageloaderitem.imageSource] = vals
                        if(PQCSettings.imageviewPreserveZoom || PQCSettings.imageviewPreserveRotation || PQCSettings.imageviewPreserveMirror)
                            image_top.reuseChanges = vals
                    } else
                        // don't delete reuseChanges here, we want to keep those
                        delete image_top.rememberChanges[imageloaderitem.imageSource]

                }

            }

            var anim = PQCSettings.imageviewAnimationType
            if(anim === "random")
                anim = image_top.randomAnimation

            if(anim === "opacity") {

                opacityAnimation.stop()

                opacityAnimation.from = opacity
                opacityAnimation.to = 0

                opacityAnimation.restart()

            } else if(anim === "x") {

                xAnimation.stop()

                xAnimation.from = 0
                // the to value depends on whether we go forwards or backwards in the folder
                xAnimation.to = width*(loader_top.imageScale/loader_top.defaultScale)
                if(visibleIndexPrevCur[1] === -1 || visibleIndexPrevCur[0] > visibleIndexPrevCur[1])
                    xAnimation.to *= -1

                xAnimation.restart()

            } else if(anim === "y") {

                yAnimation.stop()

                yAnimation.from = 0
                // the to value depends on whether we go forwards or backwards in the folder
                yAnimation.to = height*(loader_top.imageScale/loader_top.defaultScale)
                if(visibleIndexPrevCur[1] === -1 || visibleIndexPrevCur[0] > visibleIndexPrevCur[1])
                    yAnimation.to *= -1

                yAnimation.restart()

            } else if(anim === "explosion") {

                explosionAnimation.stop()

                explosionAnimation_scale.from = 1
                explosionAnimation_scale.to = 2

                explosionAnimation.restart()

            } else if(anim === "implosion") {

                explosionAnimation.stop()

                explosionAnimation_scale.from = 1
                explosionAnimation_scale.to = 0

                explosionAnimation.restart()

            } else if(anim === "rotation") {

                rotAnimation.stop()

                rotAnimation_rotation.from = 0
                rotAnimation_rotation.to = 180

                if(visibleIndexPrevCur[1] === -1 || visibleIndexPrevCur[0] > visibleIndexPrevCur[1]) {
                    rotAnimation_rotation.from = 0
                    rotAnimation_rotation.to = -180
                }

                rotAnimation_opacity.from = 1
                rotAnimation_opacity.to = 0

                rotAnimation.restart()

            }

        }

        // if anything needs to be handled after image is hidden
        function handleWhenCompletelyHidden() {

            // exit photo sphere when manually entered
            if(loader_top.thisIsAPhotoSphere && loader_top.photoSphereManuallyEntered && !PQCSettings.filetypesPhotoSphereAutoLoad) // qmllint disable unqualified
                loader_top.doExitPhotoSphere()

            // check if this file has been deleted. If so, then we deactivate this loader
            if(!PQCScriptsFilesPaths.doesItExist(imageloaderitem.imageSource)) {
                imageloaderitem.lastModified = ""
                imageloaderitem.containingFolder = ""
                imageloaderitem.imageLoadedAndReady = false
                imageloaderitem.mainItemIndex = -1
            }

        }

    }

}
