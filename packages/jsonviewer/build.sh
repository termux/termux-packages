TERMUX_PKG_HOMEPAGE=https://github.com/X-sella/jsonviewer
TERMUX_PKG_DESCRIPTION="Interactive JSON tree viewer with expand/collapse support"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.0.0
TERMUX_PKG_MAINTAINER="Your Name <you@example.com>"
TERMUX_PKG_SRCURL=https://github.com/X-sella/jsonviewer/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=SKIP
TERMUX_PKG_DEPENDS="python, python-rich, python-textual"

termux_step_make_install() {
    install -Dm700 src/jsonviewer $TERMUX_PREFIX/bin/jsonviewer
}