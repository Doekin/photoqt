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
import QtQuick.Controls
import PQCScriptsConfig

import "../../../elements"

// required top level properties for all settings:
//
// 1) property bool settingChanged
// 2) property bool catchEscape
// 3) function applyChanges()
// 4) function revertChanges()
// 5) function handleEscape()

// settings in this file:
// - filetypesPDFQuality
// - filetypesExternalUnrar
// - filetypesVideoAutoplay
// - filetypesVideoLoop
// - filetypesVideoThumbnailer
// - filetypesVideoPreferLibmpv
// - imageviewAnimatedControls
// - imageviewEscapeExitDocument
// - imageviewEscapeExitArchive

Flickable {

    id: setting_top

    anchors.fill: parent
    anchors.margins: 10

    contentHeight: contcol.height

    property bool settingChanged: false
    property bool settingsLoaded: false

    property bool catchEscape: pdf_quality.contextMenuOpen || pdf_quality.editMode || videothumb.popup.visible

    ScrollBar.vertical: PQVerticalScrollBar {}

    Column {

        id: contcol

        x: (parent.width-width)/2

        spacing: 10

        PQSetting {

            id: set_pdf

            //: Settings title
            title: qsTranslate("settingsmanager", "PDF")

            helptext: qsTranslate("settingsmanager", "PhotoQt can show PDF and Postscript documents alongside your images, you can even enter a multi-page document and browse its pages as if they were images in a folder. The quality setting here - specified in dots per pixel (dpi) - affects the resolution and speed of loading such pages.")

            content: [

                PQSliderSpinBox {
                    id: pdf_quality
                    width: set_pdf.rightcol
                    minval: 50
                    maxval: 300
                    title: qsTranslate("settingsmanager", "quality:")
                    suffix: " dpi"
                    onValueChanged:
                        setting_top.checkDefault()
                },

                PQCheckBox {
                    id: pdf_escape
                    text: qsTranslate("settingsmanager", "Escape key leaves document viewer")
                    onCheckedChanged: setting_top.checkDefault()
                }

            ]

            onResetToDefaults: {
                pdf_quality.setValue(1*PQCScriptsConfig.getDefaultSettingValueFor("filetypesPDFQuality")) // qmllint disable unqualified
                pdf_escape.checked = (1*PQCScriptsConfig.getDefaultSettingValueFor("imageviewEscapeExitDocument") == 1)
            }

            function handleEscape() {
                pdf_quality.closeContextMenus()
                pdf_quality.acceptValue()
            }

            function hasChanged() {
                return (pdf_quality.hasChanged() || pdf_escape.hasChanged())
            }

            function load() {
                pdf_quality.loadAndSetDefault(PQCSettings.filetypesPDFQuality) // qmllint disable unqualified
                pdf_escape.loadAndSetDefault(PQCSettings.imageviewEscapeExitDocument)
            }

            function applyChanges() {
                PQCSettings.filetypesPDFQuality = pdf_quality.value // qmllint disable unqualified
                PQCSettings.imageviewEscapeExitDocument = pdf_escape.checked
                pdf_quality.saveDefault()
                pdf_escape.saveDefault()
            }

        }

        /**********************************************************************/
        PQSettingsSeparator {}
        /**********************************************************************/

        PQSetting {

            id: set_arc

            //: Settings title
            title: qsTranslate("settingsmanager", "Archive")

            helptext: qsTranslate("settingsmanager",  "PhotoQt allows the browsing of all images contained in an archive file (ZIP, RAR, etc.) as if they all are located in a folder. By default, PhotoQt uses Libarchive for this purpose, but for RAR archives in particular PhotoQt can call the external tool unrar to load and display the archive and its contents. Note that this requires unrar to be installed and located in your path.") + (PQCSettings.generalCompactSettings ? ("<br><br>"+secondhelptext) : "") // qmllint disable unqualified

            property string secondhelptext: qsTranslate("settingsmanager",  "When an archive is loaded it is possible to browse through the contents of such a file either through floating controls that show up when the archive contains more than one file, or by entering the viewer mode. When the viewer mode is activated all files in the archive are loaded as thumbnails. The viewer mode can be activated by shortcut or through a small button located below the status info and as part of the floating controls.")

            content: [
                PQCheckBox {
                    id: arc_extunrar
                    enforceMaxWidth: set_arc.rightcol
                    text: qsTranslate("settingsmanager", "use external tool: unrar")
                    onCheckedChanged: setting_top.checkDefault()
                },

                Item {
                    width: set_arc.rightcol
                    height: PQCSettings.generalCompactSettings ? 0 : help2txt.height // qmllint disable unqualified
                    Behavior on height { NumberAnimation { duration: 200 } }
                    opacity: PQCSettings.generalCompactSettings ? 0 : 1 // qmllint disable unqualified
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                    clip: true
                    PQText {
                        id: help2txt
                        width: parent.width
                        text: set_arc.secondhelptext
                        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                    }
                },

                PQCheckBox {
                    id: archivecontrols
                    enforceMaxWidth: set_arc.rightcol
                    text: qsTranslate("settingsmanager", "show floating controls for archives")
                    onCheckedChanged: setting_top.checkDefault()
                },

                PQCheckBox {
                    id: archiveleftright
                    enforceMaxWidth: set_arc.rightcol
                    text: qsTranslate("settingsmanager", "use left/right arrow to load previous/next page")
                    onCheckedChanged: setting_top.checkDefault()
                },

                PQCheckBox {
                    id: archive_escape
                    text: qsTranslate("settingsmanager", "Escape key leaves archive viewer")
                    onCheckedChanged: setting_top.checkDefault()
                }

            ]

            onResetToDefaults: {
                arc_extunrar.checked = (1*PQCScriptsConfig.getDefaultSettingValueFor("filetypesExternalUnrar") == 1)
                archivecontrols.checked = (1*PQCScriptsConfig.getDefaultSettingValueFor("filetypesArchiveControls") == 1)
                archiveleftright.checked = (1*PQCScriptsConfig.getDefaultSettingValueFor("filetypesArchiveLeftRight") == 1)
                archive_escape.checked = (1*PQCScriptsConfig.getDefaultSettingValueFor("imageviewEscapeExitArchive") == 1)
            }

            function handleEscape() {
            }

            function hasChanged() {
                return (arc_extunrar.hasChanged() || archivecontrols.hasChanged() || archiveleftright.hasChanged())
            }

            function load() {
                arc_extunrar.loadAndSetDefault(PQCSettings.filetypesExternalUnrar)
                archivecontrols.loadAndSetDefault(PQCSettings.filetypesArchiveControls)
                archiveleftright.loadAndSetDefault(PQCSettings.filetypesArchiveLeftRight)
                archive_escape.loadAndSetDefault(PQCSettings.imageviewEscapeExitArchive)
            }

            function applyChanges() {
                PQCSettings.filetypesExternalUnrar = arc_extunrar.checked
                PQCSettings.filetypesArchiveControls = archivecontrols.checked
                PQCSettings.filetypesArchiveLeftRight = archiveleftright.checked
                PQCSettings.imageviewEscapeExitArchive = archive_escape.checked
                arc_extunrar.saveDefault()
                archivecontrols.saveDefault()
                archiveleftright.saveDefault()
                archive_escape.saveDefault()
            }

        }

        /**********************************************************************/
        PQSettingsSeparator {}
        /**********************************************************************/

        PQSetting {

            id: set_vid

            //: Settings title
            title: qsTranslate("settingsmanager", "Video")

            helptext: qsTranslate("settingsmanager",  "PhotoQt can treat video files the same as image files, as long as the respective video formats are enabled. There are a few settings available for managing how videos behave in PhotoQt: Whether they should autoplay when loaded, whether they should loop from the beginning when the end is reached, whether to prefer libmpv (if available) or Qt for video playback, and which video thumbnail generator to use.")

            content: [

                PQCheckBox {
                    id: vid_autoplay
                    enforceMaxWidth: set_vid.rightcol
                    text: qsTranslate("settingsmanager", "Autoplay")
                    onCheckedChanged: setting_top.checkDefault()
                },

                PQCheckBox {
                    id: vid_loop
                    enforceMaxWidth: set_vid.rightcol
                    text: qsTranslate("settingsmanager", "Loop")
                    onCheckedChanged: setting_top.checkDefault()
                },

                Flow {
                    width: set_vid.rightcol
                    PQRadioButton {
                        id: vid_qtmult
                        text: qsTranslate("settingsmanager", "prefer Qt Multimedia")
                        onCheckedChanged: setting_top.checkDefault()
                    }
                    PQRadioButton {
                        id: vid_libmpv
                        text: qsTranslate("settingsmanager", "prefer Libmpv")
                        onCheckedChanged: setting_top.checkDefault()
                    }
                },

                Flow {
                    width: set_vid.rightcol
                    spacing: 10
                    Item {
                        width: 25
                        height: 1
                    }

                    PQText {
                        height: videothumb.height
                        verticalAlignment: Text.AlignVCenter
                        text: qsTranslate("settingsmanager", "Video thumbnail generator:")
                    }
                    PQComboBox {
                        id: videothumb
                        model: ["------",
                                "ffmpegthumbnailer"]
                        currentIndex: (PQCSettings.filetypesVideoThumbnailer==="" ? 0 : 1) // qmllint disable unqualified
                        onCurrentIndexChanged: setting_top.checkDefault()
                    }
                },

                PQCheckBox {
                    id: videojump
                    enforceMaxWidth: set_vid.rightcol
                    spacing: 10
                    text: qsTranslate("settingsmanager", "Always use left/right arrow keys to jump back/ahead in videos")
                    onCheckedChanged: setting_top.checkDefault()
                },

                PQCheckBox {
                    id: videospace
                    enforceMaxWidth: set_vid.rightcol
                    spacing: 10
                    text: qsTranslate("settingsmanager", "Always use space key to play/pause videos")
                    onCheckedChanged: setting_top.checkDefault()
                }

            ]

            onResetToDefaults: {
                vid_autoplay.checked = (1*PQCScriptsConfig.getDefaultSettingValueFor("filetypesVideoAutoplay") == 1)
                vid_loop.checked = (1*PQCScriptsConfig.getDefaultSettingValueFor("filetypesVideoLoop") == 1)
                vid_qtmult.checked = (1*PQCScriptsConfig.getDefaultSettingValueFor("filetypesVideoPreferLibmpv") == 0)
                vid_libmpv.checked = (1*PQCScriptsConfig.getDefaultSettingValueFor("filetypesVideoPreferLibmpv") == 1)
                videothumb.currentIndex = (PQCScriptsConfig.getDefaultSettingValueFor("filetypesVideoThumbnailer").toString()==="" ? 0 : 1)
                videojump.checked = (1*PQCScriptsConfig.getDefaultSettingValueFor("filetypesVideoLeftRightJumpVideo") == 1)
                videospace.checked = (1*PQCScriptsConfig.getDefaultSettingValueFor("filetypesVideoSpacePause") == 1)
            }

            function handleEscape() {
                videothumb.popup.close()
            }

            function hasChanged() {
                return (vid_autoplay.hasChanged() || vid_loop.hasChanged() || vid_qtmult.hasChanged() ||
                        vid_libmpv.hasChanged() || videothumb.hasChanged() ||
                        videojump.hasChanged() || videospace.hasChanged())
            }

            function load() {
                vid_autoplay.loadAndSetDefault(PQCSettings.filetypesVideoAutoplay)
                vid_loop.loadAndSetDefault(PQCSettings.filetypesVideoLoop)
                vid_qtmult.loadAndSetDefault(!PQCSettings.filetypesVideoPreferLibmpv)
                vid_libmpv.loadAndSetDefault(PQCSettings.filetypesVideoPreferLibmpv)
                videothumb.loadAndSetDefault(PQCSettings.filetypesVideoThumbnailer==="" ? 0 : 1)
                videojump.loadAndSetDefault(PQCSettings.filetypesVideoLeftRightJumpVideo)
                videospace.loadAndSetDefault(PQCSettings.filetypesVideoSpacePause)
            }

            function applyChanges() {
                PQCSettings.filetypesVideoAutoplay = vid_autoplay.checked
                PQCSettings.filetypesVideoLoop = vid_loop.checked
                PQCSettings.filetypesVideoPreferLibmpv = vid_libmpv.checked
                PQCSettings.filetypesVideoThumbnailer = (videothumb.currentIndex===1 ? videothumb.currentText : "")
                PQCSettings.filetypesVideoLeftRightJumpVideo = videojump.checked
                PQCSettings.filetypesVideoSpacePause = videospace.checked
                vid_autoplay.saveDefault()
                vid_loop.saveDefault()
                vid_qtmult.saveDefault()
                vid_libmpv.saveDefault()
                videothumb.saveDefault()
                videojump.saveDefault()
                videospace.saveDefault()
            }

        }

        /**********************************************************************/
        PQSettingsSeparator {}
        /**********************************************************************/

        PQSetting {

            id: set_ani

            //: Settings title
            title: qsTranslate("settingsmanager", "Animated images")

            helptext: qsTranslate("settingsmanager", "PhotoQt can show controls for animated images that allow for stepping through an animated image frame by frame, jumping to a specific frame, and play/pause the animation. Additionally is is possible to force the left/right arrow keys to load the previous/next frame and/or use the space key to play/pause the animation, no matter what shortcut action is set to these keys.")

            content: [

                PQCheckBox {
                    id: animatedcontrol
                    enforceMaxWidth: set_ani.rightcol
                    text: qsTranslate("settingsmanager", "show floating controls for animated images")
                    onCheckedChanged: setting_top.checkDefault()
                },

                PQCheckBox {
                    id: animatedleftright
                    enforceMaxWidth: set_ani.rightcol
                    text: qsTranslate("settingsmanager", "use left/right arrow to load previous/next frame")
                    onCheckedChanged: setting_top.checkDefault()
                },

                PQCheckBox {
                    id: animspace
                    enforceMaxWidth: set_ani.rightcol
                    text: qsTranslate("settingsmanager", "Always use space key to play/pause animation")
                    onCheckedChanged: setting_top.checkDefault()
                }

            ]

            onResetToDefaults: {
                animatedcontrol.checked = (1*PQCScriptsConfig.getDefaultSettingValueFor("filetypesAnimatedControls") == 1)
                animatedleftright.checked = (1*PQCScriptsConfig.getDefaultSettingValueFor("filetypesAnimatedLeftRight") == 1)
                animspace.checked = (1*PQCScriptsConfig.getDefaultSettingValueFor("filetypesAnimatedSpacePause") == 1)
            }

            function handleEscape() {
            }

            function hasChanged() {
                return (animatedcontrol.hasChanged() || animatedleftright.hasChanged() || animspace.hasChanged())
            }

            function load() {
                animatedcontrol.loadAndSetDefault(PQCSettings.filetypesAnimatedControls)
                animatedleftright.loadAndSetDefault(PQCSettings.filetypesAnimatedLeftRight)
                animspace.loadAndSetDefault(PQCSettings.filetypesAnimatedSpacePause)
            }

            function applyChanges() {
                PQCSettings.filetypesAnimatedControls = animatedcontrol.checked
                PQCSettings.filetypesAnimatedLeftRight = animatedleftright.checked
                PQCSettings.filetypesAnimatedSpacePause = animspace.checked
                animatedcontrol.saveDefault()
                animatedleftright.saveDefault()
                animspace.saveDefault()
            }

        }

        /**********************************************************************/
        PQSettingsSeparator {}
        /**********************************************************************/

        PQSetting {

            id: set_raw

            //: Settings title
            title: qsTranslate("settingsmanager", "RAW images")

            helptext: qsTranslate("settingsmanager", "Some RAW images have embedded thumbnail images. If available, PhotoQt will always use those for generating a thumbnail image. Some embedded thumbnails are even as large as the actual RAW image. In that case, PhotoQt can simply load those embedded images instead of the full RAW image. This can result in much faster load times.")

            content: [
                PQCheckBox {
                    id: rawembed
                    enforceMaxWidth: set_raw.rightcol
                    text: qsTranslate("settingsmanager", "use embedded image if available")
                    onCheckedChanged: setting_top.checkDefault()
                }
            ]

            onResetToDefaults: {
                rawembed.checked = (1*PQCScriptsConfig.getDefaultSettingValueFor("filetypesRAWUseEmbeddedIfAvailable") == 1)
            }

            function handleEscape() {
            }

            function hasChanged() {
                return rawembed.hasChanged()
            }

            function load() {
                rawembed.loadAndSetDefault(PQCSettings.filetypesRAWUseEmbeddedIfAvailable)
            }

            function applyChanges() {
                PQCSettings.filetypesRAWUseEmbeddedIfAvailable = rawembed.checked
                rawembed.saveDefault()
            }

        }

        /**********************************************************************/
        PQSettingsSeparator {}
        /**********************************************************************/

        PQSetting {

            id: set_doc

            //: Settings title
            title: qsTranslate("settingsmanager", "Documents")

            helptext: qsTranslate("settingsmanager", "When a document is loaded it is possible to navigate through the pages of such a file either through floating controls that show up when the document contains more than one page, or by entering the viewer mode. When the viewer mode is activated all pages are loaded as thumbnails. The viewer mode can be activated by shortcut or through a small button located below the status info and as part of the floating navigation.")

            content: [

                PQCheckBox {
                    id: documentcontrols
                    enforceMaxWidth: set_doc.rightcol
                    text: qsTranslate("settingsmanager", "show floating controls for documents")
                    onCheckedChanged: setting_top.checkDefault()
                },

                PQCheckBox {
                    id: documentleftright
                    enforceMaxWidth: set_doc.rightcol
                    text: qsTranslate("settingsmanager", "use left/right arrow to load previous/next page")
                    onCheckedChanged: setting_top.checkDefault()
                }

            ]

            onResetToDefaults: {
                documentcontrols.checked = (1*PQCScriptsConfig.getDefaultSettingValueFor("filetypesDocumentControls") == 1)
                documentleftright.checked = (1*PQCScriptsConfig.getDefaultSettingValueFor("filetypesDocumentLeftRight") == 1)
            }

            function handleEscape() {
            }

            function hasChanged() {
                return (documentcontrols.hasChanged() || documentleftright.hasChanged())
            }

            function load() {
                documentcontrols.loadAndSetDefault(PQCSettings.filetypesDocumentControls)
                documentleftright.loadAndSetDefault(PQCSettings.filetypesDocumentLeftRight)
            }

            function applyChanges() {
                PQCSettings.filetypesDocumentControls = documentcontrols.checked
                PQCSettings.filetypesDocumentLeftRight = documentleftright.checked
                documentcontrols.saveDefault()
                documentleftright.saveDefault()
            }

        }

        Item {
            width: 1
            height: 1
        }

    }

    Component.onCompleted:
        load()

    function handleEscape() {
        set_pdf.handleEscape()
        set_arc.handleEscape()
        set_vid.handleEscape()
        set_ani.handleEscape()
        set_raw.handleEscape()
        set_doc.handleEscape()
    }

    function checkDefault() {

        if(!settingsLoaded) return
        if(PQCSettings.generalAutoSaveSettings) { // qmllint disable unqualified
            applyChanges()
            return
        }

        settingChanged = (set_pdf.hasChanged() || set_arc.hasChanged() || set_vid.hasChanged() ||
                          set_ani.hasChanged() || set_raw.hasChanged() || set_doc.hasChanged())

    }

    function load() {

        set_pdf.load()
        set_arc.load()
        set_vid.load()
        set_ani.load()
        set_raw.load()
        set_doc.load()

        settingChanged = false
        settingsLoaded = true

    }

    function applyChanges() {

        set_pdf.applyChanges()
        set_arc.applyChanges()
        set_vid.applyChanges()
        set_ani.applyChanges()
        set_raw.applyChanges()
        set_doc.applyChanges()

        settingChanged = false

    }

    function revertChanges() {
        load()
    }

}
