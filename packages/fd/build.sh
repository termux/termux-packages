TERMUX_PKG_HOMEPAGE=https://github.com/sharkdp/fd
TERMUX_PKG_DESCRIPTION="Simple, fast and user-friendly alternative to find"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=8.0.0
TERMUX_PKG_SRCURL=https://github.com/sharkdp/fd/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fba93204c10266317e0981914c630b08e12cd322c75ff2a2e504ff1dce17d557
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	mkdir -p  $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/doc/fd.1 $TERMUX_PREFIX/share/man/man1/fd.1
}
