TERMUX_PKG_HOMEPAGE=http://tinyscheme.sourceforge.net/home.html
TERMUX_PKG_DESCRIPTION="Very small scheme implementation"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_VERSION=1.41
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://downloads.sourceforge.net/project/tinyscheme/tinyscheme/tinyscheme-1.41/tinyscheme-1.41.tar.gz
TERMUX_PKG_SHA256=eac0103494c755192b9e8f10454d9f98f2bbd4d352e046f7b253439a3f991999
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	AR+=" crs"
	LD=$CC
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/tinyscheme/
	cp $TERMUX_PKG_SRCDIR/init.scm $TERMUX_PREFIX/share/tinyscheme/
}
