TERMUX_PKG_HOMEPAGE=https://www.alsa-project.org
TERMUX_PKG_DESCRIPTION="The Advanced Linux Sound Architecture (ALSA) - utils"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.15.1"
TERMUX_PKG_SRCURL="https://github.com/alsa-project/alsa-utils/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=40737cd5c1c2554d2d0b8863309d91903757e86550c8ed08a85ad4d953ac0856
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="ncurses, alsa-lib"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-udev-rules-dir=$TERMUX_PREFIX/lib/udev/rules.d
--with-asound-state-dir=$TERMUX_PREFIX/var/lib/alsa
--disable-bat
--disable-rst2man
"

termux_step_pre_configure() {
	LDFLAGS+=" -llog"
	export ACLOCAL_PATH="${TERMUX_PREFIX}/share/aclocal"
	autoreconf -fi
}
