TERMUX_PKG_HOMEPAGE=https://github.com/agnostic-apollo/sudo
TERMUX_PKG_DESCRIPTION="A su wrapper for Termux"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@agnostic-apollo"
TERMUX_PKG_VERSION=0.2.0
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_SRCURL=https://github.com/agnostic-apollo/sudo/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d6d36c69c588feb3281fd9dd1d0ed73b5ab87416e823ee5e8733351dd15ae064
TERMUX_PKG_REPLACES=tsu
TERMUX_PKG_BREAKS=tsu

termux_step_make_install() {
	install -Dm755 sudo "$TERMUX_PREFIX/bin"
}
