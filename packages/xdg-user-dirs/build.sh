TERMUX_PKG_HOMEPAGE="https://www.freedesktop.org/wiki/Software/xdg-user-dirs"
TERMUX_PKG_DESCRIPTION="Manage user directories like ~/Desktop and ~/Music"
TERMUX_PKG_LICENSE="GPL-3.0-only, LGPL-3.0-only"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.20"
TERMUX_PKG_SRCURL="https://gitlab.freedesktop.org/xdg/xdg-user-dirs/-/archive/v${TERMUX_PKG_VERSION}/xdg-user-dirs-v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256="988d3f3274cb2b69796ace22ddbb0abfc2c0157fff65258045f055cfba024d6e"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libc++, libiconv"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--sysconfdir=$TERMUX_PREFIX/etc
-Dnls=false
-Ddocs=false
"

termux_step_pre_configure() {
	LDFLAGS+=" -liconv"
}
