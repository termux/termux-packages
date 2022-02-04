TERMUX_PKG_HOMEPAGE=https://github.com/Netflix/dynomite
TERMUX_PKG_DESCRIPTION="A thin, distributed dynamo layer for different storage engines and protocols"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.6.22
TERMUX_PKG_SRCURL=https://github.com/Netflix/dynomite/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9c3c60d95b39939f3ce596776febe8aa00ae8614ba85aa767e74d41e302e704a
TERMUX_PKG_DEPENDS="libyaml, openssl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
ac_cv_epoll_works=yes
ac_cv_evports_works=no
ac_cv_header_execinfo_h=no
ac_cv_kqueue_works=no
"

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" -Wl,-z,muldefs"

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
