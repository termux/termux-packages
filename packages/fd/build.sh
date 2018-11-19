TERMUX_PKG_HOMEPAGE=https://github.com/sharkdp/fd
TERMUX_PKG_DESCRIPTION="Simple, fast and user-friendly alternative to find"
TERMUX_PKG_VERSION=7.2.0
TERMUX_PKG_SHA256=153d0ac821901d9843b501dd6ba00e82aa73e3d61c27b2150af7ebc1fb6dff67
TERMUX_PKG_SRCURL=https://github.com/sharkdp/fd/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_make_install() {
	mkdir -p  $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/doc/fd.1 $TERMUX_PREFIX/share/man/man1/fd.1
}
