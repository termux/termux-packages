TERMUX_PKG_HOMEPAGE=https://smxi.org/site/about.htm#inxi
TERMUX_PKG_DESCRIPTION="Full featured CLI system information tool"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.3.39-1"
TERMUX_PKG_SRCURL=https://codeberg.org/smxi/inxi/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c0441f21dc5ea365a6d63466070d00e6858aed3b3c42276a1bf18ab3c57c013c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin/" inxi
	install -Dm600 -t "$TERMUX_PREFIX/share/man/man1/" inxi.1
}
