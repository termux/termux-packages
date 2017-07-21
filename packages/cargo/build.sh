TERMUX_PKG_HOMEPAGE=https://crates.io
TERMUX_PKG_VERSION=0.20.0
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_SRCURL=https://github.com/rust-lang/cargo/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f0e21d23cffd3510ba8a65e6a4d1010073afc0e573d9d92c23d22b868ca0bc42
TERMUX_PKG_DEPENDS="libcurl, rustc, openssl, libgit2, libssh2"
TERMUX_PKG_DESCRIPTION="Rust package manager"
TERMUX_PKG_FOLDERNAME=cargo-$TERMUX_PKG_VERSION
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure () {
	termux_setup_rust
	termux_setup_cmake

	export PKG_CONFIG_ALLOW_CROSS=1
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
}

termux_step_make_install () {
	mkdir -p $TERMUX_PREFIX/{bin,etc/bash_completion.d,share/man/man1,share/zsh/site-functions}
	local _mode="release"
	test -n "$TERMUX_DEBUG" && _mode="debug"
	cp $TERMUX_PKG_BUILDDIR/target/$RUST_TARGET_TRIPLE/$_mode/cargo $TERMUX_PREFIX/bin/cargo
	cp $TERMUX_PKG_SRCDIR/src/etc/cargo.bashcomp.sh $TERMUX_PREFIX/etc/bash_completion.d/cargo
	cp $TERMUX_PKG_SRCDIR/src/etc/man/* $TERMUX_PREFIX/share/man/man1/
	cp $TERMUX_PKG_SRCDIR/src/etc/_cargo $TERMUX_PREFIX/share/zsh/site-functions/_cargo
}
