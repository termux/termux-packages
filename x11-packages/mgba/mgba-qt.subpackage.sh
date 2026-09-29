TERMUX_SUBPKG_DESCRIPTION="An emulator for running Game Boy Advance games (Qt GUI)"
TERMUX_SUBPKG_DEPENDS="libc++, libmgba, qt5-qtbase, qt5-qtmultimedia, sdl2 | sdl2-compat"
TERMUX_SUBPKG_INCLUDE="
bin/mgba-qt
share/applications
share/doc
share/icons
share/mgba
share/man/man6/mgba-qt.6.gz
"
