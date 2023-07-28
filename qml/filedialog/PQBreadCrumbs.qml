import QtQuick
import QtQuick.Controls
import "../elements"

import PQCFileFolderModel
import PQCScriptsConfig
import PQCScriptsFilesPaths

Item {

    id: breadcrumbs_top

    width: parent.width
    height: 50

    property alias topSettingsMenu: settingsmenu

    property bool folderListMenuOpen: false
    signal closeFolderListMenu()

    Row {

        Item {
            width: placesWidth
            height: breadcrumbs_top.height

            Row {

                x: 5

                Component.onCompleted: {
                    filedialog_top.leftColMinWidth = width+10
                }

                y: (parent.height-height)/2
                spacing: 5

                PQButtonIcon {
                    source: "/white/backwards.svg"
                    enabled: filedialog_top.historyIndex>0
                    onClicked:
                        filedialog_top.goBackInHistory()
                }
                PQButtonIcon {
                    source: "/white/upwards.svg"
                    onClicked:
                        filedialog_top.loadNewPath(PQCScriptsFilesPaths.goUpOneLevel(PQCFileFolderModel.folderFileDialog))
                }
                PQButtonIcon {
                    source: "/white/forwards.svg"
                    enabled: filedialog_top.historyIndex<filedialog_top.history.length-1
                    onClicked:
                        filedialog_top.goForwardsInHistory()
                }

                Item {

                    width: 5
                    height: 40

                    Rectangle {
                        x: 2
                        width: 1
                        height: 40
                        color: PQCLook.baseColorActive
                    }

                }

                PQButtonIcon {
                    id: iconview
                    checkable: true
                    checked: PQCSettings.filedialogLayout==="icons"
                    source: "/white/iconview.svg"
                    tooltip: qsTranslate("filedialog", "Show files as icons")
                    onCheckedChanged: {
                        PQCSettings.filedialogLayout = (checked ? "icons" : "list")
                        checked = Qt.binding(function() { return PQCSettings.filedialogLayout==="icons" })
                    }
                }

                PQButtonIcon {
                    id: listview
                    checkable: true
                    checked: PQCSettings.filedialogLayout!=="icons"
                    source: "/white/listview.svg"
                    tooltip: qsTranslate("filedialog", "Show files as list")
                    onCheckedChanged: {
                        PQCSettings.filedialogLayout = (checked ? "list" : "icons")
                        checked = Qt.binding(function() { return PQCSettings.filedialogLayout==="list" })
                    }
                }

                Item {

                    width: 5
                    height: 40

                    Rectangle {
                        x: 2
                        width: 1
                        height: 40
                        color: PQCLook.baseColorActive
                    }

                }

                PQButtonIcon {
                    id: remember
                    checkable: true
                    checked: true
                    source: "/white/remember.svg"
                }

                PQButtonIcon {
                    id: settings
                    checkable: true
                    source: "/white/settings.svg"
                    onCheckedChanged: {
                        if(checked)
                            settingsmenu.popup(0, height)
                    }

                    PQSettingsMenu {
                        id: settingsmenu
                    }

                }


            }

        }

        Rectangle {
            width: 8
            height: breadcrumbs_top.height
            color: PQCLook.baseColorAccent
        }

        Item {
            width: fileviewWidth
            height: breadcrumbs_top.height

            Row {

                id: crumbs

                y: (parent.height-height)/2

                property bool windows: PQCScriptsConfig.amIOnWindows()

                property var parts: !windows&&PQCFileFolderModel.folderFileDialog==="/" ? ["/"] : PQCFileFolderModel.folderFileDialog.split("/")

                Repeater {

                    model: crumbs.parts.length

                    Row {

                        id: deleg
                        property string subdir: {
                            var p = ""
                            if(crumbs.windows) {
                                for(var i = 0; i <= index; ++i) {
                                    if(p != "") p += "/"
                                    p += crumbs.parts[i]
                                }
                                return p
                            } else {
                                if(index == 0)
                                    return "/"
                                p = ""
                                for(var j = 1; j <= index; ++j)
                                    p += "/"+crumbs.parts[j]
                                return p
                            }
                        }

                        Rectangle {
                            height: breadcrumbs_top.height
                            width: folder.width+20
                            color: (mousearea2.containsPress ? PQCLook.baseColorActive : (mousearea2.containsMouse ? PQCLook.baseColorHighlight : PQCLook.baseColor))
                            Behavior on color { ColorAnimation { duration: 200 } }
                            PQText {
                                id: folder
                                x: 10
                                y: (parent.height-height)/2
                                font.weight: PQCLook.fontWeightBold
                                text: index===0&&!crumbs.windows ? "/" : crumbs.parts[index]
                            }
                            PQMouseArea {
                                id: mousearea2
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: filedialog_top.loadNewPath(deleg.subdir)
                            }
                        }

                        Rectangle {
                            height: breadcrumbs_top.height
                            width: height*2/3
                            property bool down: folderlist.visible
                            color: (down ? PQCLook.baseColorActive : (mousearea.containsMouse ? PQCLook.baseColorHighlight : PQCLook.baseColor))
                            Behavior on color { ColorAnimation { duration: 200 } }
                            Image {
                                anchors.fill: parent
                                anchors.leftMargin: parent.width/3
                                anchors.rightMargin: parent.width/3
                                anchors.topMargin: parent.height/3
                                anchors.bottomMargin: parent.height/3
                                fillMode: Image.PreserveAspectFit
                                source: "/white/breadcrumb.svg"
                            }
                            PQMouseArea {
                                id: mousearea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: (pos) => {
                                    folderlist.popup(0,height)
                                }
                            }

                            PQMenu {
                                id: folderlist
                                property var subfolders: []
                                PQMenuItem {
                                    text: "no subfolders found"
                                    font.italic: true
                                    enabled: false
                                    visible: folderlist.subfolders.length==0
                                    height: visible ? 40 : 0
                                }

                                Instantiator {
                                    id: inst
                                    model: 0
                                    delegate: PQMenuItem {
                                        id: menuItem
                                        text: folderlist.subfolders[modelData]
                                        onTriggered: filedialog_top.loadNewPath(PQCScriptsFilesPaths.cleanPath(deleg.subdir+"/"+text))
                                    }

                                    onObjectAdded: (index, object) => folderlist.insertItem(index, object)
                                    onObjectRemoved: (index, object) => folderlist.removeItem(object)

                                }
                                onAboutToShow: {
                                    subfolders = PQCScriptsFilesPaths.getFoldersIn(deleg.subdir)
                                    inst.model = 0
                                    inst.model = subfolders.length
                                    folderListMenuOpen = true
                                }
                                onAboutToHide:
                                    folderListMenuOpen = false
                                Connections {
                                    target: filedialog_top
                                    function onOpacityChanged() {
                                        if(filedialog_top.opacity<1)
                                            folderlist.close()
                                    }
                                }
                                Connections {
                                    target: breadcrumbs_top
                                    function onCloseFolderListMenu() {
                                        folderlist.close()
                                    }
                                }
                            }
                        }

                    }

                }

            }

        }

    }

    Rectangle {
        y: parent.height-1
        width: parent.width
        height: 1
        color: PQCLook.baseColorActive
    }

}
