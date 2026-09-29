TERMUX_PKG_HOMEPAGE=https://github.com/atanunq/viu
TERMUX_PKG_DESCRIPTION="Terminal image viewer with native support for iTerm and Kitty"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.6.1"
TERMUX_PKG_SRCURL=https://github.com/atanunq/viu/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=639c1fe14aee5e34b635de041ac77177e2959cf26072d8ef69c444b15c8273bd
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust

	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/viu
}
