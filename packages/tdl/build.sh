TERMUX_PKG_HOMEPAGE=https://github.com/iyear/tdl
TERMUX_PKG_DESCRIPTION="Telegram downloader written in GO"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.11.1"
TERMUX_PKG_SRCURL=https://github.com/iyear/tdl/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0048003955D674583B0B7B05771F81341E2A5A15E2E4E9FB09C11814F984B617
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true


termux_step_make() {
        termux_setup_golang
        go build
	}

termux_step_make_install() {
        install -Dm700 -t $TERMUX_PREFIX/bin tdl
}
