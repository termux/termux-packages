TERMUX_PKG_HOMEPAGE=http://projects.l3ib.org/nitrogen/
TERMUX_PKG_DESCRIPTION="Background browser and setter for X windows."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_SRCURL=https://github.com/l3ib/nitrogen/releases/download/${TERMUX_PKG_VERSION}/nitrogen-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f40213707b7a3be87e556f65521cef8795bd91afda13dfac8f00c3550375837d
TERMUX_PKG_DEPENDS="gtkmm2, gtk2"
TERMUX_PKG_BUILD_DEPENDS="gtkmm2, gtk2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
  CFLAGS+=" -I${TERMUX_PREFIX}/include"
  autoreconf -fi
}
