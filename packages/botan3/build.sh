TERMUX_PKG_HOMEPAGE=https://botan.randombit.net/
TERMUX_PKG_DESCRIPTION="Crypto and TLS for Modern C++"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
# This specific package is for libbotan-3.
TERMUX_PKG_VERSION="3.13.0"
TERMUX_PKG_SRCURL="https://botan.randombit.net/releases/Botan-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=12f5a8358890bbee82edfe9d2e7769b0a610b6dd0e0698aea13d20a675d84620
TERMUX_PKG_DEPENDS="libbz2, libc++, liblzma, libsqlite, zlib"
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--cpu=$TERMUX_ARCH
--os=android
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
	local _GUARD_FILE="lib/libbotan-3.so"
	if [ ! -e "${_GUARD_FILE}" ]; then
		termux_error_exit "file ${_GUARD_FILE} not found."
	fi
}
