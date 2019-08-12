TERMUX_PKG_HOMEPAGE=https://github.com/sharkdp/bat
TERMUX_PKG_DESCRIPTION="A cat(1) clone with wings"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=0.11.0
TERMUX_PKG_SHA256=bb4e39efadfab71c0c929a92b82dac58deacfe2a4eb527d4256ac0634e042ed2
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
