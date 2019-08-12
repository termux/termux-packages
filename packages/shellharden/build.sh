TERMUX_PKG_HOMEPAGE=https://github.com/anordal/shellharden
TERMUX_PKG_DESCRIPTION="The corrective bash syntax highlighter"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=4.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/anordal/shellharden/archive/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2714b827f72c336b7abf87f5a291ec182443a5479ec3eee516d6e04c81d56414
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_make_install() {
	install -Dm700 \
		"$TERMUX_PKG_SRCDIR/target/$CARGO_TARGET_NAME"/release/shellharden \
		"$TERMUX_PREFIX"/bin/
}
