TERMUX_PKG_HOMEPAGE=https://stachenov.github.io/quazip/
TERMUX_PKG_DESCRIPTION="Qt/C++ wrapper over minizip library"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_LICENSE_FILE="COPYING"
TERMUX_PKG_MAINTAINER="@Yisus7u7"
TERMUX_PKG_VERSION=1.4
TERMUX_PKG_SRCURL=https://github.com/stachenov/quazip/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=79633fd3a18e2d11a7d5c40c4c79c1786ba0c74b59ad752e8429746fe1781dd6
TERMUX_PKG_DEPENDS="libbz2, libc++, qt6-qt5compat, qt6-qtbase, zlib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DQUAZIP_QT_MAJOR_VERSION=6
"

# needed only when qt5-qtbase is also installed in the system and causing -I$TERMUX_PREFIX/include overriding -isystem $TERMUX_PREFIX/include/qt6.
termux_step_pre_configure() {
	export CXXFLAGS+=" -I$TERMUX_PREFIX/include/qt6 -I$TERMUX_PREFIX/include/qt6/QtCore5Compat"
}
