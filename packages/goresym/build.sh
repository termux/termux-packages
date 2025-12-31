TERMUX_PKG_HOMEPAGE=https://github.com/mandiant/GoReSym
TERMUX_PKG_DESCRIPTION="Go symbol recovery tool"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.1.2"
TERMUX_PKG_SRCURL=https://github.com/mandiant/goresym/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=5ed82506ca6d79968c6dfe3ac721a14ca886a19394228c2dce71ef69941aea90
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang
}

termux_step_make() {
	go build -o goresym
}

termux_step_make_install() {
	install -Dm755 goresym $TERMUX_PREFIX/bin/goresym
}
