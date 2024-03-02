#####################
#### C++ SOURCES ####
#####################

SET(photoqt_QML "")

SET(d "qml")
SET(photoqt_QML ${photoqt_QML} ${d}/PQMainWindow.qml ${d}/PQMainWindowBackground.qml)

SET(d "qml/elements")
SET(photoqt_QML ${photoqt_QML} ${d}/PQText.qml ${d}/PQTextS.qml ${d}/PQTextL.qml ${d}/PQTextXL.qml ${d}/PQMouseArea.qml ${d}/PQButtonIcon.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQSlider.qml ${d}/PQComboBox.qml ${d}/PQButtonElement.qml ${d}/PQVerticalScrollBar.qml ${d}/PQMenu.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQMenuItem.qml ${d}/PQMultiEffect.qml ${d}/PQMultiEffect_real.qml ${d}/PQMultiEffect_fake.qml ${d}/PQMenuSeparator.qml ${d}/PQButton.qml ${d}/PQCheckBox.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQToolTip.qml ${d}/PQHorizontalScrollBar.qml ${d}/PQMainMenuEntry.qml ${d}/PQMainMenuIcon.qml ${d}/PQMetaDataEntry.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQModal.qml ${d}/PQTextXXL.qml ${d}/PQTemplateFullscreen.qml ${d}/PQTemplatePopout.qml ${d}/PQTemplateFloating.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQSpinBox.qml ${d}/PQWorking.qml ${d}/PQLineEdit.qml ${d}/PQRadioButton.qml ${d}/PQTabBar.qml ${d}/PQTextArea.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQBlurBackground.qml ${d}/PQBlurBackground_real.qml ${d}/PQBlurBackground_fake.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQSettingsSeparator.qml)

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
SET(photoqt_QML ${photoqt_QML} ${d}/PQImage.qml)
SET(d "qml/image/imageitems")
SET(photoqt_QML ${photoqt_QML} ${d}/PQImageNormal.qml ${d}/PQImageAnimated.qml ${d}/PQVideoMpv.qml ${d}/PQVideoQt.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQPhotoSphere.qml ${d}/PQPhotoSphere_real.qml ${d}/PQPhotoSphere_fake.qml)
SET(d "qml/image/components")
SET(photoqt_QML ${photoqt_QML} ${d}/PQVideoControls.qml ${d}/PQFaceTracker.qml ${d}/PQFaceTagger.qml ${d}/PQBarCodes.qml)

SET(d "qml/ongoing")
SET(photoqt_QML ${photoqt_QML} ${d}/PQThumbnails.qml ${d}/PQMainMenu.qml ${d}/PQMetaData.qml ${d}/PQStatusInfo.qml ${d}/PQContextMenu.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQHistogram.qml ${d}/PQMapCurrent.qml ${d}/PQTrayIcon.qml ${d}/PQWindowButtons.qml ${d}/PQNavigation.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQSlideshowControls.qml ${d}/PQNotification.qml ${d}/PQChromeCast.qml ${d}/PQWindowHandles.qml)

SET(d "qml/ongoing/popout")
SET(photoqt_QML ${photoqt_QML} ${d}/PQMainMenuPopout.qml ${d}/PQMetaDataPopout.qml ${d}/PQHistogramPopout.qml ${d}/PQMapCurrentPopout.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQLoggingPopout.qml ${d}/PQSlideshowControlsPopout.qml)

SET(d "qml/actions")
SET(photoqt_QML ${photoqt_QML} ${d}/PQExport.qml ${d}/PQAbout.qml ${d}/PQScale.qml ${d}/PQDelete.qml ${d}/PQRename.qml ${d}/PQCopy.qml ${d}/PQMove.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQFilter.qml ${d}/PQAdvancedSort.qml ${d}/PQSlideshowSetup.qml ${d}/PQImgur.qml ${d}/PQWallpaper.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQMapExplorer.qml ${d}/PQChromeCastManager.qml)

SET(d "qml/actions/popout")
SET(photoqt_QML ${photoqt_QML} ${d}/PQExportPopout.qml ${d}/PQAboutPopout.qml ${d}/PQScalePopout.qml ${d}/PQDeletePopout.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQRenamePopout.qml ${d}/PQFilterPopout.qml ${d}/PQAdvancedSortPopout.qml ${d}/PQSlideshowSetupPopout.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQImgurPopout.qml ${d}/PQWallpaperPopout.qml ${d}/PQChromeCastManagerPopout.qml ${d}/PQMapExplorerPopout.qml)

SET(d "qml/actions/wallpaperparts")
SET(photoqt_QML ${photoqt_QML} ${d}/PQEnlightenment.qml ${d}/PQGnome.qml ${d}/PQOther.qml ${d}/PQPlasma.qml ${d}/PQWindows.qml ${d}/PQXfce.qml)

SET(d "qml/actions/mapexplorerparts")
SET(photoqt_QML ${photoqt_QML} ${d}/PQMapExplorerImages.qml ${d}/PQMapExplorerImagesTweaks.qml ${d}/PQMapExplorerMap.qml ${d}/PQMapExplorerMapTweaks.qml)

SET(d "qml/settingsmanager")
SET(photoqt_QML ${photoqt_QML} ${d}/PQSettingsManager.qml ${d}/PQCategory.qml)

SET(d "qml/settingsmanager/popout")
SET(photoqt_QML ${photoqt_QML} ${d}/PQSettingsManagerPopout.qml)

SET(d "qml/settingsmanager/settings/filetypes")
SET(photoqt_QML ${photoqt_QML} ${d}/PQFileTypes.qml ${d}/PQBehavior.qml ${d}/PQAdvanced.qml)

SET(d "qml/settingsmanager/settings/imageview")
SET(photoqt_QML ${photoqt_QML} ${d}/PQShareOnline.qml ${d}/PQImage.qml ${d}/PQInteraction.qml ${d}/PQFolder.qml)

SET(d "qml/settingsmanager/settings/interface")
SET(photoqt_QML ${photoqt_QML} ${d}/PQBackground.qml ${d}/PQContextMenu.qml ${d}/PQLanguage.qml ${d}/PQPopout.qml ${d}/PQWindow.qml)
SET(photoqt_QML ${photoqt_QML} ${d}/PQStatusInfo.qml ${d}/PQEdges.qml)

SET(d "qml/settingsmanager/settings/metadata")
SET(photoqt_QML ${photoqt_QML} ${d}/PQFaceTags.qml ${d}/PQLabels.qml ${d}/PQBehavior.qml)

SET(d "qml/settingsmanager/settings/session")
SET(photoqt_QML ${photoqt_QML} ${d}/PQRemember.qml ${d}/PQInstance.qml ${d}/PQTrayIcon.qml)

SET(d "qml/settingsmanager/settings/shortcuts")
SET(photoqt_QML ${photoqt_QML} ${d}/PQShortcuts.qml ${d}/PQNewAction.qml ${d}/PQNewShortcut.qml ${d}/PQBehavior.qml)

SET(d "qml/settingsmanager/settings/thumbnails")
SET(photoqt_QML ${photoqt_QML} ${d}/PQImage.qml ${d}/PQAllThumbnails.qml ${d}/PQManage.qml)

SET(d "qml/settingsmanager/settings/manage")
SET(photoqt_QML ${photoqt_QML} ${d}/PQReset.qml ${d}/PQExportImport.qml)
