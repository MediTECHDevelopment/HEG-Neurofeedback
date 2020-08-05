/****************************************************************************
** Meta object code from reading C++ file 'logicdatahandler.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.12.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "logicdatahandler.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'logicdatahandler.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.12.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_DataHandler_t {
    QByteArrayData data[17];
    char stringdata0[196];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_DataHandler_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_DataHandler_t qt_meta_stringdata_DataHandler = {
    {
QT_MOC_LITERAL(0, 0, 11), // "DataHandler"
QT_MOC_LITERAL(1, 12, 20), // "forwardingToDatabase"
QT_MOC_LITERAL(2, 33, 0), // ""
QT_MOC_LITERAL(3, 34, 20), // "updateDatabasedialog"
QT_MOC_LITERAL(4, 55, 6), // "Client"
QT_MOC_LITERAL(5, 62, 15), // "setNotepadNotes"
QT_MOC_LITERAL(6, 78, 5), // "notes"
QT_MOC_LITERAL(7, 84, 8), // "saveData"
QT_MOC_LITERAL(8, 93, 13), // "currentClient"
QT_MOC_LITERAL(9, 107, 5), // "Data*"
QT_MOC_LITERAL(10, 113, 12), // "Data_pointer"
QT_MOC_LITERAL(11, 126, 8), // "loadData"
QT_MOC_LITERAL(12, 135, 9), // "saveAsCSV"
QT_MOC_LITERAL(13, 145, 12), // "exportClient"
QT_MOC_LITERAL(14, 158, 11), // "Measurement"
QT_MOC_LITERAL(15, 170, 17), // "exportMeasurement"
QT_MOC_LITERAL(16, 188, 7) // "fileUrl"

    },
    "DataHandler\0forwardingToDatabase\0\0"
    "updateDatabasedialog\0Client\0setNotepadNotes\0"
    "notes\0saveData\0currentClient\0Data*\0"
    "Data_pointer\0loadData\0saveAsCSV\0"
    "exportClient\0Measurement\0exportMeasurement\0"
    "fileUrl"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_DataHandler[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       6,   14, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       3,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   44,    2, 0x06 /* Public */,
       3,    1,   45,    2, 0x06 /* Public */,
       5,    1,   48,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       7,    2,   51,    2, 0x0a /* Public */,
      11,    2,   56,    2, 0x0a /* Public */,
      12,    3,   61,    2, 0x0a /* Public */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 4,    2,
    QMetaType::Void, QMetaType::QVariant,    6,

 // slots: parameters
    QMetaType::Bool, 0x80000000 | 4, 0x80000000 | 9,    8,   10,
    QMetaType::Void, 0x80000000 | 4, 0x80000000 | 9,    8,   10,
    QMetaType::Void, 0x80000000 | 4, 0x80000000 | 14, QMetaType::QString,   13,   15,   16,

       0        // eod
};

void DataHandler::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        DataHandler *_t = static_cast<DataHandler *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->forwardingToDatabase(); break;
        case 1: _t->updateDatabasedialog((*reinterpret_cast< Client(*)>(_a[1]))); break;
        case 2: _t->setNotepadNotes((*reinterpret_cast< QVariant(*)>(_a[1]))); break;
        case 3: { bool _r = _t->saveData((*reinterpret_cast< Client(*)>(_a[1])),(*reinterpret_cast< Data*(*)>(_a[2])));
            if (_a[0]) *reinterpret_cast< bool*>(_a[0]) = std::move(_r); }  break;
        case 4: _t->loadData((*reinterpret_cast< Client(*)>(_a[1])),(*reinterpret_cast< Data*(*)>(_a[2]))); break;
        case 5: _t->saveAsCSV((*reinterpret_cast< Client(*)>(_a[1])),(*reinterpret_cast< Measurement(*)>(_a[2])),(*reinterpret_cast< QString(*)>(_a[3]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (DataHandler::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&DataHandler::forwardingToDatabase)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (DataHandler::*)(Client );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&DataHandler::updateDatabasedialog)) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (DataHandler::*)(QVariant );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&DataHandler::setNotepadNotes)) {
                *result = 2;
                return;
            }
        }
    }
}

QT_INIT_METAOBJECT const QMetaObject DataHandler::staticMetaObject = { {
    &QObject::staticMetaObject,
    qt_meta_stringdata_DataHandler.data,
    qt_meta_data_DataHandler,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *DataHandler::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *DataHandler::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_DataHandler.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int DataHandler::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 6)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 6)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 6;
    }
    return _id;
}

// SIGNAL 0
void DataHandler::forwardingToDatabase()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void DataHandler::updateDatabasedialog(Client _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void DataHandler::setNotepadNotes(QVariant _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(&_t1)) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
