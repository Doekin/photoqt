#include "mainhandler.h"

MainHandler::MainHandler(bool verbose, QObject *parent) : QObject(parent) {

    // holding some variables of the current session
    variables = new Variables;
    variables->verbose = verbose;
    permanentSettings = new Settings;

    overrideCursorSet = false;

    // Perform some startup checks/tasks
    performSomeStartupChecks();

    // Find and load the right translation file
    loadTranslation();

    // Register the qml types. This need to happen BEFORE creating the QQmlApplicationEngine!.
    registerQmlTypes();

}

// Performs some initial startup checks to make sure everything is in order
int MainHandler::performSomeStartupChecks() {

    StartupCheck::Migration::migrateIfNecessary(variables->verbose);
    int update = StartupCheck::UpdateCheck::checkForUpdateInstall(variables->verbose, permanentSettings);
    StartupCheck::Screenshots::getAndStore(variables->verbose);
    StartupCheck::StartInTray::makeSureSettingsReflectTrayStartupSetting(variables->verbose, variables->startintray, permanentSettings);
    StartupCheck::Thumbnails::checkThumbnailsDatabase(update, variables->nothumbs, permanentSettings, variables->verbose);
    StartupCheck::FileFormats::checkForDefaultSettingsFileAndReturnWhetherDefaultsAreToBeSet(variables->verbose);

    return update;

}

// Load the right translation file
void MainHandler::loadTranslation() {

    StartupCheck::Localisation::loadTranslation(variables->verbose, permanentSettings, &trans);

}

// store the engine and the connected object
void MainHandler::setEngine(QQmlApplicationEngine *engine) {

    this->engine = engine;

}

// Create a handler to the engine's object and connect to its signals
void MainHandler::setObjectAndConnect() {

    this->object = engine->rootObjects()[0];

    connect(object, SIGNAL(verboseMessage(QString,QString)), this, SLOT(qmlVerboseMessage(QString,QString)));
    connect(object, SIGNAL(setOverrideCursor()), this, SLOT(setOverrideCursor()));
    connect(object, SIGNAL(restoreOverrideCursor()), this, SLOT(restoreOverrideCursor()));

}

// Add settings/scripts access to QML
void MainHandler::registerQmlTypes() {
    qmlRegisterType<Settings>("PSettings", 1, 0, "PSettings");
    qmlRegisterType<FileFormats>("PFileFormats", 1, 0, "PFileFormats");
    qmlRegisterType<GetMetaData>("PGetMetaData", 1, 0, "PGetMetaData");
    qmlRegisterType<GetAndDoStuff>("PGetAndDoStuff", 1, 0, "PGetAndDoStuff");
    qmlRegisterType<ToolTip>("PToolTip", 1, 0, "PToolTip");
    qmlRegisterType<Colour>("PColour", 1, 0, "PColour");
    qmlRegisterType<ImageWatch>("PImageWatch", 1, 0, "PImageWatch");
    qmlRegisterType<ShareOnline::Imgur>("PImgur", 1, 0, "PImgur");
    qmlRegisterType<Clipboard>("PClipboard", 1, 0, "PClipboard");
    qmlRegisterType<ShortcutsNotifier>("PShortcutsNotifier", 1, 0, "PShortcutsNotifier");
}

// Add image providers to QML
void MainHandler::addImageProvider() {
    this->engine->addImageProvider("thumb",new ImageProviderThumbnail);
    this->engine->addImageProvider("full",new ImageProviderFull);
    this->engine->addImageProvider("icon",new ImageProviderIcon);
    this->engine->addImageProvider("empty", new ImageProviderEmpty);
    this->engine->addImageProvider("hist", new ImageProviderHistogram);
}

// Output any QML debug messages if verbose mode is enabled
void MainHandler::qmlVerboseMessage(QString loc, QString msg) {
    if(variables->verbose)
        LOG << CURDATE << "[QML] " << loc.toStdString() << ": " << msg.toStdString() << NL;
}

// Remote controlling
void MainHandler::remoteAction(QString cmd) {

    if(variables->verbose)
        LOG << CURDATE << "remoteAction(): " << cmd.toStdString() << NL;

    if(cmd == "open") {

//        if(variables->verbose)
//            LOG << CURDATE << "remoteAction(): Open file" << NL;
//        if(!this->isVisible()) {
//            // Get screenshots
//            for(int i = 0; i < QGuiApplication::screens().count(); ++i) {
//                QScreen *screen = QGuiApplication::screens().at(i);
//                QRect r = screen->geometry();
//                QPixmap pix = screen->grabWindow(0,r.x(),r.y(),r.width(),r.height());
//                pix.save(QDir::tempPath() + QString("/photoqt_screenshot_%1.jpg").arg(i));
//            }
//            updateWindowGeometry();
//            this->raise();
//            this->requestActivate();
//        }

//        QMetaObject::invokeMethod(object, "openFile");

    } else if(cmd == "nothumbs") {

//        if(variables->verbose)
//            LOG << CURDATE << "remoteAction(): Disable thumbnails" << NL;
//        settingsPermanent->thumbnailDisable = true;
//        settingsPermanent->thumbnailDisableChanged(settingsPermanent->thumbnailDisable);

    } else if(cmd == "thumbs") {

//        if(variables->verbose)
//            LOG << CURDATE << "remoteAction(): Enable thumbnails" << NL;
//        settingsPermanent->thumbnailDisable = true;
//        settingsPermanent->thumbnailDisableChanged(settingsPermanent->thumbnailDisable);

    } else if(cmd == "hide" || (cmd == "toggle"/* && this->isVisible()*/)) {

//        if(variables->verbose)
//            LOG << CURDATE << "remoteAction(): Hiding" << NL;
//        if(settingsPermanent->trayicon != 1) {
//            settingsPermanent->trayicon = 1;
//            settingsPermanent->trayiconChanged(settingsPermanent->trayicon);
//        }
//        QMetaObject::invokeMethod(object, "hideOpenFile");
//        this->hide();

    } else if(cmd.startsWith("show") || (cmd == "toggle"/* && !this->isVisible()*/)) {

//        if(variables->verbose)
//            LOG << CURDATE << "remoteAction(): Showing" << NL;

//        // The same code can be found at the end of main.cpp
//        if(!this->isVisible()) {
//            // Get screenshots
//            for(int i = 0; i < QGuiApplication::screens().count(); ++i) {
//                QScreen *screen = QGuiApplication::screens().at(i);
//                QRect r = screen->geometry();
//                QPixmap pix = screen->grabWindow(0,r.x(),r.y(),r.width(),r.height());
//                pix.save(QDir::tempPath() + QString("/photoqt_screenshot_%1.jpg").arg(i));
//            }
//            updateWindowGeometry();
//        }
//        this->raise();
//        this->requestActivate();

//        if(variables->currentDir == "" && cmd != "show_noopen")
//            QMetaObject::invokeMethod(object, "openFile");

    } else if(cmd.startsWith("::file::")) {

//        if(variables->verbose)
//            LOG << CURDATE << "remoteAction(): Opening passed-on file" << NL;
//        QMetaObject::invokeMethod(object, "hideOpenFile");
//        handleOpenFileEvent(cmd.remove(0,8));

    }


}
