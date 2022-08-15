TERMUX_PKG_HOMEPAGE=https://miniflux.app/
TERMUX_PKG_DESCRIPTION="A minimalist and opinionated feed reader"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.36
TERMUX_PKG_SRCURL=https://github.com/miniflux/v2/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=15ac4ad4ab6f87de2143a85f52252e80d7c216a69aab334363e1972b81f231fd
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="VERSION=$TERMUX_PKG_VERSION"

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/bin miniflux
	install -Dm600 -t $TERMUX_PKG_MASSAGEDIR/$TERMUX_PREFIX/share/man/man1 miniflux.1
}
