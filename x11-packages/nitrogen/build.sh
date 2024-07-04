TERMUX_PKG_HOMEPAGE=http://projects.l3ib.org/nitrogen/
TERMUX_PKG_DESCRIPTION="Background browser and setter for X windows"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.6.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/l3ib/nitrogen/releases/download/${TERMUX_PKG_VERSION}/nitrogen-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f40213707b7a3be87e556f65521cef8795bd91afda13dfac8f00c3550375837d
TERMUX_PKG_DEPENDS="libc++, gtkmm2, gtk2"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" -I${TERMUX_PREFIX}/include"
	# Fix "error: no member named bind2nd in namespace std" (bind2nd was removed in c++17):
	CXXFLAGS+=" -std=c++14"
	autoreconf -fi
}
