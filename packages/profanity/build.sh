TERMUX_PKG_HOMEPAGE=https://profanity-im.github.io
TERMUX_PKG_DESCRIPTION="Profanity is a console based XMPP client written in C using ncurses and libstrophe, inspired by Irssi"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
# This package depends on libpython${TERMUX_PYTHON_VERSION}.so.
# Please revbump and rebuild when bumping TERMUX_PYTHON_VERSION.
TERMUX_PKG_VERSION="0.14.0"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/profanity-im/profanity/releases/download/$TERMUX_PKG_VERSION/profanity-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fd23ffd38a31907974a680a3900c959e14d44e16f1fb7df2bdb7f6c67bd7cf7f
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gpgme, libandroid-support, libassuan, libcurl, libgcrypt, libgpg-error, libotr, libsignal-protocol-c, libsqlite, libstrophe, ncurses, python, readline"
TERMUX_PKG_BREAKS="profanity-dev"
TERMUX_PKG_REPLACES="profanity-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --enable-plugins --without-xscreensaver"
TERMUX_PKG_BUILD_IN_SRC=true
