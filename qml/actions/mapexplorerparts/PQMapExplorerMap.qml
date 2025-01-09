pragma ComponentBehavior: Bound
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
import QtLocation
import QtPositioning

import PQCScriptsFilesPaths
import PQCLocation
import PQCScriptsClipboard

import "../../elements"

Item {

    id: map_top

    property real visibleLatitudeLeft: -180
    property real visibleLatitudeRight: 180
    property real visibleLongitudeLeft: -180
    property real visibleLongitudeRight: 180

    property int detaillevel: 0

    signal computeDetailLevel()
    signal clearModel()
    signal resetCurZ()
    signal resetMap()
    signal addItem(var lat, var lon, var fn, var lvl, var lbl, var full_lat, var full_lon)
    signal setMapCenter(var lat, var lon)
    signal setMapCenterSmooth(var lat, var lon)
    signal setMapZoomLevelSmooth(var lvl)
    signal updateVisibleRegionNow()
    signal showHighlightMarkerAt(var lat, var lon)
    signal hideHightlightMarker()

    function reloadLoader() {
        explorerMapLoader.active = false
        reloadExplorerMapAfterTimeout.restart()
    }

    Timer {
        id: reloadExplorerMapAfterTimeout
        interval: 100
        repeat: false
        onTriggered: {
            explorerMapLoader.active = true
        }
    }

    Plugin {

        id: osmPlugin

        name: "osm"

        PluginParameter {
            name: "osm.useragent"
            value: "PhotoQt Image Viewer"
        }

        PluginParameter {
            name: "osm.mapping.providersrepository.address"
            value: "https://osm.photoqt.org"
        }

        PluginParameter {
            name: "osm.mapping.highdpi_tiles";
            value: true
        }

    }

    Loader {

        id: explorerMapLoader

        anchors.fill: map_top

        sourceComponent: mapComponent

    }

    Component {

        id: mapComponent

        Map {

            id: map

            anchors.fill: explorerMapLoader

            center: QtPositioning.coordinate(49.01, 8.40)
            zoomLevel: mapexplorer_top.mapZoomLevel // qmllint disable unqualified

            property int curZ: 0

            plugin: osmPlugin

            activeMapType: supportedMapTypes[5]

            property geoCoordinate startCentroid

            WheelHandler {
                id: wheel
                // workaround for QTBUG-87646 / QTBUG-112394 / QTBUG-112432:
                // Magic Mouse pretends to be a trackpad but doesn't work with PinchHandler
                // and we don't yet distinguish mice and trackpads on Wayland either
                acceptedDevices: Qt.platform.pluginName === "cocoa" || Qt.platform.pluginName === "wayland" ?
                                     PointerDevice.Mouse | PointerDevice.TouchPad :
                                     PointerDevice.Mouse
                rotationScale: 1/40
                property: "zoomLevel"
            }

            DragHandler {
                id: drag
                target: null
                onTranslationChanged: (delta) => map.pan(-delta.x, -delta.y)
            }

            PinchHandler {
                id: pinch
                target: null
                onActiveChanged: if (active) {
                    map.startCentroid = map.toCoordinate(pinch.centroid.position, false)
                }
                onScaleChanged: (delta) => {
                    map.zoomLevel += Math.log2(delta)
                    map.alignCoordinateToPoint(map.startCentroid, pinch.centroid.position)
                }
                grabPermissions: PointerHandler.TakeOverForbidden
            }

            onZoomLevelChanged: (zoomLevel) => {
                if(!mapexplorer_top.finishShow) return // qmllint disable unqualified
                map_top.computeDetailLevel()
                if(zoomLevel !== mapexplorer_top.mapZoomLevel)
                    mapexplorer_top.mapZoomLevel = zoomLevel
            }

            Timer {
                id: updateVisibleRegion
                interval: 500
                repeat: true
                running: mapexplorer_top.visible // qmllint disable unqualified
                onTriggered: {
                    execute()
                }
                function execute() {
                    map_top.visibleLatitudeLeft = map.visibleRegion.boundingGeoRectangle().topLeft.latitude
                    map_top.visibleLongitudeLeft = map.visibleRegion.boundingGeoRectangle().topLeft.longitude
                    map_top.visibleLatitudeRight = map.visibleRegion.boundingGeoRectangle().bottomRight.latitude
                    map_top.visibleLongitudeRight= map.visibleRegion.boundingGeoRectangle().bottomRight.longitude
                }
            }

            property list<var> steps: [
                [0.001, 16.5],
                [0.005, 14],
                [0.01, 13],
                [0.02, 12],
                [0.05, 11],
                [0.1, 10],
                [0.2, 9],
                [0.5, 7.5],
                [1, 6.5],
                [2, 5.5],
                [4, 4.5],
                [8, 3.5],
                [12, 1],
            ]

            MapQuickItem {

                id: highlightMarker

                anchorPoint.x: highlightImage.width*(61/256)
                anchorPoint.y: highlightImage.height*(198/201)

                opacity: 0
                Behavior on opacity { NumberAnimation { duration: 100 } }
                visible: opacity>0

                property real latitude
                property real longitude
                Behavior on latitude { NumberAnimation { duration: 100 } }
                Behavior on longitude { NumberAnimation { duration: 100 } }
                coordinate: QtPositioning.coordinate(latitude, longitude)

                z: map.curZ+1

                sourceItem:
                    Image {
                        id: highlightImage
                        width: 64
                        height: 50
                        mipmap: true
                        smooth: false
                        source: "qrc:/" + PQCLook.iconShade + "/maplocation.png" // qmllint disable unqualified
                    }

                function showAt(lat : real, lon : real) {
                    highlightMarker.latitude = lat
                    highlightMarker.longitude = lon
                    highlightMarker.opacity = 1
                }

                function hide() {
                    highlightMarker.opacity = 0
                }

            }

            MapItemView {

                model: ListModel { id: mdl }

                opacity: highlightMarker.visible ? 0.5 : 1
                Behavior on opacity { NumberAnimation { duration: 100 } }

                delegate: MapQuickItem {

                    id: deleg

                    required property string latitude
                    required property string longitude
                    required property string filename
                    required property string levels
                    required property var labels
                    required property string display_latitude
                    required property string display_longitude

                    property list<string> keys: Object.keys(labels)

                    anchorPoint.x: container.width/2
                    anchorPoint.y: container.height/2

                    opacity: (x > -width && x < map.width && y > -height && y < map.height) && (lvls.indexOf(""+map_top.detaillevel) !== -1) ? 1 : 0
                    visible: opacity>0

                    property bool showTruePos: keys.indexOf(map_top.detaillevel+"")!=-1 && labels[map_top.detaillevel]*1==1
                    coordinate: QtPositioning.coordinate((showTruePos ? display_latitude : latitude), (showTruePos ? display_longitude : longitude))

                    property var lvls

                    sourceItem:
                        Rectangle {
                            id: container
                            width: 68
                            height: 68
                            color: "white"
                            Image {
                                id: image
                                x: 2
                                y: 2
                                width: 64
                                height: 64
                                fillMode: Image.PreserveAspectCrop
                                sourceSize.width: width
                                sourceSize.height: height
                                mipmap: true
                                cache: true
                                asynchronous: true
                                source: (!visible && source==="") ? "" : encodeURI("image://thumb/" + deleg.filename) // qmllint disable unqualified
                            }
                            Repeater {
                                model: deleg.keys.length
                                Rectangle {
                                    id: lbldeleg
                                    required property int modelData
                                    x: parent.width-width*0.8
                                    y: -height*0.2
                                    width: numlabel.width+20
                                    height: numlabel.height+4
                                    color: "#0088ff"
                                    radius: height/4
                                    visible: mdl.count>0 && deleg.labels[deleg.keys[modelData]]>1 && map_top.detaillevel===deleg.keys[modelData]
                                    PQText {
                                        id: numlabel
                                        x: 10
                                        y: 2
                                        font.weight: PQCLook.fontWeightBold // qmllint disable unqualified
                                        anchors.centerIn: parent
                                        text: deleg.labels[deleg.keys[lbldeleg.modelData]]
                                    }
                                }
                            }
                            PQMouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                property bool tooltipSetup: false
                                text: ""
                                onEntered: {
                                    if(!tooltipSetup) {
                                        text = (image.source=="" ? "" : ("<img src='" + image.source + "'>")) + "<br><br>" +
                                                                            " <b>" + PQCScriptsFilesPaths.getFilename(deleg.filename) + "</b>" + // qmllint disable unqualified
                                                                            ((deleg.labels[map_top.detaillevel]>1) ? (" + " + (deleg.labels[map_top.detaillevel]-1) + "") : "")
                                        tooltipSetup = true
                                    }

                                    map.curZ += 1
                                    deleg.z = map.curZ
                                }
                                onClicked: {

                                    smoothCenterLat.from = map.center.latitude
                                    smoothCenterLat.to = deleg.latitude

                                    smoothCenterLon.from = map.center.longitude
                                    smoothCenterLon.to = deleg.longitude

                                    smoothZoom.from = map.zoomLevel
                                    smoothZoom.to = Math.min(map.zoomLevel+1, map.maximumZoomLevel)

                                    smoothZoom.start()
                                    smoothCenterLat.start()
                                    smoothCenterLon.start()

                                }
                            }

                            Component.onCompleted: {
                                deleg.lvls = deleg.levels.split("_")
                            }

                        }

                }

            }

            Rectangle {
                width: gpspos.width+6
                height: gpspos.height+6
                color: "#bb000000"
                z: 5
                x: parent.width-width
                y: parent.height-height

                PQTextS {
                    id: gpspos
                    x: 3
                    y: 3
                    property list<double> loc: [Math.round(1e2*map.center.latitude)/1e2, Math.round(1e2*map.center.longitude)/1e2]
                    text: loc[0] + ", " + loc[1]
                    font.weight: PQCLook.fontWeightBold
                }

                PQMouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    text: qsTranslate("mapexplorer", "Click to copy location to clipboard")
                    onClicked: {
                        PQCScriptsClipboard.copyTextToClipboard(gpspos.loc[0] + " " + gpspos.loc[1])
                    }
                }
            }

            NumberAnimation {
                id: smoothZoom
                duration: 200
                target: mapexplorer_top // qmllint disable unqualified
                property: "mapZoomLevel"
            }

            NumberAnimation {
                id: smoothCenterLat
                duration: 200
                target: map
                property: "center.latitude"
            }

            NumberAnimation {
                id: smoothCenterLon
                duration: 200
                target: map
                property: "center.longitude"
            }

            NumberAnimation {
                id: smoothRotation
                duration: 200
                target: map
                property: "bearing"
            }

            NumberAnimation {
                id: smoothTilt
                duration: 200
                target: map
                property: "tilt"
            }

            Component.onCompleted:  {
                maptweaks.minZoomLevel = minimumZoomLevel // qmllint disable unqualified
                maptweaks.maxZoomLevel = maximumZoomLevel
            }

            Connections {

                target: map_top

                function onComputeDetailLevel() {
                    for(var i = 0; i < map.steps.length; ++i) {
                        if(map.zoomLevel > map.steps[i][1]) {
                            map_top.detaillevel = i
                            break
                        }
                    }
                }

                function onClearModel() {
                    mdl.clear()
                }

                function onResetCurZ() {
                    map.curZ = 0
                }

                function onResetMap() {
                    smoothCenterLat.from = map.center.latitude
                    smoothCenterLat.to = (PQCLocation.minimumLocation.x+PQCLocation.maximumLocation.x)/2 // qmllint disable unqualified

                    smoothCenterLon.from = map.center.longitude
                    smoothCenterLon.to = (PQCLocation.minimumLocation.y+PQCLocation.maximumLocation.y)/2

                    smoothZoom.from = map.zoomLevel
                    smoothZoom.to = (mdl.count>0 ? ((map.maximumZoomLevel-map.minimumZoomLevel)*0.3) : map.minimumZoomLevel)

                    smoothRotation.from = map.bearing
                    smoothRotation.to = 0

                    smoothTilt.from = map.tilt
                    smoothTilt.to = 0

                    smoothZoom.start()
                    smoothCenterLat.start()
                    smoothCenterLon.start()
                    smoothRotation.start()
                    smoothTilt.start()

                }

                function onAddItem(lat, lon, fn, lvl, lbl, full_lat, full_lon) {

                    mdl.append({"latitude": lat,
                                "longitude": lon,
                                "filename": fn,
                                "levels": lvl,
                                "labels": lbl,
                                "display_latitude": full_lat,
                                "display_longitude": full_lon
                               })

                }

                function onSetMapCenter(lat : real, lon : real) {
                    map.center.latitude = lat
                    map.center.longitude = lon
                }

                function onSetMapCenterSmooth(lat : real, lon : real) {

                    smoothCenterLat.from = map.center.latitude
                    smoothCenterLat.to = lat

                    smoothCenterLon.from = map.center.longitude
                    smoothCenterLon.to = lon

                    smoothCenterLat.start()
                    smoothCenterLon.start()
                }

                function onSetMapZoomLevelSmooth(lvl : int) {

                    smoothZoom.from = map.zoomLevel
                    smoothZoom.to = lvl
                    smoothZoom.start()

                }

                function onUpdateVisibleRegionNow() {
                    updateVisibleRegion.execute()
                }

                function onShowHighlightMarkerAt(lat : real, lon : real) {
                    highlightMarker.showAt(lat, lon)
                }

                function onHideHightlightMarker() {
                    highlightMarker.hide()
                }

            }

        }

    }

}
