TERMUX_PKG_HOMEPAGE=https://www.nushell.sh
TERMUX_PKG_DESCRIPTION="A new type of shell operating on structured data"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.72.1"
TERMUX_PKG_SRCURL=https://github.com/nushell/nushell/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9f921243512702bd02845a58f8d9225e432667084f4d5e3a8d6375bec2f92f31
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl, zlib"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--features=extra"

termux_step_pre_configure() {
	termux_setup_rust

	export CFLAGS="${TARGET_CFLAGS}"

	local _CARGO_TARGET_LIBDIR="target/${CARGO_TARGET_NAME}/release/deps"
	mkdir -p $_CARGO_TARGET_LIBDIR

	if [ $TERMUX_ARCH = "i686" ]; then
		RUSTFLAGS+=" -C link-arg=-latomic"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		pushd $_CARGO_TARGET_LIBDIR
		local libgcc="$($CC -print-libgcc-file-name)"
		echo "INPUT($libgcc -l:libunwind.a)" >libgcc.so
		popd
	fi

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	rm -rf $CARGO_HOME/registry/src/github.com-*/pwd-*
	cargo fetch --target "${CARGO_TARGET_NAME}"

	for d in $CARGO_HOME/registry/src/github.com-*/pwd-*; do
		patch --silent -p1 -d ${d} < $TERMUX_PKG_BUILDER_DIR/crates-pwd-for-android.diff || :
	done

	mv $TERMUX_PREFIX/lib/libz.so.1{,.tmp}
	mv $TERMUX_PREFIX/lib/libz.so{,.tmp}

	ln -sfT $(readlink -f $TERMUX_PREFIX/lib/libz.so.1.tmp) \
		$_CARGO_TARGET_LIBDIR/libz.so.1
	ln -sfT $(readlink -f $TERMUX_PREFIX/lib/libz.so.tmp) \
		$_CARGO_TARGET_LIBDIR/libz.so
}

termux_step_post_make_install() {
	mv $TERMUX_PREFIX/lib/libz.so.1{.tmp,}
	mv $TERMUX_PREFIX/lib/libz.so{.tmp,}
}

termux_step_post_massage() {
	rm -f lib/libz.so.1
	rm -f lib/libz.so
}
