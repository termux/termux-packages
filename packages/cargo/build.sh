TERMUX_PKG_HOMEPAGE=https://crates.io
TERMUX_PKG_VERSION=0.19.0
TERMUX_PKG_MAINTAINER="Vishal Biswas @vishalbiswas"
TERMUX_PKG_SRCURL=https://github.com/rust-lang/cargo/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=9ea59d17a7fa81aa4bdefa2bb45a5315219414386753eaf0988cadd465550b40
TERMUX_PKG_DEPENDS="libcurl, rustc, openssl, libgit2, libssh2"
TERMUX_PKG_DESCRIPTION="Rust package manager"
TERMUX_PKG_FOLDERNAME=cargo-$TERMUX_PKG_VERSION
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--release-channel=stable
--enable-optimize
--disable-cross-tests
--disable-option-checking
--disable-verify-install
--disable-build-openssl
"

termux_step_pre_configure () {
	termux_setup_rust
	termux_setup_cmake

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

termux_step_post_massage () {
	rm $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/lib/rustlib/{components,rust-installer-version,install.log,uninstall.sh}
}
