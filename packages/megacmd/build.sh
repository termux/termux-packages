TERMUX_PKG_HOMEPAGE=https://mega.io/
TERMUX_PKG_DESCRIPTION="Provides non UI access to MEGA services"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.5.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/meganz/MEGAcmd.git
TERMUX_PKG_GIT_BRANCH=${TERMUX_PKG_VERSION}_Linux
# dbus is required for $PREFIX/var/lib/dbus/machine-id
TERMUX_PKG_DEPENDS="c-ares, cryptopp, dbus, ffmpeg, freeimage, libc++, libcurl, libsodium, libsqlite, libuv, mediainfo, openssl, pcre, readline, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-static
--with-pcre=$TERMUX_PREFIX
ac_cv_lib_pthread_pthread_create=yes
"

termux_step_pre_configure() {
	autoreconf -fi

	export OBJCXX="$CXX"
	CPPFLAGS+=" -DENABLE_SYNC"

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

termux_step_post_massage() {
	find lib -name '*.la' -delete
}
