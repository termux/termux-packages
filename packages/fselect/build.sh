TERMUX_PKG_HOMEPAGE=https://github.com/jhspetersson/fselect
TERMUX_PKG_DESCRIPTION="Find files with SQL-like queries"
TERMUX_PKG_LICENSE="Apache-2.0, MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.7.4
TERMUX_PKG_SRCURL=https://github.com/jhspetersson/fselect/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=c3bf4096419ae8ff5390b6f0d064cfd2917169d41841071c61e6f265ebf11d7a
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME"/release/fselect \
		"$TERMUX_PREFIX"/bin/fselect
}
