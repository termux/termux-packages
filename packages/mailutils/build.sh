TERMUX_PKG_HOMEPAGE=http://mailutils.org/
TERMUX_PKG_DESCRIPTION="GNU mailutils utilities for handling mail"
TERMUX_PKG_DEPENDS="libandroid-glob, libcrypt"
TERMUX_PKG_VERSION=2.2
TERMUX_PKG_SRCURL=ftp://ftp.gnu.org/gnu/mailutils/mailutils-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_FOLDERNAME=mailutils-${TERMUX_PKG_VERSION}
TERMUX_PKG_MAINTAINER="Pierre Rudloff <contact@rudloff.pro>"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--without-python --disable-shared --with-path-sendmail=${TERMUX_PREFIX}/bin/applets/sendmail"
LDFLAGS+=" -llog"
