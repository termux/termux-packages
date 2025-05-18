# Contributor: @Neo-Oli
TERMUX_PKG_HOMEPAGE=https://profanity-im.github.io
TERMUX_PKG_DESCRIPTION="Profanity is a console based XMPP client written in C using ncurses and libstrophe, inspired by Irssi"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
# This package depends on libpython${TERMUX_PYTHON_VERSION}.so.
# Please revbump and rebuild when bumping TERMUX_PYTHON_VERSION.
TERMUX_PKG_VERSION="0.15.0"
TERMUX_PKG_SRCURL=https://github.com/profanity-im/profanity/releases/download/$TERMUX_PKG_VERSION/profanity-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=ccb8b453d3b5f65765cc875f2e947a1415eb5b55300eff841fd4ddd5fa5c0d2d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gpgme, libandroid-support, libassuan, libcurl, libgcrypt, libgpg-error, libotr, libsignal-protocol-c, libsqlite, libstrophe, ncurses, python, readline"
TERMUX_PKG_BREAKS="profanity-dev"
TERMUX_PKG_REPLACES="profanity-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --enable-plugins --without-xscreensaver"
TERMUX_PKG_BUILD_IN_SRC=true
