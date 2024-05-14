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

import PQCFileFolderModel
import PQCNotify
import PQCScriptsFilesPaths

Item {

    id: slideshowhandler_top

    property string backupAnimType: ""
    property int backupAnimSpeed: 0
    property var shuffledIndices: []
    property int shuffledCurrentIndex: -1
    property bool running: false

    property real volume: 1.0

    property var musicFileOrder: []
    property int currentMusicIndex: 0

    Loader {

        id: loader_audioplayer
        active: PQCSettings.slideshowMusic

        sourceComponent:
        MediaPlayer {
            id: audioplayer
            audioOutput: AudioOutput {
                id: audiooutput
                property real reduceVolume: (PQCSettings.slideshowMusicVolumeVideos === 0 ? 0 : (PQCSettings.slideshowMusicVolumeVideos === 1 ? 0.1 : 1))

                property bool videoWithVolume: image.currentlyShowingVideo&&image.currentlyShowingVideoHasAudio

                volume: slideshowhandler_top.volume*(videoWithVolume ? reduceVolume : 1)
                Behavior on volume { NumberAnimation { duration: 200 } }

            }

            onPlaybackStateChanged: {
                if(playbackState === MediaPlayer.StoppedState && slideshowhandler_top.running && PQCNotify.slideshowRunning) {
                    if(PQCSettings.slideshowMusic) {
                        currentMusicIndex = (currentMusicIndex+1)%PQCSettings.slideshowMusicFiles.length

                        var startingIndex = currentMusicIndex
                        while(!PQCScriptsFilesPaths.doesItExist(musicFileOrder[currentMusicIndex]) && currentMusicIndex != startingIndex)
                            currentMusicIndex += (currentMusicIndex+1)%PQCSettings.slideshowMusicFiles.length

                        audioplayer.source = "file://" + musicFileOrder[currentMusicIndex]
                    }
                }
            }

            onSourceChanged:
                play()

            function checkPlayPause() {
                if(slideshowhandler_top.running)
                    audioplayer.play()
                else
                    audioplayer.pause()
            }

        }

    }

    Timer {
        id: checkAudio
        interval: 500
        running: PQCSettings.slideshowMusic && loader_audioplayer.item.playbackState===MediaPlayer.PausedState
        onTriggered:
            loader_audioplayer.item.checkPlayPause()
    }

    Connections {

        target: slideshowhandler_top

        function onRunningChanged() {
            if(PQCSettings.slideshowMusic)
                loader_audioplayer.item.checkPlayPause()
        }

    }

    Connections {

        target: image

        function onCurrentlyShowingVideoPlayingChanged() {
            if(PQCSettings.slideshowMusic)
                loader_audioplayer.item.checkPlayPause()
            if(slideshowhandler_top.running && !image.currentlyShowingVideoPlaying) {
                switcher.triggered()
            }
            if(PQCSettings.slideshowMusic)
                loader_audioplayer.item.checkPlayPause()
        }
    }

    Timer {
        id: switcher
        interval: Math.max(1000, Math.min(300*1000, PQCSettings.slideshowTime*1000))
        repeat: true
        running: slideshowhandler_top.running&&!image.currentlyShowingVideo
        onTriggered: {
            loadNextImage()
            if(PQCSettings.slideshowMusic)
                loader_audioplayer.item.checkPlayPause()
        }
    }

    Connections {

        target: loader

        function onPassOn(what, param) {

            if(what === "show") {

                if(param === "slideshowhandler")
                    show()

            } else if(what === "hide") {

                if(param === "slideshowhandler")
                    hide()

            } else if(PQCNotify.slideshowRunning) {

                if(what === "keyEvent") {

                    if(param[0] === Qt.Key_Escape)
                        hide()

                    else if(param[0] === Qt.Key_Space)
                        toggle()

                }

            }

        }

    }

    function show() {

        backupAnimType = PQCSettings.imageviewAnimationType
        backupAnimSpeed = PQCSettings.imageviewAnimationDuration

        PQCSettings.imageviewAnimationType = PQCSettings.slideshowTypeAnimation
        PQCSettings.imageviewAnimationDuration = PQCSettings.slideshowImageTransition

        // This effect only exists for slideshow and not for normal viewing
        // Thus we need to make sure it is not set to the imageviewAnimationType
        // as otherwise old images will not be removed from view
        if(PQCSettings.imageviewAnimationType === "kenburns")
            PQCSettings.imageviewAnimationType = "opacity"

        var sortby = 1
        if(PQCSettings.imageviewSortImagesBy === "name")
            sortby = 0
        else if(PQCSettings.imageviewSortImagesBy === "time")
            sortby = 2
        else if(PQCSettings.imageviewSortImagesBy === "size")
            sortby = 3
        else if(PQCSettings.imageviewSortImagesBy === "type")
            sortby = 4

        if(PQCSettings.slideshowIncludeSubFolders)
            PQCFileFolderModel.includeFilesInSubFolders = true

        if(PQCSettings.slideshowShuffle) {

            slideshowhandler_top.shuffledIndices = []
            for(var k = 0; k < PQCFileFolderModel.countMainView; ++k) {
                if(k !== PQCFileFolderModel.currentIndex)
                    slideshowhandler_top.shuffledIndices.push(k)
            }
            shuffle(slideshowhandler_top.shuffledIndices)
            slideshowhandler_top.shuffledIndices.push(PQCFileFolderModel.currentIndex)
            slideshowhandler_top.shuffledCurrentIndex = -1

        }

        slideshowhandler_top.running = true
        PQCNotify.slideshowRunning = true

        if(PQCSettings.slideshowMusic) {
            currentMusicIndex = 0
            musicFileOrder = PQCSettings.slideshowMusicFiles
            if(PQCSettings.slideshowMusicShuffle)
                shuffle(musicFileOrder)
            while(!PQCScriptsFilesPaths.doesItExist(musicFileOrder[currentMusicIndex]) && currentMusicIndex < musicFileOrder.length)
                currentMusicIndex += 1
            loader_audioplayer.item.position = 0
            loader_audioplayer.item.source = "file://" + musicFileOrder[currentMusicIndex]
        }

    }

    function hide() {

        var tmp = slideshowhandler_top.running

        PQCNotify.slideshowRunning = false
        slideshowhandler_top.running = false
        if(PQCSettings.slideshowMusic)
            loader_audioplayer.item.checkPlayPause()
        loader.elementClosed("slideshowhandler")

        PQCSettings.imageviewAnimationType = backupAnimType
        PQCSettings.imageviewAnimationDuration = backupAnimSpeed

        image.zoomReset()

        if(tmp)
            image.playPauseAnimationVideo()

    }

    function loadPrevImage(switchedManually = false) {

        if(!PQCSettings.slideshowShuffle) {
            if(PQCFileFolderModel.currentIndex > 0)
                --PQCFileFolderModel.currentIndex
            else if(PQCSettings.slideshowLoop)
                PQCFileFolderModel.currentIndex = PQCFileFolderModel.countMainView-1
            else
                hide()
        } else {
            if(slideshowhandler_top.shuffledCurrentIndex > 0) {
                --slideshowhandler_top.shuffledCurrentIndex
                PQCFileFolderModel.currentIndex = slideshowhandler_top.shuffledIndices[slideshowhandler_top.shuffledCurrentIndex]
            } else if(PQCSettings.slideshowLoop) {
                slideshowhandler_top.shuffledCurrentIndex = slideshowhandler_top.shuffledIndices.length-1
                PQCFileFolderModel.current = slideshowhandler_top.shuffledIndices[slideshowhandler_top.shuffledCurrentIndex]
            } else
                hide()

        }

    }

    function loadNextImage(switchedManually = false) {

        if(!PQCSettings.slideshowShuffle) {
            if(PQCFileFolderModel.currentIndex < PQCFileFolderModel.countMainView-1)
                ++PQCFileFolderModel.currentIndex
            else if(PQCSettings.slideshowLoop)
                PQCFileFolderModel.currentIndex = 0
            else
                hide()
        } else {
            if(slideshowhandler_top.shuffledCurrentIndex < slideshowhandler_top.shuffledIndices.length-1) {
                ++slideshowhandler_top.shuffledCurrentIndex
                PQCFileFolderModel.currentIndex = slideshowhandler_top.shuffledIndices[slideshowhandler_top.shuffledCurrentIndex]
            } else if(PQCSettings.slideshowLoop) {
                slideshowhandler_top.shuffledCurrentIndex = 0
                PQCFileFolderModel.current = slideshowhandler_top.shuffledIndices[slideshowhandler_top.shuffledCurrentIndex]
            } else
                hide()

        }

    }

    function toggle() {
        if(!PQCNotify.slideshowRunning) return
        // The following two lines HAVE to be in this order!!
        slideshowhandler_top.running = !slideshowhandler_top.running
        if(PQCSettings.slideshowMusic)
            loader_audioplayer.item.checkPlayPause()
        image.playPauseAnimationVideo()
    }

    /***************************************/
    // The Fisher–Yates shuffle algorithm
    // Code found at http://stackoverflow.com/questions/6274339/how-can-i-shuffle-an-array-in-javascript
    // (adapted from http://bost.ocks.org/mike/shuffle/)
    function shuffle(array) {
        var counter = array.length, temp, index;

        // While there are elements in the array
        while (counter > 0) {
            // Pick a random index
            index = Math.floor(Math.random() * counter);

            // Decrease counter by 1
            counter--;

            // And swap the last element with it
            temp = array[counter];
            array[counter] = array[index];
            array[index] = temp;
        }

        return array;
    }

}
