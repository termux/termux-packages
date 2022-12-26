TERMUX_PKG_HOMEPAGE=https://github.com/alok8bb/cloneit
TERMUX_PKG_DESCRIPTION="A cli tool to download specific GitHub directories or files"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
_COMMIT=62c433f0b1c54a977d585f3b84b8c43213095474
_COMMIT_DATE=2022.10.24
TERMUX_PKG_VERSION=${_COMMIT_DATE//./}
TERMUX_PKG_SRCURL=https://github.com/alok8bb/cloneit.git
TERMUX_PKG_GIT_BRANCH="master"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BUILD_DEPENDS="openssl-1.1" 	

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
	# openssl-sys supports OpenSSL 3 in >= 0.9.69
	export OPENSSL_INCLUDE_DIR=$TERMUX_PREFIX/include/openssl-1.1
	export OPENSSL_LIB_DIR=$TERMUX_PREFIX/lib/openssl-1.1
	CFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CFLAGS"
	CPPFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CPPFLAGS"
	CXXFLAGS="-I$TERMUX_PREFIX/include/openssl-1.1 $CXXFLAGS"
	LDFLAGS="-L$TERMUX_PREFIX/lib/openssl-1.1 -Wl,-rpath=$TERMUX_PREFIX/lib/openssl-1.1 $LDFLAGS"
	RUSTFLAGS+=" -C link-arg=-Wl,-rpath=$TERMUX_PREFIX/lib/openssl-1.1"
}

termux_step_make() {
	termux_setup_rust

	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/cloneit
}
