TERMUX_PKG_HOMEPAGE=http://jetmore.org/john/code/swaks/
TERMUX_PKG_DESCRIPTION="Swiss Army Knife for SMTP"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=20190914.0
TERMUX_PKG_SRCURL=https://github.com/jetmore/swaks/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=0ea331fdb036dda84bd67b4c9800250521d13224c2ccf0455f90d11e57facc5f
TERMUX_PKG_DEPENDS="perl"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_make_install() {
	install -Dm700 swaks "$TERMUX_PREFIX"/bin/swaks
}
