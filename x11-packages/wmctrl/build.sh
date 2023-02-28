TERMUX_PKG_HOMEPAGE=https://sites.google.com/site/tstyblo/wmctrl/
TERMUX_PKG_DESCRIPTION="A UNIX/Linux command line tool to interact with an EWMH/NetWM compatible X Window Manager"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.07
TERMUX_PKG_SRCURL=https://sites.google.com/site/tstyblo/wmctrl/wmctrl-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d78a1efdb62f18674298ad039c5cbdb1edb6e8e149bb3a8e3a01a4750aa3cca9
TERMUX_PKG_DEPENDS="glib, libx11, libxmu"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--mandir=$TERMUX_PREFIX/share/man
"
