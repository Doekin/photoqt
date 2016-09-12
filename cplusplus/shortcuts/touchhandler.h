#ifndef TOUCHHANDLER_H
#define TOUCHHANDLER_H

#include <QtDebug>
#include <QTouchEvent>
#include <QTime>
#include <cmath>
#include <QTimer>

class TouchHandler : public QObject {

	Q_OBJECT

public:
	explicit TouchHandler(QObject *parent = 0) : QObject(parent) {
		touchPath.clear();
		touchPathCenterPoints.clear();
		touchPathAverageRadius.clear();
		threshold = 100;
		numFingers = 0;
		amDetecting = false;
	}
	~TouchHandler() {}

	// Handle touch event -> call respective handler function
	bool handle(QEvent *e) {
		if(e->type() == QEvent::TouchBegin) {
			amDetecting = true;
			touchStarted((QTouchEvent*)e);
			return true;
		} else if(e->type() == QEvent::TouchUpdate) {
			touchUpdated((QTouchEvent*)e);
			return true;
		} else if(e->type() == QEvent::TouchEnd) {
			touchEnded((QTouchEvent*)e);
//			amDetecting = false;
			QTimer::singleShot(100, this, SLOT(setDetectingVarToFalse()));
			return true;
		}
		return amDetecting;
	}

	bool amDetectingTouchScreenEvent() { return amDetecting; }

private slots:
	void setDetectingVarToFalse() { amDetecting = false; }

private:

	// Some variables handling the movement
	QStringList touchPath;
	QList<QPoint> touchPathCenterPoints;
	QList<int> touchPathAverageRadius;
	int threshold;
	int numFingers;
	qint64 startTime;
	bool amDetecting;

	// A touch has been started -> reset variables
	void touchStarted(QTouchEvent *e) {

		emit setImageInteractiveMode(false);

		// Reset variables
		numFingers = e->touchPoints().count();
		touchPath.clear();
		touchPathCenterPoints.clear();
		touchPathAverageRadius.clear();

		// Calculate average center point
		qreal sum_x = 0;
		qreal sum_y = 0;
		bool passedFirst = false;
		QPointF firstPt = e->touchPoints().first().pos();
		double sum_radius = 0;
		foreach(QTouchEvent::TouchPoint pt, e->touchPoints()) {
			sum_x += pt.pos().x();
			sum_y += pt.pos().y();
			if(passedFirst)
				sum_radius += std::sqrt(std::pow(pt.pos().x()-firstPt.x(),2) + std::pow(pt.pos().y()-firstPt.y(),2));
			passedFirst = true;
		}
		int len = e->touchPoints().length();
		touchPathCenterPoints.append(QPoint(sum_x/(double)len, sum_y/(double)len));
		touchPathAverageRadius.append(len > 1 ? sum_radius/(double)(len-1) : 0);

		startTime = QDateTime::currentMSecsSinceEpoch();

		qDebug() << "touch started:" << touchPathCenterPoints.last() << " - " <<touchPathAverageRadius.last();

	}

	// Update to touch
	void touchUpdated(QTouchEvent *e) {
/*
		// Get current touch points
		QList<QTouchEvent::TouchPoint> cur = e->touchPoints();

		QList<int> dx;
		QList<int> dy;

		// We check each detected finger movements and the smallest difference (most likely) corresponds to the moved finger
		for(int i = 0; i < cur.count(); ++i) {

			// Append difference in x and y to list
			dx.append(cur[i].pos().x()-touchPathPts.last().pos().x());
			dy.append(cur[i].pos().y()-touchPathPts.last().pos().y());

		}

		// Each one has to be counted to fingers detected
		// -> only if all fingers are still 'threshold' away
		// from 'master' finger
		int detectedRight = 0;
		int detectedLeft = 0;
		int detectedUp = 0;
		int detectedDown = 0;

		foreach(int d, dx) {
			if(d > threshold)
				++detectedRight;
			else if(d < -threshold)
				++detectedLeft;
		}

		foreach(int d, dy) {
			if(d > threshold)
				++detectedDown;
			else if(d < -threshold)
				++detectedUp;
		}

		bool upd = false;

		if(detectedRight == cur.count()) {
			upd = true;
			if(touchPath.length() == 0 || touchPath.last() != "E")
				touchPath.append("E");
		}
		if(detectedLeft == cur.count()) {
			upd = true;
			if(touchPath.length() == 0 || touchPath.last() != "W")
				touchPath.append("W");
		}
		if(detectedDown == cur.count()) {
			upd = true;
			if(touchPath.length() == 0 || touchPath.last() != "S")
				touchPath.append("S");
		}
		if(detectedUp == cur.count()) {
			upd = true;
			if(touchPath.length() == 0 || touchPath.last() != "N")
				touchPath.append("N");
		}

		// Store new touch point
		if(upd)
			touchPathPts.append(cur);

		// Detect how many fingers
		// When releasing fingers, Qt might claim fewer fingers are used (as usually not all finger
		// are released at EXACTLY the same time), so we stick to the largest value
		numFingers = qMax(numFingers,cur.count());
*/
	}

	// A gesture has been finished
	void touchEnded(QTouchEvent *) {
/*		emit setImageInteractiveMode(true);
		qint64 endTime = QDateTime::currentMSecsSinceEpoch();
		emit receivedTouchEvent(touchPathPts.first().pos(), touchPathPts.last().pos(), endTime-startTime, numFingers, touchPath);*/
	}

signals:
	void receivedTouchEvent(QPointF start, QPointF end, qint64 duration, int numFingers, QStringList gesture);
	void setImageInteractiveMode(bool enabled);

};

#endif // TOUCHHANDLER_H
