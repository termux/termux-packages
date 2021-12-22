TERMUX_PKG_HOMEPAGE=https://ohse.de/uwe/software/lrzsz.html
TERMUX_PKG_DESCRIPTION="Tools for zmodem/xmodem/ymodem file transfer"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.12.21-rc1
_COMMIT=8cb2a6a29f6345f84d5e8248e2d3376166ab844f
TERMUX_PKG_SRCURL=https://github.com/UweOhse/lrzsz/archive/$_COMMIT.tar.gz
TERMUX_PKG_SHA256=56f79c3eb8f6b140693667802d516824c2e115a83d15e1b4d5adbe1deab7c2e0
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-syslog 
--mandir=$TERMUX_PREFIX/share/man
"

termux_step_pre_configure() {
	autoreconf -vfi
}
