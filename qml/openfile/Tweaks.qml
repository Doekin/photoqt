import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

Rectangle {

    id: statusbar

    color: "#44000000"

    signal displayIcons();
    signal displayList();
    signal updateShowHidden()

    property int zoomlevel: zoom.getZoomLevel()
    property bool isHoverPreviewEnabled: preview.isHoverEnabled

    TweaksZoom {
        id: zoom
        anchors.left: parent.left
        anchors.leftMargin: 10
        onUpdateZoom: zoomlevel = level
    }

    TweaksHiddenFolders {
        id: hiddenfolders
        anchors.right: select.left
        anchors.rightMargin: 20
        onUpdateHidden: updateShowHidden()
    }

    TweaksFileTypeSelection {
        id: select
        anchors.right: preview.left
        anchors.rightMargin: 10
    }

    TweaksPreview {
        id: preview
        anchors.right: thumbnail.left
        anchors.rightMargin: 10
    }

    TweaksThumbnail {
        id: thumbnail
        anchors.right: viewmode.left
    }


    TweaksViewMode {
        id: viewmode
        anchors.right: parent.right
        anchors.rightMargin: 10
    }

    function getView() {
        return viewmode.getView()
    }

    function getThumbnailEnabled() {
        return thumbnail.getThumbnailEnabled()
    }
    function setThumbnailChecked(s) {
        thumbnail.setThumbnailChecked(s)
    }

    function getFileTypeSelection() {
        return select.getFileTypeSelection()
    }

    function getHiddenFolders() {
        return hiddenfolders.getHiddenFolders()
    }

    function zoomLarger() {
        zoom.zoomLarger()
    }
    function zoomSmaller() {
        zoom.zoomSmaller()
    }
    function toggleHiddenFolders() {
        hiddenfolders.toggleHiddenFolders()
    }

}
