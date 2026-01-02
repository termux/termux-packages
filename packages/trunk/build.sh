TERMUX_PKG_HOMEPAGE=https://trunkrs.dev/
TERMUX_PKG_DESCRIPTION="Build, bundle & ship your Rust WASM application to the web"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.21.14"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/trunk-rs/trunk/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=8687bcf96bdc4decee88458745bbb760ad31dfd109e955cf455c2b64caeeae2f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="openssl, bzip2"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--no-default-features
--features native-tls
"

termux_step_pre_configure() {
	termux_setup_rust
}
