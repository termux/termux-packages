TERMUX_PKG_HOMEPAGE=https://fritzing.org/
TERMUX_PKG_DESCRIPTION="An Electronic Design Automation software"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.9.6
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/fritzing/fritzing-app/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=eb4ebe461c5d42edb4b10f1f824e7c855ad54555e222c5999061dead09834491
TERMUX_PKG_DEPENDS="fritzing-data, libc++, libgit2, qt5-qtbase, qt5-qtserialport, qt5-qtsvg, quazip"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers, qt5-qtbase-cross-tools"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
PREFIX=$TERMUX_PREFIX
PKG_CONFIG=pkg-config
DEFINES=QUAZIP_INSTALLED
"

termux_step_post_get_source() {
	rm -rf src/lib/quazip pri/quazip.pri
}

termux_step_configure() {
	"${TERMUX_PREFIX}/opt/qt/cross/bin/qmake" \
		-spec "${TERMUX_PREFIX}/lib/qt/mkspecs/termux-cross" \
		${TERMUX_PKG_EXTRA_CONFIGURE_ARGS}
}
