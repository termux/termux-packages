TERMUX_PKG_HOMEPAGE=https://www.sbcl.org/
TERMUX_PKG_DESCRIPTION="Steel Bank Common Lisp"
TERMUX_PKG_LICENSE="BSD"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.3.0
TERMUX_PKG_SRCURL=https://prdownloads.sourceforge.net/sbcl/sbcl-${TERMUX_PKG_VERSION}-source.tar.bz2
TERMUX_PKG_BUILD_DEPENDS="ecl"
TERMUX_PKG_SHA256=bf743949712ae02cb7493f3b8b57ce241948bf61131e36860ddb334da1439c97

termux_step_make() {
	cd $TERMUX_PKG_SRCDIR
    XC_HOST="$TERMUX_PREFIX/bin/ecl --norc --c-stack 16777217"
	./make.sh --prefix=$TERMUX_PREFIX \
              --xc-host="$XC_HOST" \
              --with-android \
              --fancy \
              --without-gcc-tls
}

termux_step_make_install() {
	cd $TERMUX_PKG_SRCDIR
	./install.sh
}
