TERMUX_PKG_HOMEPAGE=https://github.com/logrotate/logrotate
TERMUX_PKG_DESCRIPTION="Simplify the administration of log files on a system which generates a lot of log files"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.21.0"
TERMUX_PKG_SRCURL=https://github.com/logrotate/logrotate/releases/download/${TERMUX_PKG_VERSION}/logrotate-${TERMUX_PKG_VERSION}.tar.xz
TERMUX_PKG_SHA256=8fa12015e3b8415c121fc9c0ca53aa872f7b0702f543afda7e32b6c4900f6516
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libpopt, libandroid-glob"

termux_step_pre_configure() {
	LDFLAGS+=" -landroid-glob"
}
