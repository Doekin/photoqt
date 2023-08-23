#ifndef PQCSCRIPTSOTHER_H
#define PQCSCRIPTSOTHER_H

#include <QObject>

class PQCScriptsOther : public QObject {

    Q_OBJECT

public:
    static PQCScriptsOther& get() {
        static PQCScriptsOther instance;
        return instance;
    }
    ~PQCScriptsOther();

    PQCScriptsOther(PQCScriptsOther const&)     = delete;
    void operator=(PQCScriptsOther const&) = delete;

    Q_INVOKABLE qint64 getTimestamp();

private:
    PQCScriptsOther();

};

#endif
