TERMUX_PKG_HOMEPAGE=http://distcc.org/
TERMUX_PKG_DESCRIPTION="Distributed C/C++ compiler."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.4
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/distcc/distcc/releases/download/v$TERMUX_PKG_VERSION/distcc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2b99edda9dad9dbf283933a02eace6de7423fe5650daa4a728c950e5cd37bd7d
TERMUX_PKG_DEPENDS="libpopt"
TERMUX_PKG_BUILD_IN_SRC=true

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-pump-mode
--without-avahi
--without-gtk
--without-libiberty"

termux_step_pre_configure() {
	./autogen.sh
	export LIBS="-llog"
}
