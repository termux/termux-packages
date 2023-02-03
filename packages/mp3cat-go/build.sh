TERMUX_PKG_HOMEPAGE=https://www.dmulholl.com/dev/mp3cat.html
TERMUX_PKG_DESCRIPTION="A command line utility for joining MP3 files."
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.2.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/dmulholl/mp3cat/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=457e680e5b05e8a5a50a8b557372e23bf797026f43253efdff14b8137f214470
TERMUX_PKG_CONFLICTS="mp3cat"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	go build
}

termux_step_make_install() {
	install -Dm700 mp3cat $TERMUX_PREFIX/bin/
}
