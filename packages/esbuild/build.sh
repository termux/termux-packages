TERMUX_PKG_HOMEPAGE=https://esbuild.github.io/
TERMUX_PKG_DESCRIPTION="An extremely fast JavaScript bundler"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.16.16"
TERMUX_PKG_SRCURL=https://github.com/evanw/esbuild/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=36136c1cfa0f4af2bd778672d7d127ebdf4e138f54af5b98181f07a8e93d6762
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build ./cmd/esbuild
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin esbuild
}
