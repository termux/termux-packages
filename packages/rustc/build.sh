TERMUX_PKG_HOMEPAGE=https://www.rust-lang.org
TERMUX_PKG_DEPENDS="libllvm, clang"
TERMUX_PKG_VERSION=1.17.0
TERMUX_PKG_SHA256=4baba3895b75f2492df6ce5a28a916307ecd1c088dc1fd02dbfa8a8e86174f87
TERMUX_PKG_SRCURL=https://static.rust-lang.org/dist/rustc-$TERMUX_PKG_VERSION-src.tar.gz
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
_bootstrap_args="
-j $TERMUX_MAKE_PROCESSES
--host $TERMUX_HOST_PLATFORM
--target $TERMUX_HOST_PLATFORM
"

termux_step_pre_configure () {
	termux_setup_rust

	# most configuration is done with this file
	sed $TERMUX_PKG_BUILDER_DIR/config.toml \
		-e "s|@TERMUX_PREFIX@|$TERMUX_PREFIX|g" \
		-e "s|@TERMUX_HOST_PLATFORM@|$TERMUX_HOST_PLATFORM|g" > $TERMUX_PKG_BUILDDIR/config.toml

	unset CFLAGS CXXFLAGS LDFLAGS CC CXX LD
	# hack for some build hosts to get stage0 to compile
	export LDFLAGS="-L/usr/lib"

	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --target=$TERMUX_HOST_PLATFORM --host=$TERMUX_HOST_PLATFORM --local-rust-root=$RUSTUP_HOME"
}

termux_step_make () {
	$TERMUX_PKG_SRCDIR/x.py build $_bootstrap_args
}

termux_step_make_install () {
	$TERMUX_PKG_SRCDIR/x.py dist $_bootstrap_args

	mkdir -p $TERMUX_PKG_BUILDDIR/install
	for tar in rustc rust-docs rust-std; do
		tar -xf $TERMUX_PKG_BUILDDIR/build/dist/$tar-$TERMUX_PKG_VERSION-$TERMUX_HOST_PLATFORM.tar.gz -C $TERMUX_PKG_BUILDDIR/install
		# uninstall previous version
		$TERMUX_PKG_BUILDDIR/install/$tar-$TERMUX_PKG_VERSION-$TERMUX_HOST_PLATFORM/install.sh --uninstall --prefix=$TERMUX_PREFIX || true
		$TERMUX_PKG_BUILDDIR/install/$tar-$TERMUX_PKG_VERSION-$TERMUX_HOST_PLATFORM/install.sh --prefix=$TERMUX_PREFIX
	done

	cd "$TERMUX_PREFIX/lib"
	ln -sf rustlib/$TERMUX_HOST_PLATFORM/lib/*.so .
}

termux_step_post_massage () {
	rm $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/rustlib/{components,rust-installer-version,install.log,uninstall.sh}
}
