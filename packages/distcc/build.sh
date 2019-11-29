TERMUX_PKG_HOMEPAGE=http://distcc.org/
TERMUX_PKG_DESCRIPTION="Distributed C/C++ compiler."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=3.3.3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/distcc/distcc/releases/download/v$TERMUX_PKG_VERSION/distcc-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=bead25471d5a53ecfdf8f065a6fe48901c14d5008956c318c700e56bc87bf0bc
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
