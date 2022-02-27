TERMUX_PKG_HOMEPAGE=https://github.com/o2sh/onefetch
TERMUX_PKG_DESCRIPTION="A command-line Git information tool written in Rust"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@ELWAER-M"
TERMUX_PKG_VERSION=2.11.0
TERMUX_PKG_SRCURL=https://github.com/o2sh/onefetch/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ffd3cc3bd24e299ede1fada2b2da8bf066d59219da167477e1997c860650c192
TERMUX_PKG_DEPENDS="libgit2"
TERMUX_PKG_BUILD_IN_SRC=true
	
termux_step_make() {
    termux_setup_rust
	cargo build \
		--jobs $TERMUX_MAKE_PROCESSES \
		--target $CARGO_TARGET_NAME \
		--release
}
	
termux_step_make_install() {
	install -Dm700 target/"${CARGO_TARGET_NAME}"/release/onefetch "$TERMUX_PREFIX"/bin
}
