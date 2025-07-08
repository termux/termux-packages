TERMUX_PKG_HOMEPAGE=https://github.com/natesales/q
TERMUX_PKG_DESCRIPTION="A tiny command line DNS client with support for UDP, TCP, DoT, DoH, DoQ and ODoH"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="kay9925@outlook.com"
TERMUX_PKG_VERSION="0.19.5"
TERMUX_PKG_SRCURL="https://github.com/natesales/q/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=6d85b6e5ebb99a2c2e69dfba4fdb758b676664fde5af7cd258f4fdc2b6c4702a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	termux_setup_golang

	local _builtAt=$(date +'%FT%T%Z')

	local ldflags="\
	-w -s \
	-X 'main.version=${TERMUX_PKG_VERSION}' \
	-X 'main.commit=$(git log -1 --format=%H)' \
	-X 'main.date=${_builtAt}' \
	"

	export CGO_ENABLED=1

	go build -o "${TERMUX_PKG_NAME}" -ldflags="$ldflags"
}

termux_step_make_install() {
	install -Dm700 ${TERMUX_PKG_NAME} ${TERMUX_PREFIX}/bin/q
}
