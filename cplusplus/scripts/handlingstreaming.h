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

#ifndef PQHANDLINGSTREAMING_H
#define PQHANDLINGSTREAMING_H

#include <QObject>
#include <QJSValue>
#include <QJSEngine>
#include <QtConcurrent/QtConcurrent>
#include "httpserver.h"
#include "../python/pqpy.h"
#include "../logger.h"
#include "../imageprovider/imageproviderfull.h"

class PQHandlingStreaming : public QObject {

    Q_OBJECT

public:
    PQHandlingStreaming(QObject *parent = nullptr);
    ~PQHandlingStreaming();

    Q_INVOKABLE void getListOfChromecastDevices();
    static QVariantList _getListOfChromecastDevices();

    Q_INVOKABLE bool connectToDevice(QString friendlyname);
    Q_INVOKABLE void streamOnDevice(QString src);

    Q_INVOKABLE void cancelScanForChromecast();

    QFutureWatcher<QVariantList> *watcher;

Q_SIGNALS:
    void updatedListChromecast(QVariantList devices);
    void cancelScan();

private:
    QString chromecastModuleName;
    QString localIP;

    PQPyObject chromecastServices;
    PQPyObject chromecastBrowser;
    PQPyObject chromecastMediaController;

    PQImageProviderFull *imageprovider;

    PQHttpServer *server;
    int serverPort;

};


#endif // PQHANDLINGSTREAMING_H
