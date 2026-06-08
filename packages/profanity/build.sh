# Contributor: @Neo-Oli
TERMUX_PKG_HOMEPAGE=https://profanity-im.github.io
TERMUX_PKG_DESCRIPTION="Profanity is a console based XMPP client written in C using ncurses and libstrophe, inspired by Irssi"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
# This package depends on libpython${TERMUX_PYTHON_VERSION}.so.
# Please revbump and rebuild when bumping TERMUX_PYTHON_VERSION.
TERMUX_PKG_VERSION="0.18.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/profanity-im/profanity/releases/download/$TERMUX_PKG_VERSION/profanity-$TERMUX_PKG_VERSION.tar.xz"
TERMUX_PKG_SHA256=9077e82dcc45ec38fa907cbfc7d63bd3f1344086cbd855f2d432658b06dee30a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="glib, gpgme, libandroid-support, libassuan, libcurl, libgcrypt, libgpg-error, libotr, libsignal-protocol-c, libstrophe, ncurses, python, readline, sqlite"
TERMUX_PKG_BREAKS="profanity-dev"
TERMUX_PKG_REPLACES="profanity-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dc-plugins=enabled
-Domemo=enabled
-Dotr=enabled
-Dpgp=enabled
-Dpython-plugins=enabled
"
