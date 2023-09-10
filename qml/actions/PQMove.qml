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

import QtQuick

import PQCScriptsFileManagement
import PQCFileFolderModel
import PQCNotify
import PQCImageFormats
import PQCScriptsFilesPaths

import "../elements"

Item {

    width: toplevel.width
    height: toplevel.height

    Connections {

        target: loader

        function onPassOn(what, param) {

            if(what === "show") {

                if(param === "filemove") {

                    error.opacity = 0
                    if(PQCFileFolderModel.currentIndex === -1 || PQCFileFolderModel.countMainView === 0) {
                        loader.elementClosed("filecopy")
                        return
                    }

                    error.opacity = 0
                    PQCNotify.modalFileDialogOpen = true
                    var targetfile = PQCScriptsFilesPaths.selectFileFromDialog(qsTranslate("filemanagement", "Move here"), PQCFileFolderModel.currentFile, PQCImageFormats.detectFormatId(PQCFileFolderModel.currentFile), true);
                    if(targetfile === "") {
                        loader.elementClosed("filemove")
                    } else {
                        if(!PQCScriptsFileManagement.moveFile(PQCFileFolderModel.currentFile, targetfile))
                            error.opacity = 1
                        else {
                            PQCFileFolderModel.removeEntryMainView(PQCFileFolderModel.currentIndex)
                            loader.elementClosed("filemove")
                        }
                    }
                    PQCNotify.modalFileDialogOpen = false
                }

            } else if(error.visible) {
                if(what === "keyEvent") {
                    if(param[0] === Qt.Key_Escape || param[0] === Qt.Key_Return || param[0] === Qt.Key_Enter) {
                        error.opacity = 0
                        loader.elementClosed("filemove")
                    }
                }
            }
        }
    }

    Rectangle {
        id: error
        anchors.fill: parent
        color: PQCLook.baseColor
        opacity: 0
        Behavior on opacity { NumberAnimation { duration: 200 } }
        visible: opacity>0
        Column {
            x: (parent.width-width)/2
            y: (parent.height-height)/2
            spacing: 20
            PQTextXXL {
                x: (parent.width-width)/2
                text: qsTranslate("filemanagement", "An error occured")
                font.weight: PQCLook.fontWeightBold
            }
            PQTextL {
                x: (parent.width-width)/2
                text: qsTranslate("filemanagement", "File could not be moved")
                font.weight: PQCLook.fontWeightBold
            }
            PQButton {
                x: (parent.width-width)/2
                text: genericStringClose
                onClicked: {
                    error.opacity = 0
                    loader.elementClosed("filemove")
                }
            }
        }
    }

}
