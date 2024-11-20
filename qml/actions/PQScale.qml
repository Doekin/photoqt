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

import PQCNotify
import PQCFileFolderModel
import PQCScriptsFileManagement
import PQCScriptsFilesPaths
import PQCImageFormats
import PQCWindowGeometry

import "../elements"

PQTemplateFullscreen {

    id: scale_top

    thisis: "scale"
    popout: PQCSettings.interfacePopoutScale // qmllint disable unqualified
    forcePopout: PQCWindowGeometry.scaleForcePopout // qmllint disable unqualified
    shortcut: "__scale"

    title: qsTranslate("scale", "Scale image")

    button1.text: qsTranslate("scale", "Scale")
    button1.enabled: (spin_w.value>0 && spin_h.value>0)

    button2.visible: true
    button2.text: genericStringCancel

    onPopoutChanged:
        PQCSettings.interfacePopoutScale = popout // qmllint disable unqualified

    button1.onClicked:
        scaleImage()

    button2.onClicked:
        hide()

    property bool keepAspectRatio: true
    property real aspectRatio: 1.0

    content: [

        PQTextL {
            id: errorlabel
            width: parent.width
            horizontalAlignment: Qt.AlignHCenter
            font.weight: PQCLook.fontWeightBold // qmllint disable unqualified
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            visible: false
            text: qsTranslate("scale", "An error occured, file could not be scaled")
        },

        Item {
            width: 1
            height: 10
        },

        Row {

            x: (parent.width-width)/2

            spacing: 10

            Column {
                spacing: 5
                PQText {
                    height: spin_w.height
                    //: The number of horizontal pixels of the image
                    text: qsTranslate("scale", "Width:")
                    verticalAlignment: Qt.AlignVCenter
                }
                PQText {
                    height: spin_h.height
                    //: The number of vertical pixels of the image
                    text: qsTranslate("scale", "Height:")
                    verticalAlignment: Qt.AlignVCenter
                }
            }

            Column {
                id: spincol
                spacing: 5

                PQSliderSpinBox {
                    id: spin_w
                    enabled: scale_top.visible
                    minval: 1
                    maxval: 99999
                    showSlider: false
                    onEditModeChanged: {
                        if(!editMode && spin_h.editMode) {
                            PQCNotify.spinBoxPassKeyEvents = true // qmllint disable unqualified
                        }
                    }
                    property bool reactToValueChanged: true
                    onValueChanged: {
                        if(scale_top.opacity < 1) return
                        if(scale_top.keepAspectRatio && reactToValueChanged) {
                            var h = value/scale_top.aspectRatio
                            if(h !== spin_h.value) {
                                spin_h.reactToValueChanged = false
                                spin_h.value = Math.round(h)
                            }
                        } else
                            reactToValueChanged = true
                    }
                }
                PQSliderSpinBox {
                    id: spin_h
                    enabled: scale_top.visible
                    minval: 1
                    maxval: 99999
                    showSlider: false
                    onEditModeChanged: {
                        if(!editMode && spin_w.editMode) {
                            PQCNotify.spinBoxPassKeyEvents = true // qmllint disable unqualified
                        }
                    }
                    property bool reactToValueChanged: true
                    onValueChanged: {
                        if(scale_top.opacity < 1) return
                        if(scale_top.keepAspectRatio && reactToValueChanged) {
                            var w = value*scale_top.aspectRatio
                            if(w !== spin_w.value) {
                                spin_w.reactToValueChanged = false
                                spin_w.value = Math.round(w)
                            }
                        } else
                            reactToValueChanged = true
                    }
                }

            }

            Image {
                source: scale_top.keepAspectRatio ? "image://svg/:/" + PQCLook.iconShade + "/aspectratiokeep.svg" : "image://svg/:/" + PQCLook.iconShade + "/aspectratioignore.svg" // qmllint disable unqualified
                y: (spincol.height-height)/2
                width: height/3
                height: spincol.height*0.8
                sourceSize: Qt.size(width, height)
                smooth: false
                mipmap: false
                opacity: scale_top.keepAspectRatio ? 1 : 0.5
                Behavior on opacity { NumberAnimation { duration: 200 } }
                PQMouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        scale_top.keepAspectRatio = !scale_top.keepAspectRatio
                    }
                }
            }

        },

        PQTextS {

            x: (parent.width-width)/2
            font.weight: PQCLook.fontWeightBold // qmllint disable unqualified
            text: qsTranslate("scale", "New size:") + " " +
                  spin_w.value + " x " + spin_h.value + " " +
                  //: This is used as in: 100x100 pixels
                  qsTranslate("scale", "pixels")
        },

        Item {
            width: 1
            height: 10
        },

        Row {

            x: (parent.width-width)/2

            spacing: 5

            PQButton {
                text: "0.25x"
                font.pointSize: PQCLook.fontSize // qmllint disable unqualified
                font.weight: PQCLook.fontWeightNormal // qmllint disable unqualified
                width: height*1.5
                onClicked: {
                    spin_w.value = image.currentResolution.width*0.25 // qmllint disable unqualified
                    spin_h.value = image.currentResolution.height*0.25 // qmllint disable unqualified
                }
            }

            PQButton {
                text: "0.5x"
                font.pointSize: PQCLook.fontSize // qmllint disable unqualified
                font.weight: PQCLook.fontWeightNormal // qmllint disable unqualified
                width: height*1.5
                onClicked: {
                    spin_w.value = image.currentResolution.width*0.5 // qmllint disable unqualified
                    spin_h.value = image.currentResolution.height*0.5
                }
            }

            PQButton {
                text: "0.75x"
                font.pointSize: PQCLook.fontSize // qmllint disable unqualified
                font.weight: PQCLook.fontWeightNormal // qmllint disable unqualified
                width: height*1.5
                onClicked: {
                    spin_w.value = image.currentResolution.width*0.75 // qmllint disable unqualified
                    spin_h.value = image.currentResolution.height*0.75
                }
            }

            PQButton {
                text: "1x"
                font.pointSize: PQCLook.fontSize // qmllint disable unqualified
                font.weight: PQCLook.fontWeightNormal // qmllint disable unqualified
                width: height*1.5
                onClicked: {
                    spin_w.value = image.currentResolution.width // qmllint disable unqualified
                    spin_h.value = image.currentResolution.height
                }
            }

            PQButton {
                text: "1.5x"
                font.pointSize: PQCLook.fontSize // qmllint disable unqualified
                font.weight: PQCLook.fontWeightNormal // qmllint disable unqualified
                width: height*1.5
                onClicked: {
                    spin_w.value = image.currentResolution.width*1.5 // qmllint disable unqualified
                    spin_h.value = image.currentResolution.height*1.5
                }
            }

        },

        Item {
            width: 1
            height: 10
        },

        Row {

            x: (parent.width-width)/2

            spacing: 10

            PQText {
                text: qsTranslate("scale", "Quality:")
            }

            PQSlider {
                id: quality
                from: 1
                to: 100
                value: 80
            }

            PQText {
                text: quality.value + "%"
            }

        }

    ]

    PQWorking {
        id: scalebusy
    }

    Connections {
        target: PQCScriptsFileManagement // qmllint disable unqualified
        function onScaleCompleted(success : bool) {
            if(success) {
                errorlabel.visible = false
                scalebusy.showSuccess()
            } else {
                scalebusy.hide()
                errorlabel.visible = true
            }
        }
    }

    Connections {
        target: scalebusy
        function onSuccessHidden() {
            scale_top.hide()
       }
    }

    Connections {

        target: loader // qmllint disable unqualified

        function onPassOn(what : string, param : var) {

            if(what === "show") {

                if(param === scale_top.thisis)
                    scale_top.show()

            } else if(what === "hide") {

                if(param === scale_top.thisis)
                    scale_top.hide()

            } else if(scale_top.opacity > 0) {

                if(what === "keyEvent") {

                    if(param[0] === Qt.Key_Escape) {

                        if(spin_w.editMode || spin_h.editMode)
                            closePopupMenuSpin()
                        else
                            scale_top.hide()

                    }

                    else if(param[0] === Qt.Key_Plus) {

                        if(spin_w.activeFocus)
                            spin_w.increase()
                        else if(spin_h.activeFocus)
                            spin_h.increase()

                    } else if(param[0] === Qt.Key_Minus) {

                        if(spin_w.activeFocus)
                            spin_w.decrease()
                        else if(spin_h.activeFocus)
                            spin_h.decrease()

                    } else if(param[0] === Qt.Key_Enter || param[0] === Qt.Key_Return) {

                        if(scale_top.button1.enabled)
                            scale_top.scaleImage()

                    }

                }

            }

        }

    }

    function closePopupMenuSpin() {
        spin_w.acceptValue()
        spin_h.acceptValue()
    }

    function scaleImage() {

        if(spin_w.value === 0 || spin_h.value === 0)
            return

        errorlabel.visible = false
        scalebusy.showBusy()

        var uniqueid = PQCImageFormats.detectFormatId(PQCFileFolderModel.currentFile) // qmllint disable unqualified
        var targetFilename = PQCScriptsFilesPaths.selectFileFromDialog(qsTranslate("scale", "Scale"), PQCFileFolderModel.currentFile, uniqueid, true);

        if(targetFilename === "") {
            scalebusy.hide()
            return
        }

        var success = PQCScriptsFileManagement.scaleImage(PQCFileFolderModel.currentFile, targetFilename, uniqueid, Qt.size(spin_w.value, spin_h.value), quality.value)
        if(!success) {
            errorlabel.visible = true
            return
        }

        if(PQCScriptsFilesPaths.getDir(targetFilename) === PQCScriptsFilesPaths.getDir(PQCFileFolderModel.currentFile))
            PQCFileFolderModel.fileInFolderMainView = targetFilename

        hide()

    }

    function show() {
        if(PQCFileFolderModel.currentIndex === -1 || PQCFileFolderModel.countMainView === 0) { // qmllint disable unqualified
            hide()
            return
        }

        var canBeScaled = !PQCNotify.showingPhotoSphere && PQCScriptsFileManagement.canThisBeScaled(PQCFileFolderModel.currentFile)

        if(!canBeScaled) {
            loader.show("notification", [qsTranslate("filemanagement", "Action not available"), qsTranslate("filemanagement", "This image can not be scaled.")])
            hide()
            return
        }

        spin_w.loadAndSetDefault(image.currentResolution.width)
        spin_h.loadAndSetDefault(image.currentResolution.height)
        aspectRatio = image.currentResolution.width/image.currentResolution.height

        scalebusy.hide()
        errorlabel.visible = false

        // the opacity should be set at the end of this function
        opacity = 1
        if(popoutWindowUsed)
            scale_popout.visible = true
    }

    function hide() {
        closePopupMenuSpin()
        opacity = 0
        if(popoutWindowUsed)
            scale_popout.visible = false // qmllint disable unqualified
        else
            loader.elementClosed(thisis)

    }

}
