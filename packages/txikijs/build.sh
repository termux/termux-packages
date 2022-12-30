TERMUX_PKG_HOMEPAGE=https://github.com/saghul/txiki.js
TERMUX_PKG_DESCRIPTION="A small and powerful JavaScript runtime"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:22.11.1
TERMUX_PKG_SRCURL=git+https://github.com/saghul/txiki.js
TERMUX_PKG_GIT_BRANCH=v${TERMUX_PKG_VERSION#*:}
TERMUX_PKG_DEPENDS="libcurl, libffi"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DBUILD_NATIVE=OFF
-DUSE_EXTERNAL_FFI=ON
-DFFI_INCLUDE_DIR=$TERMUX_PREFIX/include
-DFFI_LIB=$TERMUX_PREFIX/lib/libffi.so
"
TERMUX_PKG_HOSTBUILD=true

# Build failure for i686:
#   [...]/txikijs/src/deps/wasm3/source/./extra/wasi_core.h:46:1:
#   fatal error: static_assert failed due to requirement
#   '__alignof(long long) == 8' "non-wasi data layout"
#   _Static_assert(_Alignof(int64_t) == 8, "non-wasi data layout");
#   ^              ~~~~~~~~~~~~~~~~~~~~~~
TERMUX_PKG_BLACKLISTED_ARCHES="i686"

termux_step_host_build() {
	find $TERMUX_PKG_SRCDIR -mindepth 1 -maxdepth 1 ! -name '.git*' \
		-exec cp -a \{\} ./ \;

	termux_setup_cmake

	cmake .
	make -j $TERMUX_MAKE_PROCESSES
}

termux_step_pre_configure() {
	_NEED_DUMMY_LIBPTHREAD_A=
	_LIBPTHREAD_A=$TERMUX_PREFIX/lib/libpthread.a
	if [ ! -e $_LIBPTHREAD_A ]; then
		_NEED_DUMMY_LIBPTHREAD_A=true
		echo '!<arch>' > $_LIBPTHREAD_A
	fi
	_NEED_DUMMY_LIBRT_A=
	_LIBRT_A=$TERMUX_PREFIX/lib/librt.a
	if [ ! -e $_LIBRT_A ]; then
		_NEED_DUMMY_LIBRT_A=true
		echo '!<arch>' > $_LIBRT_A
	fi
}

termux_step_post_configure() {
	export PATH=$TERMUX_PKG_HOSTBUILD_DIR:$PATH
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin tjs
}

termux_step_post_make_install() {
	if [ $_NEED_DUMMY_LIBPTHREAD_A ]; then
		rm -f $_LIBPTHREAD_A
	fi
	if [ $_NEED_DUMMY_LIBRT_A ]; then
		rm -f $_LIBRT_A
	fi
}
