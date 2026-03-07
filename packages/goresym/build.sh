TERMUX_PKG_HOMEPAGE=https://github.com/mandiant/GoReSym
TERMUX_PKG_DESCRIPTION="Go symbol recovery tool"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.3"
TERMUX_PKG_SRCURL=https://github.com/mandiant/goresym/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=e0afe3faaf824460b611a1ef6e93015341cfea999a6237516c15b59f8936d3f0
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
