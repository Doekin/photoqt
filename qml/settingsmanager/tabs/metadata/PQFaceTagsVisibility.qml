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
import QtQuick.Controls 2.2

import "../../../elements"

PQSetting {
    id: set
    //: A settings title. The face tags are labels that can be shown (if available) on faces including their name.
    title: em.pty+qsTranslate("settingsmanager_metadata", "face tags - visibility")
    helptext: em.pty+qsTranslate("settingsmanager_metadata", "When to show the face tags and for how long.")
    content: [

        PQComboBox {
            id: ft_combo
            //: A mode for showing face tags.
            model: [em.pty+qsTranslate("settingsmanager_metadata", "hybrid mode"),
                    //: A mode for showing face tags.
                    em.pty+qsTranslate("settingsmanager_metadata", "always show all"),
                    //: A mode for showing face tags.
                    em.pty+qsTranslate("settingsmanager_metadata", "show one on hover"),
                    //: A mode for showing face tags.
                    em.pty+qsTranslate("settingsmanager_metadata", "show all on hover")]
        }

    ]

    Connections {

        target: settingsmanager_top

        onLoadAllSettings: {
            load()
        }

        onSaveAllSettings: {
            if(ft_combo.currentIndex == 0) {
                PQSettings.peopleTagInMetaHybridMode = true
                PQSettings.peopleTagInMetaAlwaysVisible = false
                PQSettings.peopleTagInMetaIndependentLabels = false
            } else if(ft_combo.currentIndex == 1) {
                PQSettings.peopleTagInMetaHybridMode = false
                PQSettings.peopleTagInMetaAlwaysVisible = true
                PQSettings.peopleTagInMetaIndependentLabels = false
            } else if(ft_combo.currentIndex == 2) {
                PQSettings.peopleTagInMetaHybridMode = false
                PQSettings.peopleTagInMetaAlwaysVisible = false
                PQSettings.peopleTagInMetaIndependentLabels = true
            } else {
                PQSettings.peopleTagInMetaHybridMode = false
                PQSettings.peopleTagInMetaAlwaysVisible = false
                PQSettings.peopleTagInMetaIndependentLabels = false
            }
        }

    }

    Component.onCompleted: {
        load()
    }

    function load() {
        if(PQSettings.peopleTagInMetaHybridMode)
            ft_combo.currentIndex = 0
        else if(PQSettings.peopleTagInMetaAlwaysVisible)
            ft_combo.currentIndex = 1
        else if(PQSettings.peopleTagInMetaIndependentLabels)
            ft_combo.currentIndex = 2
        else
            ft_combo.currentIndex = 3
    }

}
