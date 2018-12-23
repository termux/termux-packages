TERMUX_PKG_HOMEPAGE=https://the.exa.website
TERMUX_PKG_DESCRIPTION="A modern replacement for ls"
TERMUX_PKG_VERSION=0.9~pre2
TERMUX_PKG_SHA256=df558e74aed27425b9dd2fbca4ee14eee672677722b93b77984d1b9b5265e023
TERMUX_PKG_SRCURL=https://github.com/ogham/exa/archive/485611e7c97d2043731ae83653a70eee2eb69a4b.zip
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
