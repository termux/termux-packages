TERMUX_PKG_HOMEPAGE=https://www.mars.org/home/rob/proj/hfs/
TERMUX_PKG_DESCRIPTION="Tool for manipulating HFS images."
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_VERSION=3.2.6
TERMUX_PKG_SRCURL=ftp://ftp.mars.org/pub/hfs/hfsutils-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=bc9d22d6d252b920ec9cdf18e00b7655a6189b3f34f42e58d5bb152957289840
TERMUX_PKG_DEPENDS="libandroid-support"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--mandir=$TERMUX_PREFIX/share/man"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_configure() {
	mkdir -p ${TERMUX_PREFIX}/share/man/man1
}

