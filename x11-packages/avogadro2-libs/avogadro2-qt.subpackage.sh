TERMUX_SUBPKG_DESCRIPTION="Avogadro2 Qt Plugins"
TERMUX_SUBPKG_INCLUDE="
lib/avogadro2/staticplugins/*
lib/libAvogadroQt*
lib/libAvogadroMoleQueue*
include/avogadro/molequeue/*
include/avogadro/qtgui/*
include/avogadro/qtopengl/*
include/avogadro/qtplugins/*
"
TERMUX_SUBPKG_PLATFORM_INDEPENDENT=false
TERMUX_SUBPKG_DEPENDS="qt6-qtbase, qt6-qtnetworkauth, qt6-qtsvg"
