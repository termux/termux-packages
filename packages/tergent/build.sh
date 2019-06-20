TERMUX_PKG_HOMEPAGE=https://github.com/aeolwyr/tergent
TERMUX_PKG_DESCRIPTION="An ssh-agent implementation for Termux that uses Android Keystore as its backend"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=0.1.1
TERMUX_PKG_SHA256=b16e5ba1a9333d6e14b94d8cf3f5ad27d3af124f6f2bbebb0eca62ac95783281
TERMUX_PKG_SRCURL=https://github.com/aeolwyr/tergent/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="termux-api"

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR

	cargo build --target=$CARGO_TARGET_NAME --release

	cp target/$CARGO_TARGET_NAME/release/tergent $TERMUX_PREFIX/bin/tergent
}
