TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/related_software/pinentry/index.html
TERMUX_PKG_DESCRIPTION="Dialog allowing secure password entry"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.0"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=9b3cd5226e7597f2fded399a3bc659923351536559e9db0826981bca316494de
TERMUX_PKG_DEPENDS="libandroid-support, libassuan, libgpg-error, libiconv, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-pinentry-fltk
--enable-pinentry-tty
--without-libcap
"
