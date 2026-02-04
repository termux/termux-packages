TERMUX_PKG_HOMEPAGE="https://github.com/file-acomplaint/simuwaerm"
TERMUX_PKG_DESCRIPTION="A simple heat transfer simulator in pure Rust"
TERMUX_PKG_GROUPS="science"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.02"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/file-acomplaint/simuwaerm/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=cf3d86e9883e917b9c74ff3d1fc9146197b216b5aa84e84cc188326c8d922ac0
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}
