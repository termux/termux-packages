TERMUX_PKG_HOMEPAGE=https://bladelang.com/
TERMUX_PKG_DESCRIPTION="A simple, fast, clean and dynamic language"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.0.6
TERMUX_PKG_SRCURL=https://github.com/blade-lang/blade/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3c13f2a81dc027871993e8a369691a470ed7f62b9fb4a72237ff75db36abe35d
TERMUX_PKG_DEPENDS="libsqlite, readline"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	termux_setup_cmake
	cmake $TERMUX_PKG_SRCDIR
	make -j $TERMUX_MAKE_PROCESSES
}

termux_step_pre_configure() {
	PATH=$TERMUX_PKG_HOSTBUILD_DIR/bin:$PATH

	_NEED_DUMMY_LIBPTHREAD_A=
	_LIBPTHREAD_A=$TERMUX_PREFIX/lib/libpthread.a
	if [ ! -e $_LIBPTHREAD_A ]; then
		_NEED_DUMMY_LIBPTHREAD_A=true
		echo '!<arch>' > $_LIBPTHREAD_A
	fi
}

termux_step_make_install() {
	pushd bin
	install -Dm700 -t $TERMUX_PREFIX/bin blade
	install -Dm600 -t $TERMUX_PREFIX/lib libblade.so
	local sharedir=$TERMUX_PREFIX/share/blade
	mkdir -p $sharedir
	cp -r benchmarks includes libs tests $sharedir/
	popd
}

termux_step_post_make_install() {
	if [ $_NEED_DUMMY_LIBPTHREAD_A ]; then
		rm -f $_LIBPTHREAD_A
	fi
}
