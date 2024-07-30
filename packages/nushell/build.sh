TERMUX_PKG_HOMEPAGE=https://www.nushell.sh
TERMUX_PKG_DESCRIPTION="A new type of shell operating on structured data"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.96.1"
TERMUX_PKG_SRCURL=https://github.com/nushell/nushell/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=829e2f91d130d7b0063a08b1fadb737bdff616ac744eba43baa5fc42aa8b682b
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--no-default-features
--features=default-no-clipboard
"

termux_step_pre_configure() {
	termux_setup_rust

	local _CARGO_TARGET_LIBDIR="target/${CARGO_TARGET_NAME}/release/deps"
	mkdir -p $_CARGO_TARGET_LIBDIR

	if [ $TERMUX_ARCH = "i686" ]; then
		RUSTFLAGS+=" -C link-arg=-latomic"
	elif [ $TERMUX_ARCH = "x86_64" ]; then
		pushd $_CARGO_TARGET_LIBDIR
		RUSTFLAGS+=" -C link-arg=$($CC -print-libgcc-file-name)"
		echo "INPUT(-l:libunwind.a)" >libgcc.so
		popd
	fi

	: "${CARGO_HOME:=$HOME/.cargo}"
	export CARGO_HOME

	rm -rf $CARGO_HOME/registry/src/*/libmimalloc-sys-*
	cargo fetch --target "${CARGO_TARGET_NAME}"

	local d p
	p="libmimalloc-sys-tls.diff"
	for d in $CARGO_HOME/registry/src/*/libmimalloc-sys-*; do
		patch --silent -p1 -d ${d} < "${TERMUX_PKG_BUILDER_DIR}/${p}"
	done

	# XXX: Do not enable `mimalloc` feature. It will fetch `libmimalloc-sys`,
	# XXX: which needs to be patched to compile successfully, at building
	# XXX: time. `cargo fetch` will not fetch its source.
	# XXX: Besides, the above `libminalloc-sys` patch is also necessary because
	# XXX: some dependencies of nushell refer to it.
	sed -i 's/"mimalloc",/ /g' $TERMUX_PKG_SRCDIR/Cargo.toml

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

	rm -rf $CARGO_HOME/registry/src/*/libmimalloc-sys-*
}
