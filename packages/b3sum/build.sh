TERMUX_PKG_HOMEPAGE=https://github.com/BLAKE3-team/BLAKE3/tree/master/b3sum
TERMUX_PKG_DESCRIPTION="Systems programming language focused on safety, speed and concurrency"
TERMUX_PKG_LICENSE="CC0-1.0"
TERMUX_PKG_MAINTAINER="@medzikuser"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_SRCURL=https://github.com/BLAKE3-team/BLAKE3/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=f13468889833c88e744ad579c5d8fbb7ecb53216159b54481a90e5dcdaa9e320

termux_step_configure() {
	termux_setup_rust
}

termux_step_make() {
	cd $TERMUX_PKG_SRCDIR/b3sum
	cargo build --release --host $CARGO_TARGET_NAME
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin $TERMUX_PKG_SRCDIR/b3sum/target/release/b3sum
}
