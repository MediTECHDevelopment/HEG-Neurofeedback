#include <QtQml/qqmlprivate.h>
#include <QtCore/qdir.h>
#include <QtCore/qurl.h>

static const unsigned char qt_resource_tree[] = {
0,
0,0,0,0,2,0,0,0,37,0,0,0,1,0,0,0,
8,0,0,0,0,0,1,0,0,0,0,0,0,4,26,0,
0,0,0,0,1,0,0,0,0,0,0,1,252,0,0,0,
0,0,1,0,0,0,0,0,0,4,190,0,0,0,0,0,
1,0,0,0,0,0,0,2,194,0,0,0,0,0,1,0,
0,0,0,0,0,5,38,0,0,0,0,0,1,0,0,0,
0,0,0,6,136,0,0,0,0,0,1,0,0,0,0,0,
0,5,186,0,0,0,0,0,1,0,0,0,0,0,0,1,
218,0,0,0,0,0,1,0,0,0,0,0,0,1,8,0,
0,0,0,0,1,0,0,0,0,0,0,1,116,0,0,0,
0,0,1,0,0,0,0,0,0,2,104,0,0,0,0,0,
1,0,0,0,0,0,0,4,76,0,0,0,0,0,1,0,
0,0,0,0,0,2,146,0,0,0,0,0,1,0,0,0,
0,0,0,3,132,0,0,0,0,0,1,0,0,0,0,0,
0,0,108,0,0,0,0,0,1,0,0,0,0,0,0,5,
230,0,0,0,0,0,1,0,0,0,0,0,0,0,54,0,
0,0,0,0,1,0,0,0,0,0,0,0,168,0,0,0,
0,0,1,0,0,0,0,0,0,6,92,0,0,0,0,0,
1,0,0,0,0,0,0,2,44,0,0,0,0,0,1,0,
0,0,0,0,0,5,92,0,0,0,0,0,1,0,0,0,
0,0,0,6,184,0,0,0,0,0,1,0,0,0,0,0,
0,4,136,0,0,0,0,0,1,0,0,0,0,0,0,0,
214,0,0,0,0,0,1,0,0,0,0,0,0,3,14,0,
0,0,0,0,1,0,0,0,0,0,0,5,146,0,0,0,
0,0,1,0,0,0,0,0,0,6,40,0,0,0,0,0,
1,0,0,0,0,0,0,5,252,0,0,0,0,0,1,0,
0,0,0,0,0,3,226,0,0,0,0,0,1,0,0,0,
0,0,0,4,232,0,0,0,0,0,1,0,0,0,0,0,
0,3,56,0,0,0,0,0,1,0,0,0,0,0,0,3,
190,0,0,0,0,0,1,0,0,0,0,0,0,1,168,0,
0,0,0,0,1,0,0,0,0,0,0,3,94,0,0,0,
0,0,1,0,0,0,0,0,0,1,50,0,0,0,0,0,
1,0,0,0,0,0,0,2,230,0,0,0,0,0,1,0,
0,0,0};
static const unsigned char qt_resource_names[] = {
0,
1,0,0,0,47,0,47,0,20,0,190,224,252,0,85,0,
73,0,84,0,114,0,97,0,105,0,110,0,105,0,110,0,
103,0,83,0,116,0,97,0,116,0,101,0,115,0,46,0,
113,0,109,0,108,0,24,8,39,185,252,0,85,0,73,0,
67,0,108,0,105,0,101,0,110,0,116,0,68,0,97,0,
116,0,97,0,83,0,105,0,100,0,101,0,80,0,97,0,
114,0,116,0,46,0,113,0,109,0,108,0,27,7,100,233,
252,0,85,0,73,0,67,0,108,0,105,0,101,0,110,0,
116,0,77,0,101,0,97,0,115,0,117,0,114,0,101,0,
109,0,101,0,110,0,116,0,80,0,97,0,114,0,116,0,
46,0,113,0,109,0,108,0,20,8,43,140,124,0,85,0,
73,0,80,0,108,0,97,0,121,0,66,0,117,0,116,0,
116,0,111,0,110,0,80,0,97,0,114,0,116,0,46,0,
113,0,109,0,108,0,22,12,2,249,92,0,85,0,73,0,
84,0,114,0,97,0,105,0,110,0,105,0,110,0,103,0,
83,0,101,0,116,0,116,0,105,0,110,0,103,0,115,0,
46,0,113,0,109,0,108,0,18,3,241,175,124,0,85,0,
73,0,66,0,97,0,114,0,71,0,114,0,97,0,112,0,
104,0,80,0,97,0,114,0,116,0,46,0,113,0,109,0,
108,0,30,14,120,101,252,0,85,0,73,0,84,0,114,0,
97,0,105,0,110,0,105,0,110,0,103,0,83,0,116,0,
97,0,116,0,101,0,66,0,117,0,116,0,116,0,111,0,
110,0,115,0,80,0,97,0,114,0,116,0,46,0,113,0,
109,0,108,0,23,6,37,78,60,0,85,0,73,0,65,0,
110,0,97,0,108,0,121,0,115,0,101,0,77,0,97,0,
105,0,110,0,87,0,105,0,110,0,100,0,111,0,119,0,
46,0,113,0,109,0,108,0,22,14,73,202,124,0,85,0,
73,0,65,0,110,0,97,0,108,0,121,0,115,0,101,0,
84,0,97,0,98,0,108,0,101,0,80,0,97,0,114,0,
116,0,46,0,113,0,109,0,108,0,14,3,201,13,92,0,
85,0,73,0,68,0,97,0,116,0,97,0,66,0,97,0,
115,0,101,0,46,0,113,0,109,0,108,0,21,1,1,241,
156,0,85,0,73,0,65,0,110,0,97,0,108,0,121,0,
115,0,101,0,83,0,101,0,116,0,116,0,105,0,110,0,
103,0,115,0,46,0,113,0,109,0,108,0,27,8,255,98,
220,0,85,0,73,0,68,0,105,0,102,0,102,0,105,0,
99,0,117,0,108,0,116,0,121,0,66,0,117,0,116,0,
116,0,111,0,110,0,115,0,80,0,97,0,114,0,116,0,
46,0,113,0,109,0,108,0,18,6,177,195,28,0,85,0,
73,0,68,0,97,0,116,0,97,0,98,0,97,0,115,0,
101,0,86,0,105,0,101,0,119,0,46,0,113,0,109,0,
108,0,21,6,243,239,220,0,85,0,73,0,84,0,114,0,
101,0,110,0,100,0,83,0,101,0,108,0,101,0,99,0,
116,0,80,0,97,0,114,0,116,0,46,0,113,0,109,0,
108,0,15,1,99,59,92,0,85,0,73,0,86,0,105,0,
100,0,101,0,111,0,80,0,97,0,114,0,116,0,46,0,
113,0,109,0,108,0,17,14,176,4,156,0,85,0,73,0,
65,0,110,0,97,0,108,0,121,0,115,0,101,0,86,0,
105,0,101,0,119,0,46,0,113,0,109,0,108,0,18,12,
61,247,124,0,85,0,73,0,83,0,101,0,116,0,116,0,
105,0,110,0,103,0,115,0,86,0,105,0,101,0,119,0,
46,0,113,0,109,0,108,0,16,13,114,147,188,0,85,0,
73,0,67,0,108,0,105,0,101,0,110,0,116,0,66,0,
97,0,115,0,101,0,46,0,113,0,109,0,108,0,16,14,
100,54,220,0,85,0,73,0,67,0,111,0,110,0,116,0,
114,0,111,0,108,0,108,0,101,0,114,0,46,0,113,0,
109,0,108,0,26,7,53,254,220,0,85,0,73,0,84,0,
104,0,114,0,101,0,115,0,104,0,111,0,108,0,100,0,
66,0,117,0,116,0,116,0,111,0,110,0,115,0,80,0,
97,0,114,0,116,0,46,0,113,0,109,0,108,0,15,13,
213,75,124,0,85,0,73,0,83,0,116,0,97,0,116,0,
117,0,115,0,66,0,97,0,114,0,46,0,113,0,109,0,
108,0,25,12,176,197,252,0,85,0,73,0,67,0,104,0,
111,0,111,0,115,0,101,0,67,0,111,0,109,0,112,0,
111,0,110,0,101,0,110,0,116,0,80,0,97,0,114,0,
116,0,46,0,113,0,109,0,108,0,22,0,209,113,156,0,
85,0,73,0,67,0,104,0,111,0,111,0,115,0,101,0,
67,0,108,0,105,0,101,0,110,0,116,0,80,0,97,0,
114,0,116,0,46,0,113,0,109,0,108,0,27,6,214,211,
28,0,85,0,73,0,65,0,110,0,97,0,108,0,121,0,
115,0,101,0,83,0,101,0,108,0,101,0,99,0,116,0,
105,0,111,0,110,0,115,0,80,0,97,0,114,0,116,0,
46,0,113,0,109,0,108,0,24,10,215,209,60,0,85,0,
73,0,68,0,97,0,116,0,97,0,98,0,97,0,115,0,
101,0,77,0,97,0,110,0,97,0,103,0,101,0,80,0,
97,0,114,0,116,0,46,0,113,0,109,0,108,0,18,1,
36,48,124,0,85,0,73,0,84,0,114,0,97,0,105,0,
110,0,105,0,110,0,103,0,86,0,105,0,101,0,119,0,
46,0,113,0,109,0,108,0,28,12,192,227,188,0,85,0,
73,0,84,0,114,0,97,0,105,0,110,0,105,0,110,0,
103,0,83,0,101,0,108,0,101,0,99,0,116,0,105,0,
111,0,110,0,115,0,80,0,97,0,114,0,116,0,46,0,
113,0,109,0,108,0,24,1,119,231,252,0,85,0,73,0,
67,0,108,0,105,0,101,0,110,0,116,0,68,0,97,0,
116,0,97,0,77,0,97,0,105,0,110,0,80,0,97,0,
114,0,116,0,46,0,113,0,109,0,108,0,24,9,61,7,
220,0,85,0,73,0,84,0,114,0,97,0,105,0,110,0,
105,0,110,0,103,0,77,0,97,0,105,0,110,0,87,0,
105,0,110,0,100,0,111,0,119,0,46,0,113,0,109,0,
108,0,17,12,124,51,92,0,85,0,73,0,78,0,111,0,
116,0,101,0,112,0,97,0,100,0,80,0,97,0,114,0,
116,0,46,0,113,0,109,0,108,0,19,2,11,158,92,0,
85,0,73,0,76,0,105,0,110,0,101,0,71,0,114,0,
97,0,112,0,104,0,80,0,97,0,114,0,116,0,46,0,
113,0,109,0,108,0,8,8,1,90,92,0,109,0,97,0,
105,0,110,0,46,0,113,0,109,0,108,0,19,12,146,35,
252,0,85,0,73,0,65,0,110,0,97,0,108,0,121,0,
115,0,101,0,83,0,116,0,97,0,116,0,101,0,115,0,
46,0,113,0,109,0,108,0,23,12,142,215,92,0,85,0,
73,0,76,0,97,0,121,0,111,0,117,0,116,0,66,0,
117,0,116,0,116,0,111,0,110,0,115,0,80,0,97,0,
114,0,116,0,46,0,113,0,109,0,108,0,19,8,115,158,
60,0,85,0,73,0,86,0,105,0,100,0,101,0,111,0,
67,0,116,0,114,0,108,0,80,0,97,0,114,0,116,0,
46,0,113,0,109,0,108,0,21,1,249,144,220,0,85,0,
73,0,77,0,97,0,105,0,110,0,66,0,117,0,116,0,
116,0,111,0,110,0,115,0,80,0,97,0,114,0,116,0,
46,0,113,0,109,0,108,0,17,9,242,158,220,0,85,0,
73,0,89,0,65,0,120,0,105,0,115,0,95,0,67,0,
111,0,111,0,114,0,100,0,46,0,113,0,109,0,108};
static const unsigned char qt_resource_empty_payout[] = { 0, 0, 0, 0, 0 };
QT_BEGIN_NAMESPACE
extern Q_CORE_EXPORT bool qRegisterResourceData(int, const unsigned char *, const unsigned char *, const unsigned char *);
QT_END_NAMESPACE
namespace QmlCacheGeneratedCode {
namespace _0x5f__UIYAxis_Coord_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIMainButtonsPart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIVideoCtrlPart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UILayoutButtonsPart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIAnalyseStates_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__main_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UILineGraphPart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UINotepadPart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UITrainingMainWindow_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIClientDataMainPart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UITrainingSelectionsPart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UITrainingView_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIDatabaseManagePart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIAnalyseSelectionsPart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIChooseClientPart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIChooseComponentPart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIStatusBar_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIThresholdButtonsPart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIController_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIClientBase_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UISettingsView_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIAnalyseView_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIVideoPart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UITrendSelectPart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIDatabaseView_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIDifficultyButtonsPart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIAnalyseSettings_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIDataBase_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIAnalyseTablePart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIAnalyseMainWindow_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UITrainingStateButtonsPart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIBarGraphPart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UITrainingSettings_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIPlayButtonPart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIClientMeasurementPart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UIClientDataSidePart_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}
namespace _0x5f__UITrainingStates_qml { 
    extern const unsigned char qmlData[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), nullptr, nullptr
    };
}

}
namespace {
struct Registry {
    Registry();
    QHash<QString, const QQmlPrivate::CachedQmlUnit*> resourcePathToCachedUnit;
    static const QQmlPrivate::CachedQmlUnit *lookupCachedUnit(const QUrl &url);
};

Q_GLOBAL_STATIC(Registry, unitRegistry)


Registry::Registry() {
        resourcePathToCachedUnit.insert(QStringLiteral("/UIYAxis_Coord.qml"), &QmlCacheGeneratedCode::_0x5f__UIYAxis_Coord_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIMainButtonsPart.qml"), &QmlCacheGeneratedCode::_0x5f__UIMainButtonsPart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIVideoCtrlPart.qml"), &QmlCacheGeneratedCode::_0x5f__UIVideoCtrlPart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UILayoutButtonsPart.qml"), &QmlCacheGeneratedCode::_0x5f__UILayoutButtonsPart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIAnalyseStates.qml"), &QmlCacheGeneratedCode::_0x5f__UIAnalyseStates_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/main.qml"), &QmlCacheGeneratedCode::_0x5f__main_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UILineGraphPart.qml"), &QmlCacheGeneratedCode::_0x5f__UILineGraphPart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UINotepadPart.qml"), &QmlCacheGeneratedCode::_0x5f__UINotepadPart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UITrainingMainWindow.qml"), &QmlCacheGeneratedCode::_0x5f__UITrainingMainWindow_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIClientDataMainPart.qml"), &QmlCacheGeneratedCode::_0x5f__UIClientDataMainPart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UITrainingSelectionsPart.qml"), &QmlCacheGeneratedCode::_0x5f__UITrainingSelectionsPart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UITrainingView.qml"), &QmlCacheGeneratedCode::_0x5f__UITrainingView_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIDatabaseManagePart.qml"), &QmlCacheGeneratedCode::_0x5f__UIDatabaseManagePart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIAnalyseSelectionsPart.qml"), &QmlCacheGeneratedCode::_0x5f__UIAnalyseSelectionsPart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIChooseClientPart.qml"), &QmlCacheGeneratedCode::_0x5f__UIChooseClientPart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIChooseComponentPart.qml"), &QmlCacheGeneratedCode::_0x5f__UIChooseComponentPart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIStatusBar.qml"), &QmlCacheGeneratedCode::_0x5f__UIStatusBar_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIThresholdButtonsPart.qml"), &QmlCacheGeneratedCode::_0x5f__UIThresholdButtonsPart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIController.qml"), &QmlCacheGeneratedCode::_0x5f__UIController_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIClientBase.qml"), &QmlCacheGeneratedCode::_0x5f__UIClientBase_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UISettingsView.qml"), &QmlCacheGeneratedCode::_0x5f__UISettingsView_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIAnalyseView.qml"), &QmlCacheGeneratedCode::_0x5f__UIAnalyseView_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIVideoPart.qml"), &QmlCacheGeneratedCode::_0x5f__UIVideoPart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UITrendSelectPart.qml"), &QmlCacheGeneratedCode::_0x5f__UITrendSelectPart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIDatabaseView.qml"), &QmlCacheGeneratedCode::_0x5f__UIDatabaseView_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIDifficultyButtonsPart.qml"), &QmlCacheGeneratedCode::_0x5f__UIDifficultyButtonsPart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIAnalyseSettings.qml"), &QmlCacheGeneratedCode::_0x5f__UIAnalyseSettings_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIDataBase.qml"), &QmlCacheGeneratedCode::_0x5f__UIDataBase_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIAnalyseTablePart.qml"), &QmlCacheGeneratedCode::_0x5f__UIAnalyseTablePart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIAnalyseMainWindow.qml"), &QmlCacheGeneratedCode::_0x5f__UIAnalyseMainWindow_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UITrainingStateButtonsPart.qml"), &QmlCacheGeneratedCode::_0x5f__UITrainingStateButtonsPart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIBarGraphPart.qml"), &QmlCacheGeneratedCode::_0x5f__UIBarGraphPart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UITrainingSettings.qml"), &QmlCacheGeneratedCode::_0x5f__UITrainingSettings_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIPlayButtonPart.qml"), &QmlCacheGeneratedCode::_0x5f__UIPlayButtonPart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIClientMeasurementPart.qml"), &QmlCacheGeneratedCode::_0x5f__UIClientMeasurementPart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UIClientDataSidePart.qml"), &QmlCacheGeneratedCode::_0x5f__UIClientDataSidePart_qml::unit);
        resourcePathToCachedUnit.insert(QStringLiteral("/UITrainingStates.qml"), &QmlCacheGeneratedCode::_0x5f__UITrainingStates_qml::unit);
    QQmlPrivate::RegisterQmlUnitCacheHook registration;
    registration.version = 0;
    registration.lookupCachedQmlUnit = &lookupCachedUnit;
    QQmlPrivate::qmlregister(QQmlPrivate::QmlUnitCacheHookRegistration, &registration);
QT_PREPEND_NAMESPACE(qRegisterResourceData)(/*version*/0x01, qt_resource_tree, qt_resource_names, qt_resource_empty_payout);
}
const QQmlPrivate::CachedQmlUnit *Registry::lookupCachedUnit(const QUrl &url) {
    if (url.scheme() != QLatin1String("qrc"))
        return nullptr;
    QString resourcePath = QDir::cleanPath(url.path());
    if (resourcePath.isEmpty())
        return nullptr;
    if (!resourcePath.startsWith(QLatin1Char('/')))
        resourcePath.prepend(QLatin1Char('/'));
    return unitRegistry()->resourcePathToCachedUnit.value(resourcePath, nullptr);
}
}
int QT_MANGLE_NAMESPACE(qInitResources_qml)() {
    ::unitRegistry();
    return 1;
}
Q_CONSTRUCTOR_FUNCTION(QT_MANGLE_NAMESPACE(qInitResources_qml))
int QT_MANGLE_NAMESPACE(qCleanupResources_qml)() {
    return 1;
}
