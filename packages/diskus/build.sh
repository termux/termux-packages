TERMUX_PKG_HOMEPAGE=https://github.com/sharkdp/diskus
TERMUX_PKG_DESCRIPTION="A minimal, fast alternative to 'du -sh'"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.9.0"
TERMUX_PKG_SRCURL=https://github.com/sharkdp/diskus/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c4c9e4cd3cda25f55172130e3d6a58b389f0113fcefa96c73e4c80565547d1bf
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_rust
}
