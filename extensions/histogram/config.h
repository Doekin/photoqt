#include "../pqc_configtemplate.h"

class PQCExtensionHistogram : public PQCExtensionConfig {

public:
    PQCExtensionHistogram() {

        id = "histogram";
        allowPopout = true;
        isModal = false;

        defaultPopoutWindowSize = QSize(300,200);
        minimumRequiredWindowSize = QSize(500,350);

        qmlBaseName = "PQHistogram";

        popoutSettingName = "HistogramPopout";

        shortcutsActions = {
            {"__histogram",
             //: Description of shortcut action
             QApplication::translate("settingsmanager", "Show Histogram"),
             "", // no default shortcut set
             "show", "histogram"}
        };

        settings = {
            {"Histogram",         "extensions", "bool",   "0"},
            {"HistogramPosition", "extensions", "point",  "100,100"},
            {"HistogramSize",     "extensions", "size",   "300,200"},
            {"HistogramVersion",  "extensions", "string", "color"},
            {"HistogramPopout",   "extensions", "bool",   "0"}
        };

        doAtStartup = {
            {"Histogram", "show", "histogram"}
        };

        // {"x.x", {{"oldname1", "oldtable1", "newname1", "newtable1"},
        //          {"oldname2", "oldtable2", "newname2", "newtable2"}}}
        migrateSettings = {
            {"4.9", {{"Visible",         "histogram", "Histogram",         "extensions"},
                     {"Position",        "histogram", "HistogramPosition", "extensions"},
                     {"Size",            "histogram", "HistogramSize",     "extensions"},
                     {"Version",         "histogram", "HistogramVersion",  "extensions"},
                     {"PopoutHistogram", "interface", "HistogramPopout",   "extensions"}}}
        };

    }

};
