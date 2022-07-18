TERMUX_PKG_HOMEPAGE=https://github.com/dalance/amber
TERMUX_PKG_DESCRIPTION="A code search / replace tool"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.5.9
TERMUX_PKG_SRCURL=https://github.com/dalance/amber/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bf974e997fffa0d54463fc85e44f054563372ca4dade50099fb6ecec0ca8c483
TERMUX_PKG_BUILD_IN_SRC=true
# Depend on its subpackages.
TERMUX_PKG_DEPENDS="ambr,ambs"
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust

	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/ambr
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/ambs
}
