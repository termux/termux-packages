TERMUX_PKG_HOMEPAGE="https://github.com/asciinema/agg"
TERMUX_PKG_DESCRIPTION="asciinema gif generator"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.0"
TERMUX_PKG_SRCURL="https://github.com/asciinema/agg/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=31e0d54b6abc2c7545464bef0b5b9603d851c186c4ecfcd52f08a30d7bfa2781
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_RECOMMENDS="asciinema"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}
