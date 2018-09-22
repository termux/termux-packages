TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com> @xeffyr"

TERMUX_PKG_HOMEPAGE=https://github.com/Yawning/obfs4
TERMUX_PKG_DESCRIPTION="A pluggable transport plugin for Tor"
_COMMIT=89c21805c212bcc2f5a0c4ffdadf424cbff1c7c9
TERMUX_PKG_VERSION=0.0.8-dev
TERMUX_PKG_SRCURL=https://github.com/Yawning/obfs4/archive/${_COMMIT}.zip
TERMUX_PKG_SHA256=418d69a32095ffdbc4e937c17fa1d4df013a912c16c3de33ab51fbfd36838483
TERMUX_PKG_BUILD_IN_SRC=true

## obfs4proxy is a pluggable transport plugin for Tor
TERMUX_PKG_DEPENDS="tor"

termux_step_make() {
	termux_setup_golang
	cd "${TERMUX_PKG_SRCDIR}/obfs4proxy"
	go get -d ./...
	go build .
}

termux_step_post_make_install() {
	cd "${TERMUX_PKG_SRCDIR}/obfs4proxy"
	install -Dm700 "obfs4proxy" "${TERMUX_PREFIX}/bin/obfs4proxy"
}
