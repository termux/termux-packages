TERMUX_PKG_HOMEPAGE=https://crates.io
TERMUX_PKG_VERSION=0.18.0
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_SRCURL=https://github.com/rust-lang/cargo/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=19b5c142c194fc2f940d93b4679850980ed077db0ff7c558122c7ef865e24983
TERMUX_PKG_DEPENDS="libcurl, rustc, openssl, libgit2"
TERMUX_PKG_DESCRIPTION="Rust package manager"
TERMUX_PKG_FOLDERNAME=cargo-$TERMUX_PKG_VERSION
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--release-channel=stable
--enable-optimize
--disable-cross-tests
--disable-option-checking
--disable-verify-install
--enable-build-openssl
"

termux_step_pre_configure () {
	termux_setup_rust

	_commit=4f994850808a572e2cc8d43f968893c8e942e9bf
	RUST_INSTALLER_FILE=$TERMUX_PKG_CACHEDIR/rust-installer-$_commit.tar.gz
	test ! -f $RUST_INSTALLER_FILE && termux_download https://github.com/rust-lang/rust-installer/archive/$_commit.tar.gz \
		$RUST_INSTALLER_FILE \
		dc7240d60a869fa24a68c8734fb7c810c27cca0a6dad52df6279865e4e8e7fae
	rmdir $TERMUX_PKG_SRCDIR/src/rust-installer
	tar -xf $TERMUX_PKG_CACHEDIR/rust-installer-$_commit.tar.gz -C $TERMUX_PKG_TMPDIR
	mv $TERMUX_PKG_TMPDIR/`basename $RUST_INSTALLER_FILE .tar.gz` $TERMUX_PKG_SRCDIR/src/rust-installer

	export PKG_CONFIG_ALLOW_CROSS=1
	export LIBGIT2_SYS_USE_PKG_CONFIG=1
}

termux_step_post_make_install () {
	rm -f $TERMUX_PREFIX/lib/rustlib/{install.log,manifest-cargo,uninstall.sh}
}
