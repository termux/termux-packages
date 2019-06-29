TERMUX_PKG_HOMEPAGE=https://github.com/Yawning/obfs4
TERMUX_PKG_DESCRIPTION="A pluggable transport plugin for Tor"
TERMUX_PKG_LICENSE="BSD 2-Clause, BSD 3-Clause, GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=0.0.11
TERMUX_PKG_SRCURL=https://github.com/Yawning/obfs4/archive/obfs4proxy-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=46f621f1d94d244e7b1d0b93dafea7abadb2428f8b1d0463559426362ea98eae
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
