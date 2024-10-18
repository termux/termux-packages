TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/related_software/pinentry/index.html
TERMUX_PKG_DESCRIPTION="Dialog allowing secure password entry"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.1"
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=bc72ee27c7239007ab1896c3c2fae53b076e2c9bd2483dc2769a16902bce8c04
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libassuan, libgpg-error, libiconv, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-pinentry-fltk
--enable-pinentry-tty
--without-libcap
"
