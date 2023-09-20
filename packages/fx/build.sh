TERMUX_PKG_HOMEPAGE="https://github.com/antonmedv/fx"
TERMUX_PKG_DESCRIPTION="Interactive JSON viewer on your terminal"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@flosnvjx"
TERMUX_PKG_VERSION="30.0.2"
TERMUX_PKG_SRCURL="https://github.com/antonmedv/fx/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=8ac17c5fd0beecbd9e94b8a8a0af8ed93111a66afe55b596d9fcd032f73f9365
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_AUTO_UPDATE=true

termux_step_make() {
	termux_setup_golang
	mkdir bin
	go build -o ./bin -trimpath
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin bin/*
}
