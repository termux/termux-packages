TERMUX_PKG_HOMEPAGE=https://mujs.com/
TERMUX_PKG_DESCRIPTION="A lightweight Javascript interpreter designed for embedding in other software"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.3.7
TERMUX_PKG_SRCURL=https://codeberg.org/ccxvii/mujs/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5701ac8314d7cb9c792d620c066d93682a74c43f2a49a8966014de05afec5d6a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="readline"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS+=" -I$TERMUX_PREFIX/include"
	LDFLAGS+=" -L$TERMUX_PREFIX/lib"
}

termux_step_make() {
	make release \
		prefix=$TERMUX_PREFIX \
		HAVE_READLINE=yes \
		CC="$CC" \
		CFLAGS="$CFLAGS $CPPFLAGS" \
		LDFLAGS="$LDFLAGS"
}

termux_step_make_install() {
	make install prefix=$TERMUX_PREFIX
}
