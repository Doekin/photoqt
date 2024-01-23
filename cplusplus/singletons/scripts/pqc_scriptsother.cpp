/**************************************************************************
 **                                                                      **
 ** Copyright (C) 2011-2024 Lukas Spies                                  **
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

#include <scripts/pqc_scriptsother.h>
#include <pqc_notify.h>
#include <pqc_printtabimageoptions.h>
#include <pqc_printtabimagepositiontile.h>
#include <pqc_loadimage.h>

#include <sstream>
#include <QMessageBox>
#include <QDateTime>
#include <QApplication>
#include <QScreen>
#include <QDir>
#include <QPrinter>
#include <QPrintDialog>
#include <QPainter>
#include <QColorDialog>

PQCScriptsOther::PQCScriptsOther() {}

PQCScriptsOther::~PQCScriptsOther() {}

qint64 PQCScriptsOther::getTimestamp() {
    return QDateTime::currentMSecsSinceEpoch();
}

bool PQCScriptsOther::takeScreenshots() {
    qDebug() << "";
    for(int i = 0; i < QApplication::screens().count(); ++i) {
        QScreen *screen = QApplication::screens().at(i);
        QRect r = screen->geometry();
        QPixmap pix = screen->grabWindow(0,r.x(),r.y(),r.width(),r.height());
        if(!pix.save(QDir::tempPath() + QString("/photoqt_screenshot_%1.jpg").arg(i))) {
            qWarning() << "Error taking screenshot for screen #" << i;
            return false;
        }
    }
    return true;
}

void PQCScriptsOther::deleteScreenshots() {
    qDebug() << "";
    int count = 0;
    while(true) {
        QFile file(QDir::tempPath() + QString("/photoqt_screenshot_%1.jpg").arg(count));
        if(file.exists())
            file.remove();
        else
            break;
    }
}

QString PQCScriptsOther::getUniqueId() {

    qDebug() << "";

    return QString::number(QDateTime::currentMSecsSinceEpoch());

}

void PQCScriptsOther::printFile(QString filename) {

    PQCNotify::get().setModalFileDialogOpen(true);

    QSettings settings;

    // Get the image
    QImage img;
    QSize orig;
    PQCLoadImage::get().load(filename, QSize(), orig, img);

    // show the printer dialog with additional options tab
    QPrinter printer(QPrinter::HighResolution);

    // get the starting output filename (directory stored, filename based on image filename)
    QFileInfo info(filename);
    printer.setOutputFileName(QString("%1/%2.pdf").arg(info.absolutePath(), info.baseName()));

    // the additional image options tab
    PQCPrintTabImageOptions *imageoptions = new PQCPrintTabImageOptions(printer.pageLayout().pageSize().rect(QPageSize::Millimeter).size());

    // The print dialog
    QPrintDialog printDialog(&printer, nullptr);
    printDialog.setWindowTitle(tr("Print"));
    printDialog.setOptionTabs({imageoptions});
    if(printDialog.exec() != QDialog::Accepted) {
        delete imageoptions;
        PQCNotify::get().setModalFileDialogOpen(false);
        return;
    }

    // store all the settings
    imageoptions->storeNewSettings();

    // create a painter and create handles for some much used properties
    QPainter painter(&printer);
    QRect viewport = painter.viewport();
    QSize imgsize = img.size();

    // scale the image to fit into the page
    if(imageoptions->getScalingFitToPage()) {

        bool imageBiggerThanPaper = imgsize.width() > viewport.width() || imgsize.height() > viewport.height();

        if (imageBiggerThanPaper || imageoptions->getScalingEnlargeSmaller())
            imgsize.scale(viewport.size(), Qt::KeepAspectRatio);

        // scale the image to a certain width/height
    } else if(imageoptions->getScalingScaleTo()) {

        double wImg = imageoptions->getScalingScaleToSize().width();
        double hImg = imageoptions->getScalingScaleToSize().height();
        imgsize.setWidth(int(wImg * printer.resolution()));
        imgsize.setHeight(int(hImg * printer.resolution()));

        // do not scale the image
    } else {

        const double INCHES_PER_METER = 100. / 2.54;
        const int dpmX = img.dotsPerMeterX();
        const int dpmY = img.dotsPerMeterY();

        if (dpmX > 0 && dpmY > 0) {
            double wImg = double(imgsize.width()) / double(dpmX) * INCHES_PER_METER;
            double hImg = double(imgsize.height()) / double(dpmY) * INCHES_PER_METER;
            imgsize.setWidth(int(wImg * printer.resolution()));
            imgsize.setHeight(int(hImg * printer.resolution()));
        }

    }


    // get the image position the user selected in the options tab
    int imgPos = imageoptions->getImagePosition();

    // we are done with this, so delete
    delete imageoptions;

    // the final position of the image on the page is stored in these
    // these default values are horizontal left and vertical top
    int x = 0;
    int y = 0;

    // horizontal center
    if((imgPos-1)%3 == 0)
        x = (viewport.width()-imgsize.width())/2;
    // horizontal right
    else if((imgPos+1)%3 == 0)
        x = viewport.width()-imgsize.width();

    // vertical center
    if(imgPos > 2 && imgPos < 6)
        y = (viewport.height()-imgsize.height())/2;
    // vertical bottom
    else if(imgPos > 5)
        y = viewport.height()-imgsize.height();

    // set properties to painter
    painter.setViewport(x, y, imgsize.width(), imgsize.height());
    painter.setWindow(img.rect());

    // and draw final image
    painter.drawImage(0, 0, img);

    // done!
    painter.end();

    PQCNotify::get().setModalFileDialogOpen(false);

}

int PQCScriptsOther::getCurrentScreen(QPoint pos) {
    for(int i = 0; i < QApplication::screens().count(); ++i) {
        QScreen *screen = QApplication::screens().at(i);
        QRect r = screen->geometry();
        if(r.x() < pos.x() && r.x()+r.width() > pos.x() &&
            r.y() < pos.y() && r.y()+r.height() > pos.y())
            return i;
    }
    return 0;
}

QVariantList PQCScriptsOther::convertHexToRgba(QString hex) {

    qDebug() << "args: hex =" << hex;

    int r,g,b,a;

    // no transparency
    if(hex.length() == 7) {

        a = 255;
        r = hex.sliced(1, 2).toUInt(nullptr, 16);
        g = hex.sliced(3, 2).toUInt(nullptr, 16);
        b = hex.sliced(5, 2).toUInt(nullptr, 16);

    } else {

        a = hex.sliced(1, 2).toUInt(nullptr, 16);
        r = hex.sliced(3, 2).toUInt(nullptr, 16);
        g = hex.sliced(5, 2).toUInt(nullptr, 16);
        b = hex.sliced(7, 2).toUInt(nullptr, 16);

    }

    return QVariantList() << r << g << b << a;

}

QString PQCScriptsOther::convertRgbaToHex(QVariantList rgba) {

    qDebug() << "args: rgba =" << rgba;

    std::stringstream ss;
    ss << "#";
    ss << std::hex << (rgba[3].toInt() << 24 | rgba[0].toInt() << 16 | rgba[1].toInt() << 8 | rgba[2].toInt());
    return QString::fromStdString(ss.str());

}

QVariantList PQCScriptsOther::selectColor(QVariantList def) {

    QVariantList ret;

    QColor col = QColorDialog::getColor(qRgba(def[0].toInt(), def[1].toInt(), def[2].toInt(), def[3].toInt()), nullptr, "Select color", QColorDialog::ShowAlphaChannel);

    if(col == QColor::Invalid)
        return ret;

    ret.push_back(col.red());
    ret.push_back(col.green());
    ret.push_back(col.blue());
    ret.push_back(col.alpha());

    return ret;

}

void PQCScriptsOther::setPointingHandCursor() {

    if(qApp->overrideCursor() != nullptr)
        qApp->restoreOverrideCursor();
    qApp->setOverrideCursor(Qt::PointingHandCursor);

}

void PQCScriptsOther::restoreOverrideCursor() {

    qApp->restoreOverrideCursor();

}
