TERMUX_PKG_HOMEPAGE=https://miniflux.app/
TERMUX_PKG_DESCRIPTION="A minimalist and opinionated feed reader"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.2.3"
TERMUX_PKG_SRCURL=https://github.com/miniflux/v2/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ac046742c7d500da83aa97bf5a394d6a5e7d8c34c7f5d9ed6d7b7faab2426136
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="VERSION=$TERMUX_PKG_VERSION"

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin miniflux
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1 miniflux.1
}
