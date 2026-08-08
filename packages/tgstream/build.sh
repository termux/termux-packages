TERMUX_PKG_HOMEPAGE=https://github.com/Soupboy006/tgstream
TERMUX_PKG_DESCRIPTION="Stream Telegram videos without downloading"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@Soupboy006"
TERMUX_PKG_VERSION="0.2.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/Soupboy006/tgstream/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=3a22810215a3cf34fb61ccdf69d3da8c702912f0e5f577ec3c0ad057e712e3e6
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	go build -o tgstream .
}

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin" tgstream
}
