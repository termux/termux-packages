TERMUX_PKG_HOMEPAGE=https://the.exa.website
TERMUX_PKG_DESCRIPTION="A modern replacement for ls"
TERMUX_PKG_VERSION=0.9~pre1
TERMUX_PKG_SHA256=3cec8e192dd5b69e650605a1948832d4d52ad25d37deecb49a180df020449f54
TERMUX_PKG_SRCURL=https://github.com/ogham/exa/archive/57e4c08411f59e7db91fa7d8127fbd412667ea32.zip
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--no-default-features --features default"
TERMUX_PKG_BUILD_IN_SRC=yes

termux_step_pre_configure() {
	rm $TERMUX_PKG_SRCDIR/Makefile
	termux_setup_rust
	cargo update
}

termux_step_post_make_install() {
	mkdir -p $TERMUX_PREFIX/share/man/man1
	cp $TERMUX_PKG_SRCDIR/contrib/man/exa.1 $TERMUX_PREFIX/share/man/man1/
}
