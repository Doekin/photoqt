#include <scripts/pqc_scriptschromecast.h>
#include <pqc_localhttpserver.h>
#include <pqc_loadimage.h>
#include <pqc_settings.h>
#include <pqc_filefoldermodel.h>

#include <QVariantList>
#include <QFile>
#include <QDir>
#include <QNetworkInterface>
#include <QProcess>
#include <QImage>
#include <QSize>
#include <QPainter>

PQCScriptsChromeCast::PQCScriptsChromeCast() {

    m_connected = false;
    m_curDeviceName = "";

    server = new PQCLocalHttpServer;

    procDiscovery = new QProcess;
    procCast = new QProcess;
    procDisconnect = new QProcess;

    connect(procDiscovery, &QProcess::readyReadStandardOutput, this, &PQCScriptsChromeCast::readDiscoveryOutput);

}

PQCScriptsChromeCast::~PQCScriptsChromeCast() {

    disconnect();

    QFile::remove(QString("%1/chromecast_discovery.py").arg(QDir::tempPath()));
    QFile::remove(QString("%1/chromecast_cast.py").arg(QDir::tempPath()));
    QFile::remove(QString("%1/chromecast_disconnect.py").arg(QDir::tempPath()));

    server->deleteLater();
    procDiscovery->deleteLater();
    procCast->deleteLater();
    procDisconnect->deleteLater();

}

/************************************************************/

void PQCScriptsChromeCast::setAvailableDevices(QVariantList val) {
    if(val != m_availableDevices) {
        m_availableDevices = val;
        Q_EMIT availableDevicesChanged();
    }
}

QVariantList PQCScriptsChromeCast::getAvailableDevices() {
    return m_availableDevices;
}

void PQCScriptsChromeCast::setInDiscovery(bool val) {
    if(m_inDiscovery != val) {
        m_inDiscovery = val;
        Q_EMIT inDiscoveryChanged();
    }
}

int PQCScriptsChromeCast::getInDiscovery() {
    return m_inDiscovery;
}

void PQCScriptsChromeCast::setConnected(bool val) {
    if(m_connected != val) {
        m_connected = val;
        Q_EMIT connectedChanged();
    }
}

int PQCScriptsChromeCast::getConnected() {
    return m_connected;
}

void PQCScriptsChromeCast::setCurDeviceName(QString val) {
    if(m_curDeviceName != val) {
        m_curDeviceName = val;
        Q_EMIT curDeviceNameChanged();
    }
}

QString PQCScriptsChromeCast::getCurDeviceName() {
    return m_curDeviceName;
}

/************************************************************/

void PQCScriptsChromeCast::readDiscoveryOutput() {

    qDebug() << "";

    QString str = procDiscovery->readAll();

    m_availableDevices.clear();

    if(str.trimmed() != "x") {

        QStringList p = str.split("\n");
        for(int i = 0; i < p.length()/2; ++i) {
            QVariantList l;
            l.push_back(p[2*i].trimmed());
            l.push_back(p[2*i+1].trimmed());
            m_availableDevices.push_back(l);
        }

    }

    qWarning() << m_availableDevices;

    setInDiscovery(false);
    Q_EMIT availableDevicesChanged();

}

bool PQCScriptsChromeCast::startDiscovery() {

    qDebug() << "";

    setInDiscovery(true);

    const QString tmpPath = QString("%1/chromecast_discovery.py").arg(QDir::tempPath());

    QFile::remove(tmpPath);
    if(!QFile::copy(":/chromecast_discovery.py", tmpPath)) {
        qWarning() << "ERROR preparing discovery python script, chromecast not available";
        setInDiscovery(false);
        return false;
    }

    procDiscovery->start("python", {tmpPath});

    return true;

}

bool PQCScriptsChromeCast::connectToDevice(int index) {

    qDebug() << "args: index =" << index;

    if(index >= m_availableDevices.length())
        return false;

    m_selectedDevice = index;

    setCurDeviceName(m_availableDevices[m_selectedDevice].toList()[0].toString());
    setConnected(true);

    if(PQCFileFolderModel::get().getCountMainView() > 0 && PQCFileFolderModel::get().getCurrentIndex() > -1)
        return castImage(PQCFileFolderModel::get().getCurrentFile());
    return castImage("");


}

bool PQCScriptsChromeCast::castImage(QString filename) {

    qDebug() << "args: filename =" << filename;

    if(m_curDeviceName == "") {
        qDebug() << "Not connected to chromecast device.";
        return false;
    }

    procCast->kill();

    if(!server->isRunning()) {

        serverPort = server->start();

        // find local ip address
        localIP = "";
        const auto addresses = QNetworkInterface::allAddresses();
        for(const auto &entry : addresses) {
            if(!entry.isLoopback() &&  entry.protocol() == QAbstractSocket::IPv4Protocol) {
                const QString ip = entry.toString();
                if(ip != "127.0.0.1" && ip != "localhost") {
                    localIP = ip;
                    break;
                }
            }
        }

    }


    // request image

    // PhotoQt logo
    if(filename.isNull() || filename == "") {

        QImage img(":/other/logo_chromecast.jpg");
        if(!img.save(QString("%1/photoqtchromecast.jpg").arg(QDir::tempPath()), nullptr, 100)) {
            qWarning() << "Failed to save default image.";
            return false;
        }

    } else {

        QImage img;
        QSize orig;
        PQCLoadImage::get().load(filename, QSize(1920,1080), orig, img);

        if(img.height() > 1080)
            img = img.scaledToHeight(1080);

        // if image is smaller than display and is not to be fit to window size
        if(!PQCSettings::get()["imageviewFitInWindow"].toBool() && (img.width() < 1920 || img.height() < 1080)) {
            QImage ret(1920, 1080, QImage::Format_ARGB32);
            ret.fill(Qt::black);
            QPainter painter(&ret);
            painter.drawImage((1920-img.width())/2, (1080-img.height())/2, img);
            painter.end();
            if(!ret.save(QString("%1/photoqtchromecast.jpg").arg(QDir::tempPath()), nullptr, 100)) {
                qWarning() << "Failed to save image:" << filename;
                return false;
            }
        } else {
            if(!img.save(QString("%1/photoqtchromecast.jpg").arg(QDir::tempPath()), nullptr, 100)) {
                qWarning() << "Failed to save image:" << filename;
                return false;
            }
        }
    }

    const QString pyPath = QString("%1/chromecast_cast.py").arg(QDir::tempPath());
    QFile::remove(pyPath);
    if(!QFile::copy(":/chromecast_cast.py", pyPath)) {
        qWarning() << "ERROR preparing cast python script, chromecast not available";
        return false;
    }

    procCast->start("python", {pyPath, m_curDeviceName, localIP, QString::number(serverPort)});

    return true;

}

bool PQCScriptsChromeCast::disconnect() {

    qDebug() << "";

    if(!m_connected)
        return true;

    const QString pyPath = QString("%1/chromecast_disconnect.py").arg(QDir::tempPath());
    QFile::remove(pyPath);
    if(!QFile::copy(":/chromecast_disconnect.py", pyPath)) {
        qWarning() << "ERROR preparing disconnect python script, chromecast wont properly shut down";
        return false;
    }

    server->stop();

    procDisconnect->start("python", {pyPath, m_curDeviceName, localIP, QString::number(serverPort)});

    setCurDeviceName("");
    setConnected(false);

    return true;

}
