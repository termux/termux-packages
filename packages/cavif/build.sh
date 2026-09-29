TERMUX_PKG_HOMEPAGE="https://lib.rs/cavif"
TERMUX_PKG_DESCRIPTION="AVIF image creator in pure Rust"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.0"
TERMUX_PKG_SRCURL="https://github.com/kornelski/cavif-rs/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=5357cae1e36990311c97a4dfbd897a373ba12025c3c1f56f8f11f451583b82f0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BREAKS="cavif-rs"
TERMUX_PKG_REPLACES="cavif-rs"

termux_step_pre_configure() {
	termux_setup_rust
}
