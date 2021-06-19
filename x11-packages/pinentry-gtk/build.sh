TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/related_software/pinentry/index.html
TERMUX_PKG_DESCRIPTION="Dialog allowing secure password entry (with gtk2 support)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=1.1.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=cd12a064013ed18e2ee8475e669b9f58db1b225a0144debdb85a68cecddba57f
TERMUX_PKG_DEPENDS="atk, fontconfig, freetype, gdk-pixbuf, glib, gtk2, libandroid-shmem, libassuan, libcairo, libgpg-error, ncurses, pango"

TERMUX_PKG_CONFLICTS="pinentry"
TERMUX_PKG_REPLACES="pinentry"
TERMUX_PKG_PROVIDES="pinentry"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-pinentry-fltk
--disable-pinentry-qt5
--enable-pinentry-gtk2
--without-libcap
"

termux_step_pre_configure() {
	export LIBS="-landroid-shmem"
}
