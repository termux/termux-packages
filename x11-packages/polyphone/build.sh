TERMUX_PKG_HOMEPAGE=https://www.polyphone-soundfonts.com/
TERMUX_PKG_DESCRIPTION="An open-source soundfont editor for creating musical instruments"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.0
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/davy7125/polyphone/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ecf401f2a083bb5396032953bb3d051e39aa4483063da9546852219ad532605a
TERMUX_PKG_DEPENDS="glib, libc++, libflac, libogg, librtmidi, libvorbis, openssl, portaudio, qcustomplot, qt5-qtbase, qt5-qtsvg, zlib"
TERMUX_PKG_BUILD_DEPENDS="qt5-qtbase-cross-tools, qt5-qttools-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
DEFINES+=USE_LOCAL_STK
PKG_CONFIG=pkg-config
PREFIX=$TERMUX_PREFIX
"

termux_step_pre_configure() {
	TERMUX_PKG_SRCDIR+="/sources"
	TERMUX_PKG_BUILDDIR="$TERMUX_PKG_SRCDIR"
}

termux_step_configure() {
	"${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
		-spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross" \
		${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}
}
