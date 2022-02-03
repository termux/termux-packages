TERMUX_PKG_HOMEPAGE=https://git.sr.ht/~sircmpwn/scdoc
TERMUX_PKG_DESCRIPTION="Small man page generator"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Yaksh Bariya <yakshbari4@gmail.com>"
TERMUX_PKG_VERSION=1.11.2
TERMUX_PKG_SRCURL=https://git.sr.ht/~sircmpwn/scdoc/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e9ff9981b5854301789a6778ee64ef1f6d1e5f4829a9dd3e58a9a63eacc2e6f0
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	cd $TERMUX_PKG_SRCDIR
	(
		unset CC CXX CFLAGS CXXFLAGS LD LDFLAGS
		make PREFIX=/usr OUTDIR=$TERMUX_PKG_HOSTBUILD_DIR CC=clang
	)
	make PREFIX=$TERMUX_PREFIX OUTDIR=$TERMUX_PKG_SRCDIR HOST_SCDOC=$TERMUX_PKG_HOSTBUILD_DIR/scdoc install
}

termux_step_make_install() {
	:
}
