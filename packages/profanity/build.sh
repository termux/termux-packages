TERMUX_PKG_HOMEPAGE=https://profanity-im.github.io
TERMUX_PKG_DESCRIPTION="Profanity is a console based XMPP client written in C using ncurses and libstrophe, inspired by Irssi"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_VERSION="0.13.1"
TERMUX_PKG_SRCURL=https://github.com/profanity-im/profanity/releases/download/$TERMUX_PKG_VERSION/profanity-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2b5075272e7ec9d9c991542e592b1d474fff88c61c66e7e23096ad306ed2c84a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libffi, ncurses, glib, libcurl, readline, libuuid, libotr, gpgme, python, libassuan, libgpg-error, zlib, libsignal-protocol-c, libstrophe"
TERMUX_PKG_BREAKS="profanity-dev"
TERMUX_PKG_REPLACES="profanity-dev"
# pcre2 needed by glib:
TERMUX_PKG_BUILD_DEPENDS="pcre2, libgcrypt, libcrypt"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --enable-plugins --without-xscreensaver"
TERMUX_PKG_BUILD_IN_SRC=true
