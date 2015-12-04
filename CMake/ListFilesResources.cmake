# All the qml files
SET(d "qmlresources")
SET(photoqt_RESOURCES ${photoqt_RESOURCES} ${d}/elements.qrc)
SET(photoqt_RESOURCES ${photoqt_RESOURCES} ${d}/fadein.qrc)
SET(photoqt_RESOURCES ${photoqt_RESOURCES} ${d}/mainview.qrc)
SET(photoqt_RESOURCES ${photoqt_RESOURCES} ${d}/openfile.qrc)
SET(photoqt_RESOURCES ${photoqt_RESOURCES} ${d}/other.qrc)
SET(photoqt_RESOURCES ${photoqt_RESOURCES} ${d}/settings.qrc)
SET(photoqt_RESOURCES ${photoqt_RESOURCES} ${d}/settings2.qrc)
SET(photoqt_RESOURCES ${photoqt_RESOURCES} ${d}/slidein.qrc)

# Add language resource file
SET(photoqt_RESOURCES ${photoqt_RESOURCES} ${CMAKE_CURRENT_BINARY_DIR}/lang.qrc)

# And the images
SET(photoqt_RESOURCES ${photoqt_RESOURCES} img.qrc)
