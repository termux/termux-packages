TERMUX_PKG_HOMEPAGE=https://www.rust-lang.org
TERMUX_PKG_DEPENDS="libllvm, clang"
TERMUX_PKG_VERSION=1.19.0
TERMUX_PKG_SHA256=392148ab52db6299c46df6f48f066b7bdf9a7af9775fb05571984ff500f7f9ad
TERMUX_PKG_SRCURL=https://static.rust-lang.org/dist/rustc-$TERMUX_PKG_VERSION-src.tar.xz
TERMUX_PKG_DESCRIPTION="A safe, concurrent, practical language."
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_KEEP_SHARE_DOC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-option-checking
--disable-optimize-tests
--disable-debuginfo-tests
--disable-codegen-tests
--enable-llvm-link-shared
--enable-clang
--disable-jemalloc
--enable-local-rust
--enable-local-rebuild
"
termux_step_pre_configure () {
	termux_setup_rust

	# most configuration is done with this file
	sed $TERMUX_PKG_BUILDER_DIR/config.toml \
		-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		-e "s|@TERMUX_HOST_PLATFORM@|$TERMUX_HOST_PLATFORM|g" \
		-e "s|@RUST_TARGET_TRIPLE@|$RUST_TARGET_TRIPLE|g" > $TERMUX_PKG_BUILDDIR/config.toml

	unset CFLAGS CXXFLAGS LDFLAGS CC CXX LD
	# hack for some build hosts to get stage0 to compile
	export LDFLAGS="-L/usr/lib"
	export _arch_args="--target=$RUST_TARGET_TRIPLE --host=$RUST_TARGET_TRIPLE"

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" $_arch_args --local-rust-root=$RUSTUP_HOME"
}

termux_step_make () {
	$TERMUX_PKG_SRCDIR/x.py build -j $TERMUX_MAKE_PROCESSES $_arch_args
}

termux_step_make_install () {
	$TERMUX_PKG_SRCDIR/x.py dist $_arch_args

	mkdir -p $TERMUX_PKG_BUILDDIR/install
	for tar in rustc rust-docs rust-std; do
		tar -xf $TERMUX_PKG_BUILDDIR/build/dist/$tar-$TERMUX_PKG_VERSION-$RUST_TARGET_TRIPLE.tar.gz -C $TERMUX_PKG_BUILDDIR/install
		# uninstall previous version
		$TERMUX_PKG_BUILDDIR/install/$tar-$TERMUX_PKG_VERSION-$RUST_TARGET_TRIPLE/install.sh --uninstall --prefix=$TERMUX_PREFIX || true
		$TERMUX_PKG_BUILDDIR/install/$tar-$TERMUX_PKG_VERSION-$RUST_TARGET_TRIPLE/install.sh --prefix=$TERMUX_PREFIX
	done

	cd "$TERMUX_PREFIX/lib"
	ln -sf rustlib/$RUST_TARGET_TRIPLE/lib/*.so .
}

termux_step_post_massage () {
	rm $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/rustlib/{components,rust-installer-version,install.log,uninstall.sh}
}
