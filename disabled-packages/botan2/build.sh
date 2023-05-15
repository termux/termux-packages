TERMUX_PKG_HOMEPAGE=https://botan.randombit.net/
TERMUX_PKG_DESCRIPTION="Crypto and TLS for Modern C++"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
# This specific package is for libbotan-2.
TERMUX_PKG_VERSION=2.19.3
TERMUX_PKG_REVISION=1
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
--program-suffix=$(echo ${TERMUX_PKG_VERSION#*:} | cut -d . -f 1)
"

termux_step_pre_configure() {
	CXXFLAGS+=" $CPPFLAGS"
}

termux_step_configure() {
	python3 $TERMUX_PKG_SRCDIR/configure.py \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_post_massage() {
	local _GUARD_FILE="lib/libbotan-2.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "Error: file ${_GUARD_FILE} not found."
	fi
}
