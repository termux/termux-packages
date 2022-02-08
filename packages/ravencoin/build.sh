TERMUX_PKG_HOMEPAGE=https://ravencoin.org/
TERMUX_PKG_DESCRIPTION="A peer-to-peer blockchain, handling the efficient creation and transfer of assets from one party to another"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.3.2.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/RavenProject/Ravencoin/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=02e6c12220ba0f9378a3af790a57a0a6e11d7b091adfd91f555aab07341d62e3
TERMUX_PKG_DEPENDS="boost, libevent, openssl"
TERMUX_PKG_BUILD_DEPENDS="libdb"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-tests
--disable-wallet
--with-boost=$TERMUX_PREFIX/lib
--with-boost-libdir=$TERMUX_PREFIX/lib
"

termux_step_pre_configure() {
	autoreconf -fi

	_NEED_DUMMY_LIBPTHREAD_A=
	_LIBPTHREAD_A=$TERMUX_PREFIX/lib/libpthread.a
	if [ ! -e $_LIBPTHREAD_A ]; then
		_NEED_DUMMY_LIBPTHREAD_A=true
		echo '!<arch>' > $_LIBPTHREAD_A
	fi
}


termux_step_post_make_install() {
	if [ $_NEED_DUMMY_LIBPTHREAD_A ]; then
		rm -f $_LIBPTHREAD_A
	fi
}
