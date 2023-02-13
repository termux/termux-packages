TERMUX_PKG_HOMEPAGE=https://botan.randombit.net/
TERMUX_PKG_DESCRIPTION="Crypto and TLS for Modern C++"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.19.3
TERMUX_PKG_SRCURL=https://botan.randombit.net/releases/Botan-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=dae047f399c5a47f087db5d3d9d9e8f11ae4985d14c928d71da1aff801802d55
TERMUX_PKG_DEPENDS="libbz2, libc++, liblzma, libsqlite, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--cpu=$TERMUX_ARCH
--os=linux
--no-install-python-module
--without-documentation
--with-boost
--with-bzip2
--with-lzma
--with-sqlite3
--with-zlib
--prefix=$TERMUX_PREFIX
"

termux_step_pre_configure() {
	CXXFLAGS+=" $CPPFLAGS"
}

termux_step_configure() {
	python3 $TERMUX_PKG_SRCDIR/configure.py \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}
