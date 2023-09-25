#####################
#### C++ SOURCES ####
#####################

SET(photoqt_QML "")

SET(d "qml")
SET(photoqt_QML ${photoqt_QML} ${d}/PQMainWindow.qml)

SET(d "qml/elements")
SET(photoqt_QML ${photoqt_QML} ${d}/PQText.qml ${d}/PQTextS.qml ${d}/PQTextL.qml ${d}/PQTextXL.qml ${d}/PQMouseArea.qml ${d}/PQButtonIcon.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQSlider.qml ${d}/PQComboBox.qml ${d}/PQButtonElement.qml ${d}/PQVerticalScrollBar.qml ${d}/PQMenu.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQMenuItem.qml ${d}/PQMultiEffect.qml ${d}/PQMenuSeparator.qml ${d}/PQButton.qml ${d}/PQCheckBox.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQToolTip.qml ${d}/PQHorizontalScrollBar.qml ${d}/PQMainMenuEntry.qml ${d}/PQMainMenuIcon.qml ${d}/PQMetaDataEntry.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQModal.qml ${d}/PQTextXXL.qml ${d}/PQTemplateFullscreen.qml ${d}/PQTemplatePopout.qml ${d}/PQTemplateFloating.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQSpinBox.qml ${d}/PQWorking.qml ${d}/PQLineEdit.qml ${d}/PQRadioButton.qml ${d}/PQTabBar.qml ${d}/PQTextArea.qml)

SET(d "qml/filedialog")
SET(photoqt_QML ${photoqt_QML} ${d}/PQFileDialog.qml ${d}/PQPlaces.qml ${d}/PQBreadCrumbs.qml ${d}/PQFileView.qml ${d}/PQTweaks.qml ${d}/PQPreview.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQPasteExistingConfirm.qml ${d}/PQSettingsMenu.qml)

SET(d "qml/filedialog/popout")
SET(photoqt_QML ${photoqt_QML} ${d}/PQFileDialogPopout.qml)

SET(d "qml/manage")
SET(photoqt_QML ${photoqt_QML} ${d}/PQLoader.qml)

SET(d "qml/other")
SET(photoqt_QML ${photoqt_QML} ${d}/PQShortcuts.qml ${d}/PQBackgroundMessage.qml ${d}/PQTemplateFullscreen.qml ${d}/PQSlideshowHandler.qml)

SET(d "qml/image")
SET(photoqt_QML ${photoqt_QML} ${d}/PQImage.qml ${d}/PQImageNormal.qml ${d}/PQImageAnimated.qml ${d}/PQVideoMpv.qml ${d}/PQVideoControls.qml)

SET(d "qml/ongoing")
SET(photoqt_QML ${photoqt_QML} ${d}/PQThumbnails.qml ${d}/PQMainMenu.qml ${d}/PQMetaData.qml ${d}/PQStatusInfo.qml ${d}/PQContextMenu.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQHistogram.qml ${d}/PQMapCurrent.qml ${d}/PQTrayIcon.qml ${d}/PQWindowButtons.qml ${d}/PQNavigation.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQSlideshowControls.qml ${d}/PQNotification.qml)

SET(d "qml/ongoing/popout")
SET(photoqt_QML ${photoqt_QML} ${d}/PQMainMenuPopout.qml ${d}/PQMetaDataPopout.qml ${d}/PQHistogramPopout.qml ${d}/PQMapCurrentPopout.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQLoggingPopout.qml ${d}/PQSlideshowControlsPopout.qml)

SET(d "qml/actions")
SET(photoqt_QML ${photoqt_QML} ${d}/PQExport.qml ${d}/PQAbout.qml ${d}/PQScale.qml ${d}/PQDelete.qml ${d}/PQRename.qml ${d}/PQCopy.qml ${d}/PQMove.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQFilter.qml ${d}/PQAdvancedSort.qml ${d}/PQSlideshowSetup.qml ${d}/PQImgur.qml)

SET(d "qml/actions/popout")
SET(photoqt_QML ${photoqt_QML} ${d}/PQExportPopout.qml ${d}/PQAboutPopout.qml ${d}/PQScalePopout.qml ${d}/PQDeletePopout.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQRenamePopout.qml ${d}/PQFilterPopout.qml ${d}/PQAdvancedSortPopout.qml ${d}/PQSlideshowSetupPopout.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQImgurPopout.qml)
