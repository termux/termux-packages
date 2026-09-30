TERMUX_PKG_HOMEPAGE=https://www.polyphone-soundfonts.com/
TERMUX_PKG_DESCRIPTION="An open-source soundfont editor for creating musical instruments"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.6.0
TERMUX_PKG_SRCURL=https://github.com/davy7125/polyphone/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=25579f338ce7bf7112b7554094f24790ad3b8c617ad4119c3a37a3e89b856e28
TERMUX_PKG_DEPENDS="glib, libc++, libflac, libogg, librtmidi, libvorbis, libsndfile, openssl, pulseaudio, qcustomplot, qt5-qtbase, qt5-qtsvg, zlib"
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
