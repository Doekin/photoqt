/**************************************************************************
 **                                                                      **
 ** Copyright (C) 2011-2020 Lukas Spies                                  **
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

#include "imageformats.h"
#include <QImageReader>

PQImageFormats::PQImageFormats() {

    if(QSqlDatabase::isDriverAvailable("QSQLITE3"))
        db = QSqlDatabase::addDatabase("QSQLITE3");
    else if(QSqlDatabase::isDriverAvailable("QSQLITE"))
        db = QSqlDatabase::addDatabase("QSQLITE");
    else {
        LOG << CURDATE << "PQImageFormats::PQImageFormats(): ERROR: SQLite driver not available. Available drivers are: " << QSqlDatabase::drivers().join(",").toStdString() << NL;
        QMessageBox::critical(0, "ERROR getting default image formats", "You seem to be missing the SQLite driver for Qt. This is needed though for a few different things, like reading the enabled/default image formats. Without it some things will not work correctly.");
        return;
    }
    db.setHostName("formats");
    db.setDatabaseName(ConfigFiles::IMAGEFORMATS_DB());

    if(!QFile::exists(ConfigFiles::IMAGEFORMATS_DB()) || !db.open()) {

        LOG << CURDATE << "PQImageFormats::PQImageFormats(): ERROR opening database: " << db.lastError().text().trimmed().toStdString() << NL;
        LOG << CURDATE << "PQImageFormats::PQImageFormats(): Will load built-in read-only database of imageformats" << NL;

        readonly = true;
        db.setConnectOptions("QSQLITE_OPEN_READONLY");

        QString tmppath = QStandardPaths::writableLocation(QStandardPaths::TempLocation)+"/imageformats.db";

        if(QFile::exists(tmppath))
            QFile::remove(tmppath);

        if(!QFile::copy(":/imageformats.db", tmppath)) {
            LOG << CURDATE << "PQImageFormats::PQImageFormats(): ERROR copying read-only default database!" << NL;
            QMessageBox::critical(0, "ERROR getting default image formats", "I tried hard, but I just cannot open even a read-only version of the database of default image formats, something went terribly wrong somewhere... :/");
            return;
        }

        db.setDatabaseName(tmppath);

        if(!db.open()) {
            LOG << CURDATE << "PQImageFormats::PQImageFormats(): ERROR opening read-only default database!" << NL;
            QMessageBox::critical(0, "ERROR getting default image formats", "I tried hard, but I just cannot open the database of default image formats, something went terribly wrong somewhere... :/");
            return;
        }

        readFromDatabase();

    } else {

        readonly = false;
        readFromDatabase();

    }

}

void PQImageFormats::readFromDatabase() {

    formats.clear();
    formats_enabled.clear();
    formats_defaultenabled.clear();
    formats_qt.clear();
    formats_im.clear();
    formats_gm.clear();
    formats_libraw.clear();
    formats_poppler.clear();
    formats_xcftools.clear();
    formats_devil.clear();
    formats_freeimage.clear();
    formats_archive.clear();
    formats_video.clear();

    mimetypes_enabled.clear();
    mimetypes_qt.clear();
    mimetypes_im.clear();
    mimetypes_gm.clear();
    mimetypes_libraw.clear();
    mimetypes_poppler.clear();
    mimetypes_xcftools.clear();
    mimetypes_devil.clear();
    mimetypes_freeimage.clear();
    mimetypes_archive.clear();
    mimetypes_video.clear();

    magick.clear();
    magick_mimetype.clear();

    const QList<QByteArray> qtSupported = QImageReader::supportedImageFormats();

    QSqlQuery query("SELECT * FROM imageformats ORDER BY description ASC", db);

    while(query.next()) {

        const QString endings = query.record().value("endings").toString();
        const QString mimetypes = query.record().value("mimetypes").toString();
        const QString desc = query.record().value("description").toString();
        const int enabled = query.record().value("enabled").toInt();
        const int defaultenabled = query.record().value("defaultenabled").toInt();
        const int qt = query.record().value("qt").toInt();
#ifdef IMAGEMAGICK
        const int im = query.record().value("imagemagick").toInt();
#endif
#ifdef GRAPHICSMAGICK
        const int gm = query.record().value("graphicsmagick").toInt();
#endif
        const int libraw = query.record().value("libraw").toInt();
        const int poppler = query.record().value("poppler").toInt();
        const int xcftools = query.record().value("xcftools").toInt();
        const int devil = query.record().value("devil").toInt();
        const int freeimage = query.record().value("freeimage").toInt();
        const int archive = query.record().value("archive").toInt();
        const int video = query.record().value("video").toInt();
        const QString im_gm_magick = query.record().value("im_gm_magick").toString();
        const QString qt_formatname = query.record().value("qt_formatname").toString();

        bool supportedByAnyLibrary = false;
        bool magickToBeAdded = false;

        QList<QVariant> all;
        all << endings;
        all << enabled;
        all << desc;
        if(qt) {
            // we check the formats against the list of supported image formats
            // this list can vary depending on which plugins are installed
            if(qtSupported.contains(qt_formatname.toUtf8())) {
                supportedByAnyLibrary = true;
                all << "Qt";
                formats_qt << endings.split(",").toVector();
                if(mimetypes != "")
                    mimetypes_qt << mimetypes.split(",").toVector();
            }
        }
#if defined(IMAGEMAGICK) || defined(GRAPHICSMAGICK)
        if(im) {

            // we check with the Magick++ API to see if each format is readable
            // by default we assume it is and if either no codec is available (exception thrown)
            // or when it is reported as not readable, then we skip this format
            bool alright = true;
            if(im_gm_magick != "") {
                try {
                    Magick::CoderInfo magickCoderInfo(im_gm_magick.toStdString());
                    if(!magickCoderInfo.isReadable())
                        alright = false;
                } catch(Magick::Exception &) {
                    alright = false;
                }
            }

            if(alright) {
                supportedByAnyLibrary = true;
                magickToBeAdded = true;
#ifdef IMAGEMAGICK
                all << "ImageMagick";
                formats_im << endings.split(",").toVector();
                if(mimetypes != "")
                    mimetypes_im << mimetypes.split(",").toVector();
#endif
#ifdef GRAPHICSMAGICK
                all << "GraphicsMagick";
                formats_gm << endings.split(",").toVector();
                if(mimetypes != "")
                    mimetypes_gm << mimetypes.split(",").toVector();
#endif
            }
        }
#endif
#ifdef RAW
        if(libraw) {
            supportedByAnyLibrary = true;
            all << "libraw";
            formats_libraw << endings.split(",").toVector();
            if(mimetypes != "")
                mimetypes_libraw << mimetypes.split(",").toVector();
        }
#endif
#ifdef POPPLER
        if(poppler) {
            supportedByAnyLibrary = true;
            all << "Poppler";
            formats_poppler << endings.split(",").toVector();
            if(mimetypes != "")
                mimetypes_poppler << mimetypes.split(",").toVector();
        }
#endif
        if(xcftools) {
            supportedByAnyLibrary = true;
            all << "XCFTools";
            formats_xcftools << endings.split(",").toVector();
            if(mimetypes != "")
                mimetypes_xcftools << mimetypes.split(",").toVector();
        }
#ifdef DEVIL
        if(devil) {
            supportedByAnyLibrary = true;
            all << "DevIL";
            formats_devil << endings.split(",").toVector();
            if(mimetypes != "")
                mimetypes_devil << mimetypes.split(",").toVector();
        }
#endif
#ifdef FREEIMAGE
        if(freeimage) {
            supportedByAnyLibrary = true;
            all << "FreeImage";
            formats_freeimage << endings.split(",").toVector();
            if(mimetypes != "")
                mimetypes_freeimage << mimetypes.split(",").toVector();
        }
#endif
#ifdef LIBARCHIVE
        if(archive) {
            supportedByAnyLibrary = true;
            all << "LibArchive";
            formats_archive << endings.split(",").toVector();
            if(mimetypes != "")
                mimetypes_archive << mimetypes.split(",").toVector();
        }
#endif
#ifdef VIDEO
        if(video) {
            supportedByAnyLibrary = true;
            all << "Video";
            formats_video << endings.split(",").toVector();
            if(mimetypes != "")
                mimetypes_video << mimetypes.split(",").toVector();
        }
#endif

        if(supportedByAnyLibrary) {

            formats << QVariant::fromValue(all);

            if(enabled) {
                formats_enabled << endings.split(",").toVector();
                if(mimetypes != "")
                    mimetypes_enabled << mimetypes.split(",").toVector();
            }
            if(defaultenabled)
                formats_defaultenabled << endings;
            if(magickToBeAdded && im_gm_magick != "") {
                for(QString e : endings.split(",")) {
                    if(magick.keys().contains(e))
                        magick[e] = QStringList() << magick[e].toStringList() << im_gm_magick;
                    else
                        magick.insert(e, QStringList() << im_gm_magick);
                }
                for(QString mt : mimetypes.split(",")) {
                    if(magick_mimetype.keys().contains(mt))
                        magick_mimetype[mt] = QStringList() << magick_mimetype[mt].toStringList() << im_gm_magick;
                    else
                        magick_mimetype.insert(mt, QStringList() << im_gm_magick);
                }
            }

        }
    }

}

void PQImageFormats::writeToDatabase(QVariantList f) {

    if(readonly) return;

    db.transaction();

    for(QVariant entry : f) {

        QSqlQuery query(db);
        query.prepare("UPDATE imageformats SET enabled=:enabled WHERE endings=:endings");
        query.bindValue(":enabled", entry.toList()[1].toInt());
        query.bindValue(":endings", entry.toList()[0].toString());
        if(!query.exec())
            LOG << CURDATE << "PQImageFormats::writeToDatabase(): SQL Query error: " << query.lastError().text().trimmed().toStdString() << NL;

    }

    db.commit();

    readFromDatabase();

}
