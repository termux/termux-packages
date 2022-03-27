TERMUX_PKG_HOMEPAGE=https://projects.unbit.it/uwsgi
TERMUX_PKG_DESCRIPTION="uWSGI application server container"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.19.1
TERMUX_PKG_REVISION=5
TERMUX_PKG_SRCURL=https://github.com/unbit/uwsgi/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bf17cdbb9bd8bcb7c1633e34d9d7308cb4cc19eb0ff2d61057f840c1ba1fc41b
TERMUX_PKG_DEPENDS="libandroid-glob, libandroid-sysv-semaphore, libcap, libcrypt, libjansson, libuuid, libxml2, openssl, pcre, python"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	cp $TERMUX_PKG_BUILDER_DIR/sys_time.c ./core/
}

termux_step_pre_configure() {
	_PYTHON_VERSION=$(. $TERMUX_SCRIPTDIR/packages/python/build.sh; echo $_MAJOR_VERSION)
	export UWSGI_PYTHON_NOLIB=true
	export UWSGI_INCLUDES="$TERMUX_PREFIX/include"
	export APPEND_CFLAGS="$CPPFLAGS
		-I$TERMUX_PREFIX/include/python${_PYTHON_VERSION}
		-DOBSOLETE_LINUX_KERNEL
		"
	LDFLAGS+="
		-lpython${_PYTHON_VERSION}
		-landroid-glob
		-landroid-sysv-semaphore
		"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin "$TERMUX_PKG_BUILDDIR/uwsgi"
}

