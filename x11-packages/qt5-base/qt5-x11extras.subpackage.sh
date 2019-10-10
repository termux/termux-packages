TERMUX_SUBPKG_DESCRIPTION="Qt platform-specific APIs for X11"
TERMUX_SUBPKG_DEPENDS="qt5-base"
TERMUX_PKG_BREAKS="qt5-x11extras-dev"
TERMUX_PKG_REPLACES="qt5-x11extras-dev"

TERMUX_SUBPKG_INCLUDE="
include/qt/QtX11Extras
lib/cmake/Qt5X11Extras
lib/libQt5X11Extras.prl
lib/libQt5X11Extras.so
lib/libQt5X11Extras.so.5
lib/libQt5X11Extras.so.5.11
lib/libQt5X11Extras.so.5.11.2
lib/pkgconfig/Qt5X11Extras.pc
lib/qt/mkspecs/modules/qt_lib_x11extras.pri
lib/qt/mkspecs/modules/qt_lib_x11extras_private.pri
"
