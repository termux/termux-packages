TERMUX_PKG_HOMEPAGE=https://salsa.debian.org/minicom-team/minicom
TERMUX_PKG_DESCRIPTION="Friendly menu driven serial communication program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.10"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://salsa.debian.org/minicom-team/minicom/-/archive/${TERMUX_PKG_VERSION}/minicom-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=66ff82661c3cc49ab2e447f8a070ec1a64ba71d64219906d80a49da284a5d43e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP='^[\d.]+$'
TERMUX_PKG_DEPENDS="libiconv, ncurses"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-socket
--disable-music
--enable-lock-dir=$TERMUX_PREFIX/var/run
"

termux_step_pre_configure() {
	export CFLAGS+=" -fcommon"
	CPPFLAGS+=" -Dushort=u_short"
}
