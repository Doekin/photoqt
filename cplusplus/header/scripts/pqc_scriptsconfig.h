#ifndef PQCSCRIPTS_H
#define PQCSCRIPTS_H

#include <QObject>

class PQCScriptsConfig : public QObject {

    Q_OBJECT

public:
    static PQCScriptsConfig& get() {
        static PQCScriptsConfig instance;
        return instance;
    }
    ~PQCScriptsConfig();

    PQCScriptsConfig(PQCScriptsConfig const&)     = delete;
    void operator=(PQCScriptsConfig const&) = delete;

    Q_INVOKABLE static QString getConfigInfo(bool formatHTML = false);
    Q_INVOKABLE static bool exportConfigTo(QString path);
    Q_INVOKABLE static bool importConfigFrom(QString path, QString importToFolder = "");
    Q_INVOKABLE bool amIOnWindows();
    Q_INVOKABLE bool isChromecastEnabled();
    Q_INVOKABLE bool isLocationSupportEnabled();
    Q_INVOKABLE bool isGraphicsMagickSupportEnabled();
    Q_INVOKABLE bool isImageMagickSupportEnabled();
    Q_INVOKABLE bool isPugixmlSupportEnabled();
    Q_INVOKABLE bool isQtAtLeast6_4();

private:
    PQCScriptsConfig();

};

#endif
