TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/related_software/pinentry/index.html
TERMUX_PKG_DESCRIPTION="Dialog allowing secure password entry (with gtk2 support)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=1.1.0
TERMUX_PKG_REVISION=11
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=68076686fa724a290ea49cdf0d1c0c1500907d1b759a3bcbfbec0293e8f56570
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
