TERMUX_PKG_HOMEPAGE=https://ohse.de/uwe/software/lrzsz.html
TERMUX_PKG_DESCRIPTION="Tools for zmodem/xmodem/ymodem file transfer"
TERMUX_PKG_VERSION=0.12.20
TERMUX_PKG_SRCURL=https://ohse.de/uwe/releases/lrzsz-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=c28b36b14bddb014d9e9c97c52459852f97bd405f89113f30bee45ed92728ff1
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-syslog --mandir=$TERMUX_PREFIX/share/man"
