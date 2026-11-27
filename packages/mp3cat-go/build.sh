TERMUX_PKG_HOMEPAGE=https://www.dmulholl.com/dev/mp3cat.html
TERMUX_PKG_DESCRIPTION="A command line utility for joining MP3 files."
TERMUX_PKG_LICENSE="Unlicense"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=4.3.0
TERMUX_PKG_SRCURL=https://github.com/dmulholl/mp3cat/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=5d5aa1ec4a2050d81b8be5a7ad0f02912cfa024210fbb3cdbfe976ba8ab01f70
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
