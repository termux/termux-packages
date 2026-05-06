TERMUX_PKG_HOMEPAGE="https://github.com/asciinema/agg"
TERMUX_PKG_DESCRIPTION="asciinema gif generator"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.1"
TERMUX_PKG_SRCURL="https://github.com/asciinema/agg/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=9a2a7e6ca2748befb6a4c1c3eff437ae6029fde99ec882a951b3671aa30eacdb
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RECOMMENDS="asciinema"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}
