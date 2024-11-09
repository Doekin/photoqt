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

Row {

    id: setctrl

    property int leftcol: Math.max(200, Math.min(300, setting_top.width/3)) // qmllint disable unqualified
    property int rightcol: parent.width-leftcol-30

    property string helptext: ""
    property string title: ""
    property alias content: contcol.children
    property int contentSpacing: contcol.spacing

    property bool makeHelpTextVisible: !PQCSettings.generalCompactSettings // qmllint disable unqualified

    Row {

        width: setctrl.leftcol
        spacing: 10

        PQButtonIcon {
            id: helpicon
            y: (parent.height/ttl.lineCount -height)/2
            width: setctrl.makeHelpTextVisible ? 0 : 30
            Behavior on width { NumberAnimation { duration: 200 } }
            height: 30
            opacity: setctrl.makeHelpTextVisible ? 0 : 1
            Behavior on opacity { NumberAnimation { duration: 150 } }
            clip: true
            source: "image://svg/:/white/help.svg"
            tooltip: setctrl.helptext
            tooltipPartialTransparency: false
            visible: width>0
            onClicked: {
                settinginfomessage.show(setctrl.helptext) // qmllint disable unqualified
            }
        }

        PQTextXL {
            id: ttl
            font.weight: PQCLook.fontWeightBold // qmllint disable unqualified
            text: setctrl.title
            font.capitalization: Font.SmallCaps
            width: setctrl.leftcol - (setctrl.makeHelpTextVisible ? 0 : 40)
            Behavior on width { NumberAnimation { duration: 200 } }
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        }

    }

    Item {
        width: 20
        height: 1
    }

    Column {

        width: setctrl.rightcol

        Item {
            width: 1
            height: setctrl.makeHelpTextVisible ? 5 : 2
            Behavior on height { NumberAnimation { duration: 200 } }
        }

        Item {

            width: parent.width
            height: setctrl.makeHelpTextVisible ? helptext_verbose.height+10 : 0
            Behavior on height { NumberAnimation { duration: 200 } }
            opacity: setctrl.makeHelpTextVisible ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 150 } }
            visible: height>0

            PQText {

                id: helptext_verbose

                width: parent.width

                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                text: setctrl.helptext
            }

        }

        Item {
            width: 1
            height: setctrl.makeHelpTextVisible ? 10 : 0
            Behavior on height { NumberAnimation { duration: 200 } }
        }

        Column {

            id: contcol

            spacing: 10

            width: setctrl.rightcol

        }

    }

}
