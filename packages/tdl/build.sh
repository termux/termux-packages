TERMUX_PKG_HOMEPAGE=https://github.com/iyear/tdl
TERMUX_PKG_DESCRIPTION="Telegram downloader written in GO"
TERMUX_PKG_LICENSE="AGPL-V3"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.13.0"
TERMUX_PKG_SRCURL=https://github.com/iyear/tdl/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=415ceeb7b2ab2e3627c9064275a7e0fd5c42200c2f12bfe09d0703d650747c0d
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin tdl
}
