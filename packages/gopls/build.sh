TERMUX_PKG_HOMEPAGE=https://github.com/golang/tools
TERMUX_PKG_DESCRIPTION="The official Go language server"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Joshua Kahn <tom@termux.dev>"
TERMUX_PKG_VERSION="0.21.1"
TERMUX_PKG_SRCURL=https://github.com/golang/tools/archive/refs/tags/gopls/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=af211e00c3ffe44fdf2dd3efd557e580791e09f8dbb4284c917bd120bc3c8f9c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_UPDATE_TAG_TYPE=latest-release-tag

termux_step_make() {
	termux_setup_golang

	cd "$TERMUX_PKG_SRCDIR/gopls" && \
	go build -o gopls
}

termux_step_make_install() {
	install -Dm755 -t "$TERMUX_PREFIX/bin" "$TERMUX_PKG_SRCDIR/gopls/gopls"
}
