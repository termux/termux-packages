TERMUX_PKG_HOMEPAGE=https://github.com/anordal/shellharden
TERMUX_PKG_DESCRIPTION="The corrective bash syntax highlighter"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.1.2
TERMUX_PKG_SRCURL=https://github.com/anordal/shellharden/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8e5f623f9d58e08460d3ecabb28c53f1969bed09c2526f01b5e00362a8b08e7f
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME"/release/shellharden \
		"$TERMUX_PREFIX"/bin/
}
