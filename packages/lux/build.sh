TERMUX_PKG_HOMEPAGE=https://github.com/iawia002/lux
TERMUX_PKG_DESCRIPTION="CLI tool to download videos from various websites"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@flosnvjx"
TERMUX_PKG_VERSION="0.24.1"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/iawia002/lux/archive/refs/tags/v$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=69d4fe58c588cc6957b8682795210cd8154170ac51af83520c6b1334901c6d3d
TERMUX_PKG_RECOMMENDS="ffmpeg"
TERMUX_PKG_SUGGESTS="aria2"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	mkdir bin
	# https://github.com/iawia002/lux/issues/1340
	# https://github.com/iawia002/lux/blob/348ae97219784a32dd3c4721ad0cbc2584ee7b46/.goreleaser.yml#L10
	go build -o ./bin -trimpath -ldflags "-s -w -X github.com/iawia002/lux/app.version=v${TERMUX_PKG_VERSION}"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin bin/*
	install -Dm600 -t $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME README.*
}
