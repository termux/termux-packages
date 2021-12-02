TERMUX_PKG_HOMEPAGE=https://mailutils.org/
TERMUX_PKG_DESCRIPTION="Mailutils is a swiss army knife of electronic mail handling. "
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@suhan-paradkar"
TERMUX_PKG_VERSION=3.13
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/mailutils/mailutils-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=d920971dcb49878a009911774fd6404f13d27bd101e2d59b664a28659a4094c7
TERMUX_PKG_BUILD_DEPENDS="libandroid-glob, libcrypt"

termux_step_pre_configure() {
	export LIBS="-landroid-glob"
}
