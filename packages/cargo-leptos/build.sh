TERMUX_PKG_HOMEPAGE=https://github.com/leptos-rs/cargo-leptos
TERMUX_PKG_DESCRIPTION="Build tool for the Rust framework Leptos"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.45"
TERMUX_PKG_SRCURL=https://github.com/leptos-rs/cargo-leptos/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b44a291da688866f27f1c2b163c18125f741a837776339965e6352af4e11d21c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
	export OPENSSL_NO_VENDOR=1
}
