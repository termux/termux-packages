TERMUX_PKG_HOMEPAGE="https://github.com/itchyny/bed"
TERMUX_PKG_DESCRIPTION="Binary editor written in GO"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.2.9"
TERMUX_PKG_SRCURL="https://github.com/itchyny/bed/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=c163cc9d851db280e85adc2d5218ffad9a39c79f6f874c0d9dfaff939b6cd9ca
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true


termux_step_make() {
	termux_setup_golang
	go build -ldflags="-s -w" -o bed ./cmd/bed
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin bed
}
