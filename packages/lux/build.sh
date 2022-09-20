TERMUX_PKG_HOMEPAGE=https://github.com/iawia002/lux
TERMUX_PKG_DESCRIPTION="CLI tool to download videos from various websites (youtube-dl alternative)"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.15.0
TERMUX_PKG_SRCURL=https://github.com/iawia002/lux/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=41e45542587caa27bf8180e66c72c6c77e83d00f8dcba2e952c5a9b04d382c6c
TERMUX_PKG_SUGGESTS="aria2"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	mkdir bin
	go build -o ./bin -trimpath
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin bin/*
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME README.*
}
