TERMUX_PKG_HOMEPAGE=https://github.com/vapier/ncompress
TERMUX_PKG_DESCRIPTION="The classic unix compression utility which can handle the ancient .Z archive"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.2.4.6
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/vapier/ncompress/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=112acfc76382e7b631d6cfc8e6ff9c8fd5b3677e5d49d3d9f1657bc15ad13d13
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	mkdir -p "$TERMUX_PREFIX"/share/man/man1/
	install -Dm700 compress "$TERMUX_PREFIX"/bin/
	install -Dm600 compress.1 "$TERMUX_PREFIX"/share/man/man1/
}
