TERMUX_PKG_HOMEPAGE=https://trunkrs.dev/
TERMUX_PKG_DESCRIPTION="Build, bundle & ship your Rust WASM application to the web"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.22.1"
TERMUX_PKG_SRCURL=https://github.com/trunk-rs/trunk/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b93e82dcb8cb3de8a6762d9d2df60a22b8e0db73c504edfcfabeb8017997bf1d
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
