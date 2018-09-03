TERMUX_PKG_HOMEPAGE=https://github.com/BurntSushi/ripgrep
TERMUX_PKG_DESCRIPTION="Search tool like grep and The Silver Searcher"
TERMUX_PKG_VERSION=0.9.0
TERMUX_PKG_SHA256=871a24ad29a4c5b6d82f6049156db2662e6a9820cca6f361547b8ab8bc1be7ae
TERMUX_PKG_SRCURL=https://github.com/BurntSushi/ripgrep/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_post_make_install() {
	cp target/$CARGO_TARGET_NAME/release/rg $TERMUX_PREFIX/bin/rg

	mkdir -p $TERMUX_PREFIX/share/man/man1/
	cp `find . -name rg.1` $TERMUX_PREFIX/share/man/man1/
}
