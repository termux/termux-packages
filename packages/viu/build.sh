TERMUX_PKG_HOMEPAGE=https://github.com/atanunq/viu
TERMUX_PKG_DESCRIPTION="Terminal image viewer with native support for iTerm and Kitty"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE-MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.0
TERMUX_PKG_REVISION=0
TERMUX_PKG_SRCURL=https://github.com/atanunq/viu/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9b359c2c7e78d418266654e4c94988b0495ddea62391fcf51512038dd3109146
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust

	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/viu
}
