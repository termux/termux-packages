TERMUX_PKG_HOMEPAGE=https://vkcom.github.io/kphp/
TERMUX_PKG_DESCRIPTION="A PHP compiler"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=b1b2cec0f0e1206e1c134830ebd1f28e21bbd330
TERMUX_PKG_VERSION=2021.12.30
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/VKCOM/kphp.git
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_DEPENDS="fmt, libc++, libcurl, libmsgpack-cxx, libre2, libuber-h3, libucontext, libyaml-cpp, openssl-1.1, pcre, zstd"
TERMUX_PKG_BUILD_DEPENDS="kphp-timelib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DKPHP_TESTS=OFF
-DOPENSSL_INCLUDE_DIR=$TERMUX_PREFIX/include/openssl-1.1
-DOPENSSL_LIBRARIES=$TERMUX_PREFIX/lib/openssl-1.1
-DOPENSSL_CRYPTO_LIBRARY=$TERMUX_PREFIX/lib/openssl-1.1/libcrypto.so.1.1
-DOPENSSL_SSL_LIBRARY=$TERMUX_PREFIX/lib/openssl-1.1/libssl.so.1.1"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$TERMUX_PKG_VERSION" ]; then
		echo -n "ERROR: The specified version \"$TERMUX_PKG_VERSION\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi
}

termux_step_pre_configure() {
	_NEED_DUMMY_LIBPTHREAD_A=
	_LIBPTHREAD_A=$TERMUX_PREFIX/lib/libpthread.a
	if [ ! -e $_LIBPTHREAD_A ]; then
		_NEED_DUMMY_LIBPTHREAD_A=true
		echo '!<arch>' > $_LIBPTHREAD_A
	fi
	CFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CFLAGS"
	CPPFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CPPFLAGS"
	CXXFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CXXFLAGS"
	LDFLAGS="-L$TERMUX_PREFIX/lib/openssl-1.1 -Wl,-rpath=$TERMUX_PREFIX/lib/openssl-1.1 $LDFLAGS"
	
}

termux_step_post_configure() {
	local f
	if [ "$TERMUX_CMAKE_BUILD" == "Ninja" ]; then
		f=build.ninja
	else
		f=CMakeFiles/kphp2cpp.dir/link.txt
	fi
	sed -i -e 's/-l:libyaml-cpp\.a/-lyaml-cpp/g' \
		-e 's/-l:libre2\.a/-lre2/g' \
		$f

	local bin=$TERMUX_PKG_BUILDDIR/_prefix/bin
	mkdir -p $bin
	for exe in generate_unicode_utils prepare_unicode_data; do
		$CC_FOR_BUILD $TERMUX_PKG_SRCDIR/common/unicode/${exe//_/-}.cpp \
			-o ${bin}/${exe}
	done
	export PATH=$bin:$PATH
}

termux_step_post_make_install() {
	if [ $_NEED_DUMMY_LIBPTHREAD_A ]; then
		rm -f $_LIBPTHREAD_A
	fi
}
