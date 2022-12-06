TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/related_software/pinentry/index.html
TERMUX_PKG_DESCRIPTION="Dialog allowing secure password entry (with gtk2 support)"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.2.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=457a185e5a85238fb945a955dc6352ab962dc8b48720b62fc9fa48c7540a4067
TERMUX_PKG_DEPENDS="glib, gtk2, libandroid-support, libassuan, libgpg-error, libiconv, ncurses"

TERMUX_PKG_CONFLICTS="pinentry"
TERMUX_PKG_REPLACES="pinentry"
TERMUX_PKG_PROVIDES="pinentry"

TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-pinentry-fltk
--disable-pinentry-qt5
--enable-pinentry-gtk2
--enable-pinentry-tty
--without-libcap
"
