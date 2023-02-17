/**************************************************************************
 **                                                                      **
 ** Copyright (C) 2011-2022 Lukas Spies                                  **
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
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtQml.Models 2.15
import "../elements"
import "../shortcuts/handleshortcuts.js" as HandleShortcuts

Menu {
    id: contextMenu

    style: MenuStyle {
        frame: Rectangle {
            color: "#44000000"
            border.color: "#44ffffff"
        }
        itemDelegate {
            background:
                Rectangle {
                    color: (styleData.selected&&styleData.enabled) ? "#bb333333" : "#bb000000"
                    anchors.margins: 0
                }
            label:
                Row {
                    anchors.margins: 0
                    Image {
                        y: 5
                        opacity: styleData.enabled ? 1 : 0.6
                        height: txt.height-10
                        width: height
                        source: styleData.iconSource
                        sourceSize: Qt.size(width, height)
                    }

                    Text {
                        id: txt
                        color: styleData.enabled ? "white" : "#aaaaaa"
                        text: styleData.text
                        leftPadding: 10
                        rightPadding: 10
                        topPadding: 5
                        bottomPadding: 5
                    }
                }
        }
    }

    property var allitems_file: [

        //: This is an entry in the main menu on the right. Please keep short!
        ["rename.svg", em.pty+qsTranslate("MainMenu", "Rename file"), "__rename"],

        //: This is an entry in the main menu on the right. Please keep short!
        ["copy.svg", em.pty+qsTranslate("MainMenu", "Copy file"), "__copy"],

        //: This is an entry in the main menu on the right. Please keep short!
        ["move.svg", em.pty+qsTranslate("MainMenu", "Move file"), "__move"],

        //: This is an entry in the main menu on the right. Please keep short!
        ["delete.svg", em.pty+qsTranslate("MainMenu", "Delete file"), "__delete"]

    ]

    property var allitems_image: [

        //: This is an entry in the main menu on the right. Please keep short!
        ["clipboard.svg", em.pty+qsTranslate("MainMenu", "Copy to clipboard"), "__clipboard"],

        //: This is an entry in the main menu on the right. Please keep short!
        ["faces.svg", em.pty+qsTranslate("MainMenu", "Tag faces"), "__tagFaces"],

        //: This is an entry in the main menu on the right. Please keep short!
        ["scale.svg", em.pty+qsTranslate("MainMenu", "Scale image"), "__scale"],

        //: This is an entry in the main menu on the right. Please keep short!
        ["wallpaper.svg", em.pty+qsTranslate("MainMenu", "Set as wallpaper"), "__wallpaper"]


    ]

    property var allitems_interface: [

        //: This is an entry in the main menu on the right. Please keep short!
        ["metadata.svg", PQSettings.metadataElementVisible ? (em.pty+qsTranslate("MainMenu", "Hide metadata")) : (em.pty+qsTranslate("MainMenu", "Show metadata")), "__showMetaData"],

        //: This is an entry in the main menu on the right. Please keep short!
        ["histogram.svg", PQSettings.histogramVisible ? (em.pty+qsTranslate("MainMenu", "Hide histogram")) : (em.pty+qsTranslate("MainMenu", "Show histogram")), "__histogram"]

    ]

    property var allitems_external: []


    Instantiator {
        model: allitems_file.length
        MenuItem {
            enabled: (filefoldermodel.current!=-1)
            iconSource: "/mainmenu/" + allitems_file[index][0]
            text: allitems_file[index][1]
            onTriggered:
                HandleShortcuts.executeInternalFunction(allitems_file[index][2])
        }
        onObjectAdded: contextMenu.insertItem(index, object)
        onObjectRemoved: contextMenu.removeItem(object)
    }

    MenuSeparator { }

    Instantiator {
        model: allitems_image.length
        MenuItem {
            enabled: (filefoldermodel.current!=-1)
            iconSource: "/mainmenu/" + allitems_image[index][0]
            text: allitems_image[index][1]
            onTriggered:
                HandleShortcuts.executeInternalFunction(allitems_image[index][2])
        }
        onObjectAdded: contextMenu.insertItem(index, object)
        onObjectRemoved: contextMenu.removeItem(object)
    }

    MenuSeparator { }

    Instantiator {
        model: allitems_interface.length
        MenuItem {
            iconSource: "/mainmenu/" + allitems_interface[index][0]
            text: allitems_interface[index][1]
            onTriggered:
                HandleShortcuts.executeInternalFunction(allitems_interface[index][2])
        }
        onObjectAdded: contextMenu.insertItem(index, object)
        onObjectRemoved: contextMenu.removeItem(object)
    }

    MenuSeparator { visible: allitems_external.length>0 }

    Instantiator {
        model: allitems_external.length
        MenuItem {
            iconSource: (allitems_external[index][0].slice(4)=="" ? "/settingsmanager/interface/application.svg" : ("data:image/png;base64,"+allitems_external[index][0].slice(4)))
            text: allitems_external[index][1]
            onTriggered: {
                HandleShortcuts.executeInternalFunction(allitems_external[index][2], allitems_external[index][3])
                if(allitems_external[index][4])
                    toplevel.quitPhotoQt()
            }
        }
        onObjectAdded: contextMenu.insertItem(index, object)
        onObjectRemoved: contextMenu.removeItem(object)
    }

    Component.onCompleted:
        readExternalContextmenu()

    Connections {
        target: filewatcher
        onContextmenuChanged: {
            readExternalContextmenu()
        }
    }

    function readExternalContextmenu() {

        var tmpentries = handlingExternal.getContextMenuEntries()
        var entries = []
        for(var i = 0; i < tmpentries.length; ++i) {
            // icon, desc, cmd, args, quit
            entries.push(["icn:"+tmpentries[i][0], tmpentries[i][2], tmpentries[i][1], tmpentries[i][4], 1*tmpentries[i][3]])
        }
        allitems_external = entries
    }

    function showMenu() {
        popup()
    }

    function hideMenu() { }

}
