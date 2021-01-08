/**************************************************************************
 **                                                                      **
 ** Copyright (C) 2011-2021 Lukas Spies                                  **
 ** Contact: http://photoqt.org                                          **
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

#ifndef PQIMAGEFORMATS_H
#define PQIMAGEFORMATS_H

#include <QObject>
#include <QtSql>
#include <QMessageBox>

#if defined(IMAGEMAGICK) || defined(GRAPHICSMAGICK)
#include <Magick++.h>
#endif

#include "../logger.h"
#include "../configfiles.h"

class PQImageFormats : public QObject {

    Q_OBJECT

public:
    static PQImageFormats& get() {
        static PQImageFormats instance;
        return instance;
    }

    PQImageFormats(PQImageFormats const&)     = delete;
    void operator=(PQImageFormats const&) = delete;

    Q_INVOKABLE void readDatabase() {
        readFromDatabase();
    }

    Q_INVOKABLE QVariantList getAllFormats() {
        return formats;
    }
    Q_INVOKABLE void setAllFormats(QVariantList f) {
        writeToDatabase(f);
    }

    Q_INVOKABLE QStringList getEnabledFormats() {
        return formats_enabled;
    }

    Q_INVOKABLE QStringList getEnabledMimeTypes() {
        return mimetypes_enabled;
    }

    Q_INVOKABLE QStringList getEnabledFormatsQt() {
        return formats_qt;
    }

    Q_INVOKABLE QStringList getEnabledMimeTypesQt() {
        return mimetypes_qt;
    }

    Q_INVOKABLE QStringList getEnabledFormatsMagick() {
        return formats_magick;
    }

    Q_INVOKABLE QStringList getEnabledMimeTypesMagick() {
        return mimetypes_magick;
    }

    Q_INVOKABLE QStringList getEnabledFormatsLibRaw() {
        return formats_libraw;
    }

    Q_INVOKABLE QStringList getEnabledMimeTypesLibRaw() {
        return mimetypes_libraw;
    }

    Q_INVOKABLE QStringList getEnabledFormatsPoppler() {
        return formats_poppler;
    }

    Q_INVOKABLE QStringList getEnabledMimeTypesPoppler() {
        return mimetypes_poppler;
    }

    Q_INVOKABLE QStringList getEnabledFormatsXCFTools() {
        return formats_xcftools;
    }

    Q_INVOKABLE QStringList getEnabledMimeTypesXCFTools() {
        return mimetypes_xcftools;
    }

    Q_INVOKABLE QStringList getEnabledFormatsDevIL() {
        return formats_devil;
    }

    Q_INVOKABLE QStringList getEnabledMimeTypesDevIL() {
        return mimetypes_devil;
    }

    Q_INVOKABLE QStringList getEnabledFormatsFreeImage() {
        return formats_freeimage;
    }

    Q_INVOKABLE QStringList getEnabledMimeTypesFreeImage() {
        return mimetypes_freeimage;
    }

    Q_INVOKABLE QStringList getEnabledFormatsLibArchive() {
        return formats_archive;
    }

    Q_INVOKABLE QStringList getEnabledMimeTypesLibArchive() {
        return mimetypes_archive;
    }

    Q_INVOKABLE QStringList getEnabledFormatsVideo() {
        return formats_video;
    }

    Q_INVOKABLE QStringList getEnabledMimeTypesVideo() {
        return mimetypes_video;
    }

    Q_INVOKABLE QVariantMap getMagick() {
        return magick;
    }

    Q_INVOKABLE QVariantMap getMagickMimeType() {
        return magick_mimetype;
    }

private:
    PQImageFormats();

    void readFromDatabase();
    void writeToDatabase(QVariantList f);

    QSqlDatabase db;

    QVariantList formats;

    QStringList formats_enabled;
    QStringList mimetypes_enabled;

    QStringList formats_qt;
    QStringList mimetypes_qt;
    QStringList formats_magick;
    QStringList mimetypes_magick;
    QStringList formats_libraw;
    QStringList mimetypes_libraw;
    QStringList formats_poppler;
    QStringList mimetypes_poppler;
    QStringList formats_xcftools;
    QStringList mimetypes_xcftools;
    QStringList formats_devil;
    QStringList mimetypes_devil;
    QStringList formats_freeimage;
    QStringList mimetypes_freeimage;
    QStringList formats_archive;
    QStringList mimetypes_archive;
    QStringList formats_video;
    QStringList mimetypes_video;

    QVariantMap magick;
    QVariantMap magick_mimetype;

    // this is true if reading from the permanent database failed
    // in that case we load the built-in default database but read-only
    bool readonly;

};


#endif // PQIMAGEFORMATS_H
