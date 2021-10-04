TERMUX_PKG_HOMEPAGE=https://github.com/xiph/rav1e/
TERMUX_PKG_DESCRIPTION="An AV1 encoder library focused on speed and safety"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/xiph/rav1e/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b0be59435a40e03b973ecc551ca7e632e03190b5a20f944818afa3c2ecf4852d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_AUTO_UPDATE_TAG_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BUILD_IN_SRC=true


termux_step_post_make_install(){
	# required for librav1e
	(
		unset LDFLAGS
		cargo install cargo-c --features=vendored-openssl
	)

	# `cargo cinstall` refuses to work with Android
	cargo cbuild \
		--release \
		--prefix $TERMUX_PREFIX \
		--jobs $TERMUX_MAKE_PROCESSES \
		--locked \
		--target $CARGO_TARGET_NAME \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS

	cd target/$CARGO_TARGET_NAME/release/
	mkdir -p $TERMUX_PREFIX/include/rav1e/
	cp rav1e.h $TERMUX_PREFIX/include/rav1e/
	mkdir -p $TERMUX_PREFIX/lib/pkgconfig/
	cp rav1e.pc $TERMUX_PREFIX/lib/pkgconfig/
	cp librav1e.a $TERMUX_PREFIX/lib/
	cp librav1e.so $TERMUX_PREFIX/lib/librav1e.so.$TERMUX_PKG_VERSION
	ln -s librav1e.so.$TERMUX_PKG_VERSION \
		$TERMUX_PREFIX/lib/librav1e.so.${TERMUX_PKG_VERSION%%.*}
	ln -s librav1e.so.$TERMUX_PKG_VERSION $TERMUX_PREFIX/lib/librav1e.so

	# https://github.com/rust-lang/cargo/issues/3316:
	rm -f $TERMUX_PREFIX/.crates.toml
	rm -f $TERMUX_PREFIX/.crates2.json
}
