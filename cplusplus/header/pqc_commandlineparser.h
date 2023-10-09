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

#ifndef PQCCOMMANDLINEPARSER_H
#define PQCCOMMANDLINEPARSER_H

#include <QObject>
#include <QCommandLineParser>
#include <QApplication>
#include <QTranslator>
#include <QFile>
#include <iostream>

enum PQCCommandLineResult {
    PQCCommandLineNothing = 0,
    PQCCommandLineFile = 1,
    PQCCommandLineOpen = 2,
    PQCCommandLineShow = 4,
    PQCCommandLineHide = 8,
    PQCCommandLineToggle = 16,
    PQCCommandLineThumbs = 32,
    PQCCommandLineNoThumbs = 64,
    PQCCommandLineStartInTray = 128,
    PQCCommandLineStandalone = 256,
    PQCCommandLineDebug = 512,
    PQCCommandLineNoDebug = 1024,
    PQCCommandLineExport = 2048,
    PQCCommandLineImport = 4096,
    PQShortcutSequence = 8192,
    PQCCommandLineEnableTray = 16384,
    PQCCommandLineDisableTray = 32768,
    PQCCommandLineCheckConfig = 65536,
    PQCCommandLineResetConfig = 131072,
    PQCCommandLineShowInfo = 262144
};
inline PQCCommandLineResult operator|(PQCCommandLineResult a, PQCCommandLineResult b) {
    return static_cast<PQCCommandLineResult>(static_cast<int>(a) | static_cast<int>(b));
}

class PQCCommandLineParser : public QObject, public QCommandLineParser {

    Q_OBJECT

public:

    explicit PQCCommandLineParser(QApplication &app, QObject *parent = nullptr);
    ~PQCCommandLineParser();
    PQCCommandLineResult getResult();

    QString exportFileName;
    QString importFileName;
    QString filename;
    QString shortcutSequence;

private:
    QTranslator trans;

};


#endif // PQCCommandLINEPARSER_H
