TERMUX_PKG_HOMEPAGE=https://github.com/walles/moor
TERMUX_PKG_DESCRIPTION="A pager designed to just do the right thing without any configuration"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.5.1"
TERMUX_PKG_SRCURL=https://github.com/walles/moor/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=52b42419e565e2bc2aae0b3cbf4b4e6539e8a7daa5ba97c5384982e6fb8c2f40
TERMUX_PKG_CONFLICTS="moar"
TERMUX_PKG_REPLACES="moar"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	go build -trimpath -ldflags="-s -w -X main.versionString=${TERMUX_PKG_VERSION}" ./cmd/moor
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}/bin" moor
	install -Dm600 -t "${TERMUX_PREFIX}/share/man/man1" moor.1
}
