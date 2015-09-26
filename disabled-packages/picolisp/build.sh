TERMUX_PKG_HOMEPAGE=http://picolisp.com
TERMUX_PKG_DESCRIPTION="Lisp interpreter and application server framework"
TERMUX_PKG_VERSION=3.1.11
TERMUX_PKG_SRCURL=http://software-lab.de/picoLisp-${TERMUX_PKG_VERSION}.tgz
TERMUX_PKG_FOLDERNAME=picoLisp
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_MAKE_PROCESSES=1
# TERMUX_PKG_DEPENDS="pcre, openssl, libuuid"
#TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ssl=openssl"

termux_step_post_extract_package () {
	TERMUX_PKG_SRCDIR=$TERMUX_PKG_SRCDIR/src
	CFLAGS+=" $LDFLAGS $CPPFLAGS"
}
