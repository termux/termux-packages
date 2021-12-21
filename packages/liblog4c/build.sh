TERMUX_PKG_HOMEPAGE=http://log4c.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A C library for flexible logging to files, syslog and other destinations"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.4
TERMUX_PKG_SRCURL=http://prdownloads.sourceforge.net/log4c/log4c-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5991020192f52cc40fa852fbf6bbf5bd5db5d5d00aa9905c67f6f0eadeed48ea
TERMUX_PKG_DEPENDS="libexpat"

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
