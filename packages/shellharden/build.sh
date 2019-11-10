TERMUX_PKG_HOMEPAGE=https://github.com/anordal/shellharden
TERMUX_PKG_DESCRIPTION="The corrective bash syntax highlighter"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=4.1.1
TERMUX_PKG_SRCURL=https://github.com/anordal/shellharden/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=7d7ac3443f35eb74abfc78fa67db2947d60b7d0782f225f55d6eefafcf294c7c
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME"/release/shellharden \
		"$TERMUX_PREFIX"/bin/
}
