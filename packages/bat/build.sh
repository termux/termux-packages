TERMUX_PKG_HOMEPAGE=https://github.com/sharkdp/bat
TERMUX_PKG_DESCRIPTION="A cat(1) clone with wings"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=0.12.0
TERMUX_PKG_SHA256=7a3d0d94b6bffa00644a4afbc5952f87965f4723de3878b97ef8b7ebfd912477
TERMUX_PKG_SRCURL=https://github.com/sharkdp/bat/archive/v$TERMUX_PKG_VERSION.tar.gz
# bat calls less with '--RAW-CONTROL-CHARS' which busybox less does not support:
TERMUX_PKG_DEPENDS="less, zlib"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	CFLAGS="$CFLAGS $CPPFLAGS"
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/doc/bat.1 $TERMUX_PREFIX/share/man/man1/
}
