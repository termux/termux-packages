TERMUX_PKG_HOMEPAGE=https://mcrypt.sourceforge.net/
TERMUX_PKG_DESCRIPTION="A library which provides a uniform interface to several symmetric encryption algorithms"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.8"
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/mcrypt/libmcrypt-$TERMUX_PKG_VERSION.tar.bz2
TERMUX_PKG_SHA256=bf2f1671f44af88e66477db0982d5ecb5116a5c767b0a0d68acb34499d41b793
TERMUX_PKG_BREAKS="libmcrypt-dev"
TERMUX_PKG_REPLACES="libmcrypt-dev"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=$TERMUX_PREFIX/share/man"

termux_step_post_configure() {
	# Fix for `error: call to undeclared library function 'memmove/calloc/malloc/memcpy/free/sprintf/etc.'` during running `build-all.sh`
	# Probably it would be easier to add `-Wimplicit-function-declaration` to `CFLAGS`, but this solution feels more correct.
	echo "#include <stdio.h>" >> "$TERMUX_PKG_SRCDIR/config.h"
	echo "#include <stdlib.h>" >> "$TERMUX_PKG_SRCDIR/config.h"
	echo "#include <string.h>" >> "$TERMUX_PKG_SRCDIR/config.h"
	echo "#include <ctype.h>" >> "$TERMUX_PKG_SRCDIR/config.h"
}
