TERMUX_PKG_HOMEPAGE=https://github.com/BurntSushi/ripgrep
TERMUX_PKG_DESCRIPTION="Search tool like grep and The Silver Searcher"
TERMUX_PKG_VERSION=0.10.0
TERMUX_PKG_SHA256=a2a6eb7d33d75e64613c158e1ae450899b437e37f1bfbd54f713b011cd8cc31e
TERMUX_PKG_SRCURL=https://github.com/BurntSushi/ripgrep/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_make_install() {
	cp target/$CARGO_TARGET_NAME/release/rg $TERMUX_PREFIX/bin/rg

	mkdir -p $TERMUX_PREFIX/share/man/man1/
	cp `find . -name rg.1` $TERMUX_PREFIX/share/man/man1/
}
