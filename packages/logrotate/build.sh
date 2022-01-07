TERMUX_PKG_HOMEPAGE=https://github.com/logrotate/logrotate
TERMUX_PKG_DESCRIPTION="Simplify the administration of log files on a system which generates a lot of log files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.19.0
TERMUX_PKG_SRCURL=https://github.com/logrotate/logrotate/releases/download/${TERMUX_PKG_VERSION}/logrotate-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=ddd5274d684c5c99ca724e8069329f343ebe376e07493d537d9effdc501214ba
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libpopt, libandroid-glob"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
