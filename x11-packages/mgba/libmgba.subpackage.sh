TERMUX_SUBPKG_DESCRIPTION="An emulator for running Game Boy Advance games (library)"
TERMUX_SUBPKG_DEPENDS="ffmpeg, libedit, libelf, lua54, libpng, libsqlite, libzip, opengl, zlib"
TERMUX_SUBPKG_CONFLICTS="mgba (<< 0.10.5-4)"
TERMUX_SUBPKG_INCLUDE="
include
lib
"
