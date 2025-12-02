TERMUX_PKG_HOMEPAGE=https://github.com/leptos-rs/cargo-leptos
TERMUX_PKG_DESCRIPTION="Build tool for the Rust framework Leptos"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.1"
TERMUX_PKG_SRCURL=https://github.com/leptos-rs/cargo-leptos/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=315e90ed7b4119715255b49dafa63ea24d38b6a819e10d44200a6d06c81dcb88
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
	export OPENSSL_NO_VENDOR=1
}
