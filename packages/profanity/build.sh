TERMUX_PKG_HOMEPAGE=http://profanity.im
TERMUX_PKG_DESCRIPTION="Profanity is a console based XMPP client written in C using ncurses and libstrophe, inspired by Irssi"
TERMUX_PKG_VERSION=0.5.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_MAINTAINER="Oliver Schmidhauser @Neo-Oli"
TERMUX_PKG_SRCURL=http://profanity.im/profanity-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="ncurses,glib,libmesode,libcurl,readline,libuuid,libotr,gpgme,python"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS=" --disable-python-plugins"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
  CPPFLAGS+=" -I$TERMUX_PREFIX/include/python3.5m"
  LDFLAGS+=" -lpython3.5m"
}

termux_step_post_configure() {
  # Enable python support manually, as trying to go using --enable-python-plugins
  # causes configure trying to execut python:
  echo '#define HAVE_PYTHON 1' >> $TERMUX_PKG_SRCDIR/src/config.h
  perl -p -i -e 's|#am__objects_2|am__objects_2|' $TERMUX_PKG_SRCDIR/Makefile
}
