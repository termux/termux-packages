TERMUX_PKG_HOMEPAGE=https://github.com/mozilla/sccache
TERMUX_PKG_DESCRIPTION="sccache is ccache with cloud storage"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.1"
TERMUX_PKG_SRCURL=https://github.com/mozilla/sccache/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=30b951b49246d5ca7d614e5712215cb5f39509d6f899641f511fb19036b5c4e5
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_rust
	cargo build --jobs $TERMUX_MAKE_PROCESSES --target $CARGO_TARGET_NAME --release
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin target/${CARGO_TARGET_NAME}/release/sccache
}
