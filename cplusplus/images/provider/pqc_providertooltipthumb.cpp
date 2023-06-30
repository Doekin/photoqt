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

#include <pqc_providertooltipthumb.h>
#include <pqc_settings.h>
#include <pqc_configfiles.h>
#include <pqc_loadimage.h>
#include <pqc_providerthumb.h>
#include <QPainter>

QQuickImageResponse *PQCAsyncImageProviderTooltipThumb::requestImageResponse(const QString &url, const QSize &requestedSize) {

    PQCAsyncImageResponseTooltipThumb *response = new PQCAsyncImageResponseTooltipThumb(url, ((requestedSize.isValid() && !requestedSize.isNull()) ? requestedSize : QSize(256,256)));
    QThreadPool::globalInstance()->setMaxThreadCount(qMax(1,PQCSettings::get()["thumbnailsMaxNumberThreads"].toInt()));
    pool.start(response);
    return response;
}

PQCAsyncImageResponseTooltipThumb::PQCAsyncImageResponseTooltipThumb(const QString &url, const QSize &requestedSize) : m_requestedSize(requestedSize) {
    m_url = url;
    setAutoDelete(false);
    loader = new PQCAsyncImageResponseThumb(url, requestedSize);
}

PQCAsyncImageResponseTooltipThumb::~PQCAsyncImageResponseTooltipThumb() {
    delete loader;
}

QQuickTextureFactory *PQCAsyncImageResponseTooltipThumb::textureFactory() const {
    return QQuickTextureFactory::textureFactoryForImage(m_image);
}

void PQCAsyncImageResponseTooltipThumb::run() {
    loadImage();
}

void PQCAsyncImageResponseTooltipThumb::loadImage() {

    qDebug() << "";

    loader->loadImage();

    m_image = QImage(m_requestedSize.width(), std::max(m_requestedSize.height()/2, std::min(m_requestedSize.height(), loader->m_image.height())), QImage::Format_ARGB32);
    m_image.fill(QColor::fromRgba(qRgba(255,255,255,16)));
    QPainter painter(&m_image);
    painter.drawImage((m_requestedSize.width()-loader->m_image.width())/2, (m_image.height()-loader->m_image.height())/2, loader->m_image);
    painter.end();

    // aaaaand done!
    Q_EMIT finished();

}
