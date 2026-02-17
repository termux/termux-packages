TERMUX_PKG_HOMEPAGE=https://github.com/mandiant/GoReSym
TERMUX_PKG_DESCRIPTION="Go symbol recovery tool"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="3.2"
TERMUX_PKG_SRCURL=https://github.com/mandiant/goresym/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2751ee41d9864982747ffa34d787a1465a0f547db6b2464f24109cb089382183
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
