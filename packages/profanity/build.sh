TERMUX_PKG_HOMEPAGE=http://profanity.im
TERMUX_PKG_DESCRIPTION="Profanity is a console based XMPP client written in C using ncurses and libstrophe, inspired by Irssi"
TERMUX_PKG_VERSION=0.4.7
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=http://profanity.im/profanity-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses,glib,libstrophe,libcurl,readline,libuuid,libotr,gpgme"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
./bootstrap.sh
}
