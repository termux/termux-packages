TERMUX_PKG_HOMEPAGE="https://lib.rs/cavif"
TERMUX_PKG_DESCRIPTION="AVIF image creator in pure Rust"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.5.6"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/kornelski/cavif-rs/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=a5ddb99a10d052e2ccb2999eb9e7ddf37f999f03e2b684744f5ca69cdef2e814
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BREAKS="cavif-rs"
TERMUX_PKG_REPLACES="cavif-rs"

termux_step_pre_configure() {
	termux_setup_rust
}
