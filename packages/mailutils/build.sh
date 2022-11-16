TERMUX_PKG_HOMEPAGE=https://mailutils.org/
TERMUX_PKG_DESCRIPTION="Mailutils is a swiss army knife of electronic mail handling. "
TERMUX_PKG_LICENSE="LGPL-3.0, GPL-3.0"
TERMUX_PKG_MAINTAINER="@suhan-paradkar"
TERMUX_PKG_VERSION=3.15
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/mailutils/mailutils-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=b7d0c286c352fcc7da7978cfd617cc66736b21fa891aa4f88855f516354f2ddb
TERMUX_PKG_DEPENDS="libandroid-glob, libcrypt"

termux_step_pre_configure() {
	export LIBS="-landroid-glob"
}
