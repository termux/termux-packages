TERMUX_SUBPKG_DESCRIPTION="Qt development tools (incomplete !)"
TERMUX_SUBPKG_DEPENDS="qt5-base, qt5-tools"

TERMUX_SUBPKG_INCLUDE="
include/qt/QtHelp
include/qt/QtUiPlugin
include/qt/QtUiTools
lib/cmake/Qt5Help
lib/cmake/Qt5UiPlugin
lib/cmake/Qt5UiTools
lib/cmake/Qt5LinguistTools
lib/libQt5Help.prl
lib/libQt5UiTools.prl
lib/libQt5UiTools.a
lib/pkgconfig/Qt5Help.pc
lib/pkgconfig/Qt5UiTools.pc
lib/qt/mkspecs/modules/qt_lib_help.pri
lib/qt/mkspecs/modules/qt_lib_help_private.pri
lib/qt/mkspecs/modules/qt_lib_uiplugin.pri
lib/qt/mkspecs/modules/qt_lib_uitools.pri
lib/qt/mkspecs/modules/qt_lib_uitools_private.pri
"
