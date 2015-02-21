#ifndef GETIMAGEINFO_H
#define GETIMAGEINFO_H

#include <QImageReader>
#include <QFileInfo>
#include <GraphicsMagick/Magick++.h>
#include <QSettings>
#include <QCursor>

class GetStuff : public QObject {

	Q_OBJECT

public:
	explicit GetStuff(QObject *parent = 0);

	Q_INVOKABLE bool isImageAnimated(QString path);
	Q_INVOKABLE QSize getImageSize(QString path);

	Q_INVOKABLE QPoint getCursorPos();

	Q_INVOKABLE QString removePathFromFilename(QString path);

private:
	QImageReader reader;
	QSettings *settings;

};


#endif // GETIMAGEINFO_H
