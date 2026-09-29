TERMUX_PKG_HOMEPAGE=https://melonds.kuribo64.net/
TERMUX_PKG_DESCRIPTION="A fast and accurate Nintendo DS emulator."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/melonDS-emu/melonDS/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=61e339bcb18a68a17485973637d972ea628c5624d7e6b8adf6870f895d5e26fd
TERMUX_PKG_DEPENDS="libcurl, libpcap, sdl2, libarchive, libenet, zstd, faad2, qt6-qtbase, qt6-qtmultimedia, qt6-qtsvg"
TERMUX_PKG_BUILD_DEPENDS="extra-cmake-modules, qt6-qtbase-cross-tools, qt6-qtmultimedia-cross-tools, qt6-qtsvg-cross-tools"
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_INSTALL_PREFIX=${TERMUX__PREFIX}
-DCMAKE_BUILD_TYPE=Debug
-DCMAKE_SYSTEM_NAME=Linux
"
