# Skeleton build.sh script for new package.
# For reference about available fields, check the Termux Developer's Wiki page:
# https://github.com/termux/termux-packages/wiki/Creating-new-package

TERMUX_PKG_HOMEPAGE=https://openethereum.github.io
TERMUX_PKG_DESCRIPTION="Lightweight Ethereum Client"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.1.0
TERMUX_PKG_SRCURL=https://github.com/openethereum/openethereum/archive/v${TERMUX_PKG_VERSION}.zip
TERMUX_PKG_SHA256=62e577abbeddaeb38071e396847a4fcaa4117709aa2689f0d53005bd4c7d7690
TERMUX_PKG_BUILD_DEPENDS="perl, yasm"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	termux_setup_rust

	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release --features final
	install -Dm755 -t $TERMUX_PREFIX/bin target/release/openethereum
	install -Dm755 -t $TERMUX_PREFIX/bin target/release/openethereum-evm
	install -Dm755 -t $TERMUX_PREFIX/bin target/release/ethstore
	install -Dm755 -t $TERMUX_PREFIX/bin target/release/ethkey
}
