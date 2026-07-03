TERMUX_PKG_HOMEPAGE=https://github.com/sharkdp/vivid
TERMUX_PKG_DESCRIPTION="A themeable LS_COLORS generator with a rich filetype datebase"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.1"
TERMUX_PKG_SRCURL=https://github.com/sharkdp/vivid/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a43ccfbc6554055181a08f2740664f9280fa2d0e57c4641850c60dd0e5323720
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}
