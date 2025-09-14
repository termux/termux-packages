TERMUX_PKG_HOMEPAGE=https://github.com/logrotate/logrotate
TERMUX_PKG_DESCRIPTION="Simplify the administration of log files on a system which generates a lot of log files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.22.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/logrotate/logrotate/releases/download/${TERMUX_PKG_VERSION}/logrotate-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=42b4080ee99c9fb6a7d12d8e787637d057a635194e25971997eebbe8d5e57618
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libpopt, libandroid-glob"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
