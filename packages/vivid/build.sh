TERMUX_PKG_HOMEPAGE=https://github.com/sharkdp/vivid
TERMUX_PKG_DESCRIPTION="A themeable LS_COLORS generator with a rich filetype datebase"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.0"
TERMUX_PKG_SRCURL=https://github.com/sharkdp/vivid/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2d31f72ac9df81ddc8b5ecb9e5e539c754c22863ada3e76e4c1a88ee53c99a21
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}
