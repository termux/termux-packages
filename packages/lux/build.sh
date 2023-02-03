TERMUX_PKG_HOMEPAGE=https://github.com/iawia002/lux
TERMUX_PKG_DESCRIPTION="CLI tool to download videos from various websites"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@flosnvjx"
TERMUX_PKG_VERSION=0.16.0
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/iawia002/lux/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=e16f3ec485793326c09f6b7096edacbb117fcbbd40341289e055ea19a5347033
TERMUX_PKG_RECOMMENDS="ffmpeg"
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
