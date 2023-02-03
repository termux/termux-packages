TERMUX_PKG_HOMEPAGE=https://github.com/Yawning/obfs4
TERMUX_PKG_DESCRIPTION="A pluggable transport plugin for Tor"
TERMUX_PKG_LICENSE="BSD 2-Clause, BSD 3-Clause, GPL-3.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE-GPL3.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.0.14
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/Yawning/obfs4/archive/obfs4proxy-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=a4b7520e732b0f168832f6f2fdf1be57f3e2cce0612e743d3f6b51341a740903
TERMUX_PKG_BUILD_IN_SRC=true

## obfs4proxy is a pluggable transport plugin for Tor, so
## marking "tor" package as dependency.
TERMUX_PKG_DEPENDS="tor"

termux_step_make() {
	termux_setup_golang
	cd "$TERMUX_PKG_SRCDIR"/obfs4proxy
	go get -d ./...
	go build .
}

termux_step_post_make_install() {
	cd "$TERMUX_PKG_SRCDIR"/obfs4proxy
	install -Dm700 obfs4proxy "${TERMUX_PREFIX}"/bin/
}
