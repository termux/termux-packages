TERMUX_PKG_HOMEPAGE=https://github.com/leptos-rs/cargo-leptos
TERMUX_PKG_DESCRIPTION="Build tool for the Rust framework Leptos"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.44"
TERMUX_PKG_SRCURL=https://github.com/leptos-rs/cargo-leptos/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=3c68c56ca57e1e4ef5a04956ea300f7730a38950e632c3c29c2429a152cc271a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
	export OPENSSL_NO_VENDOR=1
}
