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

#ifndef FILEFOLDERMODEL_H
#define FILEFOLDERMODEL_H

#include <QtGlobal>

#ifdef EXIV2
#ifdef Q_OS_WIN
#define NOMINMAX
#endif
#endif

#include <algorithm>
#include <QtConcurrent/QtConcurrent>
#include <QObject>
#include <QDateTime>
#include <QTimer>
#include <QCollator>
#include <QMimeDatabase>
#include <QDirIterator>
#include <QFileSystemWatcher>
#include "../settings/settings.h"
#include "../logger.h"
#include "../settings/imageformats.h"
#include "../scripts/handlingfiledir.h"
#include "../imageprovider/imageproviderfull.h"
#include "filefoldermodelcache.h"

#ifdef POPPLER
#include <poppler/qt5/poppler-qt5.h>
#endif
#ifdef QTPDF
#include <QtPdf>
#endif

#ifdef EXIV2
#include <exiv2/exiv2.hpp>
#endif

class PQFileFolderModel : public QObject {

    Q_OBJECT

public:
    enum FileRoles {
        FileNameRole = Qt::UserRole + 1,
        FilePathRole,
        PathRole,
        FileSizeRole,
        FileModifiedRole,
        FileIsDirRole,
        FileTypeRole
    };

    enum SortBy {
        Name,
        NaturalName,
        Time,
        Size,
        Type
    };
    Q_ENUM(SortBy)

    enum AdvancedSort {
        DominantColor,
        AverageColor
    };

    PQFileFolderModel(QObject *parent = nullptr);
    ~PQFileFolderModel();

    Q_PROPERTY(QString fileInFolderMainView READ getFileInFolderMainView WRITE setFileInFolderMainView NOTIFY fileInFolderMainViewChanged)
    QString getFileInFolderMainView() { return m_fileInFolderMainView; }
    void setFileInFolderMainView(QString val) {
        if(m_fileInFolderMainView == val)
            return;
        m_fileInFolderMainView = val;
        Q_EMIT fileInFolderMainViewChanged();
        loadDelayMainView->start();
    }

    Q_PROPERTY(QString folderFileDialog READ getFolderFileDialog WRITE setFolderFileDialog NOTIFY folderFileDialogChanged)
    QString getFolderFileDialog() { return m_folderFileDialog; }
    void setFolderFileDialog(QString val) {
        if(m_folderFileDialog == val)
            return;
        m_folderFileDialog = val;
        Q_EMIT folderFileDialogChanged();
        loadDelayFileDialog->start();
    }

    Q_PROPERTY(int countMainView READ getCountMainView WRITE setCountMainView NOTIFY countMainViewChanged)
    int getCountMainView() { return m_countMainView; }
    void setCountMainView(int c) {
        if(m_countMainView == c)
            return;
        m_countMainView = c;
        Q_EMIT countMainViewChanged();
    }

    Q_PROPERTY(int countFoldersFileDialog READ getCountFoldersFileDialog WRITE setCountFoldersFileDialog NOTIFY countFileDialogChanged)
    int getCountFoldersFileDialog() { return m_countFoldersFileDialog; }
    void setCountFoldersFileDialog(int c) {
        if(m_countFoldersFileDialog == c)
            return;
        m_countFoldersFileDialog = c;
        Q_EMIT countFileDialogChanged();
    }

    Q_PROPERTY(int countFilesFileDialog READ getCountFilesFileDialog WRITE setCountFilesFileDialog NOTIFY countFileDialogChanged)
    int getCountFilesFileDialog() { return m_countFilesFileDialog; }
    void setCountFilesFileDialog(int c) {
        if(m_countFilesFileDialog == c)
            return;
        m_countFilesFileDialog = c;
        Q_EMIT countFileDialogChanged();
    }


    Q_PROPERTY(int readDocumentOnly READ getReadDocumentOnly WRITE setReadDocumentOnly NOTIFY readDocumentOnlyChanged())
    int getReadDocumentOnly() { return m_readDocumentOnly; }
    void setReadDocumentOnly(int c) {
        if(m_readDocumentOnly == c)
            return;
        m_readDocumentOnly = c;
        Q_EMIT readDocumentOnlyChanged();
    }

    Q_PROPERTY(int readArchiveOnly READ getReadArchiveOnly WRITE setReadArchiveOnly NOTIFY readArchiveOnlyChanged())
    int getReadArchiveOnly() { return m_readArchiveOnly; }
    void setReadArchiveOnly(int c) {
        if(m_readArchiveOnly == c)
            return;
        m_readArchiveOnly = c;
        Q_EMIT readArchiveOnlyChanged();
    }

    Q_PROPERTY(int includeFilesInSubFolders READ getIncludeFilesInSubFolders WRITE setIncludeFilesInSubFolders NOTIFY includeFilesInSubFoldersChanged)
    int getIncludeFilesInSubFolders() { return m_includeFilesInSubFolders; }
    void setIncludeFilesInSubFolders(int c) {
        if(m_includeFilesInSubFolders == c)
            return;
        m_includeFilesInSubFolders = c;
        Q_EMIT includeFilesInSubFoldersChanged();
        loadDelayMainView->start();
    }


    Q_PROPERTY(QStringList defaultNameFilters READ getDefaultNameFilters WRITE setDefaultNameFilters NOTIFY defaultNameFiltersChanged)
    QStringList getDefaultNameFilters() { return m_defaultNameFilters; }
    void setDefaultNameFilters(QStringList val) {
        if(m_defaultNameFilters == val)
            return;
        m_defaultNameFilters = val;
        Q_EMIT defaultNameFiltersChanged();
        loadDelayMainView->start();
        loadDelayFileDialog->start();
    }

    Q_PROPERTY(QStringList nameFilters READ getNameFilters WRITE setNameFilters NOTIFY nameFiltersChanged)
    QStringList getNameFilters() { return m_nameFilters; }
    void setNameFilters(QStringList val) {
        if(m_nameFilters == val)
            return;
        m_nameFilters = val;
        Q_EMIT nameFiltersChanged();
        loadDelayMainView->start();
        loadDelayFileDialog->start();
    }

    Q_PROPERTY(QStringList filenameFilters READ getFilenameFilters WRITE setFilenameFilters NOTIFY filenameFiltersChanged)
    QStringList getFilenameFilters() { return m_filenameFilters; }
    void setFilenameFilters(QStringList val) {
        if(m_filenameFilters == val)
            return;
        m_filenameFilters = val;
        Q_EMIT filenameFiltersChanged();
        loadDelayMainView->start();
        loadDelayFileDialog->start();
    }

    Q_PROPERTY(QStringList mimeTypeFilters READ getMimeTypeFilters WRITE setMimeTypeFilters NOTIFY mimeTypeFiltersChanged)
    QStringList getMimeTypeFilters() { return m_mimeTypeFilters; }
    void setMimeTypeFilters(QStringList val) {
        if(m_mimeTypeFilters == val)
            return;
        m_mimeTypeFilters = val;
        Q_EMIT mimeTypeFiltersChanged();
        loadDelayMainView->start();
        loadDelayFileDialog->start();
    }

    Q_PROPERTY(QSize imageResolutionFilter READ getImageResolutionFilter WRITE setImageResolutionFilter NOTIFY imageResolutionFilterChanged)
    QSize getImageResolutionFilter() { return m_imageResolutionFilter; }
    void setImageResolutionFilter(QSize val) {
        if(m_imageResolutionFilter == val)
            return;
        m_imageResolutionFilter = val;
        Q_EMIT imageResolutionFilterChanged();
        loadDelayMainView->start();
        loadDelayFileDialog->start();
    }

    Q_PROPERTY(qint64 fileSizeFilter READ getFileSizeFilter WRITE setFileSizeFilter NOTIFY fileSizeFilterChanged)
    qint64 getFileSizeFilter() { return m_fileSizeFilter; }
    void setFileSizeFilter(qint64 val) {
        if(m_fileSizeFilter == val)
            return;
        m_fileSizeFilter = val;
        Q_EMIT fileSizeFilterChanged();
        loadDelayMainView->start();
        loadDelayFileDialog->start();
    }

    Q_PROPERTY(bool showHidden READ getShowHidden WRITE setShowHidden NOTIFY showHiddenChanged)
    bool getShowHidden() { return m_showHidden; }
    void setShowHidden(bool val) {
        if(m_showHidden == val)
            return;
        m_showHidden = val;
        Q_EMIT showHiddenChanged();
        loadDelayMainView->start();
        loadDelayFileDialog->start();
    }

    Q_PROPERTY(SortBy sortField READ getSortField WRITE setSortField NOTIFY sortFieldChanged)
    SortBy getSortField() { return m_sortField; }
    void setSortField(SortBy val) {
        if(m_sortField == val)
            return;
        m_sortField = val;
        Q_EMIT sortFieldChanged();
        loadDelayMainView->start();
        loadDelayFileDialog->start();
    }

    Q_PROPERTY(bool sortReversed READ getSortReversed WRITE setSortReversed NOTIFY sortReversedChanged)
    bool getSortReversed() { return m_sortReversed; }
    void setSortReversed(bool val) {
        if(m_sortReversed == val)
            return;
        m_sortReversed = val;
        Q_EMIT sortReversedChanged();
        loadDelayMainView->start();
        loadDelayFileDialog->start();
    }

    Q_PROPERTY(QStringList entriesFileDialog READ getEntriesFileDialog NOTIFY entriesFileDialogChanged)
    QStringList getEntriesFileDialog() { return m_entriesFileDialog; }

    Q_PROPERTY(QStringList entriesMainView READ getEntriesMainView NOTIFY entriesMainViewChanged)
    QStringList getEntriesMainView() { return m_entriesMainView; }

    Q_INVOKABLE void removeEntryMainView(int index);

    Q_INVOKABLE int getIndexOfMainView(QString filepath) {
        for(int i = 0; i < m_entriesMainView.length(); ++i) {
            if(m_entriesMainView[i] == filepath)
                return i;
        }
        return -1;
    }

    Q_INVOKABLE void advancedSortMainView();
    Q_INVOKABLE void advancedSortMainViewCANCEL() {
        advancedSortKeepGoing = false;
    }
    Q_PROPERTY(int advancedSortDone READ getAdvancedSortDone NOTIFY advancedSortDoneChanged)
    int getAdvancedSortDone() {
        return m_advancedSortDone;
    }

    Q_INVOKABLE void forceReloadMainView() {
        loadDelayMainView->stop();
        loadDataMainView();
    }

    Q_INVOKABLE void resetModel();

private:
    PQFileFolderModelCache cache;

    QFileSystemWatcher *watcherMainView;
    QFileSystemWatcher *watcherFileDialog;

    QString m_fileInFolderMainView;
    QString m_folderFileDialog;
    int m_countMainView;
    int m_countFoldersFileDialog;
    int m_countFilesFileDialog;

    bool m_readDocumentOnly;
    bool m_readArchiveOnly;
    bool m_includeFilesInSubFolders;

    QStringList m_entriesMainView;
    QStringList m_entriesFileDialog;

    QStringList m_nameFilters;
    QStringList m_defaultNameFilters;
    QStringList m_filenameFilters;
    QStringList m_mimeTypeFilters;
    QSize m_imageResolutionFilter;
    qint64 m_fileSizeFilter;
    bool m_showHidden;
    SortBy m_sortField;
    bool m_sortReversed;

    QTimer *loadDelayMainView;
    QTimer *loadDelayFileDialog;

    QStringList getAllFolders(QString folder);
    QStringList getAllFiles(QString folder, bool ignoreFiltersExceptDefault = false);

    QMimeDatabase db;

    QStringList listPDFPages(QString path);

    int m_advancedSortDone;
    bool advancedSortKeepGoing;

    QString cacheAdvancedSortCriteria;
    QString cacheAdvancedSortFolderName;
    QStringList cacheAdvancedSortFolder;
    qint64 cacheAdvancedSortLastModified;
    bool cacheAdvancedSortAscending;

private Q_SLOTS:
    void loadDataMainView();
    void loadDataFileDialog();

Q_SIGNALS:
    void newDataLoadedMainView();
    void newDataLoadedFileDialog();

    void advancedSortingComplete();

    void countMainViewChanged();
    void countFileDialogChanged();
    void entriesMainViewChanged();
    void entriesFileDialogChanged();
    void fileInFolderMainViewChanged();
    void folderFileDialogChanged();
    void nameFiltersChanged();
    void defaultNameFiltersChanged();
    void filenameFiltersChanged();
    void mimeTypeFiltersChanged();
    void imageResolutionFilterChanged();
    void fileSizeFilterChanged();
    void showHiddenChanged();
    void sortFieldChanged();
    void sortReversedChanged();
    void readDocumentOnlyChanged();
    void readArchiveOnlyChanged();
    void includeFilesInSubFoldersChanged();
    void advancedSortDoneChanged();

};

#endif
