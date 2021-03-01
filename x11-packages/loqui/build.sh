TERMUX_PKG_HOMEPAGE=https://launchpad.net/loqui
TERMUX_PKG_DESCRIPTION="IRC client for the Gtk+-2.0 environment"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=0.6.4
TERMUX_PKG_REVISION=23
TERMUX_PKG_SRCURL=https://launchpad.net/loqui/${TERMUX_PKG_VERSION:0:3}/${TERMUX_PKG_VERSION}/+download/loqui-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=d0718f0eb095fbfe2af1b4ca5a0d05cd85e969322be3f5bc9fad26f042910b36
TERMUX_PKG_DEPENDS="atk, fontconfig, freetype, gdk-pixbuf, glib, gtk2, libandroid-shmem, libcairo, libffi, pango, pcre"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-glibtest --disable-gtktest"
TERMUX_PKG_RM_AFTER_INSTALL="lib/locale"

termux_step_pre_configure() {
	export CFLAGS="${CFLAGS} -Wno-return-type"
	export LIBS="-landroid-shmem"
}
