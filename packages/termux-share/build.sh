TERMUX_PKG_HOMEPAGE=https://github.com/BullLazy/termux-share
TERMUX_PKG_DESCRIPTION="Share text, URLs, clipboard, and piped data from the terminal via Android's share menu"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@BullLazy"
TERMUX_PKG_VERSION="2.1"
TERMUX_PKG_SRCURL=$TERMUX_PKG_HOMEPAGE/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=SKIP
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
    install -Dm700 termux-share "$TERMUX_PREFIX/bin/termux-share"
}
