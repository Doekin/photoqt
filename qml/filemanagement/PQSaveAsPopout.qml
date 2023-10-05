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

import QtQuick 2.9
import "../elements"
import "../templates"

PQTemplatePopout {

    id: saveas_popout

    //: Window title
    title: em.pty+qsTranslate("filemanagement", "Save file as")

    geometry: windowgeometry.fileSaveAsWindowGeometry
    isMax: windowgeometry.fileSaveAsWindowMaximized
    popup: PQSettings.interfacePopoutFileSaveAs
    sizepopup: windowsizepopup.saveAs
    name: "filesaveas"
    source: "filemanagement/PQSaveAs.qml"

    onPopupChanged:
        PQSettings.interfacePopoutFileSaveAs = popup

    onGeometryChanged:
        windowgeometry.fileSaveAsWindowGeometry = geometry

    onIsMaxChanged:
        windowgeometry.fileSaveAsWindowMaximized = isMax

}
