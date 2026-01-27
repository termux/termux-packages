TERMUX_PKG_HOMEPAGE=https://github.com/walles/moor
TERMUX_PKG_DESCRIPTION="A pager designed to just do the right thing without any configuration"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.10.3"
TERMUX_PKG_SRCURL=https://github.com/walles/moor/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=ad5cd21d4260fe2bb86a0b2f25511b810efd95f195a39969049a94350af3dd88
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
