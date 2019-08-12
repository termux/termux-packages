TERMUX_PKG_HOMEPAGE=https://github.com/sharkdp/fd
TERMUX_PKG_DESCRIPTION="Simple, fast and user-friendly alternative to find"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_VERSION=7.3.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=fbd48cc83c90a0ab09fc3bbe865708a3a528876a99f8304a17d07af7fb378170
TERMUX_PKG_SRCURL=https://github.com/sharkdp/fd/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	mkdir -p  $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/doc/fd.1 $TERMUX_PREFIX/share/man/man1/fd.1
}
