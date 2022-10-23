TERMUX_PKG_HOMEPAGE=https://www.lesbonscomptes.com/recoll/index.html
TERMUX_PKG_DESCRIPTION="Full-text search for your desktop"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.33.1
TERMUX_PKG_SRCURL=http://www.lesbonscomptes.com/recoll/recoll-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=025dec0b9745e1ddacd86ee5478f9c52b2da2e5c307f831aaa5b2c7f9d7e8db9
TERMUX_PKG_DEPENDS="aspell, libxapian, libxslt, zlib, python"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --disable-userdoc --disable-python-chm --disable-x11mon --disable-qtgui"
TERMUX_PKG_REVISION=1

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
	CXXFLAGS+=" -fPIC"
	_PYTHON_VERSION=$(source $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	CPPFLAGS+=" -I${TERMUX_PREFIX}/include/python${_PYTHON_VERSION}/"
}
