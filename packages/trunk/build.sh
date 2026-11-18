TERMUX_PKG_HOMEPAGE="https://github.com/trunk-rs/trunk"
TERMUX_PKG_DESCRIPTION="Build, bundle & ship your Rust WASM application to the web"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.22.2"
TERMUX_PKG_SRCURL=https://github.com/trunk-rs/trunk/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=66a57a27d156181f8268a15c53755bf09f6119127de71b4a1f059badf80b9a90
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
