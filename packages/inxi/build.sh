TERMUX_PKG_HOMEPAGE=https://smxi.org/site/about.htm#inxi
TERMUX_PKG_DESCRIPTION="Full featured CLI system information tool"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.3.37-1"
TERMUX_PKG_SRCURL=https://codeberg.org/smxi/inxi/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=da730f84f4a2ca53bab471860a83995c9d498bb34c2518fbb7ff65ee705e048e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -Dm700 -t "$TERMUX_PREFIX/bin/" inxi
	install -Dm600 -t "$TERMUX_PREFIX/share/man/man1/" inxi.1
}
