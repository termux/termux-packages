TERMUX_PKG_HOMEPAGE=https://github.com/ihsannyy/kilat
TERMUX_PKG_DESCRIPTION="Fast JavaScript runtime for Termux"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="ihsannyy"
TERMUX_PKG_VERSION=5.0.0
TERMUX_PKG_SRCURL=https://github.com/ihsannyy/kilat/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=SKIP_CHECK
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="golang"

termux_step_make() {
	CGO_ENABLED=0 go build -o kilat ./cmd/kilat
}

termux_step_make_install() {
	install -Dm755 kilat "$TERMUX_PREFIX/bin/kilat"
}
