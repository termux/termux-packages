TERMUX_PKG_HOMEPAGE=https://ravencoin.org/
TERMUX_PKG_DESCRIPTION="A peer-to-peer blockchain, handling the efficient creation and transfer of assets from one party to another"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.6.1
TERMUX_PKG_SRCURL=https://github.com/RavenProject/Ravencoin/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=42e8444e9e21eecfed1a546dffe6f2418271e890038a7d9d9a856b376a6284e8
TERMUX_PKG_DEPENDS="boost, libc++, libevent, libzmq, miniupnpc, openssl"
TERMUX_PKG_BUILD_DEPENDS="boost-headers, libdb"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-tests
--disable-wallet
--with-boost=$TERMUX_PREFIX/lib
--with-boost-libdir=$TERMUX_PREFIX/lib
"

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" $($CC -print-libgcc-file-name)"

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
