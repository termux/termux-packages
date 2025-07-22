TERMUX_PKG_HOMEPAGE=https://github.com/walles/moar
TERMUX_PKG_DESCRIPTION="A pager designed to just do the right thing without any configuration"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.32.5"
TERMUX_PKG_SRCURL=https://github.com/walles/moar/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=998d5a3b01b878a9af23faaacae661d1c86c800715d6af2011a5a3f5c477b3fc
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang
	go build -trimpath -ldflags="-s -w -X main.versionString=${TERMUX_PKG_VERSION}"
}

termux_step_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}/bin" moar
	install -Dm600 -t "${TERMUX_PREFIX}/share/man/man1" moar.1
}
