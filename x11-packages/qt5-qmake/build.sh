TERMUX_PKG_HOMEPAGE=https://www.qt.io/
TERMUX_PKG_DESCRIPTION="Qt 5 QMake"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=5.15.5
TERMUX_PKG_SRCURL="https://download.qt.io/official_releases/qt/5.15/${TERMUX_PKG_VERSION}/submodules/qtbase-everywhere-opensource-src-${TERMUX_PKG_VERSION}.tar.xz"
# TERMUX_PKG_SHA256 is not used in termux-build-qmake.sh.
TERMUX_PKG_SHA256=SKIP_CHECKSUM
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_DEPENDS="qt5-qtbase"
TERMUX_PKG_BREAKS="qt5-qtbase (<< 5.15.7)"
TERMUX_PKG_REPLACES="qt5-qtbase (<< 5.15.7)"

termux_step_make_install() {
	## Unpacking prebuilt qmake from archive.
	cd "${TERMUX_PKG_SRCDIR}" && {
		tar xf "${TERMUX_PKG_BUILDER_DIR}/prebuilt.tar.xz"
		install \
			-Dm700 "${TERMUX_PKG_SRCDIR}/bin/qmake-${TERMUX_HOST_PLATFORM}" \
			"${TERMUX_PREFIX}/bin/qmake"
	}
}
