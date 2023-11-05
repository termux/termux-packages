TERMUX_PKG_HOMEPAGE=https://www.lesbonscomptes.com/recoll/index.html
TERMUX_PKG_DESCRIPTION="Full-text search for your desktop"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.36.1"
TERMUX_PKG_SRCURL=https://www.lesbonscomptes.com/recoll/recoll-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=22a53984462ea782e21875012130e2b9ddeb14a30c5c083e84e55570cff35678
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="aspell, file, libc++, libiconv, libxapian, libxml2, libxslt, zlib"
TERMUX_PKG_PYTHON_COMMON_DEPS="wheel"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_path_aspellProg=$TERMUX_PREFIX/bin/aspell
--with-file-command=$TERMUX_PREFIX/bin/file
--disable-userdoc
--disable-python-chm
--disable-python-aspell
--disable-x11mon
--disable-qtgui
"

termux_step_pre_configure() {
	LDFLAGS+=" $($CC -print-libgcc-file-name)"
	CXXFLAGS+=" -fPIC"
	CPPFLAGS+=" -I${TERMUX_PREFIX}/include/python${TERMUX_PYTHON_VERSION}/"

	echo "Applying python-recoll-setup.py.in.diff"
	sed "s|@PYTHON_VERSION@|${TERMUX_PYTHON_VERSION}|g" \
		$TERMUX_PKG_BUILDER_DIR/python-recoll-setup.py.in.diff \
		| patch --silent -p1
}
