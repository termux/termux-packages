TERMUX_PKG_HOMEPAGE=https://gomi.dev
TERMUX_PKG_DESCRIPTION="Safer alternative to the rm command, with a trash can you can restore from"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@zeldrisho"
TERMUX_PKG_VERSION=1.6.4
TERMUX_PKG_SRCURL=https://github.com/babarot/gomi/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=27d4bfca8473a5c01c3ead075f2674b47b586b6de8afc7fb31ade1c01d7e5b8a
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BUILD_DEPENDS="golang"

termux_step_make() {
	termux_setup_golang

	local _ldflags="
		-s -w
		-X main.version=v${TERMUX_PKG_VERSION}
		-X main.revision=termux
		-X main.buildDate=$(date -u +%Y-%m-%dT%H:%M:%SZ)
	"
	go build -ldflags "${_ldflags}" -o gomi .
}

termux_step_make_install() {
	install -Dm700 gomi -t "${TERMUX_PREFIX}/bin/"
}
