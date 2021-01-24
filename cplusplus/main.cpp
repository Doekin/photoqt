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

#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include "variables.h"
#include "startup.h"
#include "startup/exportimport.h"
#include "settings/settings.h"
#include "scripts/handlingfiledialog.h"
#include "scripts/handlinggeneral.h"
#include "scripts/handlingshortcuts.h"
#include "scripts/handlingfiledir.h"
#include "scripts/handlingmanipulation.h"
#include "scripts/handlingshareimgur.h"
#include "scripts/handlingwallpaper.h"
#include "scripts/handlingfacetags.h"
#include "scripts/handlingexternal.h"
#include "scripts/localisation.h"
#include "scripts/imageproperties.h"
#include "settings/imageformats.h"
#include "scripts/filewatcher.h"
#include "scripts/filefoldermodel.h"
#include "singleinstance/singleinstance.h"
#include "settings/windowgeometry.h"
#include "scripts/metadata.h"
#include "scripts/systemtrayicon.h"

#include "imageprovider/imageprovidericon.h"
#include "imageprovider/imageproviderthumb.h"
#include "imageprovider/imageproviderfull.h"
#include "imageprovider/imageproviderhistogram.h"

#ifdef GRAPHICSMAGICK
#include <GraphicsMagick/Magick++.h>
#endif

#ifdef IMAGEMAGICK
#include <Magick++.h>
#endif

#ifdef DEVIL
#include <IL/il.h>
#endif

int main(int argc, char **argv) {

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    PQSingleInstance app(argc, argv);

    // Set app name and version
    QGuiApplication::setApplicationName("PhotoQt");
    QGuiApplication::setOrganizationName("");
    QGuiApplication::setOrganizationDomain("photoqt.org");
    QGuiApplication::setApplicationVersion(VERSION);

    QGuiApplication::setQuitOnLastWindowClosed(true);

    if(app.exportAndQuit != "") {
        PQStartup::Export::perform(app.exportAndQuit);
        std::exit(0);
    } else if(app.importAndQuit != "") {
        PQStartup::Import::perform(app.importAndQuit);
        std::exit(0);
    }

    // check for update or new install
    bool performStartupChecks = false;
    QFile txt(ConfigFiles::SETTINGS_FILE());
    if(!txt.exists() || PQSettings::get().getVersion().split(".")[0] == "1" || PQSettings::get().getVersion().split(".")[0] == "0") {
        performStartupChecks = true;
        PQVariables::get().setFreshInstall(true);
    } else
        PQVariables::get().setFreshInstall(false);

    if(!performStartupChecks && PQSettings::get().getVersion() != QString::fromStdString(VERSION))
        performStartupChecks = true;

// only one of them will be defined at a time
#if defined(GRAPHICSMAGICK) || defined(IMAGEMAGICK)
    // Initialise Magick as early as possible
    Magick::InitializeMagick(*argv);
#endif

#ifdef DEVIL
    ilInit();
#endif

#ifdef FREEIMAGE
    FreeImage_Initialise();
#endif

    QQmlApplicationEngine engine;
    app.qmlEngine = &engine;

    const QUrl url(QStringLiteral("qrc:/mainwindow.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);

    // we only do startup checks on updates and new installs
    if(performStartupChecks)
        PQStartup::PQStartup();

    qmlRegisterType<PQHandlingFileDialog>("PQHandlingFileDialog", 1, 0, "PQHandlingFileDialog");
    qmlRegisterType<PQHandlingGeneral>("PQHandlingGeneral", 1, 0, "PQHandlingGeneral");
    qmlRegisterType<PQHandlingShortcuts>("PQHandlingShortcuts", 1, 0, "PQHandlingShortcuts");
    qmlRegisterType<PQHandlingFileDir>("PQHandlingFileDir", 1, 0, "PQHandlingFileDir");
    qmlRegisterType<PQHandlingManipulation>("PQHandlingManipulation", 1, 0, "PQHandlingManipulation");
    qmlRegisterType<PQLocalisation>("PQLocalisation", 1, 0, "PQLocalisation");
    qmlRegisterType<PQImageProperties>("PQImageProperties", 1, 0, "PQImageProperties");
    qmlRegisterType<PQFileWatcher>("PQFileWatcher", 1, 0, "PQFileWatcher");
    qmlRegisterType<PQWindowGeometry>("PQWindowGeometry", 1, 0, "PQWindowGeometry");
    qmlRegisterType<PQMetaData>("PQCppMetaData", 1, 0, "PQCppMetaData");
    qmlRegisterType<PQHandlingShareImgur>("PQHandlingShareImgur", 1, 0, "PQHandlingShareImgur");
    qmlRegisterType<PQHandlingWallpaper>("PQHandlingWallpaper", 1, 0, "PQHandlingWallpaper");
    qmlRegisterType<PQHandlingFaceTags>("PQHandlingFaceTags", 1, 0, "PQHandlingFaceTags");
    qmlRegisterType<PQSystemTrayIcon>("PQSystemTrayIcon", 1, 0, "PQSystemTrayIcon");
    qmlRegisterType<PQHandlingExternal>("PQHandlingExternal", 1, 0, "PQHandlingExternal");

    engine.rootContext()->setContextProperty("PQSettings", &PQSettings::get());
    engine.rootContext()->setContextProperty("PQCppVariables", &PQVariables::get());
    engine.rootContext()->setContextProperty("PQImageFormats", &PQImageFormats::get());
    engine.rootContext()->setContextProperty("PQKeyPressChecker", &PQKeyPressChecker::get());

    qmlRegisterType<PQFileFolderModel>("PQFileFolderModel", 1, 0, "PQFileFolderModel");

    engine.addImageProvider("icon",new PQImageProviderIcon);
    engine.addImageProvider("thumb",new PQAsyncImageProviderThumb);
    engine.addImageProvider("full",new PQImageProviderFull);
    engine.addImageProvider("hist",new PQImageProviderHistogram);

    engine.load(url);

    app.qmlWindowAddresses.push_back(engine.rootObjects().at(0));

    int ret = app.exec();

#ifdef FREEIMAGE
    FreeImage_DeInitialise();
#endif

    return ret;

}
