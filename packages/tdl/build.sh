TERMUX_PKG_HOMEPAGE=https://docs.iyear.me/tdl/
TERMUX_PKG_DESCRIPTION="Telegram downloader/tools written in Golang"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.16.1"
TERMUX_PKG_SRCURL=https://github.com/iyear/tdl/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=b701f1cb51b906b25f19e811f30115bd6c624fc5339569baa5819be3a6a34d4a
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin tdl
}
