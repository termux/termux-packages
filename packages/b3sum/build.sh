TERMUX_PKG_HOMEPAGE=https://github.com/BLAKE3-team/BLAKE3/tree/master/b3sum
TERMUX_PKG_DESCRIPTION="A command line utility for calculating BLAKE3 hashes, similar to Coreutils tools like b2sum or md5sum"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.0"
TERMUX_PKG_SRCURL=https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b9f565adc6e2c8c813dafd6d5406a71382f7ac6aa3250b19e9d8a68c457fd769
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust

	cd $TERMUX_PKG_SRCDIR/b3sum

	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm755 -t $TERMUX_PREFIX/bin $TERMUX_PKG_SRCDIR/b3sum/target/${CARGO_TARGET_NAME}/release/b3sum
}
