TERMUX_PKG_HOMEPAGE=https://ohse.de/uwe/software/lrzsz.html
TERMUX_PKG_DESCRIPTION="z modem file transfer over serial terminal"
TERMUX_PKG_VERSION=0.12.20
TERMUX_PKG_SRCURL=https://ohse.de/uwe/releases/lrzsz-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-syslog"

