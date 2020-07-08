TERMUX_PKG_HOMEPAGE=https://github.com/cronie-crond/cronie/
TERMUX_PKG_DESCRIPTION="Daemon that runs specified programs at scheduled times and related tools"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_VERSION=1.5.5
TERMUX_PKG_SRCURL=https://github.com/cronie-crond/cronie/releases/download/cronie-${TERMUX_PKG_VERSION}/cronie-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=be34c79505e5544323281854744b9955ff16b160ee569f9df7c0dddae5720eac
TERMUX_PKG_DEPENDS="bash"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-anacron --disable-pam"
