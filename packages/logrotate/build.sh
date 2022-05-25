TERMUX_PKG_HOMEPAGE=https://github.com/logrotate/logrotate
TERMUX_PKG_DESCRIPTION="Simplify the administration of log files on a system which generates a lot of log files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.20.0"
TERMUX_PKG_SRCURL=https://github.com/logrotate/logrotate/releases/download/${TERMUX_PKG_VERSION}/logrotate-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=99dbaf276c68b0bcde116aef4f11f160e87deb85686229c4f7e7ef7fcc8205fc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libpopt, libandroid-glob"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
