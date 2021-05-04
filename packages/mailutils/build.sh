TERMUX_PKG_HOMEPAGE=https://mailutils.org/
TERMUX_PKG_DESCRIPTION="Mailutils is a swiss army knife of electronic mail handling. "
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@suhan-paradkar"
TERMUX_PKG_VERSION=3.12
TERMUX_PKG_SRCURL=https://ftp.gnu.org/gnu/mailutils/mailutils-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_SHA256=6d43fa217c4ac63f057de87890c562d170bb92bc402368b5fbc579e4c2b3a158
TERMUX_PKG_BUILD_DEPENDS="libandroid-glob, libcrypt"

termux_step_pre_configure() {
	export LIBS="-landroid-glob"
}
