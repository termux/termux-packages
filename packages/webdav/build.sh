TERMUX_PKG_HOMEPAGE=https://github.com/hacdias/webdav
TERMUX_PKG_DESCRIPTION="A simple and standalone WebDAV server."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="Izumi Sena Sora <info@unordinary.eu.org>"
TERMUX_PKG_VERSION="5.11.2"
TERMUX_PKG_SRCURL="https://github.com/hacdias/webdav/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=75c6c2339237886d3745e0efd760de20a4b16add3543de9eb50ce3603151e5b3
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang

	go build -o "${TERMUX_PKG_NAME}"
}

termux_step_make_install() {
	install -Dm700 "${TERMUX_PKG_NAME}" "${TERMUX_PREFIX}/bin"
}
