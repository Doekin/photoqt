import QtQuick

import PQCScriptsFilesPaths
import PQCScriptsImages
import PQCNotify
import PQCFileFolderModel
import PQCScriptsConfig

import QtMultimedia

Image {

    id: image

    source: "image://full/" + PQCScriptsFilesPaths.toPercentEncoding(deleg.imageSource)

    asynchronous: true

    property bool interpThreshold: (!PQCSettings.imageviewInterpolationDisableForSmallImages || width > PQCSettings.imageviewInterpolationThreshold || height > PQCSettings.imageviewInterpolationThreshold)

    smooth: interpThreshold
    mipmap: interpThreshold

    property bool fitImage: (PQCSettings.imageviewFitInWindow && image.sourceSize.width < deleg.width && image.sourceSize.height < deleg.height)

    width: fitImage ? deleg.width : undefined
    height: fitImage ? deleg.height : undefined

    fillMode: fitImage ? Image.PreserveAspectFit : Image.Pad

    onWidthChanged:
        image_wrapper.width = width
    onHeightChanged:
        image_wrapper.height = height

    onStatusChanged: {
        image_wrapper.status = status
        if(status == Image.Ready) {
            hasAlpha = PQCScriptsImages.supportsTransparency(deleg.imageSource)
            if(deleg.defaultScale < 0.95)
                loadScaledDown.restart()
        } else if(status == Image.Error)
            source = "/other/errorimage.svg"
    }

    onMirrorChanged:
        deleg.imageMirrorH = mirror
    onMirrorVerticallyChanged:
        deleg.imageMirrorV = image.mirrorVertically

    property bool hasAlpha: false

    onSourceSizeChanged:
        deleg.imageResolution = sourceSize

    Connections {
        target: image_top
        function onMirrorH() {
            image.mirror = !image.mirror
        }
        function onMirrorV() {
            image.mirrorVertically = !image.mirrorVertically
        }
        function onMirrorReset() {
            image.mirror = false
            image.mirrorVertically = false
        }
        function onWidthChanged() {
            resetScreenSize.restart()
        }
        function onHeightChanged() {
            resetScreenSize.restart()
        }

    }

    Image {
        anchors.fill: parent
        z: parent.z-1
        fillMode: Image.Tile

        source: PQCSettings.imageviewTransparencyMarker&&image.hasAlpha ? "/other/checkerboard.png" : ""

    }

    // with a short delay we load a version of the image scaled to screen dimensions
    Timer {
        id: loadScaledDown
        interval: (PQCSettings.imageviewAnimationDuration+1)*100    // this ensures it happens after the animation has stopped
        onTriggered: {
            if(deleg.shouldBeShown) {
                screenW = image_top.width
                screenH = image_top.height
                ldl.active = true
            }
        }
    }

    property int screenW
    property int screenH
    Timer {
        id: resetScreenSize
        interval: 500
        repeat: false
        onTriggered: {
            screenW = image_top.width
            screenH = image_top.height
        }
    }

    // image scaled to screen dimensions
    Loader {
        id: ldl
        asynchronous: true
        active: false
        sourceComponent:
        Image {
            width: image.width
            height: image.height
            source: image.source
            visible: deleg.defaultScale >= image_wrapper.scale
            sourceSize: Qt.size(screenW, screenH)
            mirror: image.mirror
            mirrorVertically: image.mirrorVertically
        }
    }

    function setMirrorHV(mH, mV) {
        image.mirror = mH
        image.mirrorVertically = mV
    }

    /*****************************************************************/
    // the code below takes care of loading motion photos if enabled

    Connections {

        target: PQCSettings

        function onFiletypesCheckForPhotoSphereChanged() {
            if(PQCScriptsImages.isPhotoSphere(deleg.imageSource)) {
                PQCNotify.hasPhotoSphere = true
            } else
                PQCNotify.hasPhotoSphere = false
        }

    }

    // check for photo sphere if enabled
    Timer {

        id: checkForPhotoSphere
        // this is triggered after the image has animated in
        interval: PQCSettings.imageviewAnimationDuration*100

        // we use this trimmed down version whenever we don't use the motion photo stuff below (the photo sphere checks are part of it)
        running: visible&&PQCSettings.filetypesCheckForPhotoSphere&&!PQCScriptsConfig.isMotionPhotoSupportEnabled()
        onTriggered: {

            if(PQCFileFolderModel.currentIndex !== index)
                return

            if(PQCSettings.filetypesCheckForPhotoSphere) {

                if(PQCScriptsImages.isPhotoSphere(deleg.imageSource)) {
                    PQCNotify.hasPhotoSphere = true
                } else
                    PQCNotify.hasPhotoSphere = false

            }

        }

    }

    Loader {
        asynchronous: true
        active: PQCScriptsConfig.isMotionPhotoSupportEnabled()
        sourceComponent: motionphoto
    }

    Component {

        id: motionphoto

        Item {

            width: image.width
            height: image.height

            // check for motion photo or photo sphere
            Timer {

                id: checkForMotionPhoto
                // this is triggered after the image has animated in
                interval: PQCSettings.imageviewAnimationDuration*100
                running: visible&&(PQCSettings.filetypesLoadMotionPhotos || PQCSettings.filetypesLoadAppleLivePhotos || PQCSettings.filetypesCheckForPhotoSphere)
                onTriggered: {

                    if(PQCFileFolderModel.currentIndex !== index)
                        return

                    if(PQCSettings.filetypesLoadMotionPhotos || PQCSettings.filetypesLoadAppleLivePhotos) {

                        var what = PQCScriptsImages.isMotionPhoto(deleg.imageSource)

                        if(what > 0) {

                            var src = ""

                            // Motion Photo
                            if(what === 1)
                                src = PQCScriptsFilesPaths.getDir(deleg.imageSource) + "/" + PQCScriptsFilesPaths.getBasename(deleg.imageSource) + ".mov"
                            else if(what === 2 || what === 3)
                                src = PQCScriptsImages.extractMotionPhoto(deleg.imageSource)

                            if(src != "") {
                                mediaplayer.source = "file://" + src
                                mediaplayer.play()
                                PQCNotify.hasPhotoSphere = false
                                return
                            }

                        }

                    }

                    if(PQCSettings.filetypesCheckForPhotoSphere) {

                        if(PQCScriptsImages.isPhotoSphere(deleg.imageSource)) {
                            PQCNotify.hasPhotoSphere = true
                        } else
                            PQCNotify.hasPhotoSphere = false

                    }

                }

            }

            VideoOutput {
                id: videoOutput
                anchors.fill: parent
            }

            MediaPlayer {
                id: mediaplayer
                videoOutput: videoOutput
            }

        }

    }

}
