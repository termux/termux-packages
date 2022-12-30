TERMUX_PKG_HOMEPAGE=https://upscaledb.com/
TERMUX_PKG_DESCRIPTION="A database engine written in C/C++"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=cb124e1f91601872a7b3bd4da10e5fa97a8da86b
_COMMIT_DATE=2021.08.20
TERMUX_PKG_VERSION=2.2.1p${_COMMIT_DATE//./}
TERMUX_PKG_REVISION=6
TERMUX_PKG_SRCURL=git+https://github.com/cruppstahl/upscaledb
TERMUX_PKG_GIT_BRANCH=master
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="boost, libc++, libsnappy, openssl, zlib"
TERMUX_PKG_BUILD_DEPENDS="boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-simd
--disable-java
--disable-remote
--with-boost=$TERMUX_PREFIX
--without-tcmalloc
--without-berkeleydb
"

termux_step_post_get_source() {
	git fetch --unshallow
	git checkout $_COMMIT

	local version="$(git log -1 --format=%cs | sed 's/-/./g')"
	if [ "$version" != "$_COMMIT_DATE" ]; then
		echo -n "ERROR: The specified commit date \"$_COMMIT_DATE\""
		echo " is different from what is expected to be: \"$version\""
		return 1
	fi
}

termux_step_pre_configure() {
	sh bootstrap.sh

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
