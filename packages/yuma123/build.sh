TERMUX_PKG_HOMEPAGE=https://yuma123.org/
TERMUX_PKG_DESCRIPTION="Provides an opensource YANG API in C"
TERMUX_PKG_LICENSE="BSD 3-Clause, MIT, Public Domain"
TERMUX_PKG_LICENSE_FILE="debian/copyright"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.12
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/yuma123/yuma123_${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=81a0e4d4b4420891fb0a091e9cf4c36d50dbdc5dfedb09609e9b1fee58377ea9
TERMUX_PKG_DEPENDS="libssh2, libxml2, ncurses, openssl, readline, zlib"

termux_step_pre_configure() {
	autoreconf -fi

	CPPFLAGS+=" -D__USE_BSD"

	_NEED_DUMMY_LIBRT_A=
	_LIBRT_A=$TERMUX_PREFIX/lib/librt.a
	if [ ! -e $_LIBRT_A ]; then
		_NEED_DUMMY_LIBRT_A=true
		echo '!<arch>' > $_LIBRT_A
	fi
}

termux_step_post_make_install() {
	if [ $_NEED_DUMMY_LIBRT_A ]; then
		rm -f $_LIBRT_A
	fi
}
