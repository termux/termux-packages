TERMUX_PKG_HOMEPAGE=http://spek.cc/
TERMUX_PKG_DESCRIPTION="An acoustic spectrum analyser"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.8.3-p20181228
TERMUX_PKG_REVISION=1
_COMMIT=f071c2956176ad53c7c8059e5c00e694ded31ded
TERMUX_PKG_SRCURL=https://github.com/alexkay/spek.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="ffmpeg, wxwidgets"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_path_WX_CONFIG_PATH=$TERMUX_PREFIX/bin/wx-config"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT
}

termux_step_pre_configure() {
	AUTOPOINT='intltoolize --automake --copy' \
		autoreconf -fi --include=$TERMUX_PREFIX/share/aclocal

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
