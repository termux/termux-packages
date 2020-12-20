TERMUX_PKG_HOMEPAGE=http://tinyscheme.sourceforge.net/home.html
TERMUX_PKG_DESCRIPTION="Very small scheme implementation"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.42
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/tinyscheme/tinyscheme/tinyscheme-${TERMUX_PKG_VERSION}/tinyscheme-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=17b0b1bffd22f3d49d5833e22a120b339039d2cfda0b46d6fc51dd2f01b407ad
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	AR+=" crs"
	LD=$CC
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/tinyscheme/
	cp $TERMUX_PKG_SRCDIR/init.scm $TERMUX_PREFIX/share/tinyscheme/
}
