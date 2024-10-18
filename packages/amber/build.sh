TERMUX_PKG_HOMEPAGE=https://github.com/dalance/amber
TERMUX_PKG_DESCRIPTION="A code search / replace tool"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.6.0
TERMUX_PKG_SRCURL=https://github.com/dalance/amber/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=41908502077197f55ec86b3a4dd4059a78deae9833e9ba33302b1146cc1ec3f5
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_REPLACES="amr, ambs"
TERMUX_PKG_BREAKS="amr, ambs"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust

	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/ambr
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/ambs
}
