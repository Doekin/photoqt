import QtQuick 2.3
import QtQuick.Controls 1.2

Rectangle {

	id: background
	color: "#AA000000"

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        // Hides everything when no other area is hovered
        onPositionChanged: {
            hideEverything()
        }

        // METADATA
        MouseArea {
            x: 0
            y: metaData.y
            height: metaData.height
            width: metaData.width
            hoverEnabled: true

            MouseArea {
                x: 0
                y: 0
                height: parent.height
                width: 25
                hoverEnabled: true
                onEntered:
                    PropertyAnimation {
                        target: metaData
                        property: "x"
                        to: -metaData.radius
                    }
            }

        }

        // THUMBNAILBAR
        MouseArea {
            x: 0
            y: background.height-thumbnailBar.height
            width: thumbnailBar.width
            height:thumbnailBar.height
            hoverEnabled: true

            MouseArea {
                x: 0
                y: parent.height-50
                width: parent.width
                height: 50
                hoverEnabled: true
                onEntered:
                    PropertyAnimation {
                            target:  thumbnailBar
                            property: (settings.thumbnailKeepVisible == 0 ? "y" : "");
                            to: background.height-thumbnailBar.height
                    }
            }

        }

    }

    // Hide elements

    function hideEverything() {
        hideThumbnailBar.start()
        hideMetaData.start()
    }

    PropertyAnimation {
        id: hideThumbnailBar
        target:  thumbnailBar
        property: (settings.thumbnailKeepVisible == 0 ? "y" : "");
        to: background.height
    }
    PropertyAnimation {
        id: hideMetaData
        target: metaData
        property: "x"
        to: -metaData.width
    }

}
