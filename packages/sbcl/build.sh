TERMUX_PKG_HOMEPAGE=http://www.sbcl.org/
TERMUX_PKG_DESCRIPTION="SBCL (Steel Bank Common Lisp) is a high performance Common Lisp compiler."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@metayan"
TERMUX_PKG_VERSION=2.1.9
TERMUX_PKG_SRCURL=https://downloads.sourceforge.net/sbcl/sbcl-${TERMUX_PKG_VERSION}-source.tar.bz2
TERMUX_PKG_SHA256=9e746ff12c4f78d2deabd95e48169b552f9472808cf8b8fc801d84df3e962fa1
TERMUX_PKG_DEPENDS="ecl"

termux_step_make() {
    cd $TERMUX_PKG_SRCDIR

    # Use SBCL if we have it already, otherwise ECL
    if [ "`which sbcl`" ]; then
	XC_HOST="`which sbcl` --no-sysinit --no-userinit"
    else
	XC_HOST="$TERMUX_PREFIX/bin/ecl --norc"
    fi

    ./make.sh \
       --xc-host="$XC_HOST" \
       --fancy \
       --without-gcc-tls \
       --prefix=$TERMUX_PREFIX
}

termux_step_make_install() {
    cd $TERMUX_PKG_SRCDIR
    ./install.sh
}
