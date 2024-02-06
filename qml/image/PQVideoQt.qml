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
import QtMultimedia

import PQCScriptsFilesPaths
import PQCScriptsConfig

Item {

    id: videotop

    width: video.width
    height: video.height

    Video {

        id: video

        // earlier versions of Qt6 seem to struggle if only one slash is used
        source: (PQCScriptsConfig.isQtAtLeast6_5() ? "file:/" : "file://") + deleg.imageSource

        volume: PQCSettings.filetypesVideoVolume

        width: PQCSettings.imageviewFitInWindow ? deleg.width : undefined
        height: PQCSettings.imageviewFitInWindow ? deleg.height : undefined

        fillMode: VideoOutput.PreserveAspectFit

        onPositionChanged: {
            if(position >= duration-100) {
                if(PQCSettings.filetypesVideoLoop)
                    video.seek(0)
                else
                    video.pause()
            }
        }

        onPlaybackStateChanged: {
            if(playbackState === MediaPlayer.StoppedState) {

                // earlier versions of Qt6 seem to struggle if only one slash is used
                if(PQCScriptsConfig.isQtAtLeast6_5())
                    video.source = "file:/" + deleg.imageSource
                else
                    video.source = "file://" + deleg.imageSource

                if(PQCSettings.filetypesVideoLoop) {
                    video.play()
                } else {
                    video.pause()
                    video.seek(video.duration-100)
                }
            }
        }

    }

    onWidthChanged: {
        image_wrapper.width = width
        deleg.imageResolution.width = width
    }
    onHeightChanged: {
        deleg.imageResolution.height = height
        image_wrapper.height = height
    }

    onVisibleChanged: {
        if(!visible && loader_component.videoPlaying) {
            video.pause()
        }
    }

    Component.onCompleted: {
        loader_component.videoDuration = Qt.binding(function() { return Math.round(video.duration/1000); })
        loader_component.videoPosition = Qt.binding(function() { return Math.round(video.position/1000); })
        loader_component.videoPlaying = Qt.binding(function() { return (video.playbackState===MediaPlayer.PlayingState) })
        image_wrapper.status = Image.Ready
    }

    Connections {
        target: image_top
        function onVideoJump(seconds) {

            if(image_top.currentlyVisibleIndex !== deleg.itemIndex)
                return

            if(video.seekable)
                video.seek(video.position + seconds*1000)
        }
    }

    Connections {
        target: loader_component
        function onVideoTogglePlay() {

            if(image_top.currentlyVisibleIndex !== deleg.itemIndex)
                return

            toggle()
        }
        function onVideoToPos(pos) {

            if(image_top.currentlyVisibleIndex !== deleg.itemIndex)
                return

            video.seek(pos*1000)
        }
        function onImageClicked() {

            if(image_top.currentlyVisibleIndex !== deleg.itemIndex)
                return

            toggle()
        }
    }

    Connections {
        target: deleg
        function onStopVideoAndReset() {

            if(image_top.currentlyVisibleIndex !== deleg.itemIndex)
                return

            if(loader_component.videoPlaying) {
                video.pause()
                video.seek(0)
            }
        }
        function onRestartVideoIfAutoplay() {

            if(image_top.currentlyVisibleIndex !== deleg.itemIndex)
                return

            if(loader_component.videoPlaying) {

                if(!PQCSettings.filetypesVideoAutoplay) {
                    video.pause()
                } else
                    video.seek(0)

            } else {
                video.seek(0)
                video.pause()
                if(PQCSettings.filetypesVideoAutoplay)
                    video.play()
            }

        }
    }

    function toggle() {

        if(image_top.currentlyVisibleIndex !== deleg.itemIndex)
            return

        if(loader_component.videoPlaying)
            video.pause()
        else {
            if(video.position > video.duration-150)
                video.seek(0)
            video.play()
        }
    }

    function setMirrorHV(mH, mV) {
        // do nothing, mirroring not supported by Video type
    }

}
