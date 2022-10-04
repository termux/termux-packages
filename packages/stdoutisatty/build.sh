TERMUX_PKG_HOMEPAGE=https://github.com/lilydjwg/stdoutisatty
TERMUX_PKG_DESCRIPTION="Patch the isatty() calls for colored output in pipeline"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@flosnvjx"
TERMUX_PKG_VERSION=1.0
TERMUX_PKG_SRCURL=https://github.com/lilydjwg/stdoutisatty/archive/refs/tags/"$TERMUX_PKG_VERSION".tar.gz
TERMUX_PKG_SHA256=fadc12401cd89e718d7b0127b882cf47335f436ffcc7b83a9fbf557befe5beb2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"

termux_step_post_make_install() {
	cd "$TERMUX_PKG_SRCDIR"
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME README.*
}
