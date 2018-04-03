/**************************************************************************
 **                                                                      **
 ** Copyright (C) 2018 Lukas Spies                                       **
 ** Contact: http://photoqt.org                                          **
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

import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

import "../../../elements"
import "../../"

EntryContainer {

    id: item_top

    Row {

        spacing: 20

        EntryTitle {

            id: titletext
            title: "libarchive: ZIP, RAR, TAR, 7z"
            helptext: em.pty+qsTr("PhotoQt takes advantage of tools such as 'libarchive' to load packed files (zip, rar, tar, 7z). It can either load them together with the rest of the images (each (supported) file as one image) or it can ignore such files except when asked to open one, then it wont load any other images (like a document viewer).") + "<br><br>" +
                      em.pty+qsTr("Note regarding RAR archives: 'libarchive' supports RAR archives only partially and might fail to read certain archives. If installed, PhotoQt can use the external tool 'unrar' instead of 'libarchive' for proper support of RAR archives.")
            imageSource: "qrc:/img/settings/imageformats/empty.png"
            fontcolor: enabled ? colour.text : colour.text_disabled

        }

        EntrySetting {

            Column {

                spacing: 10

                Item {

                    width: childrenRect.width
                    height: but1.height

                    Row {

                        spacing: 10

                        SettingsText {
                            id: txt1
                            y: (but1.height-height)/2
                            horizontalAlignment: Text.AlignRight
                            text: em.pty+qsTr("File endings:")
                        }
                        CustomButton {
                            id: but1
                            text: em.pty+qsTr("Use default")
                            onClickedButton: formatsPopupEndings.setDefault()
                        }
                        CustomButton {
                            //: Used as in 'Use none of the available file endings'
                            text: em.pty+qsTr("Use none")
                            onClickedButton: formatsPopupEndings.setNone()
                        }
                        CustomButton {
                            //: 'fine tuning' refers to selecting the individual file endings recognised by PhotoQt
                            text: em.pty+qsTr("Advanced fine tuning")
                            onClickedButton: formatsPopupEndings.show()
                        }

                        SettingsText {
                            y: (but1.height-height)/2
                            text: em.pty+qsTr("There are currently %1 file endings selected").arg("<b>"+formatsPopupEndings.numItemsChecked+"</b>")
                        }

                    }

                }

                Item {

                    width: childrenRect.width
                    height: but2.height

                    Row {

                        spacing: 10

                        SettingsText {
                            id: txt2
                            y: (but1.height-height)/2
                            horizontalAlignment: Text.AlignRight
                            text: em.pty+qsTr("Mime types:")
                        }
                        CustomButton {
                            id: but2
                            //: Used as in 'Use set of default file endings'
                            text: em.pty+qsTr("Use default")
                            onClickedButton: formatsPopupMimetypes.setDefault()
                        }
                        CustomButton {
                            //: Used as in 'Use none of the available file endings'
                            text: em.pty+qsTr("Use none")
                            onClickedButton: formatsPopupMimetypes.setNone()
                        }
                        CustomButton {
                            //: 'fine tuning' refers to selecting the individual file endings recognised by PhotoQt
                            text: em.pty+qsTr("Advanced fine tuning")
                            onClickedButton: formatsPopupMimetypes.show()
                        }

                        SettingsText {
                            y: (but2.height-height)/2
                            text: em.pty+qsTr("There are currently %1 mime types selected").arg("<b>"+formatsPopupMimetypes.numItemsChecked+"</b>")
                        }

                    }

                }
                Item {
                    width: 10
                    height: 1
                }

                Item {

                    width: childrenRect.width
                    height: childrenRect.height

                    CustomCheckBox {
                        id: externalUnrar
                        text: em.pty+qsTr("Use external tool 'unrar' for RAR archives")
                    }

                }

                Component.onCompleted: {
                    but1.width = Math.max(but1.width, but2.width)
                    but2.width = Math.max(but1.width, but2.width)
                    txt1.width = Math.max(txt1.width, txt2.width)
                    txt2.width = Math.max(txt1.width, txt2.width)
                }

            }

        }

    }

    PopupImageFormats {

        id: formatsPopupEndings
        title: titletext.title
        availableFormats: imageformats.getAvailableEndingsWithDescriptionArchive()
        enabledFormats: imageformats.enabledFileformatsArchive
        defaultFormats: imageformats.getDefaultEnabledEndingsArchive()

        Connections {
            target: imageformats
            onEnabledFileformatsChanged:
                formatsPopupEndings.enabledFormats = imageformats.enabledFileformatsArchive
        }

        onVisibleChanged: settings_top.imageFormatsAdvancedTuningPopupVisible = visible

    }

    PopupMimeTypes {

        id: formatsPopupMimetypes
        title: titletext.title
        availableFormats: mimetypes.getAvailableMimeTypesWithDescriptionArchive()
        enabledFormats: mimetypes.enabledMimeTypesArchive
        defaultFormats: mimetypes.getDefaultEnabledMimeTypesArchive()

        Connections {
            target: mimetypes
            onEnabledMimeTypesChanged:
                formatsPopupMimetypes.enabledFormats = mimetypes.enabledMimeTypesArchive
        }

        onVisibleChanged: settings_top.imageFormatsAdvancedTuningPopupVisible = visible

    }

    function setData() {
        formatsPopupEndings.setCurrentlySet()
        formatsPopupMimetypes.setCurrentlySet()
        externalUnrar.checkedButton = settings.archiveUseExternalUnrar
    }

    function saveData() {
        imageformats.enabledFileformatsArchive = formatsPopupEndings.getEnabledFormats()
        mimetypes.enabledMimeTypesArchive = formatsPopupMimetypes.getEnabledFormats()
        settings.archiveUseExternalUnrar = externalUnrar.checkedButton
    }

}
