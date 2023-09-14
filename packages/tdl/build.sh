TERMUX_PKG_HOMEPAGE="https://github.com/iyear/tdl"
TERMUX_PKG_DESCRIPTION="Telegram downloader written in GO"
TERMUX_PKG_LICENSE="AGPL-3.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.10.0"
TERMUX_PKG_SRCURL="https://github.com/iyear/tdl/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=17fa6e39660d7e09427d3f824ebfa077daa8e2689501c2213f52e22a5971e2d1
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true


termux_step_make() {
        termux_setup_golang
        go build
	}

termux_step_make_install() {
        install -Dm700 -t $TERMUX_PREFIX/bin tdl
}
