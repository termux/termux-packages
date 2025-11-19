TERMUX_PKG_HOMEPAGE=https://github.com/crowdagger/crowbook
TERMUX_PKG_DESCRIPTION="Allows you to write a book in Markdown without worrying about formatting or typography"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.17.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/crowdagger/crowbook/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=13c628722fedf1bfebc0fd334e9ffa41a62888e3195d2ad1e5ea851694dc4a4c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_PKG_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/crowbook
}
