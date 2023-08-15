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

import "../../../elements"
import "../../../shortcuts/mouseshortcuts.js" as PQAnalyseMouse

Rectangle {

    id: newshortcut_top

    parent: settingsmanager_top

    anchors.fill: parent

    color: "#ee000000"

    opacity: 0
    visible: opacity > 0
    Behavior on opacity { NumberAnimation { duration: PQSettings.imageviewAnimationDuration*100 } }

    property bool dontResetKeys: false

    property var mouseComboMods: []
    property string mouseComboButton: ""
    property var mouseComboDirection: []

    property var keyComboMods: []
    property string keyComboKey: ""

    property int currentIndex: -1
    property int currentSubIndex: -1

    signal newCombo(var index, var subindex, var combo)

    function assembleKeyCombo() {

        leftbutmessage.opacity = 0
        savebut.enabled = true

        var txt = ""

        if(keyComboMods.length > 0) {
            txt += "<b>" + keymousestrings.translateShortcut(keyComboMods.join("+")) + "</b>"
            txt += "<br>+<br>"
        }

        if(keyComboKey == "::PLUS::")
            txt += "<b>+</b>"
        else
            txt += "<b>" + keymousestrings.translateShortcut(keyComboKey) + "</b>"

        combo_txt.text = txt

        if(txt.slice(txt.length-7,txt.length) == "<b></b>" || txt == "")
            restartCancelTimer()
        else
            restartSaveTimer()

    }

    function assembleMouseCombo() {

        var txt = ""

        if(mouseComboMods.length > 0) {
            txt += "<b>" + keymousestrings.translateShortcut(mouseComboMods.join("+")) + "</b>"
            txt += "<br>+<br>"
        }

        txt += "<b>" + keymousestrings.translateShortcut(mouseComboButton) + "</b>"
        if(mouseComboDirection.length > 0) {
            txt += "<br>+<br>"
            txt += "<b>" + keymousestrings.translateShortcut(mouseComboDirection.join(""), true) + "</b>"
        }

        combo_txt.text = txt

        if(mouseComboMods.length == 0 && mouseComboButton == "Left Button") {
            leftbutmessage.opacity = 1
            stopSaveTimer()
            savebut.enabled = false
        } else {
            leftbutmessage.opacity = 0
            if(txt.slice(txt.length-7,txt.length) == "<b></b>" || txt == "")
                restartCancelTimer()
            else {
                restartSaveTimer()
                savebut.enabled = true
            }
        }

    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
    }

    PQTextXL {
        id: titletxt
        y: insidecont.y-2*height
        width: parent.width
        font.weight: baselook.boldweight
        horizontalAlignment: Text.AlignHCenter
        text: (newshortcut_top.currentSubIndex==-1 ? em.pty+qsTranslate("settingsmanager_shortcuts", "Add New Shortcut") : em.pty+qsTranslate("settingsmanager_shortcuts", "Set new shortcut"))
    }

    Rectangle {

        id: insidecont

        x: (parent.width-width)/2
        y: (parent.height-height)/2-10
        width: Math.min(800, parent.width)
        height: Math.min(600, parent.height-2*titletxt.height-2*butcont.height-40)

        color: "#220000"
        border.width: 1
        border.color: "#330000"

        PQText {
            id: instr_txt
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            font.weight: baselook.boldweight
            text: em.pty+qsTranslate("settingsmanager_shortcuts", "Perform a mouse gesture here or press any key combo")
        }

        PQTextXL {
            id: combo_txt
            anchors.fill: parent
            anchors.topMargin: instr_txt.height
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            color: "#cccccc"
        }

        Rectangle {
            id: leftbutmessage
            y: parent.height-height
            width: parent.width
            height: leftbutmessagetxt.height+20
            color: "#88181818"
            opacity: 0
            visible: opacity>0
            Behavior on opacity { NumberAnimation { duration: 200 } }
            PQText {
                id: leftbutmessagetxt
                y: 10
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                text: em.pty+qsTranslate("settingsmanager_shortcuts", "The left button is used for moving the main image around.") + "<br>\n" +
                      em.pty+qsTranslate("settingsmanager_shortcuts", "It can be used as part of a shortcut only when combined with modifier buttons (Alt, Ctrl, etc.).")
            }
            SequentialAnimation {
                loops: Animation.Infinite
                running: leftbutmessage.visible
                PropertyAnimation { target: leftbutmessage; property: "color"; from: "#88181818"; to: "#88333333"; duration: 400 }
                PropertyAnimation { target: leftbutmessage; property: "color"; from: "#88333333"; to: "#88181818"; duration: 400 }
            }
        }

        PQMouseArea {

            id: mouseShMouse

            anchors.fill: parent

            hoverEnabled: true
            acceptedButtons: Qt.AllButtons

            property point pressedPosLast: Qt.point(-1,-1)
            property bool pressedEventInProgress: false
            property int buttonId: 0

            property bool ignoreSingleBecauseDouble: false

            doubleClickThreshold: PQSettings.interfaceDoubleClickThreshold

            onPressed: {

                if(ignoreSingleBecauseDouble) {
                    ignoreSingleBecauseDouble = false
                    return
                }

                pressedEventInProgress = true
                pressedPosLast = Qt.point(mouse.x, mouse.y)

                mouseComboMods = PQAnalyseMouse.analyseMouseModifiers(mouse.modifiers)
                mouseComboButton = (mouse.button == Qt.LeftButton
                                        ? "Left Button"
                                        : (mouse.button == Qt.MiddleButton
                                           ? "Middle Button"
                                           : (mouse.button == Qt.RightButton
                                              ? "Right Button"
                                              : (mouse.button == Qt.ForwardButton
                                                 ? "Forward Button"
                                                 : (mouse.button == Qt.BackButton
                                                    ? "Back Button"
                                                    : (mouse.button == Qt.TaskButton
                                                       ? "Task Button"
                                                       : (mouse.button == Qt.ExtraButton4
                                                          ? "Button #7"
                                                          : (mouse.button == Qt.ExtraButton5
                                                             ? "Button #8"
                                                             : (mouse.button == Qt.ExtraButton6
                                                                ? "Button #9"
                                                                : (mouse.button == Qt.ExtraButton7
                                                                   ? "Button #10"
                                                                   : "Unknown Button"))))))))))
                mouseComboDirection = []
                keyComboKey = ""
                keyComboMods = []

                assembleMouseCombo()

            }

            onDoubleClicked: {
                ignoreSingleBecauseDouble = true
                pressedEventInProgress = false
                keyComboMods = []
                keyComboKey = ""

                mouseComboMods = PQAnalyseMouse.analyseMouseModifiers(mouse.modifiers)
                mouseComboButton = "Double Click"
                mouseComboDirection = []

                assembleMouseCombo()
            }

            onPositionChanged: {
                if(pressedEventInProgress) {
                    var mov = PQAnalyseMouse.analyseMouseGestureUpdate(mouse, pressedPosLast)
                    if(mov != "") {
                        mouseComboMods = PQAnalyseMouse.analyseMouseModifiers(mouse.modifiers)
                        if(mouseComboDirection[mouseComboDirection.length-1] != mov) {
                            mouseComboDirection.push(mov)
                        }
                        pressedPosLast = Qt.point(mouse.x, mouse.y)
                    }
                    assembleMouseCombo()
                }
            }

            onReleased: {
                pressedEventInProgress = false
            }

           onWheel: {

               keyComboMods = []
               keyComboKey = ""

               mouseComboMods = PQAnalyseMouse.analyseMouseModifiers(wheel.modifiers)
               mouseComboButton = PQAnalyseMouse.analyseMouseWheelAction(mouseComboButton, wheel.angleDelta, wheel.modifiers, true)
               mouseComboDirection = []

               assembleMouseCombo()

           }

        }

    }

    Timer {
        id: canceltimer
        repeat: true
        running: false
        interval: 1000
        property int countdown: 10
        onTriggered: {
            countdown -= 1
            if(countdown == 0) {
                canceltimer.stop()
                cancelbut.clicked()
            }
        }
    }

    Timer {
        id: savetimer
        repeat: true
        running: false
        interval: 1000
        property int countdown: 10
        onTriggered: {
            countdown -= 1
            if(countdown == 0) {
                savetimer.stop()
                savebut.clicked()
            }
        }
    }

    Item {

        id: butcont
        x: (parent.width-width)/2
        y: insidecont.y+insidecont.height+height
        width: row.width
        height: row.height

        Row {
            id: row
            spacing: 10
            PQButton {
                id: savebut
                text: (savetimer.running ? (genericStringSave+" (" + savetimer.countdown + ")") : genericStringSave)
                font.weight: (savetimer.running ? baselook.boldweight : baselook.normalweight)
                onClicked: {
                    canceltimer.stop()
                    savetimer.stop()
                    newshortcut_top.opacity = 0
                    settingsmanager_top.modalWindowOpen = false
                    settingsmanager_top.detectingShortcutCombo = false

                    var combo = ""
                    if(keyComboKey != "") {
                        if(keyComboMods.length > 0) {
                            combo += keyComboMods.join("+")
                            combo += "+"
                        }
                        combo += keyComboKey
                    } else {
                        if(mouseComboMods.length > 0)
                            combo += mouseComboMods.join("+")+"+"
                        combo += mouseComboButton
                        if(mouseComboDirection.length > 0) {
                            combo += "+"
                            combo += mouseComboDirection.join("")
                        }
                    }
                    newCombo(currentIndex, currentSubIndex, combo)
                }
            }
            PQButton {
                id: cancelbut
                text: (canceltimer.running ? genericStringCancel+" (" + canceltimer.countdown + ")" : genericStringCancel)
                font.weight: (canceltimer.running ? baselook.boldweight : baselook.normalweight)
                onClicked: {
                    canceltimer.stop()
                    savetimer.stop()
                    newshortcut_top.opacity = 0
                    settingsmanager_top.modalWindowOpen = false
                    settingsmanager_top.detectingShortcutCombo = false
                }
            }
        }

    }

    Connections {

        target: settingsmanager_top

        onNewModsKeysCombo: {

            if(!visible) return

            var tmp_keyComboMods = []
            var tmp_keyComboKey = ""

            var combo = handlingShortcuts.composeString(mods, keys)
            combo = combo.replace("++","+::PLUS::")
            var parts = combo.split("+")
            for(var iP in parts) {
                var p = parts[iP]
                if(p == "Ctrl" || p == "Alt" || p == "Shift" || p == "Meta" || p == "Keypad")
                    tmp_keyComboMods.push(p)
                else
                    tmp_keyComboKey = p
            }

            mouseComboMods = []
            mouseComboButton = ""
            mouseComboDirection = []

            keyComboMods = tmp_keyComboMods
            keyComboKey = tmp_keyComboKey

            assembleKeyCombo()

        }

    }

    function show(index, subindex) {

        mouseComboMods = []
        mouseComboButton = ""
        mouseComboDirection = []
        keyComboKey = ""
        keyComboMods = []

        combo_txt.text = ""
        leftbutmessage.opacity = 0

        restartCancelTimer()

        newshortcut_top.opacity = 1
        settingsmanager_top.modalWindowOpen = true
        settingsmanager_top.detectingShortcutCombo = true

        newshortcut_top.currentIndex = index
        newshortcut_top.currentSubIndex = subindex

    }

    function restartCancelTimer() {
        savetimer.stop()
        canceltimer.countdown = 15
        canceltimer.start()
    }

    function restartSaveTimer() {
        canceltimer.stop()
        savetimer.countdown = 5
        savetimer.start()
    }

    function stopSaveTimer() {
        canceltimer.stop()
        savetimer.stop()
        savetimer.countdown = 5
    }

}
