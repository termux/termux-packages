TERMUX_PKG_HOMEPAGE=http://profanity.im
TERMUX_PKG_DESCRIPTION="Profanity is a console based XMPP client written in C using ncurses and libstrophe, inspired by Irssi"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_VERSION=0.6.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=http://profanity.im/profanity-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f1b2773b79eb294297686f3913e9489c20effae5e3a335c8956db18f6ee2f660
TERMUX_PKG_DEPENDS="libandroid-support, libffi, ncurses, glib, libmesode, libcurl, readline, libuuid, libotr, gpgme, python, libassuan, libgpg-error, zlib"
# openssl, libexpat needed by libmesode, pcre needed by glib:
TERMUX_PKG_BUILD_DEPENDS="openssl, libexpat, pcre, libgcrypt-dev, libcrypt-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --disable-python-plugins"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	CPPFLAGS+=" -I$TERMUX_PREFIX/include/python3.7m"
	LDFLAGS+=" -lpython3.7m"
}

termux_step_post_configure() {
	# Enable python support manually, as trying to go using --enable-python-plugins
	# causes configure trying to execute python:
	echo '#define HAVE_PYTHON 1' >> $TERMUX_PKG_SRCDIR/src/config.h
	perl -p -i -e 's|#am__objects_2|am__objects_2|' $TERMUX_PKG_SRCDIR/Makefile
}
