/**************************************************************************
 **                                                                      **
 ** Copyright (C) 2011-2021 Lukas Spies                                  **
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

import QtQuick 2.9
import "../elements"

Rectangle {

    id: nav_top

    x: (parent.width-width)/2
    y: 10

    width: row.width
    height: row.height

    opacity: PQSettings.quickNavigation ? 1 : 0
    Behavior on opacity { NumberAnimation { duration: 200 } }
    visible: opacity>0

    color: "#bb000000"
    radius: 10

    PQMouseArea {
        anchors.fill: parent
        drag.target: parent
    }

    Row {

        id: row
        spacing: 5

        Item {
            width: 1
            height: 1
        }

        Image {
            width: 50
            height: width
            source: "/mainwindow/leftarrow.png"
            enabled: filefoldermodel.countMainView>0
            opacity: enabled ? 1 : 0.5
            Behavior on opacity { NumberAnimation { duration: 200 } }
            PQMouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                drag.target: nav_top
                tooltip: em.pty+qsTranslate("navigate", "Navigate to previous image in folder")
                onClicked:
                    imageitem.loadPrevImage()
            }
        }

        Image {
            width: 50
            height: width
            source: "/mainwindow/rightarrow.png"
            enabled: filefoldermodel.countMainView>0
            opacity: enabled ? 1 : 0.5
            Behavior on opacity { NumberAnimation { duration: 200 } }
            PQMouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                drag.target: nav_top
                tooltip: em.pty+qsTranslate("navigate", "Navigate to next image in folder")
                onClicked:
                    imageitem.loadNextImage()
            }
        }

        Item {
            width: 1
            height: 1
        }

        Image {
            width: 50
            height: width
            source: "/mainwindow/menu.png"
            PQMouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                drag.target: nav_top
                tooltip: em.pty+qsTranslate("navigate", "Show main menu")
                onClicked:
                    mainmenu.toggle()
            }
        }

        Item {
            width: 1
            height: 1
        }

    }

}
