TERMUX_SUBPKG_DESCRIPTION="GTK+ 3 platform theme for Qt 5"
TERMUX_SUBPKG_DEPENDS="qt5-qtbase, gtk3"
TERMUX_SUBPKG_INCLUDE="
libexec/qt/platformthemes/libqgtk3.so
lib/cmake/Qt5Gui/Qt5Gui_QGtk3ThemePlugin.cmake
"
