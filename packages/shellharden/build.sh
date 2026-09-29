TERMUX_PKG_HOMEPAGE=https://github.com/anordal/shellharden
TERMUX_PKG_DESCRIPTION="The corrective bash syntax highlighter"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.3.2"
TERMUX_PKG_SRCURL=https://github.com/anordal/shellharden/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=3a6721c3409c70449c24a5b33f83d0d05026f2318fe052db5c6d0834e2b29c6c
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_pre_configure() {
	termux_setup_rust
}

termux_step_post_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME"/release/shellharden \
		"$TERMUX_PREFIX"/bin/
}
