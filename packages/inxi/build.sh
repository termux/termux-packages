TERMUX_PKG_HOMEPAGE=https://github.com/smxi/inxi
TERMUX_PKG_DESCRIPTION="Full featured CLI system information tool"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.3.04-1
TERMUX_PKG_SRCURL=https://github.com/smxi/inxi/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1f029f5f667e0396ab9f6ba2c51cf7937ea38bf504d1621a8c50e19205a7a671
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin/ inxi
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1/ inxi.1
}
