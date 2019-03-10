TERMUX_PKG_HOMEPAGE=https://the.exa.website
TERMUX_PKG_DESCRIPTION="A modern replacement for ls"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.9~pre3
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=9931ad1c593096e69a1f0f7615e3857b1d422b7e74f63408385c663aeb2c12db
TERMUX_PKG_SRCURL=https://github.com/ogham/exa/archive/058b4a57bdb1e25cbdacc0fbd1eefc09bc5f1e95.zip
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
