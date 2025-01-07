TERMUX_PKG_HOMEPAGE=https://github.com/anordal/shellharden
TERMUX_PKG_DESCRIPTION="The corrective bash syntax highlighter"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="4.3.1"
TERMUX_PKG_SRCURL=https://github.com/anordal/shellharden/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=3c16a98502df01a2fa2b81467d5232cc1aa4c80427e2ecf9f7e74591d692e22c
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_post_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME"/release/shellharden \
		"$TERMUX_PREFIX"/bin/
}
