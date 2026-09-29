TERMUX_PKG_HOMEPAGE=https://www.gnupg.org/related_software/pinentry/index.html
TERMUX_PKG_DESCRIPTION="Dialog allowing secure password entry"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.3"
TERMUX_PKG_SRCURL=https://www.gnupg.org/ftp/gcrypt/pinentry/pinentry-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=c2970f16d6afb66ecddfca767d743936c86239bff936eed7fd7597a678414b63
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libassuan, libgpg-error, libiconv, ncurses"
# --disable-pinentry-qt avoids
# /bin/bash: line 1: /data/data/com.termux/files/usr/lib/qt6/moc: cannot execute binary file: Exec format error
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-pinentry-fltk
--enable-pinentry-tty
--without-libcap
--disable-pinentry-qt
"
