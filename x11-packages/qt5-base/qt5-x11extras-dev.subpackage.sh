TERMUX_SUBPKG_DESCRIPTION="Qt platform-specific APIs for X11"
TERMUX_SUBPKG_DEPENDS="qt5-base, qt5-x11extras"

TERMUX_SUBPKG_INCLUDE="
include/qt/QtX11Extras
lib/cmake/Qt5X11Extras
lib/libQt5X11Extras.prl
lib/pkgconfig/Qt5X11Extras.pc
lib/qt/mkspecs/modules/qt_lib_x11extras.pri
lib/qt/mkspecs/modules/qt_lib_x11extras_private.pri
"
