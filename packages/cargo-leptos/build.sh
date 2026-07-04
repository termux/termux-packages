TERMUX_PKG_HOMEPAGE=https://github.com/leptos-rs/cargo-leptos
TERMUX_PKG_DESCRIPTION="Build tool for the Rust framework Leptos"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.3.7"
TERMUX_PKG_SRCURL=https://github.com/leptos-rs/cargo-leptos/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=358d383bce6db9286301f2cfef148bc9085bb9dad8a8fb52a199ead6cb03599d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
	export OPENSSL_NO_VENDOR=1
}
