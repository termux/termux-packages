TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/related_software/pinentry/index.html
TERMUX_PKG_DESCRIPTION="GNOME 3 PIN or pass-phrase entry dialog for GnuPG"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.3"
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=c2970f16d6afb66ecddfca767d743936c86239bff936eed7fd7597a678414b63
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="gcr4, libandroid-support, libassuan, libgpg-error, libiconv, ncurses"
TERMUX_PKG_CONFLICTS="pinentry, pinentry-gtk"
TERMUX_PKG_REPLACES="pinentry, pinentry-gtk"
TERMUX_PKG_PROVIDES="pinentry"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-pinentry-fltk
--disable-pinentry-gtk2
--disable-pinentry-qt
--enable-pinentry-gnome3
--enable-pinentry-tty
--without-libcap
"
