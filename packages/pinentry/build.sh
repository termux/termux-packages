TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/related_software/pinentry/index.html
TERMUX_PKG_DESCRIPTION="Dialog allowing secure password entry"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=8e986ed88561b4da6e9efe0c54fa4ca8923035c99264df0b0464497c5fb94e9e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libassuan, libgpg-error, libiconv, ncurses"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-pinentry-fltk
--enable-pinentry-tty
--without-libcap
"
