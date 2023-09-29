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
import QtQuick.Window
import Qt.labs.platform

SystemTrayIcon {

    id: trayicon

    visible: PQCSettings.interfaceTrayIcon>0

    icon.source: "qrc:/other/logo_white.svg"

    menu: Menu {
        id: mn

        MenuItem {
            text: (toplevel.visible ? "Hide PhotoQt" : "Show PhotoQt")
            onTriggered: {
                PQCSettings.interfaceTrayIcon = 1
                toplevel.visible = !toplevel.visible
                if(toplevel.visible) {
                    if(toplevel.visibility === Window.Minimized)
                        toplevel.visibility = Window.Maximized
                    toplevel.raise()
                    toplevel.requestActivate()
                }
            }
        }

        MenuItem {
            text: "Quit PhotoQt"
            onTriggered:
                toplevel.quitPhotoQt()
        }

        Component.onCompleted:
            mn.visible = false

    }

    onActivated: {
        PQCSettings.interfaceTrayIcon = 1
        toplevel.visible = !toplevel.visible
        if(toplevel.visible) {
            if(toplevel.visibility === Window.Minimized)
                toplevel.visibility = Window.Maximized
            toplevel.raise()
            toplevel.requestActivate()
        }
    }

}
