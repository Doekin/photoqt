#include <scripts/pqc_scriptsfilespaths.h>
#include <pqc_settings.h>
#include <QtLogging>
#include <QtDebug>
#include <QDir>
#include <QMimeDatabase>
#include <QUrl>
#include <QStorageInfo>
#include <QCollator>

PQCScriptsFilesPaths::PQCScriptsFilesPaths() {

}

PQCScriptsFilesPaths::~PQCScriptsFilesPaths() {

}

QString PQCScriptsFilesPaths::cleanPath(QString path) {

#ifdef Q_OS_WIN
    return cleanPath_windows(path);
#else
    if(path.startsWith("file:////"))
        path = path.remove(0, 8);
    else if(path.startsWith("file:///"))
        path = path.remove(0, 7);
    else if(path.startsWith("file://"))
        path = path.remove(0, 6);
    else if(path.startsWith("image://full/"))
        path = path.remove(0, 13);
    else if(path.startsWith("image://thumb/"))
        path = path.remove(0, 14);

    return QDir::cleanPath(path);
#endif

}

QString PQCScriptsFilesPaths::cleanPath_windows(QString path) {

    if(path.startsWith("file:///"))
        path = path.remove(0, 8);
    else if(path.startsWith("file://"))
        path = path.remove(0, 7);
    else if(path.startsWith("file:/"))
        path = path.remove(0, 6);
    else if(path.startsWith("image://full/"))
        path = path.remove(0, 13);
    else if(path.startsWith("image://thumb/"))
        path = path.remove(0, 14);

    bool networkPath = path.startsWith("//");
    path = QDir::cleanPath(path);
    if(networkPath)
        path = "/"+path;

    return path;

}

QString PQCScriptsFilesPaths::pathWithNativeSeparators(QString path) {

#ifdef Q_OS_WIN
    while(path.startsWith("/"))
        path = path.mid(1);
#endif

    return QDir::toNativeSeparators(path);

}

QString PQCScriptsFilesPaths::getSuffix(QString path) {

    return QFileInfo(path).suffix();

}

QString PQCScriptsFilesPaths::getFilename(QString fullpath) {

    return QFileInfo(fullpath).fileName();

}

QDateTime PQCScriptsFilesPaths::getFileModified(QString path) {

    return QFileInfo(path).lastModified();

}

QString PQCScriptsFilesPaths::getFileType(QString path) {

    QMimeDatabase db;
    return db.mimeTypeForFile(path).name();

}

QString PQCScriptsFilesPaths::getFileSizeHumanReadable(QString path) {

    const qint64 bytes = QFileInfo(path).size();

    if(bytes <= 1024)
        return QString("%1 B").arg(bytes);
    else if(bytes <= 1024*1024)
        return QString("%1 KB").arg(qRound(10.0*(bytes/1024.0))/10.0);

    return QString("%1 MB").arg(qRound(100.0*(bytes/(1024.0*1024.0)))/100.0);

}

QString PQCScriptsFilesPaths::toPercentEncoding(QString str) {
    return QUrl::toPercentEncoding(str);
}

QString PQCScriptsFilesPaths::goUpOneLevel(QString path) {
    QDir dir(path);
    dir.cdUp();
    return dir.absolutePath();
}

QString PQCScriptsFilesPaths::getWindowsDriveLetter(QString path) {

    QStorageInfo info(path);
    return info.rootPath();

}

QStringList PQCScriptsFilesPaths::getFoldersIn(QString path) {

    if(path == "")
        return QStringList();

    QDir dir(path);

    dir.setFilter(QDir::Dirs|QDir::NoDotAndDotDot);

    QStringList ret = dir.entryList();

    QCollator collator;
    collator.setNumericMode(true);
    std::sort(ret.begin(), ret.end(), [&collator](const QString &file1, const QString &file2) { return collator.compare(file1, file2) < 0; });

    return ret;

}

QString PQCScriptsFilesPaths::getHomeDir() {
    return QDir::homePath();
}

bool PQCScriptsFilesPaths::isFolder(QString path) {
    return QFileInfo(path).isDir();
}

bool PQCScriptsFilesPaths::doesItExist(QString path) {
    return QFileInfo::exists(path);
}

bool PQCScriptsFilesPaths::isExcludeDirFromCaching(QString filename) {

    if(PQCSettings::get()["thumbnailsExcludeDropBox"].toString() != "") {
        if(filename.indexOf(PQCSettings::get()["thumbnailsExcludeDropBox"].toString())== 0)
            return true;
    }

    if(PQCSettings::get()["thumbnailsExcludeNextcloud"].toString() != "") {
        if(filename.indexOf(PQCSettings::get()["thumbnailsExcludeNextcloud"].toString())== 0)
            return true;
    }

    if(PQCSettings::get()["thumbnailsExcludeOwnCloud"].toString() != "") {
        if(filename.indexOf(PQCSettings::get()["thumbnailsExcludeOwnCloud"].toString())== 0)
            return true;
    }

    const QStringList str = PQCSettings::get()["thumbnailsExcludeFolders"].toStringList();
    for(const QString &dir: str) {
        if(filename.indexOf(dir) == 0)
            return true;
    }

    return false;

}
