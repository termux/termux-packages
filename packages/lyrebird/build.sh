TERMUX_PKG_HOMEPAGE=https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports
TERMUX_PKG_DESCRIPTION="A pluggable transport plugin for Tor"
TERMUX_PKG_LICENSE="BSD 2-Clause, BSD 3-Clause, GPL-3.0"
TERMUX_PKG_LICENSE_FILE="LICENSE, LICENSE-GPL3.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.8.0"
TERMUX_PKG_SRCURL=https://gitlab.torproject.org/tpo/anti-censorship/pluggable-transports/lyrebird/-/archive/lyrebird-$TERMUX_PKG_VERSION/lyrebird-lyrebird-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=8143fd28a397804bdb8b5c086500ea99f1e2b885727c1d6cbc49af3864a120b7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE=newest-tag
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BREAKS="obfs4proxy"
TERMUX_PKG_PROVIDES="obfs4proxy"
TERMUX_PKG_REPLACES="obfs4proxy"

## lyrebird/obfs4proxy is a pluggable transport plugin for Tor, so
## marking "tor" package as dependency.
TERMUX_PKG_DEPENDS="tor"

termux_step_make() {
	termux_setup_golang
	# it does not contain install target so it is useless
	rm Makefile
	cd "$TERMUX_PKG_SRCDIR"/cmd/lyrebird
	go get -d ./cmd/...
	go build -ldflags="-X main.lyrebirdVersion=${TERMUX_PKG_VERSION} -checklinkname=0" .
}

termux_step_post_make_install() {
	install -Dm700 -t "${TERMUX_PREFIX}/bin/" "${TERMUX_PKG_SRCDIR}/cmd/lyrebird/lyrebird"
	rm -f "${TERMUX_PREFIX}/bin/obfs4proxy"
	ln -s "${TERMUX_PREFIX}/bin/lyrebird" "${TERMUX_PREFIX}/bin/obfs4proxy"
}
